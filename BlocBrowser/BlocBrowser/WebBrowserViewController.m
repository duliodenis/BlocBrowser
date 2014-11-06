//
//  WebBrowserViewController.m
//  BlocBrowser
//
//  Created by Dulio Denis on 11/1/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "WebBrowserViewController.h"
#import "AwesomeFloatingToolbar.h"

// Browser Button String Define Constants
#define kWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define kWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")

@interface WebBrowserViewController () <UIWebViewDelegate, UITextFieldDelegate, AwesomeFloatingToolbarDelegate>
@property (nonatomic) UIWebView *webview;
@property (nonatomic) UITextField *textField;
@property (nonatomic) AwesomeFloatingToolbar *awesomeToolbar;
@property (nonatomic, assign) NSUInteger frameCount;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
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
    self.textField.placeholder = NSLocalizedString(@"Website URL or Search", @"Placeholder text for URL");
    self.textField.backgroundColor = [UIColor colorWithRed:0.746 green:0.863 blue:0.855 alpha:1.000];
    self.textField.delegate = self;
    
    // Navigation Buttons
    NSArray *fourButtonTitles = @[kWebBrowserBackString, kWebBrowserForwardString, kWebBrowserStopString, kWebBrowserRefreshString];
    self.awesomeToolbar = [[AwesomeFloatingToolbar alloc] initWithFourTitles:fourButtonTitles];
    self.awesomeToolbar.delegate = self;
    
    // Add Subviews
    NSArray *arrayOfViews = @[self.webview, self.textField, self.awesomeToolbar];
    
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

    static const CGFloat itemHeight = 50;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
    
    self.textField.frame = CGRectMake(0, 0, width, itemHeight);
    self.webview.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight);

    self.awesomeToolbar.frame = CGRectMake(20, 200, 280, 60);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
}


#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *urlString = textField.text;
    NSURL *url = [NSURL URLWithString:urlString];
    
    // if there are spaces use a search engine
    NSUInteger spaces = [urlString componentsSeparatedByString:@" "].count;
    if (spaces > 1) {
        NSString *searchQuery = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/search?q=%@",searchQuery]];
    }
    
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
    if (error.code != -999) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"A communication error")
                                                        message:[error localizedDescription]
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK button") otherButtonTitles: nil];
        [alert show];
    }
    [self updateButtonsAndTitles];
    self.frameCount--;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.frameCount++;
    [self updateButtonsAndTitles];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.frameCount--;
    [self updateButtonsAndTitles];
}


#pragma mark - Update UI Methods

- (void)updateButtonsAndTitles {
    NSString *webPageTitle = [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (webPageTitle) {
        self.title = webPageTitle;
    } else {
        self.title = self.webview.request.URL.absoluteString;
    }

    [self.awesomeToolbar setEnabled:[self.webview canGoBack] forButtonWithTitle:kWebBrowserBackString];
    [self.awesomeToolbar setEnabled:[self.webview canGoForward] forButtonWithTitle:kWebBrowserForwardString];
    [self.awesomeToolbar setEnabled:(self.frameCount > 0) forButtonWithTitle:kWebBrowserStopString];
    [self.awesomeToolbar setEnabled:self.webview.request.URL && (self.frameCount == 0) forButtonWithTitle:kWebBrowserRefreshString];
    
    if (self.frameCount > 0) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
}


#pragma mark - Reset Browser View

- (void)resetWebview {
    [self.webview removeFromSuperview];
    
    UIWebView *newWebview = [[UIWebView alloc] init];
    newWebview.delegate = self;
    [self.view addSubview:newWebview];
    
    self.webview = newWebview;
    
    self.textField.text = nil;
    [self updateButtonsAndTitles];
}


#pragma mark - AwesomeFloatingToolbar Delegate Methods

- (void)floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title {
    if ([title isEqualToString:kWebBrowserBackString]) {
        [self.webview goBack];
    } else if ([title isEqualToString:kWebBrowserForwardString]) {
        [self.webview goForward];
    } else if ([title isEqualToString:kWebBrowserStopString]) {
        [self.webview stopLoading];
    } else if ([title isEqualToString:kWebBrowserRefreshString]) {
        [self.webview reload];
    }
}


- (void)floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset {
    CGPoint startingPoint = toolbar.frame.origin;
    CGPoint newPoint = CGPointMake(startingPoint.x +offset.x, startingPoint.y + offset.y);
    
    CGRect potentialNewFrame = CGRectMake(newPoint.x, newPoint.y, CGRectGetWidth(toolbar.frame), CGRectGetHeight(toolbar.frame));
    
    if (CGRectContainsRect(self.view.bounds, potentialNewFrame)) {
        toolbar.frame = potentialNewFrame;
    }
}


- (void)floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToZoomWithScale:(CGFloat)scale {
    NSLog(@"Pinch and Zoom Scale = %f", scale);
    CGRect potentialNewFrame = CGRectMake(toolbar.frame.origin.x, toolbar.frame.origin.y,
                                          toolbar.frame.size.width * scale, toolbar.frame.size.height * scale);
    
    if (CGRectContainsRect(self.view.bounds, potentialNewFrame)) {
        toolbar.frame = potentialNewFrame;
    }
}

@end
