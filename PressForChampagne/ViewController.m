//
//  ViewController.m
//  PressForChampagne
//
//  Created by James Speth on 1/7/16.
//  Copyright © 2016 Jimco. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSString *message;
@end

@implementation ViewController

@synthesize message = _message;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestChampagne)];
    [self.imageView addGestureRecognizer:tapRecognizer];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeMessage:)];
    [self.imageView addGestureRecognizer:longPressRecognizer];
}

#pragma mark - Properties

#define kMessageKey @"PFCMessage"

- (NSString *)message
{
    if (!_message.length) {
        _message = [[NSUserDefaults standardUserDefaults] stringForKey:kMessageKey];
        if (!_message.length) {
            _message = @"More Champagne, please!";
        }
    }
    return _message;
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    [[NSUserDefaults standardUserDefaults] setObject:_message forKey:kMessageKey];
}

#pragma mark - Actions

- (void)requestChampagne
{
    // JGS - change to SNS
    /*
    PFPush *push = [PFPush new];
    NSString *installationId = [PFInstallation currentInstallation].objectId;
    if (installationId) {
        PFQuery *query = [PFInstallation query];
        [query whereKey:@"objectId" notEqualTo:installationId];
        [push setQuery:query];
    }
    [push setMessage:self.message];
    [push sendPushInBackground];
    */
    return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Champagne Requested"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Great!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)changeMessage:(UILongPressGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Message"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = self.message;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Change" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.message = alert.textFields.firstObject.text;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
