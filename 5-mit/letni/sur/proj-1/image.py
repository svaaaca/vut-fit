#!/usr/bin/env python3

__file__ = "image.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Image-based person detection system using HOG features and SVM classifier."
__date__ = "2026-05-04"

import os
import glob
import numpy as np
from skimage import io, color
from skimage.feature import hog
from skimage.transform import rotate
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import LeaveOneGroupOut


def extract_session_id(file_path):
    """
    Extracts the session ID from the given file path.

    Args:
        file_path (str): Path to the image file.

    Returns:
        str: Session ID extracted from the filename.

    Example:
        'target_train/f401_01_f21_i0_0.png' -> '01'
    """
    file_name = os.path.basename(file_path)
    return file_name.split('_')[1]


def augment_image(image):
    """
    Applies data augmentation to a single image.

    Creates rotated versions of the image to increase training data diversity
    and improve model robustness to slight orientation changes.

    Args:
        image (np.ndarray): Grayscale image array.

    Returns:
        list: List containing original image and rotated versions.
    """
    return [image, rotate(image, angle=5, mode='edge'), rotate(image, angle=-5, mode='edge')]


def process_image_directory(directory_path, label):
    """
    Loads images from a directory, applies preprocessing and augmentation, and extracts HOG features.

    Converts RGB images to grayscale if needed, applies augmentation to training data,
    and extracts Histogram of Oriented Gradients (HOG) features for each image variant.

    Args:
        directory_path (str): Path to directory containing .png files.
        label (int or None): 1 for target, 0 for non-target, or None for unlabeled eval data.

    Returns:
        tuple: (features_array, labels_array, session_groups, file_names)
            - features_array: 2D numpy array of HOG feature vectors
            - labels_array: 1D numpy array of labels (or None)
            - session_groups: 1D numpy array of session IDs for grouping
            - file_names: List of base filenames without extension
    """
    features_list = []
    labels_list = []
    session_groups_list = []
    file_names_list = []

    image_files = sorted(glob.glob(os.path.join(directory_path, '*.png')))
    print(f"Processing {len(image_files)} files in '{directory_path}'...")

    for file_path in image_files:
        # load image
        image = io.imread(file_path)

        # convert to grayscale if RGB
        if len(image.shape) == 3:
            image = color.rgb2gray(image)

        session_id = extract_session_id(file_path)

        # apply augmentation only to training data
        if 'train' in directory_path:
            images_to_process = augment_image(image)
        else:
            images_to_process = [image]

        for augmented_image in images_to_process:
            # extract HOG features with parameters tuned for facial structures
            # orientations=8: 8 directional bins
            # pixels_per_cell=(16,16): cell size for gradient computation
            # cells_per_block=(1,1): block size for normalization
            hog_features = hog(augmented_image, orientations=8, pixels_per_cell=(16, 16), cells_per_block=(1, 1), visualize=False)
            features_list.append(hog_features)

            if label is not None:
                labels_list.append(label)

            session_groups_list.append(session_id)
            file_names_list.append(os.path.basename(file_path).replace('.png', ''))

    return (np.array(features_list), np.array(labels_list) if labels_list else None, np.array(session_groups_list), file_names_list)


if __name__ == "__main__":
    print("Loading and extracting image features...")
    features_target_train, labels_target_train, groups_target_train, names_target_train = process_image_directory('target_train', 1)
    features_target_dev, labels_target_dev, groups_target_dev, names_target_dev = process_image_directory('target_dev', 1)
    features_non_target_train, labels_non_target_train, groups_non_target_train, names_non_target_train = process_image_directory('non_target_train', 0)
    features_non_target_dev, labels_non_target_dev, groups_non_target_dev, names_non_target_dev = process_image_directory('non_target_dev', 0)

    # combine all training data
    training_features = np.vstack((features_target_train, features_target_dev, features_non_target_train, features_non_target_dev))
    training_labels = np.hstack((labels_target_train, labels_target_dev, labels_non_target_train, labels_non_target_dev))
    training_groups = np.hstack((groups_target_train, groups_target_dev, groups_non_target_train, groups_non_target_dev))

    # standardize features
    feature_scaler = StandardScaler()
    scaled_training_features = feature_scaler.fit_transform(training_features)

    print("Training image SVM and running cross-validation on all labeled data...")
    # initialize SVM with RBF kernel and balanced class weights
    svm_classifier = SVC(kernel='rbf', C=1.0, class_weight='balanced', probability=True, random_state=42)

    # Leave-One-Group-Out cross-validation to prevent overfitting to specific sessions
    logo_cv = LeaveOneGroupOut()
    validation_scores = []

    for train_indices, validation_indices in logo_cv.split(scaled_training_features, training_labels, training_groups):
        # fit scaler on training fold only to prevent data leakage
        fold_scaler = StandardScaler()
        fold_train_features = fold_scaler.fit_transform(training_features[train_indices])
        fold_validation_features = fold_scaler.transform(training_features[validation_indices])

        fold_train_labels = training_labels[train_indices]
        fold_validation_labels = training_labels[validation_indices]

        svm_classifier.fit(fold_train_features, fold_train_labels)
        fold_accuracy = svm_classifier.score(fold_validation_features, fold_validation_labels)
        validation_scores.append(fold_accuracy)

    print(f"Validation accuracies across sessions: {[round(s, 3) for s in validation_scores]}")
    print(f"Mean validation accuracy: {np.mean(validation_scores):.3f}")

    # retrain on full dataset
    svm_classifier.fit(scaled_training_features, training_labels)

    print("Processing evaluation data...")
    eval_features, _, _, eval_names = process_image_directory('eval', label=None)
    scaled_eval_features = feature_scaler.transform(eval_features)

    # get probabilities for positive class
    positive_probabilities = svm_classifier.predict_proba(scaled_eval_features)[:, 1]

    # sort results alphabetically
    sorted_results = sorted(zip(eval_names, positive_probabilities), key=lambda x: x[0])

    with open('image.txt', 'w') as output_file:
        for file_name, probability in sorted_results:
            hard_decision = 1 if probability >= 0.5 else 0
            output_file.write(f"{file_name} {probability:.4f} {hard_decision}\n")
    print(f"Image results saved to image.txt ({len(sorted_results)} samples)")
