//
//  WebBrowserViewController.m
//  BlocBrowser
//
//  Created by Dulio Denis on 11/1/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "WebBrowserViewController.h"

@interface WebBrowserViewController () <UIWebViewDelegate>

@property (nonatomic) UIWebView *webview;

@end

@implementation WebBrowserViewController


- (void)loadView {
    UIView *mainView = [UIView new];
    self.webview = [[UIWebView alloc] init];
    self.webview.delegate = self;
    [mainView addSubview:self.webview];
    self.view = mainView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.webview.frame = self.view.frame;
    
    NSURL *url = [NSURL URLWithString:@"http://ddApps.co"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webview loadRequest:request];
}

@end
