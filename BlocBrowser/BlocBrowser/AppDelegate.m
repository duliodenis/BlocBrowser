//
//  AppDelegate.m
//  BlocBrowser
//
//  Created by Dulio Denis on 11/1/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "AppDelegate.h"
#import "WebBrowserViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[WebBrowserViewController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
    // Very excited welcome message to the user
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Welcome!", @"Welcome title")
                                                    message:NSLocalizedString(@"Get excited to use the best web browser ever!", @"Welcome comment")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK, I'm excited!", @"Welcome button title") otherButtonTitles:nil];
    [alert show];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    WebBrowserViewController *browserVC = [[navigationController viewControllers] firstObject];
    [browserVC resetWebview];
}

@end
