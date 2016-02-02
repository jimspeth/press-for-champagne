//
//  AppDelegate.m
//  PressForChampagne
//
//  Created by James Speth on 1/7/16.
//  Copyright © 2016 Jimco. All rights reserved.
//

#import <AWSCore/AWSCore.h>
#import <AWSSNS/AWSSNS.h>

#import "AppDelegate.h"

#define PFCAWSCognitoIdentityPoolId         @"us-east-1:41866684-1e6a-4fa0-bca6-372faa0d552a"
#define PFCAWSSNSPlatformApplicationArn     @"arn:aws:sns:us-east-1:957663188509:app/APNS_SANDBOX/PressForChampagne_APNS_Development"
#define PFCAWSSNSConfigurationKey           @"PressForChampagne"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure AWS
    [AWSLogger defaultLogger].logLevel = AWSLogLevelVerbose;
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                    identityPoolId:PFCAWSCognitoIdentityPoolId];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    NSString *cognitoId = credentialsProvider.identityId;
    NSLog(@"Cognito identityId: %@", cognitoId);
    
    AWSSNSCreatePlatformEndpointInput *platformEndpointRequest = [AWSSNSCreatePlatformEndpointInput new];
    platformEndpointRequest.customUserData = [NSString stringWithFormat:@"%@;%@", [UIDevice currentDevice].name, [UIDevice currentDevice].model];
    platformEndpointRequest.token = [self deviceTokenAsString:deviceToken];
    platformEndpointRequest.platformApplicationArn = PFCAWSSNSPlatformApplicationArn;
    
    [AWSSNS registerSNSWithConfiguration:configuration forKey:PFCAWSSNSConfigurationKey];
    AWSSNS *snsManager = [AWSSNS SNSForKey:PFCAWSSNSConfigurationKey];
    [snsManager createPlatformEndpoint:platformEndpointRequest completionHandler:^(AWSSNSCreateEndpointResponse *response, NSError *error) {
        NSLog(@"Create platform endpoint response: %@ error: %@", response, error);
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // JGS - TODO
}

#pragma mark - Private

- (NSString *)deviceTokenAsString:(NSData *)deviceToken
{
    return [[[[NSString stringWithFormat:@"%@", deviceToken]
              stringByReplacingOccurrencesOfString:@" " withString:@""]
             stringByReplacingOccurrencesOfString:@"<" withString:@""]
            stringByReplacingOccurrencesOfString:@">" withString:@""];
}

@end
