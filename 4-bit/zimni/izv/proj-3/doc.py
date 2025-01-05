#!/usr/bin/python3.10
"""
IZV cast3 projektu
Autor: David Kvacek (xkvace00@stud.fit.vutbr.cz)
"""
import pandas as pd
import matplotlib.pyplot as plt

def make_df(source: pd.DataFrame) -> pd.DataFrame:
    """
    Load the DataFrame from the source file and create a new DataFrame with the relevant columns.

    Args:
        source (pd.DataFrame): Path to the source file.

    Returns:
        pd.DataFrame: DataFrame with the relevant columns.
    """
    df = pd.read_pickle(source)

    # rename the column and convert the values
    df.rename(columns={"p14*100": "p14"}, inplace=True)
    df["p14"] = df["p14"] / 100

    # drop the rows with missing values
    df = df[["p11", "p11a", "p12", "p14"]].dropna()

    return df

def accident_cause(code: int) -> str:
    """
    Return the main cause of the accident based on the code.

    Args:
        code (int): Cause code of the accident.

    Returns:
        cause (str): Main cause of the accident.
    """
    if code == 100:
        cause = "nezaviněná řidičem"

    elif 201 <= code <= 209:
        cause = "nepřiměřená rychlost jízdy"

    elif 301 <= code <= 311:
        cause = "nesprávné předjíždění"

    elif 401 <= code <= 414:
        cause = "nedání přednosti v jízdě"

    elif 501 <= code <= 516:
        cause = "nesprávný způsob jízdy"

    elif 601 <= code <= 615:
        cause = "technická závada vozidla"

    return cause

def accident_damage(df: pd.DataFrame, fig_location: str = None, show_figure: bool = False) -> None:
    """
    Plot the average material damage based on the main cause of the accident.

    Args:
        df (pd.DataFrame): DataFrame with the relevant columns.
        fig_location (str, optional): Path to save the figure. Defaults to None.
        show_figure (bool, optional): Show the figure. Defaults to False.
    """
    # group the DataFrame by the main cause of the accident and calculate the average material damage
    cause = df.groupby("cause")["p14"].agg(["mean", "count"]).sort_values("count", ascending=False).reset_index()

    # create the bar plot
    plt.figure(figsize=(10, 6))
    bars = plt.bar(cause["cause"], cause["mean"], color=plt.cm.tab10.colors, width=0.6)

    # add the value of the average material damage to the bars
    for bar, value in zip(bars, cause["mean"]):
        plt.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 120, f"{value:.2f} Kč", ha="center", fontsize=10)

    # set the plot parameters
    plt.title("Průměrná hmotná škoda podle hlavní příčiny nehody", fontsize=16, fontweight="bold")
    plt.xticks(rotation=45, ha="right", fontsize=10)
    plt.ylabel("průměrná hmotná škoda (Kč)", fontsize=10)
    plt.tight_layout()

    if fig_location:
        plt.savefig(fig_location, bbox_inches="tight", dpi=300)

    if show_figure:
        plt.show()

    plt.close()

def accident_influence(series: pd.Series) -> str:
    """
    Return the influence of alcohol and drugs on the driver.

    Args:
        series (pd.Series): Row of the DataFrame.

    Returns:
        influence (str): Influence of alcohol and drugs on the driver.
    """
    if series["alcohol"] == "bez alkoholu" and series["drug"] == "bez drog":
        influence = "bez alkoholu a drog"

    elif series["alcohol"] == "pod vlivem alkoholu" and series["drug"] == "bez drog":
        influence = "pod vlivem alkoholu"

    elif series["alcohol"] == "bez alkoholu" and series["drug"] == "pod vlivem drog":
        influence = "pod vlivem drog"

    else:
        influence = "pod vlivem alkoholu a drog"

    return influence

def accident_guilty(df: pd.DataFrame) -> None:
    """
    Print the number of accidents caused by the driver under the influence of alcohol or drugs.

    Args:
        df (pd.DataFrame): DataFrame with the relevant columns.
    """
    # filter the DataFrame and drop the rows with invalid or missing values
    df = df[(df["p11"].isin([1, 2, 3, 6, 7, 8, 9])) & (df["p11a"].isin([0, 1, 2, 3, 4, 5, 6]))].copy()

    # create new columns with the influence of alcohol and drugs on the driver
    df["alcohol"] = df["p11"].apply(lambda x: "bez alkoholu" if x == 2 else "pod vlivem alkoholu")
    df["drug"] = df["p11a"].apply(lambda x: "bez drog" if x == 0 else "pod vlivem drog")

    # group the DataFrame by the main cause of the accident and the influence of alcohol and drugs on the driver
    df["status"] = df.apply(accident_influence, axis=1)
    without_influence = df[df["status"] == "bez alkoholu a drog"]["p14"].mean()
    under_influence = df[df["status"] != "bez alkoholu a drog"]["p14"].mean()
    df = df.groupby(["cause", "status"]).size().unstack(fill_value=0)

    print(f"{df}\n")
    print(f"Počet nehod zaviněných bez vlivu alkoholu a drog: {df.loc[:, "bez alkoholu a drog"].sum()} (průměrná hmotná škoda: {without_influence:.2f} Kč)")
    print(f"Počet nehod zaviněných pod vlivem alkoholu či drog: {df.loc[:, "pod vlivem alkoholu"].sum() + df.loc[:, "pod vlivem drog"].sum() + df.loc[:, "pod vlivem alkoholu a drog"].sum()} (průměrná hmotná škoda: {under_influence:.2f} Kč)")

if __name__ == "__main__":
    # load the DataFrame with accidents
    df_accidents = make_df("accidents.pkl.gz")

    # print the total number of accidents and the average material damage
    print(f"Celkový počet nehod: {df_accidents.shape[0]}")
    print(f"Průměrná hmotná škoda: {df_accidents["p14"].mean():.2f} Kč\n")

    # create a new column with the main cause of the accident
    df_accidents["cause"] = df_accidents["p12"].apply(accident_cause)

    # plot the average material damage based on the main cause of the accident
    accident_damage(df_accidents, "fig.png", False)

    # print the number of accidents caused by the driver under the influence of alcohol or drugs
    accident_guilty(df_accidents)
