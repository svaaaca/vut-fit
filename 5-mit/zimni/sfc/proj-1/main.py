#!/usr/bin/env python3

__file__ = "main.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Main script for ANFIS classification project."
__date__ = "2025-12-01"

import json
import matplotlib.pyplot as plt
import matplotlib.style as mplstyle
import numpy as np
import sys
from anfis import ANFIS
from generator import generate_dataset, split_dataset
from matplotlib.colors import ListedColormap

# setting global plotting style
mplstyle.use('seaborn-v0_8-whitegrid')

# define consistent color palette
FIRST = '#E41A1C'
SECOND = '#4DAF4A'
MISCLASSIFIED = '#000000'
LIGHT = ListedColormap([f'#FFAAAA', f'#AAFFBB'])

# define default values
EPOCHS = 256
LR = 0.08
SAMPLES = 512
INPUTS = 2
RULES = 2
X_MIN, X_MAX = 0.0, 1.0
Y_MIN, Y_MAX = 0.0, 1.0


def load_dataset(filename: str) -> tuple[np.ndarray, np.ndarray]:
    """Loads dataset from a text file.

    Args:
        filename (str): Path to the data file.

    Returns:
        (x, y) (tuple[np.ndarray, np.ndarray]): Features and labels arrays.
    """

    try:
        data = np.loadtxt(filename, delimiter=',')
        x = data[:, :-1]
        y = data[:, -1]
        return x, y

    except FileNotFoundError:
        return None, None


def generate_mse(history: dict) -> None:
    """Generates and saves a plot of the Mean Squared Error (MSE) over training epochs.

    Args:
        history (dict): Dictionary containing training history, including MSE values.
    """

    plt.figure(figsize=(10, 6))
    plt.plot(history['mse'], color='darkblue', linewidth=2, label='MSE Loss')
    plt.title('ANFIS Training Error')
    plt.xlabel('Epoch')
    plt.ylabel('Mean Squared Error (MSE)')
    plt.legend(frameon=True, facecolor='white', framealpha=1.0)
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.savefig('mse.png')
    plt.close()


def generate_test(model: ANFIS, x: np.ndarray, y_true: np.ndarray) -> None:
    """Generates and saves a plot of the decision boundary learned by the ANFIS model,

    Args:
        model (ANFIS): ANFIS model instance.
        x (np.ndarray): Input features for testing.
        y_true (np.ndarray): True labels for testing.
    """

    xx, yy = np.meshgrid(np.arange(X_MIN, X_MAX, 0.01), np.arange(Y_MIN, Y_MAX, 0.01))
    z = model.predict(np.c_[xx.ravel(), yy.ravel()])
    z = z.reshape(xx.shape)
    plt.figure(figsize=(10, 6))
    plt.pcolormesh(xx, yy, z, cmap=LIGHT, shading='auto', alpha=0.7)
    y_predict = model.predict(x)
    misclassified = x[y_true != y_predict]
    for i in range(model.n_rules_per_input):
        idx = np.where(y_true == i)
        plt.scatter(x[idx, 0], x[idx, 1], c=[FIRST, SECOND][i], edgecolor='k', s=40, marker='o', alpha=0.8, label=f'True Class {i}')

    plt.scatter(misclassified[:, 0], misclassified[:, 1], c=MISCLASSIFIED, marker='x', s=100, linewidth=2, label='Misclassified')
    plt.xlim(X_MIN, X_MAX)
    plt.ylim(Y_MIN, Y_MAX)
    plt.title(f'ANFIS Learned Decision Boundary and Testing Samples')
    plt.xlabel('Input X1')
    plt.ylabel('Input X2')
    plt.legend(loc='upper right', frameon=True, facecolor='white', framealpha=1.0)
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.savefig('test.png')
    plt.close()


if __name__ == "__main__":
    if len(sys.argv) > 3:
        EPOCHS = int(sys.argv[1])
        LR = float(sys.argv[2])
        SAMPLES = int(sys.argv[3])

    print("----------------------------")
    print("ANFIS CLASSIFICATION PROJECT")
    print("----------------------------")
    print(f"Epochs:        {EPOCHS}")
    print(f"Learning Rate: {LR}")
    print(f"Samples:       {SAMPLES}")

    data = generate_dataset(samples=SAMPLES)
    split_dataset(data)
    x_train, y_train = load_dataset('train.txt')
    x_test, y_test = load_dataset('test.txt')

    print("----------------------------")
    print("     DATA PREPARATION")
    print("----------------------------")
    print(f"Training samples: {len(x_train)}")
    print(f"Testing samples:  {len(x_test)}")

    model = ANFIS(n_inputs=INPUTS, n_rules_per_input=RULES)

    print("----------------------------")
    print("   MODEL INITIALIZATION")
    print("----------------------------")
    print(f"Model using {model.n_rules} rules (2x2)")

    print("----------------------------")
    print("  TRAINING ADAPTIVE SYSTEM")
    print("----------------------------")

    model.train(x_train, y_train, lr=LR, epochs=EPOCHS)

    print("----------------------------")
    print(" PREDICTION AND EVALUATION")
    print("----------------------------")
    print(f"Training Accuracy: {np.mean(model.predict(x_train) == y_train) * 100:.2f} %")
    print(f"Testing Accuracy:  {np.mean(model.predict(x_test) == y_test) * 100:.2f} %")

    print("----------------------------")
    print("VISUALIZATION AND MODEL SAVE")
    print("----------------------------")

    generate_mse(model.history)
    generate_test(model, x_test, y_test)

    with open('model.json', 'w') as f:
        json.dump(model.get_params(), f, indent=4)

    print("\033[0;32m[OK]\033[0m Saving completed")
