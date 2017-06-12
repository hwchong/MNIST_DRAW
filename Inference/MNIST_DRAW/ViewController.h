//
//  ViewController.h
//  MNIST_DRAW
//
//  Created by Hon Weng Chong on 8/6/17.
//  Copyright © 2017 CliniCloud Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Canvas.h"

@interface ViewController : UIViewController

@property IBOutlet Canvas *canvas;
@property IBOutlet UILabel *predictionLabel;
@property IBOutlet UIButton *predictButton;

- (IBAction)predictButtonTapped:(id)sender;
- (IBAction)clearCanvas:(id)sender;

@end

