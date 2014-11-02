//
//  WebBrowserViewController.m
//  BlocBrowser
//
//  Created by Dulio Denis on 11/1/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "WebBrowserViewController.h"

@interface WebBrowserViewController () <UIWebViewDelegate, UITextFieldDelegate>
@property (nonatomic) UIWebView *webview;
@property (nonatomic) UITextField *textField;
@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIButton *forwardButton;
@property (nonatomic) UIButton *stopButton;
@property (nonatomic) UIButton *reloadButton;
@end

@implementation WebBrowserViewController


#pragma mark - View Lifecycle Methods

- (void)loadView {
    UIView *mainView = [UIView new];
    
    self.webview = [[UIWebView alloc] init];
    self.webview.delegate = self;
    
    // Create a TextField to enter URL
    self.textField = [[UITextField alloc] init];
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.placeholder = NSLocalizedString(@"Website URL", @"Placeholder text for URL");
    self.textField.backgroundColor = [UIColor colorWithRed:0.746 green:0.863 blue:0.855 alpha:1.000];
    self.textField.delegate = self;
    
    // Navigation Buttons
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setEnabled:NO];
    [self.backButton setTitle:NSLocalizedString(@"Back", @"Back web navigation button") forState:UIControlStateNormal];
    [self.backButton addTarget:self.webview action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.forwardButton setEnabled:NO];
    [self.forwardButton setTitle:NSLocalizedString(@"Forward", @"Forward web navigation button") forState:UIControlStateNormal];
    [self.forwardButton addTarget:self.webview action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton setEnabled:NO];
    [self.stopButton setTitle:NSLocalizedString(@"Stop", @"Stop web navigation button") forState:UIControlStateNormal];
    [self.stopButton addTarget:self.webview action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.reloadButton setEnabled:NO];
    [self.reloadButton setTitle:NSLocalizedString(@"Reload", @"Reload web navigation button") forState:UIControlStateNormal];
    [self.reloadButton addTarget:self.webview action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    // Add Subviews
    NSArray *arrayOfViews = @[self.webview, self.textField,self.backButton,self.forwardButton,self.stopButton,self.reloadButton];
    
    for (UIView *viewToAdd in arrayOfViews) {
        [mainView addSubview:viewToAdd];
    }
    
    self.view = mainView;
    
    // Default URL
    NSURL *url = [NSURL URLWithString:@"https://github.com/duliodenis/BlocBrowser"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // the buttons
    NSArray *arrayOfButtons = @[self.backButton,self.forwardButton,self.stopButton,self.reloadButton];

    static const CGFloat itemHeight = 50;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight - itemHeight;
    CGFloat buttonWidth = CGRectGetWidth(self.view.bounds) / arrayOfButtons.count;
    
    self.textField.frame = CGRectMake(0, 0, width, itemHeight);
    self.webview.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight);
    
    CGFloat currentButtonN = 0;
    
    // Assign the position of the buttons
    for (UIButton *thisButton in arrayOfButtons) {
        thisButton.frame = CGRectMake(currentButtonN, CGRectGetMaxY(self.webview.frame), buttonWidth, itemHeight);
        currentButtonN += buttonWidth;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *urlString = textField.text;
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (!url.scheme) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",urlString]];
    }
    
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webview loadRequest:request];
    }
    
    return NO;
}


#pragma mark - UIWebView Delegate Methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"A communication error")
                                                   message:[error localizedDescription]
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"OK", @"OK button") otherButtonTitles: nil];
    [alert show];
}


@end
