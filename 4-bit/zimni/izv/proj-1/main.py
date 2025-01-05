#!/usr/bin/env python3
"""
IZV cast1 projektu
Autor: David Kvacek (xkvace00@fit.vutbr.cz)

Detailni zadani projektu je v samostatnem projektu e-learningu.
Nezapomente na to, ze python soubory maji dane formatovani.

Muzete pouzit libovolnou vestavenou knihovnu a knihovny predstavene na prednasce
"""
from bs4 import BeautifulSoup
import requests
import numpy as np
from numpy.typing import NDArray
import matplotlib.pyplot as plt
from typing import List, Callable, Dict, Any


def distance(a: np.array, b: np.array) -> np.array:
    """
    Calculate the Euclidean distance between two numpy arrays.

    Args:
        a (np.array): The first numpy array of points.
        b (np.array): The second numpy array of points.

    Returns:
        np.array: The Euclidean distance between each corresponding pair of points in the numpy arrays.
    """
    return np.sqrt(np.sum((a - b) ** 2, axis=1))


def generate_graph(a: List[float], show_figure: bool = False, save_path: str | None = None):
    """
    Generate a filled graph based on input coefficients.

    Args:
        a (List[float]): List of coefficients used to generate the graph.
        show_figure (bool, optional): If True, display the graph. Defaults to False.
        save_path (str | None, optional): If specified, save the graph to the given path. Defaults to None.
    """
    x = np.linspace(0, 6 * np.pi, 1885)
    y = (np.array(a)[:, np.newaxis] ** 2) * np.sin(x)   # calculate the y values using the coefficients and sine function

    plt.figure(figsize=(10, 4))
    for i, y in enumerate(y):
        # fill the area between the curve and the x-axis for positive and negative values
        plt.fill_between(x, y, where=(y > 0), color=f"C{i}", alpha=0.1)
        plt.fill_between(x, y, where=(y < 0), color=f"C{i}", alpha=0.1)
        plt.plot(x, y, label=fr"$y_{{{a[i]}}}(x)$", color=f"C{i}")

    plt.xlabel("x")
    plt.ylabel(r"$f_a(x)$")
    plt.legend(fontsize=12, loc="upper center", bbox_to_anchor=(0.5, 1.2), ncol=len(a)) # place the legend above the graph

    # set the x-axis ticks to multiples of pi
    ticks = np.arange(0, 6.5 * np.pi, np.pi / 2)
    labels = []
    for tick in ticks:
        if np.isclose(tick, 0):
            labels.append(r"$0$")
        elif np.isclose(tick % np.pi, 0):
            n = int(round(tick / np.pi))
            labels.append(rf"${n}\pi$" if n > 1 else r"$\pi$")
        else:
            n = int(round(2 * tick / np.pi))
            labels.append(rf"$\frac{{{n}}}{{2}}\pi$")
    
    plt.xticks(ticks, labels)
    plt.xlim(0, 6 * np.pi)
    plt.ylim(- max(a) ** 2 - 2 * np.pi, max(a) ** 2 + 2 * np.pi)

    if save_path:
        plt.savefig(save_path, format="png", dpi=300, bbox_inches="tight")
    if show_figure:
        plt.show()


def generate_sinus(show_figure: bool = False, save_path: str | None = None):
    """
    Generate a graph with three sinusoidal functions.

    Args:
        show_figure (bool, optional): If True, display the waveforms. Defaults to False.
        save_path (str | None, optional): If specified, save the waveforms to the given path. Defaults to None.
    """
    t = np.linspace(0, 100, 10000)
    f1 = 0.5 * np.cos((1/50) * np.pi * t)
    f2 = 0.25 * (np.sin(np.pi * t) + np.sin((3/2) * np.pi * t))
    f3 = f1 + f2

    fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(10, 8), sharey=True)

    ax1.plot(t, f1)
    ax1.set_ylabel(r"$f_1(t)$")

    ax2.plot(t, f2)
    ax2.set_ylabel(r"$f_2(t)$")

    # identify the points where the combined waveform crosses f1 and split the waveform into segments
    flip = np.where(np.diff(f3 > f1) | (t[1:] >= 50) & (t[:-1] < 50))[0]
    times = np.split(t, flip + 1)
    parts = np.split(f3, flip + 1)
    above = np.split(f3 > f1, flip + 1)

    for time, part, over in zip(times, parts, above):
        # determine the color based on whether the combined waveform is above f1
        if over[0]:
            color = "green"
        else:
            color = "red" if time[0] < 50 else "orange"
        ax3.plot(time, part, color=color)

    ax3.set_ylabel(r"$f_1(t) + f_2(t)$")

    for ax in [ax1, ax2, ax3]:
        ax.set_xlim(0, 100)
        ax.set_ylim(-0.8, 0.8)
        ax.set_xticks([0, 25, 50, 75, 100])
        ax.set_yticks([-0.8, -0.4, 0.0, 0.4, 0.8])

    # remove the x-axis labels from the first two subplots
    ax1.tick_params(axis="x", labelbottom=False)
    ax2.tick_params(axis="x", labelbottom=False)

    if save_path:
        plt.savefig(save_path, format="png", dpi=300, bbox_inches="tight")
    if show_figure:
        plt.show()


def download_data() -> Dict[str, List[Any]]:
    """
    Download and parse geographic data from a specified URL.

    Returns:
        Dict[str, List[Any]]: A dictionary containing positions, latitudes, longitudes, and heights.
    """
    # original specified URL ("https://ehw.fit.vutbr.cz/izv/stanice.html") replaced with one containing data in readable format
    response = requests.get("https://ehw.fit.vutbr.cz/izv/st_zemepis_cz.html")  # URL found using browser developer and network tools
    soup = BeautifulSoup(response.content, "html.parser")
    rows = soup.find_all("tr", {"class": ["nezvyraznit", "zvyraznit"]})

    positions, lats, longs, heights = [], [], [], []

    # extract the position name, latitude, longitude, and height from each row
    for row in rows:
        cols = row.find_all("td")

        # replace commas with periods and remove the degree symbol
        position = cols[0].get_text(strip=True)
        latitude = float(cols[2].get_text(strip=True).replace(",", ".").replace("°", ""))
        longitude = float(cols[4].get_text(strip=True).replace(",", ".").replace("°", ""))
        height = float(cols[6].get_text(strip=True).replace(",", "."))

        # append the extracted data to the corresponding lists
        positions.append(position)
        lats.append(latitude)
        longs.append(longitude)
        heights.append(height)

    return {
        "positions": positions,
        "lats": lats,
        "longs": longs,
        "heights": heights
    }


if __name__ == "main":
    generate_graph([7, 4, 3], save_path="tmp_fn.png")
    generate_sinus(save_path="tmp_sin.png")
