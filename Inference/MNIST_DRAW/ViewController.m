//
//  ViewController.m
//  MNIST_DRAW
//
//  Created by Hon Weng Chong on 8/6/17.
//  Copyright © 2017 CliniCloud Inc. All rights reserved.
//

#import "ViewController.h"
#import "mnist_cnn_keras.h"

typedef enum {
	ALPHA = 0,
	BLUE = 1,
	GREEN = 2,
	RED = 3
} PIXELS;

@interface ViewController ()

@property MLMultiArray *inputArray;
@property mnist_cnn_keras *model;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// this sets up the a NSArray with the values [1,28,28] to correspond
	// with the tensor input shape in the Keras model.
	NSArray *tensorShape = [NSArray arrayWithObjects:@1,@28,@28, nil];
	NSError *error;
	_inputArray = [[MLMultiArray alloc] initWithShape:tensorShape dataType:MLMultiArrayDataTypeFloat32 error:&error];
	
	// setup the model
	_model = [[mnist_cnn_keras alloc] init];
	
	if (error != nil) {
		[_predictionLabel setText:@"Error loading model"];
		[_predictButton setEnabled:false];
		NSLog(@"Tensor Setup Error - %@", error.localizedDescription);
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)predictButtonTapped:(id)sender {
	NSLog(@"Predict");
	
	NSError *error;
	
	[self populateInputTensor];
	
	// the output of mnist will produce a vector with 10 elements
	// each element is the probability of the recognised digit
	mnist_cnn_kerasOutput *output = [_model predictionFromInput1:_inputArray error:&error];
	
	// We loop through the output array and find the element with the highest
	// probability. That is then our output prediction.
	if (error == nil) {
		float value = 0;
		int maxIndex = 0;
		for (int i = 0; i < output.output1.count; i++) {
			NSLog(@"%f - %d", output.output1[i].floatValue, i);
			if (value < output.output1[i].floatValue) {
				maxIndex = i;
			}
		}
		_predictionLabel.text = [NSString stringWithFormat:@"Value is - %d", maxIndex];
	} else {
		NSLog(@"Model Error - %@", error.localizedDescription);
	}
}

- (void)populateInputTensor {
	// First we resize the image to 28x28px
	CGSize newSize = CGSizeMake(28, 28);
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
	[_canvas.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	CGSize size = [newImage size];
	int width = size.width;
	int height = size.height;
	
	// the pixels will be painted to this array
	uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
	// clear the pixels so any transparency is preserved
	memset(pixels, 0, width * height * sizeof(uint32_t));
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create a context with RGBA pixels
	CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
												 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
	// paint the bitmap to our context which will fill in the pixels array
	CGContextDrawImage(context, CGRectMake(0, 0, 28, 28), [newImage CGImage]);
	
	for(int y = 0; y < height; y++) {
		for(int x = 0; x < width; x++) {
			// get the individual pixel intensities from the bitmap
			uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
			// convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
			uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
			
			// copy the values of the grayscale pixel intensities to the input tensor
			_inputArray[y*width + x] = @((float)gray);
		}
	}
	
	// we're done with the context, color space, and pixels
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	free(pixels);
}

- (IBAction)clearCanvas:(id)sender {
	_canvas.image = [UIImage new];
	_predictionLabel.text = @"";
}

@end
