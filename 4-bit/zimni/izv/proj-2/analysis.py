#!/usr/bin/env python3.12
"""
IZV cast2 projektu
Autor: David Kvacek (xkvace00@stud.fit.vutbr.cz)
"""
from matplotlib import pyplot as plt
import pandas as pd
import seaborn as sns
import numpy as np
import zipfile

def load_data(filename : str, ds : str) -> pd.DataFrame:
    """
    Load data from a ZIP file and extract a specific dataset.

    Args:
        filename (str): Path to the ZIP file.
        ds (str): Name of the dataset to extract.

    Raises:
        FileNotFoundError: If the dataset is not found in the ZIP file.

    Returns:
        pd.DataFrame: Extracted dataset.
    """
    data_frames = []

    with zipfile.ZipFile(filename, "r") as zip:
        files = zip.namelist()
        folders = {file.split("/")[0] for file in files if "/" in file} # get all folders in the ZIP file

        for folder in folders:
            target = f"{folder}/I{ds}.xls"  # try to find the dataset in a folder
            if target in files:
                with zip.open(target) as file:
                    df = pd.read_html(file, encoding="cp1250")[0]
                    data_frames.append(df)

    if not data_frames:
        raise FileNotFoundError(f"File '{filename}' does not contain data for '{ds}'.")

    # concatenate all dataframes into one and remove unnamed columns
    df = pd.concat(data_frames, ignore_index=True)
    df = df.loc[:, ~df.columns.str.contains("^Unnamed")]

    return df

def parse_data(df: pd.DataFrame, verbose: bool = False) -> pd.DataFrame:
    """
    Parse the dataset and add new columns.

    Args:
        df (pd.DataFrame): Dataset to parse.
        verbose (bool, optional): Print the new size of the dataset. Defaults to False.

    Returns:
        pd.DataFrame: Parsed dataset.
    """
    df["date"] = pd.to_datetime(df["p2a"], format="%d.%m.%Y", errors="coerce")

    regions = {
        0: "PHA",
        1: "STC",
        2: "JHC",
        3: "PLK",
        4: "ULK",
        5: "HKK",
        6: "JHM",
        7: "MSK",
        14: "OLK",
        15: "ZLK",
        16: "VYS",
        17: "PAK",
        18: "LBK",
        19: "KVK"
    }

    # map region codes to region names and drop duplicates
    df["region"] = df["p4a"].map(regions)
    df = df.drop_duplicates(subset=["p1"])

    # calculate deep memory usage of the dataframe
    if verbose:
        size = df.memory_usage(deep=True).sum() / (10 ** 6)
        print(f"new_size={size:.1f} MB")

    return df

def plot_state(df: pd.DataFrame, fig_location: str = None, show_figure: bool = False):
    """
    Plot the number of accidents in each region based on the road surface state.

    Args:
        df (pd.DataFrame): Parsed dataset.
        fig_location (str, optional): Path to save the figure. Defaults to None.
        show_figure (bool, optional): Show the figure. Defaults to False.
    """
    # map road surface state codes to state names
    states = {
        1: "suchý povrch",
        2: "suchý povrch", 
        3: "mokrý povrch", 
        4: "bláto na vozovce", 
        5: "náledí, ujetý sníh",
        6: "náledí, ujetý sníh"
    }

    # group the data by region and state and count the number of accidents
    df["state"] = df["p16"].map(states)
    grouped = df.groupby(["region", "state"]).size().reset_index(name="count")

    states = grouped["state"].unique()
    regions = grouped["region"].unique()
    regions.sort()

    sns.set_theme(style="whitegrid")
    fig, axes = plt.subplots(2, 2, figsize=(12, 8), constrained_layout=True)
    fig.suptitle("Počty nehod podle stavu vozovky v jednotlivých krajích", fontsize=16, fontweight="bold")
    axes = axes.flatten()

    # plot the number of accidents in each region based on the road surface state
    for i, state in enumerate(states):
        ax = axes[i]
        data = grouped[grouped["state"] == state]
        sns.barplot(data=data, x="region", y="count", ax=ax, color=sns.color_palette("Set1")[i])

        # set plot properties
        ax.set_title(state, fontsize=14)
        ax.spines["top"].set_visible(False)
        ax.spines["right"].set_visible(False)
        ax.spines["bottom"].set_color("black")
        ax.spines["left"].set_color("black")
        ax.tick_params(axis="both", which="major", direction="inout", length=8, width=1, top=False, right=False, reset=True)
        ax.grid(visible=True, axis="both", which="major", linestyle="--", linewidth=1, alpha=0.4)

        # set axis labels
        if i // 2 == 1:
            ax.set_xlabel("kraj", fontsize=12)
        else:
            ax.set_xlabel("")

        if i % 2 == 0:
            ax.set_ylabel("počet nehod", fontsize=12)
        else:
            ax.set_ylabel("")

    if fig_location:
        plt.savefig(fig_location, bbox_inches="tight", dpi=300)

    if show_figure:
        plt.show()

    plt.close(fig)

def plot_alcohol(df: pd.DataFrame, df_consequences : pd.DataFrame, fig_location: str = None, show_figure: bool = False):
    """
    Plot the number of accidents with alcohol in each region based on the consequences.

    Args:
        df (pd.DataFrame): Parsed dataset.
        df_consequences (pd.DataFrame): Dataset with consequences.
        fig_location (str, optional): Path to save the figure. Defaults to None.
        show_figure (bool, optional): Show the figure. Defaults to False.
    """
    # merge the datasets and filter accidents with alcohol
    merged = pd.merge(df, df_consequences, on="p1", how="inner")
    alcohol = merged[(merged["p11"] >= 3) & (~merged["p2a"].isna())]

    # map injury codes to injury names
    injuries = {
        1: "usmrcení",
        2: "těžké zranění",
        3: "lehké zranění",
        4: "bez zranění"
    }

    # group the data by region, injury, and injured person and count the number of accidents
    copy = alcohol.copy()   # copy the dataframe to avoid warnings
    copy["injury"] = copy["p59g"].map(injuries)
    copy["injured"] = np.where(copy["p59a"] == 1, "řidič", "spolujezdec")
    accidents = copy.groupby(["region", "injury", "injured"]).size().reset_index(name="count")

    injuries = accidents["injury"].unique()
    regions = accidents["region"].unique()
    regions.sort()

    sns.set_theme(style="whitegrid")
    fig, axes = plt.subplots(2, 2, figsize=(12, 8), constrained_layout=True)
    fig.suptitle("Počty nehod s alkoholem podle následků v jednotlivých krajích", fontsize=16, fontweight="bold")
    axes = axes.flatten()

    # plot the number of accidents with alcohol in each region based on the consequences
    for i, injury in enumerate(injuries):
        ax = axes[i]
        data = accidents[accidents["injury"] == injury]
        sns.barplot(data=data, x="region", y="count", hue="injured", hue_order=["řidič", "spolujezdec"], ax=ax, palette="Set1")

        # set plot properties
        ax.set_title(injury, fontsize=14)
        ax.spines["top"].set_visible(False)
        ax.spines["right"].set_visible(False)
        ax.spines["bottom"].set_color("black")
        ax.spines["left"].set_color("black")
        ax.tick_params(axis="both", which="major", direction="inout", length=8, width=1, top=False, right=False, reset=True)
        ax.grid(visible=True, axis="both", which="major", linestyle="--", linewidth=1, alpha=0.4)
        ax.get_legend().remove()

        # set axis labels
        if i // 2 == 1:
            ax.set_xlabel("kraj", fontsize=12)
        else:
            ax.set_xlabel("")

        if i % 2 == 0:
            ax.set_ylabel("počet nehod", fontsize=12)
        else:
            ax.set_ylabel("")

    # add a legend to the figure
    handles, labels = ax.get_legend_handles_labels()
    fig.legend(handles, labels, loc="outside lower center", fontsize=10, ncol=2)

    if fig_location:
        plt.savefig(fig_location, bbox_inches="tight", dpi=300)

    if show_figure:
        plt.show()

    plt.close(fig)

def plot_type(df: pd.DataFrame, fig_location: str = None, show_figure: bool = False):
    """
    Plot the number of accidents in each region based on the type of collision.

    Args:
        df (pd.DataFrame): Parsed dataset.
        fig_location (str, optional): Path to save the figure. Defaults to None.
        show_figure (bool, optional): Show the figure. Defaults to False.
    """
    # select only four regions and map collision codes to collision names
    regions = ["JHM", "LBK", "STC", "VYS"]
    collisions = {
        1: "s jedoucím nekolejovým vozidlem",
        2: "s vozidlem zaparkovaným, odstaveným",
        3: "s pevnou překážkou",
        4: "s chodcem",
        5: "s lesní zvěří",
        6: "s domácím zvířetem",
        7: "s vlakem",
        8: "s tramvají"
    }

    # filter the data by four selected regions and map collision codes to collision names
    df = df[df["region"].isin(regions) & (df["p6"].notna())]
    copy = df.copy()    # copy the dataframe to avoid warnings
    copy["collision"] = copy["p6"].map(collisions)

    # group the data by region, date, and collision and count the number of accidents
    pivot = (copy.groupby(["region", "date", "collision"]).size().reset_index(name="count").pivot_table(index=["region", "date"], columns="collision", values="count", fill_value=0))
    monthly = pivot.groupby(level="region").resample("ME", level="date").sum().stack().reset_index(name="count")

    sns.set_theme(style="whitegrid")
    fig, axes = plt.subplots(2, 2, figsize=(12, 8), constrained_layout=True)
    fig.suptitle("Počty nehod podle druhu ve vybraných krajích v jednotlivých měsících", fontsize=16, fontweight="bold")
    axes = axes.flatten()

    # plot the number of accidents in each region based on the type of collision
    for i, region in enumerate(regions):
        ax = axes[i]
        data = monthly[monthly["region"] == region]
        sns.lineplot(data=data, x="date", y="count", hue="collision", ax=ax, palette="Set1", marker="o", markersize=4)

        # set plot properties
        if region == "JHM":
            ax.set_title("Jihomoravský kraj", fontsize=14)
        elif region == "LBK":
            ax.set_title("Liberecký kraj", fontsize=14)
        elif region == "STC":
            ax.set_title("Středočeský kraj", fontsize=14)
        else:
            ax.set_title("Kraj Vysočina", fontsize=14)

        ax.spines["top"].set_visible(False)
        ax.spines["right"].set_visible(False)
        ax.spines["bottom"].set_color("black")
        ax.spines["left"].set_color("black")
        ax.set_xlim([pd.Timestamp("2023-01-01"), pd.Timestamp("2024-10-01")])
        ax.tick_params(axis="both", which="major", direction="inout", length=8, width=1, top=False, right=False, reset=True)
        ax.grid(visible=True, axis="both", which="major", linestyle="--", linewidth=1, alpha=0.4)
        ax.xaxis.set_major_formatter(plt.matplotlib.dates.DateFormatter("%m/%y"))
        ax.get_legend().remove()

        # set axis labels
        if i // 2 == 1:
            ax.set_xlabel("měsíc", fontsize=12)
        else:
            ax.set_xlabel("")

        if i % 2 == 0:
            ax.set_ylabel("počet nehod", fontsize=12)
        else:
            ax.set_ylabel("")

    # add a legend to the figure
    handles, labels = ax.get_legend_handles_labels()
    fig.legend(handles, labels, loc="outside lower center", fontsize=10, ncol=4)

    if fig_location:
        plt.savefig(fig_location, bbox_inches="tight", dpi=300)

    if show_figure:
        plt.show()

    plt.close(fig)

if __name__ == "__main__":
    df = load_data("data_23_24.zip", "nehody")
    df_consequences = load_data("data_23_24.zip", "nasledky")
    df2 = parse_data(df, True)

    plot_state(df2, "01_state.png")
    plot_alcohol(df2, df_consequences, "02_alcohol.png")
    plot_type(df2, "03_type.png", True)
