//
//  WebBrowserViewController.m
//  BlocBrowser
//
//  Created by Dulio Denis on 11/1/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "WebBrowserViewController.h"
@import WebKit;

@interface WebBrowserViewController ()

@property (nonatomic) WKWebView *webview;

@end

@implementation WebBrowserViewController


- (void)loadView {
    UIView *mainView = [UIView new];
    self.webview = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [mainView addSubview:self.webview];
    self.view = mainView;
}

- (void)viewDidLoad {
    NSURL *url = [NSURL URLWithString:@"http://ddApps.co"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webview loadRequest:request];
}

@end
