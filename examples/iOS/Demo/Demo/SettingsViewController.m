//
//  MyAccountViewController.m
//  Demo
//
//  Created by Javier Navarro on 29/10/14.
//  Copyright (c) 2014 MEGA. All rights reserved.
//

#import "SettingsViewController.h"
#import "MegaSDKManager.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userEmail.text = [[MegaSDKManager sharedMegaSDK] getMyEmail];
    [self setUserAvatar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)setUserAvatar {
    
    MUser *user = [[MegaSDKManager sharedMegaSDK] getContactWithEmail:self.userEmail.text];
    NSString *destinationPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [self.userEmail.text stringByAppendingString:@".jpg"];
    NSString *destinationFilePath = [destinationPath stringByAppendingPathComponent:@"thumbs"];
    destinationFilePath = [destinationFilePath stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:destinationFilePath];
    
    if (!fileExists) {
        [[MegaSDKManager sharedMegaSDK] getAvatarWithUser:user destinationFilePath:destinationFilePath delegate:self];
    } else {
        [self.userAvatar setImage:[UIImage imageNamed:destinationFilePath]];
        
        self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width/2;
        self.userAvatar.layer.masksToBounds = YES;
    }
}

#pragma mark - MRequestDelegate

- (void)onRequestStart:(MegaSDK *)api request:(MRequest *)request {
}

- (void)onRequestFinish:(MegaSDK *)api request:(MRequest *)request error:(MError *)error {
    if ([error getErrorCode]) {
    }
    
    switch ([request getType]) {
        case MRequestTypeAccountDetails: {
            break;
        }
            
        case MRequestTypeGetAttrUser: {
            [self setUserAvatar];
        }
            
        default:
            break;
    }
}

- (void)onRequestUpdate:(MegaSDK *)api request:(MRequest *)request {
}

- (void)onRequestTemporaryError:(MegaSDK *)api request:(MRequest *)request error:(MError *)error {
}

@end
