#!/usr/bin/python3.10
"""
IZV cast3 projektu
Autor: David Kvacek (xkvace00@stud.fit.vutbr.cz)
"""
import pandas as pd
import geopandas
import matplotlib.pyplot as plt
import contextily
import sklearn.cluster
import numpy as np

def make_geo(df_accidents: pd.DataFrame, df_locations: pd.DataFrame) -> geopandas.GeoDataFrame:
    """
    Create GeoDataFrame from accidents and locations DataFrames.

    Args:
        df_accidents (pd.DataFrame): DataFrame with accidents.
        df_locations (pd.DataFrame): DataFrame with locations.

    Returns:
        geopandas.GeoDataFrame: GeoDataFrame with accidents and locations.
    """
    # merge accidents and locations dataframes and remove rows with missing or invalid coordinates
    df = df_accidents.merge(df_locations, on="p1")
    df = df[~(df["d"].isna() | df["e"].isna() | ((df["d"] == 0) & (df["e"] == 0)))]

    # replace swapped coordinates and remove outliers (coordinates outside the Czech Republic)
    df.loc[df["d"] < df["e"], ["d", "e"]] = df.loc[df["d"] < df["e"], ["e", "d"]].values

    # Czech Republic coordinates limits (EPSG:5514) from https://epsg.io/5514
    df = df[(df["d"] <= -159365.31) & (df["d"] >= -911053.67) & (df["e"] <= -951499.37) & (df["e"] >= -1353292.51)]

    # create GeoDataFrame with points from coordinates and set CRS to S-JTSK Krovak East North (EPSG:5514)
    gdf = geopandas.GeoDataFrame(df, geometry=geopandas.points_from_xy(df["d"], df["e"]), crs="EPSG:5514")
    return gdf

def plot_geo(gdf: geopandas.GeoDataFrame, fig_location: str = None, show_figure: bool = False):
    """
    Plot accidents on the map of the Czech Republic for the specified region and months.

    Args:
        gdf (geopandas.GeoDataFrame): GeoDataFrame with accidents and locations.
        fig_location (str, optional): Path to save the figure. Defaults to None.
        show_figure (bool, optional): Show the figure. Defaults to False.
    """
    # filter accidents for the Vysočina region and months January and July
    gdf = gdf[(gdf["p11"] >= 4) & (gdf["region"] == "VYS")]
    gdf_1 = gdf[gdf["date"].dt.month == 1]
    gdf_2 = gdf[gdf["date"].dt.month == 7]

    # convert GeoDataFrames to Web Mercator (EPSG:3857)
    gdf_1 = gdf_1.to_crs(epsg=3857)
    gdf_2 = gdf_2.to_crs(epsg=3857)

    # set the map extent
    x_min = pd.concat([gdf_1, gdf_2]).geometry.x.min() - 4000
    x_max = pd.concat([gdf_1, gdf_2]).geometry.x.max() + 4000
    y_min = pd.concat([gdf_1, gdf_2]).geometry.y.min() - 4000
    y_max = pd.concat([gdf_1, gdf_2]).geometry.y.max() + 4000

    # plot accidents on the map with OpenStreetMap basemap
    fig, axes = plt.subplots(1, 2, figsize=(12, 6), constrained_layout=True)
    plt.suptitle("Nehody pod vlivem alkoholu", fontsize=16, fontweight="bold")
    titles = ["Kraj Vysočina (leden)", "Kraj Vysočina (červenec)"]
    datasets = [gdf_1, gdf_2]

    # plot each dataset
    for ax, data, title in zip(axes, datasets, titles):
        data.plot(ax=ax, color="red", markersize=24, alpha=0.4)

        # set the map extent, title, and remove axis
        ax.set_xlim(x_min, x_max)
        ax.set_ylim(y_min, y_max)
        ax.set_title(title)
        ax.set_axis_off()

        # add OpenStreetMap basemap
        contextily.add_basemap(ax, crs=data.crs.to_string(), source=contextily.providers.OpenStreetMap.Mapnik)

    if fig_location:
        plt.savefig(fig_location, bbox_inches="tight", dpi=300)

    if show_figure:
        plt.show()

    plt.close(fig)

def plot_cluster(gdf: geopandas.GeoDataFrame, fig_location: str = None, show_figure: bool = False):
    """
    Plot accidents caused by wild animals in the Vysočina region with clusters.

    Args:
        gdf (geopandas.GeoDataFrame): GeoDataFrame with accidents and locations.
        fig_location (str, optional): Path to save the figure. Defaults to None.
        show_figure (bool, optional): Show the figure. Defaults to False.
    """
    # filter accidents caused by wild animals in the Vysočina region and convert to Web Mercator (EPSG:3857)
    gdf = gdf[(gdf["p10"] == 4) & (gdf["region"] == "VYS")]
    gdf = gdf.to_crs(epsg=3857)

    # cluster accidents using KMeans algorithm (originally used DBSCAN algorithm is not suitable for this task)
    kmeans = sklearn.cluster.KMeans(n_clusters=8, random_state=42).fit(np.vstack([gdf.geometry.x, gdf.geometry.y]).T)
    gdf["cluster"] = kmeans.labels_

    polygons = []
    sizes = []

    # create convex hull polygons for each cluster
    for id in np.unique(gdf["cluster"]):
        if id == -1:
            continue

        points = gdf[gdf["cluster"] == id]
        polygons.append(points.geometry.union_all().convex_hull)
        sizes.append(len(points))

    cluster_gdf = geopandas.GeoDataFrame({"size": sizes, "geometry": polygons}, crs=gdf.crs)

    # plot accidents and clusters on the map with OpenStreetMap basemap
    fig, axes = plt.subplots(1, 1, figsize=(10, 8), constrained_layout=True)
    plt.suptitle("Nehody zaviněné lesní zvěří (Kraj Vysočina)", fontsize=16, fontweight="bold")

    cluster_gdf.plot(ax=axes, column="size", cmap="viridis", alpha=0.4, legend=True, legend_kwds={"label": "počet nehod v oblasti", "orientation": "horizontal", "shrink": 0.74, "pad": 0.02})
    gdf.plot(ax=axes, color="red", markersize=16, alpha=0.4)

    # set the map extent and remove axis
    axes.set_xlim(gdf.geometry.x.min() - 4000, gdf.geometry.x.max() + 4000)
    axes.set_ylim(gdf.geometry.y.min() - 4000, gdf.geometry.y.max() + 4000)
    axes.set_axis_off()

    # add OpenStreetMap basemap
    contextily.add_basemap(axes, crs=gdf.crs.to_string(), source=contextily.providers.OpenStreetMap.Mapnik)

    if fig_location:
        plt.savefig(fig_location, bbox_inches="tight", dpi=300)

    if show_figure:
        plt.show()

    plt.close(fig)

if __name__ == "__main__":
    df_accidents = pd.read_pickle("accidents.pkl.gz")
    df_locations = pd.read_pickle("locations.pkl.gz")
    gdf = make_geo(df_accidents, df_locations)

    plot_geo(gdf, "geo1.png", True)
    plot_cluster(gdf, "geo2.png", True)

    import os
    assert os.path.exists("geo1.png")
    assert os.path.exists("geo2.png")
