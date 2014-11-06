//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Dulio Denis on 11/3/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar()

@property(nonatomic) NSArray *currentTitles;
@property(nonatomic) NSArray *colors;
@property(nonatomic) NSArray *labels;
@property(nonatomic, weak) UILabel *currentLabel;
@property(nonatomic) UITapGestureRecognizer *tapGesture;
@property(nonatomic) UIPanGestureRecognizer *panGesture;
@property(nonatomic) UIPinchGestureRecognizer *pinchGesture;

@end


@implementation AwesomeFloatingToolbar

- (instancetype)initWithFourTitles:(NSArray *)titles {
    self = [super init];
    
    if (self) {
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:0.579 green:0.293 blue:0.661 alpha:1.000],
                        [UIColor colorWithRed:1.000 green:0.613 blue:0.587 alpha:1.000],
                        [UIColor colorWithRed:0.871 green:0.794 blue:0.527 alpha:1.000],
                        [UIColor colorWithRed:1.000 green:0.890 blue:0.466 alpha:1.000]];
        
        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
        
        // for loop for the four labels in the labels array
        for (NSString *currentTitle in self.currentTitles) {
            UILabel *label = [[UILabel alloc] init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.5f;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleForThisLabel;
            label.backgroundColor = colorForThisLabel;
            label.textColor = [UIColor colorWithRed:0.642 green:0.770 blue:1.000 alpha:1.000];
            
            [labelsArray addObject:label];
        }
        
        self.labels = labelsArray;
        
        for (UILabel *thisLabel in self.labels) {
            [self addSubview:thisLabel];
        }
        // Gesture Recognizers
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        [self addGestureRecognizer:self.tapGesture];
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
    }
    return self;
}


- (void)layoutSubviews {
    for (UILabel *thisLabel in self.labels) {
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        // Adjust labelX & labelY for each label
        if (currentLabelIndex < 2) {
            // 0 or 1, so on top
            labelY = 0;
        } else {
            // 2 or 3, so on bottom
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentLabelIndex % 2 == 0) {
            // | 0 | 1 |
            // | 2 | 3 |
            // 0 or 2 on the left
            labelX = 0;
        } else {
            // 1 or 3 on the right
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
}


#pragma mark - Gesture Recognizer Methods

- (UILabel *)labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subView = [self hitTest:location withEvent:event];
    
    return (UILabel *)subView;
}


- (void)tapFired:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint location = [recognizer locationInView:self];
        UIView *tappedView = [self hitTest:location withEvent:nil];
    
        if ([self.labels containsObject:tappedView]) {
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
            }
        }
    }
}


- (void)panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
    }
    [recognizer setTranslation:CGPointZero inView:self];
}


- (void)pinchFired:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged){
        CGFloat scale = [recognizer scale];
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToZoomWithScale:)]) {
            [self.delegate floatingToolbar:self didTryToZoomWithScale:scale];
        }
    }
}

    
- (void)resetLabels {
    self.currentLabel.alpha = 1.0f;
    self.currentLabel = nil;
}


#pragma mark - Button Enabling Methods

- (void)setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    if (index != NSNotFound) {
        UILabel *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = YES;
        label.alpha = enabled ? 1.0f : 0.25f;
    }
}

@end
