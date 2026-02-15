#!/usr/bin/env python3

__file__ = "generator.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Generator of synthetic dataset for ANFIS classification."
__date__ = "2025-12-01"

import numpy as np
import sys

BOUNDARY = 1.0
SAMPLES = 512
RATIO = 0.8


def generate_dataset(samples: int = SAMPLES) -> np.ndarray:
    """Generates a synthetic dataset for ANFIS classification.

    Args:
        samples (int, optional): Number of samples to generate. Defaults to SAMPLES.

    Returns:
        dataset (np.ndarray): Generated dataset with features and labels.
    """

    X1 = np.random.rand(samples)
    X2 = np.random.rand(samples)
    Y = (X1 + X2) >= BOUNDARY
    Y = Y.astype(int)
    dataset = np.vstack((X1, X2, Y)).T
    np.random.shuffle(dataset)
    return dataset


def split_dataset(data: np.ndarray, ratio: float = RATIO) -> tuple[int, int]:
    """Splits the dataset into training and testing sets.

    Args:
        data (np.ndarray): The dataset to split.
        ratio (float, optional): The ratio of training data. Defaults to RATIO.

    Returns:
        (training, testing) (tuple[int, int]): Number of training and testing samples.
    """

    size = int(ratio * len(data))
    train = data[:size]
    test = data[size:]
    np.savetxt('train.txt', train, fmt='%.4f', delimiter=',')
    np.savetxt('test.txt', test, fmt='%.4f', delimiter=',')
    training = len(train)
    testing = len(test)
    return training, testing


if __name__ == "__main__":
    data = generate_dataset(samples=int(sys.argv[1]) if len(sys.argv) > 1 else SAMPLES)
    training, testing = split_dataset(data)

    print("----------------------")
    print("GENERATING NEW DATASET")
    print("----------------------")
    print(f"Total Samples:    {int(sys.argv[1]) if len(sys.argv) > 1 else SAMPLES}")
    print(f"Training Samples: {training}")
    print(f"Testing Samples:  {testing}")
    print("----------------------")
    print(f"\033[0;32m[OK]\033[0m Generating completed")
