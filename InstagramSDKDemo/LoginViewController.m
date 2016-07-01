//
//  LoginViewController.m
//  InstagramSDKDemo
//
//  Created by Gevorg Ghukasyan on 2016-06-29.
//  Copyright © 2016 Gevorg Ghukasyan. All rights reserved.
//

#import "LoginViewController.h"
#import "IGSDK.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.textFieldUsername.text = @"gev.gh";
    self.textFieldPassword.text = @"Cpp";
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (IBAction)buttonHandlerLogin:(id)sender {
    
    [[IGManager sharedManager] loginUserWithUsername:self.textFieldUsername.text
                                            password:self.textFieldPassword.text
                                          completion:^(NSDictionary *serverResponse, NSError *error) {
                                              
                                          }];
}

@end
