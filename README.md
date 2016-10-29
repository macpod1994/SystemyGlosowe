# SystemyGlosowe
# Speach Recognition - Command recognition

## Intruduction
   Speach signal is not deterministic signal. The biggest assumption one can make about it is that sound is a Stationary Stochactic Process in 10-40ms intervals. This characteristic makes it very difficult to analyse and process.
   Algorithms which operate directly on recorded signal are not able to filter individual information contained in them and as a result should be aimed for problems concerning recognition of specific user commands.
   If more robust system is required, then more advanced algorithms should be used which consist of two stages: feature extraction, and classification.
   
## Algorithms:
 
 1. Based on Correlation function - simply calculate correlation of pattern signals with sample to recognize, choose times for which correlation is maximal and use it to calculate mean square error of delayed signal with appropriate patterns. Recognized command is the one for which MSE is minimal.
  * Advantages: 
    * easy implementation
  * Disadvantage: 
    * Probably will work only for one specific user
    * Probably impossible to recognize many commands
    * pattern should be recorded by user for which samples will be recognized
  * Additional information:
    * requires calculation of correlation dunction, argmax, MSE.
    * [Source](http://www.diva-portal.org/smash/get/diva2:525564/fulltext01.pdf)
 2. Based on Wiener filter - evaluate Wiener filter coefficients with input as sample to recognize and estimated signals as patterns. After estimation of filters, MSEs of filter outputs deviations from estimated signal are calculated to recognize command.
  * Advantages: 
    * easy implementation
  * Disadvantage: 
    * Probably will work only for one specific user
    * Probably impossible to recognize many commands
    * Probably more general and robust than first algorithm, but not too much
    * pattern should be recorded by user for which samples will be recognized
  * Additional information:
    * requires calculation of Wiener filter coefficients a_i, which are dependent on input autocorrelation matrix and crosscorelation of estimated signal and input. 
    * [Wiener filter](https://en.wikipedia.org/wiki/Wiener_filter#Finite_impulse_response_Wiener_filter_for_discrete_series)
    
    ![Wiener Filter](https://upload.wikimedia.org/wikipedia/commons/0/00/Wiener_block.svg)
    * [Source](http://www.diva-portal.org/smash/get/diva2:525564/fulltext01.pdf)
    
 3. Feature extraction and machine learning - First stage of algorithm involves data preprocessing so that it removes unnecesary information from records and leaves samples which can be distinguished and classified in second stage, where some popular classificator from machine learning should be used i.e. SVM, K nearest neighbours or Neural Network.
 Feature extraction is usually based on [MFCC](http://practicalcryptography.com/miscellaneous/machine-learning/guide-mel-frequency-cepstral-coefficients-mfccs/) which identifies components of audio signal that correspond to linguistic information and filters most of redundant features of audio signal.
  * Advantages: 
    * that's how it should be done professionally
    * removal of individual information during first stage, which in our case is noise
    * recognition which should not be dependent on individual features
    * Second stage is implemented in [scikit-learn](http://scikit-learn.org/stable/supervised_learning.html#supervised-learning)
  * Disadvantage: 
    * lots of data required
    * Feature extraction is a bit tricky, I do not know for sure if it works. But many sources claim that it does.
  * Information for developers:
    * [Feature extraction in Python](https://github.com/jameslyons/python_speech_features)
    * [Feature extraction in MATLAB](http://labrosa.ee.columbia.edu/matlab/rastamat/)
    * [Machine learning classifiers in Python](http://scikit-learn.org/stable/supervised_learning.html#supervised-learning)
    
## Interpretation of MFCC

### Steps:
   1. Take the Fourier transform of (a windowed excerpt of) a signal.
   2. Map the powers of the spectrum obtained above onto the mel scale, using triangular overlapping windows.
   3. Take the logs of the powers at each of the mel frequencies.
   4. Take the discrete cosine transform of the list of mel log powers, as if it were a signal.
   5. The MFCCs are the amplitudes of the resulting spectrum.
   
   
First point involves FFT with usage of window function in order to limit spectrum distortion caused by limited sample.
In second point frequencies are rescaled so that the new frequency units correspnond to human percepion of sound. About 20 to 40 bins corresponding to distinguishable frequencies for human ear, are formed and average powers of each bin are calculated.  Power is proportional to |S(w)|^2. 

Human speach can be modeled as S(w) = H(w)*X(w), where H is transmitance of human vocal tract and is dependent on muscle tension and individual characteristics of a speaker, and X may be modeled as noise which is modulated by H to produce S, speach. 
Log operation changes multiplication for addition, hence third step. 
Fourth step's result are ceptral coefficients which are most common features in speach recognition. Discrete Cosine Transform DCT is a linear transform. Suppsedly only smaller coefficients contain information about muscle tension and phenomes build sounds and in effect commands.
 

Sources:

1. [Command recognition based on correlation function and wiener filter](http://www.diva-portal.org/smash/get/diva2:525564/fulltext01.pdf)
2. [Cepstral analysis](http://iitg.vlab.co.in/?sub=59&brch=164&sim=615&cnt=1)
3. [MFCC(Mel frequency cepstral coefficients)](http://practicalcryptography.com/miscellaneous/machine-learning/guide-mel-frequency-cepstral-coefficients-mfccs/)
4. [MFCC wiki](https://en.wikipedia.org/wiki/Mel-frequency_cepstrum)
