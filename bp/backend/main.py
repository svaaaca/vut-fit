#
# @file main.py
# @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
# @brief Source code of the app server implementation.
# @date 2025-05-14
#

# standard library imports
from io import BytesIO
from locale import format_string, LC_NUMERIC, setlocale
from os import getenv
from typing import Any, Union

# third-party imports
from base64 import b64encode
from dotenv import load_dotenv
from fastapi import FastAPI, File, Form, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fitparse import FitFile
from gpxpy import parse
from haversine import haversine, Unit
from lxml import etree
from matplotlib.patches import Rectangle
from matplotlib.pyplot import close, figure, savefig
from numpy import arange, inf, interp, linspace, std
from pandas import DataFrame
from requests import get
from scipy.ndimage import gaussian_filter1d


# configuration constants
ALTITUDE_FACTOR = 20.0 * 10.0e6
ALTITUDE_MULTIPLIER_MAXIMUM = 256.0
ALTITUDE_MULTIPLIER_METRIC = 1.0
ALTITUDE_MULTIPLIER_MINIMUM = 4.0
ALTITUDE_MULTIPLIER_IMPERIAL = 3.280839895013
ALTITUDE_MULTIPLIER_STANDARD_DEVIATION = 16.0
AVERAGE_SPEED = 20.0
BAD_REQUEST = 400
DIFFICULTY_INDEX_DIFFICULT = 10.24
DIFFICULTY_INDEX_EASY = 0.64
DIFFICULTY_INDEX_MEDIUM = 2.56
DISTANCE_DIFFICULT = 3072.0
DISTANCE_EASY = 768.0
DISTANCE_MEDIUM = 1536.0
DISTANCE_MULTIPLIER = 0.00001
DISTANCE_MULTIPLIER_METRIC = 0.001
DISTANCE_MULTIPLIER_IMPERIAL = 0.000621371192237
ELEVATION_PROFILE_BAND_NARROW = 0.08
ELEVATION_PROFILE_BAND_WIDE = 0.14
ELEVATION_PROFILE_CLIMB_GAP = 0.08
ELEVATION_PROFILE_CLIMB_DEFAULT = 0.16
ELEVATION_PROFILE_CLIMB_SHIFT = 0.48
ELEVATION_PROFILE_CLIMB_TOP = 0.98
ELEVATION_PROFILE_PLOT_ALTITUDE = 0.18
ELEVATION_PROFILE_PLOT_DEFAULT = 0.14
ELEVATION_PROFILE_PLOT_DISTANCE = 0.28
ELEVATION_PROFILE_PLOT_LIMIT = 0.32
ELEVATION_PROFILE_PLOT_NEARBY = 0.26
ELEVATION_PROFILE_PLOT_OFFSET = 0.04
ELEVATION_PROFILE_PLOT_OFFSET_EXTRA = 0.1
ELEVATION_PROFILE_PLOT_SHIFT = 0.46
FIGURE_DPI = 256.0
FIGURE_FIGSIZE = (16.0, 8.0)
FIT_COORDINATES_MULTIPLIER = 180.0 / (2.0 ** 31)
GAUSSIAN_FILTER_SIGMA = 4.0
GRADIENT_LOSS_THRESHOLD = 0.000016
GRADIENT_MEAN = 3.0
GRADIENT_MULTIPLIER = 100.0
GRIDLINE_STEP = 100.0
INITIAL_LIST = [0.0]
KML_COORDINATES_LENGTH = 3
LENGTH_MULTIPLIER = 0.01
SEGMENT_NUMBER = 64


# load environment variables from .env
load_dotenv()
GEONAMES_USERNAME = getenv('GEONAMES_USERNAME')


# FastAPI app initialization
app = FastAPI()

# add CORS middleware to allow origins, methods, and headers
app.add_middleware(
    allow_credentials=True,
    allow_headers=['*'],
    allow_methods=['*'],
    allow_origins=['*'],
    middleware_class=CORSMiddleware,
)


def calculate_statistics(
    average_speed: float,
    dataframe: DataFrame,
    units: str,
) -> dict[str, float]:
    '''
    Calculates various statistics from a recorded activity dataframe.

    Parameters:
        average_speed (float): Average speed (in units consistent with `units`) used to estimate time.
        dataframe (DataFrame): A pandas DataFrame containing at least the columns:
            'altitude', 'elevation', 'difficulty_index', and 'distance'.
        units (str): Either 'metric' or 'imperial'. Determines the conversion multipliers for altitude and distance.

    Returns:
        statistics (dict[str, float]): A dictionary with computed statistics including altitude extremes,
        distance, elevation changes, average gradients, difficulty index, and estimated time.
        Returns None if an error occurs during calculation.
    '''

    altitude_multiplier = ALTITUDE_MULTIPLIER_METRIC if units == 'metric' else ALTITUDE_MULTIPLIER_IMPERIAL
    distance_multiplier = DISTANCE_MULTIPLIER_METRIC if units == 'metric' else DISTANCE_MULTIPLIER_IMPERIAL

    try:
        altitude_maximum = dataframe['altitude'].max() * altitude_multiplier
        altitude_mean = dataframe['altitude'].mean() * altitude_multiplier
        altitude_minimum = dataframe['altitude'].min() * altitude_multiplier
        difficulty_index = dataframe['difficulty_index'].sum()
        distance = dataframe['distance'].iloc[-1] * distance_multiplier
        elevation = (dataframe['altitude'].iloc[-1] - dataframe['altitude'].iloc[0]) * altitude_multiplier

        # total ascent is the sum of all positive elevation changes
        elevation_gain = dataframe.loc[dataframe['elevation'] > 0.0, 'elevation'].sum() * altitude_multiplier
        elevation_gain_mean = (elevation_gain / distance) * altitude_multiplier

        # total descent is the sum of all negative elevation changes
        elevation_loss = dataframe.loc[dataframe['elevation'] < 0.0, 'elevation'].sum() * altitude_multiplier
        elevation_loss_mean = (elevation_loss / distance) * altitude_multiplier

        # average net elevation change per unit distance
        elevation_mean = (elevation / distance) * altitude_multiplier
        estimated_time = distance / average_speed

        statistics = {
            'altitude_maximum': altitude_maximum,
            'altitude_mean': altitude_mean,
            'altitude_minimum': altitude_minimum,
            'average_speed': average_speed,
            'difficulty_index': difficulty_index,
            'distance': distance,
            'elevation': elevation,
            'elevation_mean': elevation_mean,
            'elevation_gain': elevation_gain,
            'elevation_gain_mean': elevation_gain_mean,
            'elevation_loss': elevation_loss,
            'elevation_loss_mean': elevation_loss_mean,
            'estimated_time': estimated_time,
        }

        return statistics

    except Exception:
        return None


def find_nearby(
    latitude: float,
    longitude: float,
) -> Union[str, dict[str, Any]]:
    '''
    Finds the nearest geographical feature (administrative, populated place, or terrain) 
    using the GeoNames API based on the given latitude and longitude.

    Parameters:
        latitude (float): Latitude in decimal degrees.
        longitude (float): Longitude in decimal degrees.

    Returns:
        nearby (str): Name of the nearest feature if found, otherwise a formatted coordinate string with N/S and E/W suffixes.
    '''

    result = None
    url = f'http://api.geonames.org/findNearbyJSON'

    try:
        if not GEONAMES_USERNAME:
            raise Exception

        # try to find the closest feature in order of priority: Administrative, Populated place, Terrain
        for feature_class in ['A', 'P', 'T']:
            params = {
                'featureClass': feature_class,
                'lang': 'local',
                'lat': latitude,
                'lng': longitude,
                'username': GEONAMES_USERNAME,
            }

            response = get(url, params)
            response.raise_for_status()
            data = response.json()
            if 'geonames' in data and data['geonames'] and 'distance' in data['geonames'][0]:
                nearest = data['geonames'][0]
                if result is None or float(nearest['distance']) < float(result['distance']):
                    result = nearest

    except Exception:
        result = None

    if result:
        nearby = result['name']
        return nearby

    else:
        # fallback: formatted coordinates with hemisphere notation
        suffix_latitude = 'N' if latitude >= 0.0 else 'S'
        suffix_longitude = 'E' if longitude >= 0.0 else 'W'
        nearby = f'{round(abs(latitude), 8)}{suffix_latitude}, {round(abs(longitude), 8)}{suffix_longitude}'
        return nearby


def generate_climb_profile(
    climb: dict[str, float],
    dataframe,
    units: str,
    locale: str,
) -> str | None:

    altitude_multiplier = ALTITUDE_MULTIPLIER_METRIC if units == 'metric' else ALTITUDE_MULTIPLIER_IMPERIAL
    altitude_unit = 'm' if units == 'metric' else 'ft'
    distance_multiplier = DISTANCE_MULTIPLIER_METRIC if units == 'metric' else DISTANCE_MULTIPLIER_IMPERIAL
    distance_unit = 'km' if units == 'metric' else 'mi'

    try:
        setlocale(LC_NUMERIC, locale)
        dataframe = dataframe.iloc[climb['index_start']:climb['index_finish']].copy()
        altitude_maximum = dataframe['altitude'].max()
        altitude_minimum = dataframe['altitude'].min()
        dataframe['distance_relative'] = dataframe['distance'] - dataframe['distance'].iloc[0]
        distance = dataframe['distance_relative'].iloc[-1]

        distance_relative = linspace(
            num=SEGMENT_NUMBER + 1,
            start=dataframe['distance_relative'].iloc[0],
            stop=distance,
        )

        altitudes = interp(
            fp=dataframe['altitude'].values,
            x=distance_relative,
            xp=dataframe['distance_relative'].values,
        )

        fig = figure(dpi=FIGURE_DPI, figsize=FIGURE_FIGSIZE)
        ax = fig.add_subplot()
        ax.spines[['top', 'right', 'left', 'bottom']].set_visible(False)
        ax.tick_params(
            bottom=False,
            labelbottom=False,
            labelleft=False,
            left=False,
        )

        ymin = altitude_minimum - ((altitude_maximum - altitude_minimum) * 0.16)
        ymax = altitude_maximum
        ax.set_ylim(
            bottom=ymin - ((ymax - ymin) * 0.18),
            top=ymax + ((ymax - ymin) * 0.24),
        )

        ax.set_xlim(
            left=dataframe['distance_relative'].iloc[0],
            right=distance,
        )

        columns = [altitudes[0]]

        for i in range(SEGMENT_NUMBER):
            x0 = distance_relative[i]
            x1 = distance_relative[i + 1]
            y0 = columns[-1]
            length = x1 - x0
            gradient = ((altitudes[i + 1] - altitudes[i]) / length) * GRADIENT_MULTIPLIER if length > 0.0 else 0.0
            y1 = y0 + (gradient / GRADIENT_MULTIPLIER) * length
            columns.append(y1)

            if int(round(gradient)) <= 0:
                color = '#ffffff'

            elif int(round(gradient)) == 1:
                color = '#ffffc2'

            elif int(round(gradient)) == 2:
                color = '#ffff7e'

            elif int(round(gradient)) == 3:
                color = '#ffff40'

            elif int(round(gradient)) == 4:
                color = '#ffff1c'

            elif int(round(gradient)) == 5:
                color = '#fffa0a'

            elif int(round(gradient)) == 6:
                color = '#ffcd0a'

            elif int(round(gradient)) == 7:
                color = '#ffac0a'

            elif int(round(gradient)) == 8:
                color = '#fa840a'

            elif int(round(gradient)) == 9:
                color = '#fa5c08'

            elif int(round(gradient)) == 10:
                color = '#fa3208'

            elif int(round(gradient)) == 11:
                color = '#fa0208'

            elif int(round(gradient)) == 12:
                color = '#fa0006'

            elif int(round(gradient)) == 13:
                color = '#e20004'

            elif int(round(gradient)) == 14:
                color = '#c80006'

            elif int(round(gradient)) == 15:
                color = '#b40004'

            elif int(round(gradient)) == 16:
                color = '#9e0004'

            elif int(round(gradient)) == 17:
                color = '#8c0004'

            elif int(round(gradient)) >= 18:
                color = '#7c0002'

            ax.fill_between(
                color=color,
                x=[x0, x1],
                y1=[y0, y1],
                y2=ymin,
            )

            ax.vlines(
                alpha=0.4,
                colors='black',
                linestyles='-',
                linewidth=0.8,
                x=x1,
                ymax=y1,
                ymin=ymin,
            )

            ax.text(
                fontsize=10.0,
                fontweight='bold' if int(round(gradient)) > 0 else 'normal',
                ha='center',
                s=int(round(gradient)),
                va='bottom',
                x=(x0 + x1) / 2.0,
                y=max(y0, y1) + ((ymax - ymin) * 0.0064),
            )

        ax.plot(
            distance_relative,
            columns,
            color='black',
            linewidth=1.0,
        )

        ax.hlines(
            colors='black',
            linewidth=1.0,
            y=ymin,
            xmax=distance_relative[-1],
            xmin=distance_relative[0],
        )

        ax.text(
            fontsize=18.0,
            fontweight='bold',
            ha='right',
            s=climb['nearby'].upper().replace(
                '\\ ',
                ' ',
            ),
            va='top',
            x=ax.get_xlim()[1] - (distance * 0.01),
            y=ymax + ((ymax - ymin) * 0.22),
        )

        ax.text(
            fontsize=16.0,
            fontweight='bold',
            ha='right',
            s=f'({format_string(
                f='%.1f',
                grouping=True,
                val=distance * distance_multiplier,
            )} {distance_unit} à {format_string(
                f='%.1f',
                grouping=True,
                val=climb['gradient_mean'],
            )} %) $\\mathrm{{{format_string(
                f='%d',
                grouping=True,
                val=dataframe['altitude'].iloc[-1] * altitude_multiplier,
            ).replace(
                '-',
                '\\text{-}',
            )}\\ {altitude_unit}}}$',
            va='top',
            x=ax.get_xlim()[1] - (distance * 0.01),
            y=ymax + ((ymax - ymin) * 0.14),
        )

        ax.vlines(
            colors='black',
            linewidth=1.0,
            x=distance_relative[0],
            ymax=ymax + ((ymax - ymin) * 0.32),
            ymin=ymin - ((ymax - ymin) * 0.18),
        )

        ax.vlines(
            colors='black',
            linewidth=1.0,
            x=distance_relative[-1],
            ymax=columns[-1] + ((ymax - ymin) * 0.32),
            ymin=ymin - ((ymax - ymin) * 0.18),
        )

        ax.hlines(
            colors='black',
            linewidth=1.0,
            y=ymin - ((ymax - ymin) * 0.18),
            xmax=ax.get_xlim()[0] + (distance * ELEVATION_PROFILE_PLOT_OFFSET),
            xmin=ax.get_xlim()[0],
        )

        ax.hlines(
            colors='black',
            linewidth=1.0,
            y=ymin - ((ymax - ymin) * 0.18),
            xmax=ax.get_xlim()[1],
            xmin=ax.get_xlim()[1] - (distance * ELEVATION_PROFILE_PLOT_OFFSET),
        )

        ax.hlines(
            colors='black',
            linewidth=1.0,
            y=columns[-1] + ((ymax - ymin) * 0.24),
            xmax=ax.get_xlim()[0] + (distance * ELEVATION_PROFILE_PLOT_OFFSET),
            xmin=ax.get_xlim()[0],
        )

        ax.hlines(
            colors='black',
            linewidth=1.0,
            y=columns[-1] + ((ymax - ymin) * 0.24),
            xmax=ax.get_xlim()[1],
            xmin=ax.get_xlim()[1] - (distance * ELEVATION_PROFILE_PLOT_OFFSET),
        )

        if distance <= 1000.0:
            segments = [100.0, 200.0]

        elif distance <= 2000.0:
            segments = [100.0, 200.0, 500.0]

        elif distance <= 4000.0:
            segments = [200.0, 500.0, 1000.0]

        elif distance <= 10000.0:
            segments = [500.0, 1000.0, 2000.0]

        elif distance <= 20000.0:
            segments = [1000.0, 2000.0, 5000.0]

        else:
            segments = [2000.0, 5000.0, 10000.0]

        for index, width in enumerate(sorted(segments)):
            if width >= distance:
                continue

            gradient_maximum = -inf
            start = None

            for i in range(len(dataframe)):
                if dataframe['distance_relative'].iloc[i] + width > distance:
                    break

                j = dataframe['distance_relative'].searchsorted(dataframe['distance_relative'].iloc[i] + width)
                if j >= len(dataframe):
                    break

                elevation = dataframe['altitude'].iloc[j] - dataframe['altitude'].iloc[i]
                length = dataframe['distance_relative'].iloc[j] - dataframe['distance_relative'].iloc[i]
                if length == 0.0:
                    continue

                gradient = (elevation / length) * GRADIENT_MULTIPLIER
                if gradient > gradient_maximum:
                    gradient_maximum = gradient
                    start = dataframe['distance_relative'].iloc[i]

            if start is not None:
                if int(round(gradient_maximum)) <= 0:
                    color = '#ffffff'

                elif int(round(gradient_maximum)) == 1:
                    color = '#ffffc2'

                elif int(round(gradient_maximum)) == 2:
                    color = '#ffff7e'

                elif int(round(gradient_maximum)) == 3:
                    color = '#ffff40'

                elif int(round(gradient_maximum)) == 4:
                    color = '#ffff1c'

                elif int(round(gradient_maximum)) == 5:
                    color = '#fffa0a'

                elif int(round(gradient_maximum)) == 6:
                    color = '#ffcd0a'

                elif int(round(gradient_maximum)) == 7:
                    color = '#ffac0a'

                elif int(round(gradient_maximum)) == 8:
                    color = '#fa840a'

                elif int(round(gradient_maximum)) == 9:
                    color = '#fa5c08'

                elif int(round(gradient_maximum)) == 10:
                    color = '#fa3208'

                elif int(round(gradient_maximum)) == 11:
                    color = '#fa0208'

                elif int(round(gradient_maximum)) == 12:
                    color = '#fa0006'

                elif int(round(gradient_maximum)) == 13:
                    color = '#e20004'

                elif int(round(gradient_maximum)) == 14:
                    color = '#c80006'

                elif int(round(gradient_maximum)) == 15:
                    color = '#b40004'

                elif int(round(gradient_maximum)) == 16:
                    color = '#9e0004'

                elif int(round(gradient_maximum)) == 17:
                    color = '#8c0004'

                elif int(round(gradient_maximum)) >= 18:
                    color = '#7c0002'

                ax.add_patch(Rectangle(
                    edgecolor='black',
                    facecolor=color,
                    height=((ymax - ymin) * 0.026),
                    linewidth=0.4,
                    width=width,
                    xy=(start, ymin - ((ymax - ymin) * 0.1) + (2.0 - index) * (((ymax - ymin) * 0.026) + ((ymax - ymin) * 0.006))),
                ))

                gradient_text = start + width + (distance * 0.002)
                ha = 'left'

                if gradient_text > ax.get_xlim()[1] - (distance * 0.02):
                    gradient_text = start - (distance * 0.002)
                    ha = 'right'

                ax.text(
                    color='red',
                    fontsize=8.0,
                    fontweight='bold',
                    ha=ha,
                    s=format_string(
                        f='%.1f',
                        grouping=True,
                        val=gradient_maximum,
                    ),

                    va='center',
                    x=gradient_text,
                    y=(ymin - ((ymax - ymin) * 0.1) + (2.0 - index) * (((ymax - ymin) * 0.026) + ((ymax - ymin) * 0.006))) + ((ymax - ymin) * 0.026) / 2.0,
                )

        for i in reversed(range(SEGMENT_NUMBER)):
            x0 = distance_relative[i]
            x1 = distance_relative[i + 1]
            color = 'black' if (SEGMENT_NUMBER - 1 - i) % 2 == 0 else 'white'

            ax.add_patch(Rectangle(
                edgecolor='black',
                facecolor=color,
                height=(ymax - ymin) * 0.012,
                linewidth=0.4,
                width=x1 - x0,
                xy=(x0, ymin - ((ymax - ymin) * 0.12)),
            ))

            if i % 4 == 0 and i != 0 and i != SEGMENT_NUMBER:
                ax.text(
                    fontsize=8.0,
                    ha='center',
                    s=format_string(
                        f='%.1f',
                        grouping=True,
                        val=(distance - x0) * distance_multiplier,
                    ),

                    va='top',
                    x=x0,
                    y=ymin - ((ymax - ymin) * 0.14),
                )

        buffer = BytesIO()
        savefig(
            buffer,
            bbox_inches='tight',
            dpi=FIGURE_DPI,
            format='png',
        )

        close('all')
        buffer.seek(0)
        climb_profile = b64encode(buffer.read()).decode('utf-8')
        buffer.close()

        return climb_profile

    except Exception:
        return None


def generate_elevation_profile(
    climbs: list,
    dataframe: DataFrame,
    nearby_finish: str,
    nearby_start: str,
    units: str,
    locale: str = '',
) -> Union[str, None]:
    '''
    Generates an elevation profile plot as a base64-encoded PNG image string.

    Parameters:
        climbs (list): List of climb segments with metadata such as distance, gradient, and altitude.
        dataframe (DataFrame): DataFrame containing at least 'distance' and 'altitude' columns.
        nearby_finish (str): Name of the location near the route's end.
        nearby_start (str): Name of the location near the route's start.
        units (str): Unit system to use ('metric' or 'imperial').
        locale (str, optional): Locale string for number formatting. Defaults to ''.

    Returns:
        elevation_profile (Union[str, None]): Base64-encoded PNG image string if successful, otherwise None.
    '''

    altitude_multiplier = ALTITUDE_MULTIPLIER_METRIC if units == 'metric' else ALTITUDE_MULTIPLIER_IMPERIAL
    altitude_unit = 'm' if units == 'metric' else 'ft'
    distance_multiplier = DISTANCE_MULTIPLIER_METRIC if units == 'metric' else DISTANCE_MULTIPLIER_IMPERIAL
    distance_unit = 'km' if units == 'metric' else 'mi'

    try:
        setlocale(LC_NUMERIC, locale)

        altitude_finish = dataframe['altitude'].iloc[-1]
        altitude_maximum = dataframe['altitude'].max()
        altitude_minimum = dataframe['altitude'].min()
        altitude_standard_deviation = std(dataframe['altitude'])
        distance = dataframe['distance'].iloc[-1]
        start = dataframe['distance'].iloc[0]

        # dynamically calculate Y-axis upper bound depending on variation and length
        if altitude_standard_deviation > 0.0:
            ymax = altitude_maximum + ((max(altitude_maximum, ALTITUDE_MULTIPLIER_MAXIMUM)) * (ALTITUDE_MULTIPLIER_STANDARD_DEVIATION / altitude_standard_deviation) * (((distance * DISTANCE_MULTIPLIER) ** 2.0)
            if ((distance * DISTANCE_MULTIPLIER) > 1.0)
            else (distance * DISTANCE_MULTIPLIER)))

        else:
            if altitude_maximum != 0.0:
                ymax = altitude_maximum + ((ALTITUDE_MULTIPLIER_MAXIMUM / altitude_maximum) * (altitude_minimum - (altitude_minimum / ALTITUDE_MULTIPLIER_MINIMUM)))

            else:
                ymax = altitude_maximum + ALTITUDE_MULTIPLIER_MAXIMUM

        ymin = altitude_minimum - (altitude_minimum / ALTITUDE_MULTIPLIER_MINIMUM) if altitude_minimum > 0.0 else altitude_minimum
        fig = figure(dpi=FIGURE_DPI, figsize=FIGURE_FIGSIZE)
        ax = fig.add_subplot()

        # hide all default plot spines and ticks
        ax.spines[['bottom', 'left', 'right', 'top']].set_visible(False)
        ax.tick_params(
            bottom=False,
            labelbottom=False,
            labelleft=False,
            left=False,
        )

        # plot altitude line and fill the area beneath it
        ax.plot(dataframe['distance'], dataframe['altitude'], color='#ffd700', linewidth=2.0)
        ax.fill_between(dataframe['distance'], ymin, dataframe['altitude'], color='#ffd700cc')

        # set plot limits
        ax.set_xlim(start, distance)
        ax.set_ylim(ymin - ((ymax - ymin) * ELEVATION_PROFILE_PLOT_LIMIT), ymax + ((ymax - ymin) * ELEVATION_PROFILE_PLOT_LIMIT))

        # calculate interval for horizontal gridlines
        step = max(round((altitude_maximum - altitude_minimum) * DISTANCE_MULTIPLIER_METRIC) * GRADIENT_MULTIPLIER, GRIDLINE_STEP)

        # draw horizontal lines with altitude labels
        lines = arange(round((ymin // step) * step) + step, round(altitude_maximum) + step, step)

        for line in lines:
            if line > altitude_maximum:
                continue

            begin = None
            below = dataframe['altitude'] > line
            draw = False

            # detect continuous intervals where altitude exceeds the line
            for i in range(len(dataframe)):
                if below.iloc[i]:
                    if begin is None:
                        begin = i

                elif begin is not None:
                    ax.hlines(line, dataframe['distance'].iloc[begin], dataframe['distance'].iloc[i - 1], '#ffd700')
                    begin = None
                    draw = True

            if begin is not None:
                ax.hlines(line, dataframe['distance'].iloc[begin], distance, '#ffd700')
                draw = True

            if draw:
                ax.text(start - (distance * LENGTH_MULTIPLIER), line, f'{format_string('%d', round(line * altitude_multiplier), True)} {altitude_unit}', ha='right', va='center')

        # add plot border elements
        for x in ['left', 'right']:
            ax.vlines(ax.get_xlim()[0] if x == 'left' else ax.get_xlim()[1], ax.get_ylim()[0], ax.get_ylim()[1], '#000000')

        for y in ['bottom', 'top']:
            offset = distance * ELEVATION_PROFILE_PLOT_OFFSET
            ax.hlines(ax.get_ylim()[0] if y == 'bottom' else ax.get_ylim()[1], ax.get_xlim()[0], ax.get_xlim()[0] + offset, '#000000')
            ax.hlines(ax.get_ylim()[0] if y == 'bottom' else ax.get_ylim()[1], ax.get_xlim()[1] - offset, ax.get_xlim()[1], '#000000')

        # determine whether to shift labels to avoid overlap
        shift = False
        for i in range(len(climbs)):
            if ((climbs[i]['finish'] - climbs[i - 1]['finish']) / distance) < ELEVATION_PROFILE_CLIMB_GAP and i > 0:
                shift = True

        # draw black band under x-axis for distance labels
        ax.axhspan(ymin - ((ymax - ymin) * ELEVATION_PROFILE_BAND_NARROW) if shift == False else ymin - ((ymax - ymin) * ELEVATION_PROFILE_BAND_WIDE), ymin, color='#000000')

        # add start and end distance/altitude labels
        ax.text(ax.get_xlim()[0] + (distance * LENGTH_MULTIPLIER), ymin - ((ymax - ymin) * ELEVATION_PROFILE_PLOT_DISTANCE), format_string('%d', round(start * distance_multiplier), True), fontsize=16.0, fontweight='bold', ha='left', va='center')
        ax.text(ax.get_xlim()[1] - (distance * LENGTH_MULTIPLIER), ymin - ((ymax - ymin) * ELEVATION_PROFILE_PLOT_DISTANCE), f'{format_string('%.1f', round(distance * distance_multiplier, 1), True)} {distance_unit}', fontsize=16.0, fontweight='bold', ha='right', va='center')
        ax.text(ax.get_xlim()[0] + (distance * LENGTH_MULTIPLIER), ymax + ((ymax - ymin) * ELEVATION_PROFILE_PLOT_NEARBY), nearby_start.upper(), fontsize=18.0, fontweight='bold', ha='left', va='center')
        ax.text(ax.get_xlim()[1] - (distance * LENGTH_MULTIPLIER), ymax + ((ymax - ymin) * ELEVATION_PROFILE_PLOT_NEARBY), nearby_finish.upper(), fontsize=18.0, fontweight='bold', ha='right', va='center')
        ax.text(ax.get_xlim()[0] + (distance * LENGTH_MULTIPLIER), ymax + ((ymax - ymin) * ELEVATION_PROFILE_PLOT_ALTITUDE), f'{format_string('%d', round(dataframe['altitude'].iloc[0] * altitude_multiplier), True)} {altitude_unit}', fontsize=16.0, ha='left', va='center')
        ax.text(ax.get_xlim()[1] - (distance * LENGTH_MULTIPLIER), ymax + ((ymax - ymin) * ELEVATION_PROFILE_PLOT_ALTITUDE), f'({format_string('%.1f', round(climbs[-1]['distance'], 1), True)} {distance_unit} à {format_string('%.1f', round(climbs[-1]['gradient_mean'], 1), True)} %) $\\mathrm{{{format_string('%d', round(altitude_finish * altitude_multiplier), True).replace('-', '\\text{-}')}\\ {altitude_unit}}}$' if (len(climbs) > 0 and (climbs[-1]['finish'] / distance) > ELEVATION_PROFILE_CLIMB_TOP) else f'$\\mathrm{{{format_string('%d', round(altitude_finish * altitude_multiplier), True).replace('-', '\\text{-}')}\\ {altitude_unit}}}$', fontsize=16.0, fontweight='bold', ha='right', va='center')

        # draw climb markers and labels
        shift = False
        for i in range(len(climbs)):
            climb_altitude_maximum = climbs[i]['altitude_maximum']
            climb_distance = climbs[i]['distance']
            climb_finish = climbs[i]['finish']
            climb_gradient_mean = climbs[i]['gradient_mean']

            if (climb_finish / distance) < ELEVATION_PROFILE_CLIMB_TOP:
                if ((climb_finish - climbs[i - 1]['finish']) / distance) < ELEVATION_PROFILE_CLIMB_GAP and i > 0:
                    shift = True if shift == False else False

                else:
                    shift = False

                ax.text(climb_finish, ymin - ((ymax - ymin) * ELEVATION_PROFILE_PLOT_OFFSET_EXTRA) if shift == True else ymin - ((ymax - ymin) * ELEVATION_PROFILE_PLOT_OFFSET), format_string('%.1f', round(dataframe.loc[dataframe['distance'] == climb_finish, 'distance'].iloc[0] * distance_multiplier, 1), True), color='#ffd700', fontsize=12.0, fontweight='bold', ha='center', va='center')
                ax.text(climb_finish, dataframe.loc[dataframe['distance'] == climb_finish, 'altitude'].iloc[0] + ((ymax - ymin) * ELEVATION_PROFILE_CLIMB_SHIFT if shift == True else (ymax - ymin) * ELEVATION_PROFILE_CLIMB_DEFAULT), f'$\\mathrm{{{format_string('%d', round(climb_altitude_maximum), True)}\\ {altitude_unit}}}$\n$\\mathrm{{{climbs[i]['nearby'].replace(' ', '\\ ')}}}$\n({format_string('%.1f', round(climb_distance, 1), True)} {distance_unit} à {format_string('%.1f', round(climb_gradient_mean, 1), True)} %)', fontweight='bold', ha='center', va='bottom')
                ax.vlines(climb_finish, dataframe.loc[dataframe['distance'] == climb_finish, 'altitude'], dataframe.loc[dataframe['distance'] == climb_finish, 'altitude'] + ((ymax - ymin) * ELEVATION_PROFILE_PLOT_SHIFT if shift == True else (ymax - ymin) * ELEVATION_PROFILE_PLOT_DEFAULT), '#000000', alpha=0.4, lw=1.0)
                ax.vlines(climb_finish, ymin, dataframe.loc[dataframe['distance'] == climb_finish, 'altitude'], '#000000', '--', alpha=0.4, lw=1.0)

        # export to PNG in memory
        buffer = BytesIO()
        savefig(buffer, bbox_inches='tight', dpi=FIGURE_DPI, format='png')
        close('all')
        buffer.seek(0)
        elevation_profile = b64encode(buffer.read()).decode('utf-8')
        buffer.close()

        return elevation_profile

    except Exception:
        return None


def identify_climbs(
    dataframe: DataFrame,
    units: str,
    minimum_difficulty_index: float = DIFFICULTY_INDEX_EASY,
    minimum_distance: float = DISTANCE_EASY,
    minimum_gradient_mean: float = GRADIENT_MEAN,
) -> Union[list[dict[str, Any]], None]:
    '''
    Identifies climbing segments ('climbs') in a given elevation and distance dataset 
    based on difficulty, distance, and average gradient thresholds.

    Parameters:
        dataframe (DataFrame): A dataframe containing at least the following columns:
            'altitude', 'distance', 'gradient', 'difficulty_index', 
            'length', 'latitude', and 'longitude'.
        units (str): Either 'metric' or 'imperial'; determines unit conversion.
        minimum_difficulty_index (float): Minimum difficulty index to consider a segment as a climb.
        minimum_distance (float): Minimum horizontal distance (in meters) for a valid climb.
        minimum_gradient_mean (float): Minimum average gradient (%) for a valid climb.

    Returns:
        climbs (list[dict[str, Any]]): A list of identified climb segments with detailed metrics, 
        or None if an error occurs.
    '''

    altitude_multiplier = ALTITUDE_MULTIPLIER_METRIC if units == 'metric' else ALTITUDE_MULTIPLIER_IMPERIAL
    distance_multiplier = DISTANCE_MULTIPLIER_METRIC if units == 'metric' else DISTANCE_MULTIPLIER_IMPERIAL

    try:
        climbs = []
        difficulty_index = distance = elevation = elevation_gain = elevation_loss = 0.0
        identify = False
        length = 0.0

        # compute a dynamic gradient-loss threshold based on altitude variation and total distance
        threshold = min(
            std(dataframe['altitude']) * (dataframe['distance'].iloc[-1] * GRADIENT_LOSS_THRESHOLD),
            (dataframe['distance'].iloc[-1] * (round(dataframe['distance'].iloc[-1] * DISTANCE_MULTIPLIER_METRIC) ** (-1.0))),
        )

        for i in range(1, len(dataframe)):
            current_difficulty_index = dataframe['difficulty_index'].iloc[i]
            current_distance = dataframe['length'].iloc[i]
            current_elevation = dataframe['altitude'].iloc[i] - dataframe['altitude'].iloc[i - 1]
            current_gradient = dataframe['gradient'].iloc[i]

            if not identify:
                if current_gradient >= 0.0:
                    # start new climb segment
                    difficulty_index = current_difficulty_index
                    distance = current_distance
                    elevation = current_elevation
                    elevation_gain = current_elevation
                    identify = True
                    length = 0.0
                    start = i - 1

            else:
                # extend current climb segment
                difficulty_index += current_difficulty_index
                distance += current_distance
                elevation += current_elevation

                if current_gradient >= 0.0:
                    elevation_gain += current_elevation
                    length = 0.0

                else:
                    elevation_loss += current_elevation
                    length += current_distance

                # if descent after climb exceeds threshold, check if it's a valid climb
                if length > threshold:
                    gradient_mean = (elevation / distance) * GRADIENT_MULTIPLIER if distance > 0.0 else 0.0

                    if difficulty_index >= minimum_difficulty_index and distance >= minimum_distance and gradient_mean >= minimum_gradient_mean:
                        finish = dataframe.loc[start:i - 1, 'altitude'].idxmax()

                        if finish > start:
                            climb = dataframe[start:finish]
                            nearby = find_nearby(climb['latitude'].iloc[-1], climb['longitude'].iloc[-1])

                            climbs.append({
                                'altitude_finish': climb['altitude'].iloc[-1] * altitude_multiplier,
                                'altitude_maximum': climb['altitude'].max() * altitude_multiplier,
                                'altitude_mean': climb['altitude'].mean() * altitude_multiplier,
                                'altitude_minimum': climb['altitude'].min() * altitude_multiplier,
                                'difficulty_index': difficulty_index,
                                'distance': distance * distance_multiplier,
                                'elevation': elevation * altitude_multiplier,
                                'elevation_gain': elevation_gain * altitude_multiplier,
                                'elevation_gain_mean': (elevation_gain / (distance * distance_multiplier)) * altitude_multiplier,
                                'elevation_loss': elevation_loss * altitude_multiplier,
                                'elevation_loss_mean': (elevation_loss / (distance * distance_multiplier)) * altitude_multiplier,
                                'elevation_mean': (elevation / (distance * distance_multiplier)) * altitude_multiplier,
                                'finish': climb['distance'].iloc[-1],
                                'gradient_maximum': climb['gradient'].max(),
                                'gradient_mean': gradient_mean,
                                'gradient_mean_positive': climb.loc[climb['gradient'] > 0.0, 'gradient'].mean(),
                                'index_finish': finish,
                                'index_start': start,
                                'nearby': nearby,
                                'start': climb['distance'].iloc[0],
                            })

                    # reset for next segment
                    difficulty_index = distance = elevation = elevation_gain = elevation_loss = 0.0
                    identify = False
                    length = 0.0

        # handle end-of-dataframe case
        if identify:
            gradient_mean = (elevation / distance) * GRADIENT_MULTIPLIER if distance > 0.0 else 0.0

            if difficulty_index >= minimum_difficulty_index and distance >= minimum_distance and gradient_mean >= minimum_gradient_mean:
                finish = dataframe.loc[start:i - 1, 'altitude'].idxmax() + 1

                if finish > start:
                    climb = dataframe[start:finish]
                    nearby = find_nearby(climb['latitude'].iloc[-1], climb['longitude'].iloc[-1])

                    climbs.append({
                        'altitude_finish': climb['altitude'].iloc[-1] * altitude_multiplier,
                        'altitude_maximum': climb['altitude'].max() * altitude_multiplier,
                        'altitude_mean': climb['altitude'].mean() * altitude_multiplier,
                        'altitude_minimum': climb['altitude'].min() * altitude_multiplier,
                        'difficulty_index': difficulty_index,
                        'distance': distance * distance_multiplier,
                        'elevation': elevation * altitude_multiplier,
                        'elevation_gain': elevation_gain * altitude_multiplier,
                        'elevation_gain_mean': (elevation_gain / (distance * distance_multiplier)) * altitude_multiplier,
                        'elevation_loss': elevation_loss * altitude_multiplier,
                        'elevation_loss_mean': (elevation_loss / (distance * distance_multiplier)) * altitude_multiplier,
                        'elevation_mean': (elevation / (distance * distance_multiplier)) * altitude_multiplier,
                        'finish': climb['distance'].iloc[-1],
                        'gradient_maximum': climb['gradient'].max(),
                        'gradient_mean': gradient_mean,
                        'gradient_mean_positive': climb.loc[climb['gradient'] > 0.0, 'gradient'].mean(),
                        'index_finish': finish,
                        'index_start': start,
                        'nearby': nearby,
                        'start': climb['distance'].iloc[0],
                    })

        return climbs

    except Exception:
        return None


def parse_fit(
        content: bytes,
) -> Union[list[list[float]], None]:
    '''
    Parses a FIT file and extracts a list of GPS coordinates with altitude.

    Parameters:
        content (bytes): Raw binary content of a .fit file.

    Returns:
        coordinates (Union[list[list[float]] | None]): A list of [latitude, longitude, altitude] entries 
        in decimal degrees and meters. Returns None if parsing fails or if the file
        does not contain complete location records.
    '''

    try:
        # initialize FIT parser with binary content
        file = FitFile(BytesIO(content))
        file.parse()
        coordinates = []

        # iterate through all 'record' messages which contain GPS points
        for record in file.get_messages('record'):
            latitude = longitude = altitude = None

            # extract values from the record fields
            for field in record.as_dict()['fields']:
                if field['name'] == 'position_lat':
                    latitude = field['value']

                elif field['name'] == 'position_long':
                    longitude = field['value']

                elif field['name'] == 'altitude':
                    altitude = field['value']

            # if any coordinate data is missing, treat the record as invalid
            if latitude is None or longitude is None or altitude is None:
                # fail-fast if incomplete data is encountered
                raise Exception

            # convert to decimal degrees and store in output list
            coordinates.append([
                float(latitude) * FIT_COORDINATES_MULTIPLIER,
                float(longitude) * FIT_COORDINATES_MULTIPLIER,
                float(altitude),
            ])

        return coordinates

    except Exception:
        return None


def parse_gpx(
        content: bytes,
) -> Union[list[list[float]], None]:
    '''
    Parses a GPX file and extracts a list of GPS coordinates with altitude.

    Parameters:
        content (bytes): Raw byte content of a .gpx file.

    Returns:
        coordinates (Union[list[list[float]] | None]): A list of [latitude, longitude, altitude] points.
        Returns None if parsing fails or if any required data is missing.
    '''

    try:
        # decode bytes and parse as GPX
        file = parse(xml_or_file=content.decode('utf-8'))
        coordinates = []

        # traverse the GPX structure: tracks > segments > points
        for track in file.tracks:
            for segment in track.segments:
                for point in segment.points:
                    # ensure all coordinate components are present
                    if point.latitude is None or point.longitude is None or point.elevation is None:
                        # fail if any part of the coordinate is missing
                        raise Exception

                    coordinates.append([point.latitude, point.longitude, point.elevation])

        return coordinates

    except Exception:
        return None


def parse_kml(
    content: bytes,
) -> Union[list[list[float]], None]:
    '''
    Parses a KML file and extracts a list of GPS coordinates with altitude.

    Parameters:
        content (bytes): Raw byte content of a .kml file.

    Returns:
        coordinates (Union[list[list[float]], None]): A list of [latitude, longitude, altitude] entries.
        Returns None if parsing fails or coordinates are incomplete.
    '''

    try:
        # parse the XML content using lxml
        file = etree.fromstring(content)
        namespaces = file.nsmap

        # ensure a namespace key exists for 'kml'
        if None in namespaces:
            namespaces['kml'] = namespaces.pop(None)

        coordinates = []

        # find all <coordinates> elements in the KML
        elements = file.findall('.//kml:coordinates', namespaces=namespaces)

        for element in elements:
            # clean and split coordinate text into lines
            string = element.text.strip()

            for line in string.split():
                coordinate = line.split(',')

                # ensure the coordinate contains at least [longitude, latitude, altitude]
                if len(coordinate) < KML_COORDINATES_LENGTH:
                    # malformed coordinate
                    raise Exception

                # convert to float and re-order to [latitude, longitude, altitude]
                longitude, latitude, altitude = map(float, coordinate[:KML_COORDINATES_LENGTH])
                coordinates.append([latitude, longitude, altitude])

        return coordinates

    except Exception:
        return None


def parse_tcx(
    content: bytes,
) -> Union[list[list[float]], None]:
    '''
    Parses a TCX file and extracts a list of GPS coordinates with altitude.

    Parameters:
        content (bytes): Raw byte content of a .tcx file.

    Returns:
        coordinates (Union[list[list[float]], None]): A list of [latitude, longitude, altitude] points.
        Returns None if parsing fails or if required data is missing.
    '''

    try:
        # parse the XML using a file-like object
        file = etree.parse(BytesIO(content))

        # Garmin TCX XML namespace
        namespace = {'ns': 'http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2'}
        coordinates = []

        # find all <Trackpoint> elements in the TCX file
        for trackpoint in file.findall('.//ns:Trackpoint', namespace):
            latitude = trackpoint.find('ns:Position/ns:LatitudeDegrees', namespace)
            longitude = trackpoint.find('ns:Position/ns:LongitudeDegrees', namespace)
            altitude = trackpoint.find('ns:AltitudeMeters', namespace)

            # ensure all required sub-elements are present
            if latitude is None or longitude is None or altitude is None:
                # invalid or incomplete trackpoint
                raise Exception

            coordinates.append([float(latitude.text), float(longitude.text), float(altitude.text)])

        return coordinates

    except Exception:
        return None


@app.post('/fastapi/analyse')
async def analyse(
    average_speed: float = Form(AVERAGE_SPEED),
    file: UploadFile = File(...),
    level: str = Form('easy'),
    locale: str = Form(''),
    units: str = Form('metric'),
) -> JSONResponse:
    '''
    Analyse uploaded activity file (FIT, GPX, KML, TCX) and return elevation,
    statistics, and climb profiles.

    Parameters:
        average_speed (float): Assumed average speed for time estimation.
        file (UploadFile): Uploaded activity file.
        level (str): Difficulty filter ('easy', 'medium', 'difficult').
        locale (str): Locale used for formatting (e.g., 'cs_CZ' or 'en_US').
        units (str): Measurement system ('metric' or 'imperial').

    Returns:
        JSONResponse: Contains coordinates, elevation profile, climb statistics,
        and metadata for start and finish locations.

    Raises:
        HTTPException: If no valid file could be parsed.
    '''

    content = await file.read()

    for parser in [parse_fit, parse_gpx, parse_kml, parse_tcx]:
        coordinates = parser(content)

        if coordinates:
            # construct initial dataframe with basic columns
            dataframe = DataFrame(coordinates, columns=['latitude', 'longitude', 'altitude'])

            # compute point-to-point elevation change
            dataframe['elevation'] = INITIAL_LIST + [
                dataframe['altitude'].iloc[i] - dataframe['altitude'].iloc[i - 1]
                for i in range(1, len(dataframe))
            ]

            # compute distance between points using haversine formula
            dataframe['length'] = INITIAL_LIST + [
                haversine(
                    (dataframe['latitude'].iloc[i - 1], dataframe['longitude'].iloc[i - 1]),
                    (dataframe['latitude'].iloc[i], dataframe['longitude'].iloc[i]),
                    Unit.METERS,
                ) for i in range(1, len(dataframe))
            ]

            # compute cumulative distance
            dataframe['distance'] = dataframe['length'].cumsum()

            # compute gradient (elevation gain per distance)
            dataframe['gradient'] = INITIAL_LIST + [
                dataframe['elevation'].iloc[i] / (dataframe['length'].iloc[i] * LENGTH_MULTIPLIER)
                if dataframe['length'].iloc[i] != 0.0
                else 0.0
                for i in range(1, len(dataframe))
            ]

            # smooth the gradient using Gaussian filter
            dataframe['gradient'] = gaussian_filter1d(dataframe['gradient'], GAUSSIAN_FILTER_SIGMA)

            # compute difficulty index per segment based on gradient and altitude
            dataframe['difficulty_index'] = INITIAL_LIST + [
                (((max(dataframe['gradient'].iloc[i], 1.0) ** 2.0) / dataframe['length'].iloc[i])
                * (1.0 + ((dataframe['altitude'].iloc[i] ** 2.0) / ALTITUDE_FACTOR))) * LENGTH_MULTIPLIER
                if dataframe['length'].iloc[i] != 0.0
                else 0.0
                for i in range(1, len(dataframe))
            ]

            # set thresholds for climb identification based on selected level
            if level == 'easy':
                minimum_difficulty_index = DIFFICULTY_INDEX_EASY
                minimum_distance = DISTANCE_EASY
                minimum_gradient_mean = GRADIENT_MEAN

            elif level == 'medium':
                minimum_difficulty_index = DIFFICULTY_INDEX_MEDIUM
                minimum_distance = DISTANCE_MEDIUM
                minimum_gradient_mean = GRADIENT_MEAN

            elif level == 'difficult':
                minimum_difficulty_index = DIFFICULTY_INDEX_DIFFICULT
                minimum_distance = DISTANCE_DIFFICULT
                minimum_gradient_mean = GRADIENT_MEAN

            # identify nearby start and finish locations (e.g. towns or landmarks)
            start = find_nearby(dataframe['latitude'].iloc[0], dataframe['longitude'].iloc[0])
            finish = find_nearby(dataframe['latitude'].iloc[-1], dataframe['longitude'].iloc[-1])

            # identify climbs based on difficulty and distance thresholds
            climbs = identify_climbs(
                dataframe=dataframe,
                units=units,
                minimum_difficulty_index=minimum_difficulty_index,
                minimum_distance=minimum_distance,
                minimum_gradient_mean=minimum_gradient_mean,
            )

            # compute overall statistics from the trip
            statistics = calculate_statistics(
                average_speed=average_speed,
                dataframe=dataframe,
                units=units,
            )

            # generate overall elevation profile (with climb highlights, labels, etc.)
            elevation_profile = generate_elevation_profile(
                climbs=climbs,
                dataframe=dataframe,
                nearby_finish=finish,
                nearby_start=start,
                units=units,
                locale=locale,
            )

            # generate visual and statistical data for each climb
            climb_profiles = []
            for climb in climbs:
                climb_profiles.append({
                    'profile': generate_climb_profile(
                        climb=climb,
                        dataframe=dataframe,
                        units=units,
                        locale=locale,
                    ),
                    'statistics': climb,
                })

            # return all structured results in a single JSON response
            return JSONResponse(
                content={
                    'climb_profiles': climb_profiles,
                    'coordinates': coordinates,
                    'elevation_profile': elevation_profile,
                    'nearby_finish': finish,
                    'nearby_start': start,
                    'statistics': statistics,
                }
            )

    # if no parser was able to extract valid data, raise HTTPException
    raise HTTPException(BAD_REQUEST)
