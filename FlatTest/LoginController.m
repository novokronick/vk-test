//
//  LoginController.m
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

static NSArray *SCOPE = nil;

@implementation LoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SCOPE = @[VK_PER_WALL, VK_PER_OFFLINE, VK_PER_FRIENDS];
    
    [VKSdk initializeWithDelegate:self andAppId:@"4514654"];
    
    if ([VKSdk wakeUpSession]) {
        [self startWorking];
    }
    
    [self updateLoginButton];
}

- (void)updateLoginButton
{
    if (SharedDataManager.vkToken) {
        [self.loginButton setTitle:@"Logout from VK" forState:UIControlStateNormal];
    } else {
        [self.loginButton setTitle:@"Login with VK" forState:UIControlStateNormal];
    }
}

- (void)startWorking
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginTap:(id)sender
{
    if (SharedDataManager.vkToken) { // logout
        [SharedDataManager setVkToken:nil];
        [SharedDataManager removeStoredData];
    
        [self updateLoginButton];
        [self startWorking];
    } else { // login
        [VKSdk authorize:SCOPE revokeAccess:YES];
    }
}

- (IBAction)cancelTap:(id)sender
{
    [self startWorking];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
	VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
	[vc presentIn:self];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
	//[self authorize:nil];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    [SharedDataManager setVkToken:newToken.accessToken];
    
    [self updateLoginButton];
    [self startWorking];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
	[self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token {
    [self startWorking];
}
- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
	[[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
