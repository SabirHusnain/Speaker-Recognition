# Speaker Identification Project

This project focuses on speaker identification using the Mel Frequency Cepstral Coefficient (MFCC) feature extraction technique. The MATLAB code provided here consists of several files that perform various tasks related to speaker identification. Below is a description of each file and its purpose within the project.

## `mfcc.m`

This file contains the implementation of the MFCC feature extraction algorithm. The `mfcc` function takes as input a speech signal, sampling frequency, analysis frame duration, analysis frame shift, preemphasis coefficient, analysis window function, frequency range for filterbank analysis, number of filterbank channels, number of cepstral coefficients, and liftering parameter. It computes the MFCC, filterbank energies, and windowed frames of the input speech signal. The MFCC is a widely used feature for speaker identification tasks.

## `simmx.m`

The `simmx` function calculates a similarity matrix between two feature matrices using a normalized inner product, which represents the cosine similarity between the feature vectors. It takes two feature matrices as inputs and returns the similarity matrix.

## `test.m`

The `test` function performs the speaker recognition test. It takes the sampling frequency as an optional input parameter. This function records a user's voice sample for 5 seconds and extracts MFCC features from the recorded sample. It then compares the extracted features with the stored speaker models in the `database` folder using the Dynamic Time Warping (DTW) algorithm. The function returns the test data, Euclidean distances between the test sample and speaker models, and the name of the identified speaker.

## `train.m`

The `train` function trains the speaker recognition model. It takes the speaker name and sampling frequency as input parameters. This function prompts the user to record a voice sample for 5 seconds, and the recorded sample is stored in the `database` folder with the provided speaker name. This recorded sample will be used as a speaker model for future speaker identification tests.

## `trifbank.m`

The `trifbank` function generates a triangular filterbank matrix for use in the MFCC feature extraction process. It takes the number of filters, length of the frequency response of each filter, frequency limits, sampling frequency, and forward/backward warping functions as inputs. The function returns the triangular filterbank matrix, a frequency vector, and a cutoff frequency vector. The triangular filters are uniformly spaced on a warped scale defined by the provided warping functions.

### Other Helper Functions

The code also includes several inline function handles used within the main functions. These functions include:

- `hz2mel`: Converts frequencies from Hertz to the mel scale.
- `mel2hz`: Converts frequencies from the mel scale to Hertz.
- `dctm`: Computes the Type III Discrete Cosine Transform (DCT) matrix.
- `ceplifter`: Computes the liftering coefficients for cepstral coefficients.

These helper functions assist in various calculations and transformations involved in the MFCC feature extraction and speaker identification process.

## Usage

To use this code for speaker identification, follow these steps:

1. Make sure you have MATLAB installed and set up on your system.
2. Open MATLAB and copy the provided code into a new script file.
3. Run the script.
4. When prompted, enter the speaker's name or ID to record their voice for training. This step will update the speaker's voice data in the database.
5. After recording, if the database is successfully updated, you will see the message "Thank You! Database Updated." Otherwise, if there is an error, the message "Error! Data isn't Saved" will be displayed.
6. The script will then proceed to the testing phase.
7. During the testing phase, the script will compare the recorded voice with the samples in the database to determine the speaker's identity.
8. The distance vector, which represents the Euclidean distance between the test sample and each database sample, will be displayed.
9. The minimum Euclidean distance will be printed, indicating the closest match.
10. The script will output the speaker's name identified based on the minimum distance.
11. The audio signals, both in the time domain and frequency domain, will be plotted for visualization.
12. Additionally, a time-pitch plot will be generated to show the variation in pitch over time for both the database signal and the test signal.
13. Examine the generated plots and the identified speaker's name to analyze the results of the speaker recognition system.

Note: Ensure that the database contains the necessary voice samples for accurate recognition.

This project provides a basic implementation of speaker identification using MFCC features. You can further enhance it by incorporating more advanced techniques, such as Gaussian Mixture Models (GMMs) or Deep Neural Networks (DNNs), and optimizing the parameters to improve the accuracy of speaker identification.