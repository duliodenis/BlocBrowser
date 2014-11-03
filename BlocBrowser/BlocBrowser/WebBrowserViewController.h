//
//  WebBrowserViewController.h
//  BlocBrowser
//
//  Created by Dulio Denis on 11/1/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebBrowserViewController : UIViewController

/**
 Replaces the web view with a fresh one, erasing all history. Also, updates the URL field and toolbar buttons accordingly.
 */
- (void)resetWebview;

@end
