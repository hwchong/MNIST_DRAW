# End to end model training and inference using Keras (Tensorflow) and CoreML. 

This is a sample application that demonstrates the end-to-end process of training a custom model for digit recognition (MNIST) from scratch using Keras running on Tensorflow 1.1 as its backend and generating a CoreML model for inference on iOS 11.  

![Demo Gif](http://i.makeagif.com/media/6-12-2017/W16R24.gif)

[YouTube Video](https://www.youtube.com/watch?v=nL6LPTW08LQ)

### Getting Started

The fastest way to get started is to install [Docker](https://www.docker.com/community-edition) for your machine.

Once Docker has been installed, either pull a pre-made Docker image Docker Hub:

```sh
$ docker pull hwchong/kerastraining4coreml
```
or build it in the Training folder in the repo:
```sh
$ cd Training
$ docker build -t 'inserttagname' .
```
To start the Jupyter Notebook server which will serve as your Python REPL and IDE execute the following command:
```sh
$ docker run -p 8888:8888 -p 6006:6006 hwchong/kerastraining4coreml
```
*If using your own tag name, remember to subsitute hwchong/kerastraining4coreml with whatever you used to build your Docker Image*

Remember to watch the Terminal to get the token required to sign into your Jupyter Notebook instance. 

### Training
Launching the Jupyter Notebook will present you with two notebooks. To start training a Deep Neural Network consisting of a Convolutional Neural Network, execute the `Keras-1.2.2-mnist-cnn.ipynb` file.

Running the training will take ~15 minutes on a MacBook Pro.

### Conversion
Once model training has been completed, save the model file. 

To generate a coremlmodel file, run the model conversion notebook `Keras-CoreML.ipynb` . Once you have this file, download it to and insert it into your Xcode project. 

### Deployment

Please refer the the `Inference` folder and the included `MNIST_DRAW` to see how to implement the custom generated Keras coremlmodel.

