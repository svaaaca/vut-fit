#!/usr/bin/env python3

__file__ = "audio.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Audio-based person detection system using SVM with MFCC features and VAD preprocessing."
__date__ = "2026-05-04"

import os
import glob
import numpy as np
import librosa
import warnings
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC
from sklearn.model_selection import LeaveOneGroupOut

# suppress librosa warnings regarding short audio segments after VAD trimming
warnings.filterwarnings('ignore', module='librosa')


def extract_session_id(file_path):
    """
    Extracts the session ID from the given file path.

    Args:
        file_path (str): Path to the audio file.

    Returns:
        str: Session ID extracted from the filename.

    Example:
        'target_train/f401_01_f21_i0_0.wav' -> '01'
    """
    file_name = os.path.basename(file_path)
    return file_name.split('_')[1]


def augment_audio_signal(audio_signal, sample_rate):
    """
    Applies data augmentation to the audio signal.

    This function creates variations of the input audio to increase the diversity
    of training data, helping to improve model generalization.

    Args:
        audio_signal (np.ndarray): The original audio signal.
        sample_rate (int): Sampling rate of the audio.

    Returns:
        list: List containing the original signal, a noisy version, and a time-stretched version.
    """
    # add random white noise with amplitude proportional to signal max
    noise_amplitude = 0.005 * np.random.uniform() * np.amax(audio_signal)
    noisy_signal = audio_signal + noise_amplitude * np.random.normal(size=audio_signal.shape[0])

    # apply time stretching to simulate faster speech
    fast_signal = librosa.effects.time_stretch(audio_signal, rate=1.05)

    return [audio_signal, noisy_signal, fast_signal]


def extract_audio_features(audio_signal, sample_rate):
    """
    Extracts MFCC features and their derivatives, then computes statistical moments.

    This creates a fixed-length feature vector by aggregating MFCCs, deltas, and delta-deltas
    across time using mean, std, median, max, and min statistics.

    Args:
        audio_signal (np.ndarray): The audio signal to process.
        sample_rate (int): Sampling rate of the audio.

    Returns:
        np.ndarray: 1D feature vector containing aggregated MFCC statistics.
    """
    # extract 20 MFCC coefficients
    mfcc_features = librosa.feature.mfcc(y=audio_signal, sr=sample_rate, n_mfcc=20)

    # compute first and second derivatives (deltas)
    delta_features = librosa.feature.delta(mfcc_features)
    delta_delta_features = librosa.feature.delta(mfcc_features, order=2)

    # stack all features vertically
    combined_features = np.vstack([mfcc_features, delta_features, delta_delta_features])

    # compute statistical aggregates across time axis (axis=1)
    feature_vector = np.hstack([
        np.mean(combined_features, axis=1),
        np.std(combined_features, axis=1),
        np.median(combined_features, axis=1),
        np.max(combined_features, axis=1),
        np.min(combined_features, axis=1)
    ])

    return feature_vector


def process_audio_directory(directory_path, label):
    """
    Loads audio files from a directory, applies preprocessing and augmentation, and extracts features.

    For training data, applies Voice Activity Detection (VAD) to remove silence and performs
    data augmentation. For evaluation data, only applies VAD.

    Args:
        directory_path (str): Path to directory containing .wav files.
        label (int or None): 1 for target, 0 for non-target, or None for unlabeled eval data.

    Returns:
        tuple: (features_array, labels_array, session_groups, file_names)
            - features_array: 2D numpy array of feature vectors
            - labels_array: 1D numpy array of labels (or None)
            - session_groups: 1D numpy array of session IDs for grouping
            - file_names: List of base filenames without extension
    """
    features_list = []
    labels_list = []
    session_groups_list = []
    file_names_list = []

    audio_files = sorted(glob.glob(os.path.join(directory_path, '*.wav')))
    print(f"Processing {len(audio_files)} files in '{directory_path}'...")

    for file_path in audio_files:
        # load audio with fixed sample rate
        audio_signal, sample_rate = librosa.load(file_path, sr=16000)

        # apply Voice Activity Detection to trim silence
        trimmed_signal, _ = librosa.effects.trim(audio_signal, top_db=20)

        # if trimming removes too much (mostly noise), keep original
        if len(trimmed_signal) > sample_rate * 0.1: 
            processed_signal = trimmed_signal
        else:
            processed_signal = audio_signal

        session_id = extract_session_id(file_path)

        # apply augmentation only to training data
        if 'train' in directory_path:
            signals_to_process = augment_audio_signal(processed_signal, sample_rate)
        else:
            signals_to_process = [processed_signal]

        for signal_variant in signals_to_process:
            feature_vector = extract_audio_features(signal_variant, sample_rate)
            features_list.append(feature_vector)

            if label is not None:
                labels_list.append(label)

            session_groups_list.append(session_id)
            file_names_list.append(os.path.basename(file_path).replace('.wav', ''))

    return (np.array(features_list), np.array(labels_list) if labels_list else None, np.array(session_groups_list), file_names_list)


if __name__ == "__main__":
    print("Loading and extracting audio features...")
    features_target_train, labels_target_train, groups_target_train, names_target_train = process_audio_directory('target_train', 1)
    features_target_dev, labels_target_dev, groups_target_dev, names_target_dev = process_audio_directory('target_dev', 1)
    features_non_target_train, labels_non_target_train, groups_non_target_train, names_non_target_train = process_audio_directory('non_target_train', 0)
    features_non_target_dev, labels_non_target_dev, groups_non_target_dev, names_non_target_dev = process_audio_directory('non_target_dev', 0)

    # combine all training features and labels
    training_features = np.vstack((features_target_train, features_target_dev, features_non_target_train, features_non_target_dev))
    training_labels = np.hstack((labels_target_train, labels_target_dev, labels_non_target_train, labels_non_target_dev))
    training_groups = np.hstack((groups_target_train, groups_target_dev, groups_non_target_train, groups_non_target_dev))

    # standardize features using StandardScaler
    feature_scaler = StandardScaler()
    scaled_training_features = feature_scaler.fit_transform(training_features)

    print("Training audio SVM and running cross-validation on all labeled data...")
    # initialize SVM classifier with RBF kernel
    svm_classifier = SVC(kernel='rbf', C=10.0, class_weight='balanced', probability=True, random_state=42)

    # use Leave-One-Group-Out cross-validation to respect session structure
    logo_cv = LeaveOneGroupOut()
    validation_scores = []

    for train_indices, validation_indices in logo_cv.split(scaled_training_features, training_labels, training_groups):
        # fit scaler on training fold only
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

    # retrain on full dataset for final model
    svm_classifier.fit(scaled_training_features, training_labels)

    print("Processing evaluation data...")
    eval_features, _, _, eval_names = process_audio_directory('eval', label=None)
    scaled_eval_features = feature_scaler.transform(eval_features)

    # get probability estimates for positive class
    positive_probabilities = svm_classifier.predict_proba(scaled_eval_features)[:, 1]

    # sort results by filename for consistent output
    sorted_results = sorted(zip(eval_names, positive_probabilities), key=lambda x: x[0])

    with open('audio.txt', 'w') as output_file:
        for file_name, probability in sorted_results:
            hard_decision = 1 if probability >= 0.5 else 0
            output_file.write(f"{file_name} {probability:.4f} {hard_decision}\n")
    print(f"Audio results saved to audio.txt ({len(sorted_results)} samples)")
