//
//  ViewController.m
//  PressForChampagne
//
//  Created by James Speth on 1/7/16.
//  Copyright © 2016 Jimco. All rights reserved.
//

#import <Parse/Parse.h>
#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestChampagne)];
    [self.imageView addGestureRecognizer:recognizer];
}

- (void)requestChampagne
{
    PFPush *push = [PFPush new];
    [push setMessage:@"More Champagne, please!"];
    [push sendPushInBackground];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Champagne Requested"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Great!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
