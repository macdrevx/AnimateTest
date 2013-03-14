//
//  ViewController.m
//  AnimateTest
//
//  Created by Andrew Hershberger on 3/7/13.
//  Copyright (c) 2013 Two Toasters, LLC. All rights reserved.
//

#import "ViewController.h"
#import "TestView.h"
#import <QuartzCore/QuartzCore.h>
#import "TestLayer.h"

static const CGPoint kCenters[] = { {160.0f, 20.0f}, {20.0f, 262.0f}, {300.0f, 262.0f} };
static const CGSize kMarkerSize = { 10.0f, 10.0f };
static const CGSize kAnimatingViewSize = { 20.0f, 20.0f };
static const CGSize kButtonSize = { 100.0f, 100.0f };

@interface ViewController ()
@property (nonatomic, weak) TestView *testView;
@property (nonatomic, weak) UISwitch *animateSwitch;
@property (nonatomic, weak) UISlider *durationSlider;
@property (nonatomic, weak) UILabel *durationSliderLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor grayColor];

    TestView *testView = [[TestView alloc] initWithFrame:(CGRect){CGPointZero, kAnimatingViewSize}];
    testView.center = kCenters[0];
    testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:testView];
    self.testView = testView;
    [self logAnimationForTestViewWithTitle:@"After initialization"];

    UIImage *markerImage = [self blackSquareImage];
    for (NSUInteger i=0; i<3; i++) {
        UIButton *marker = [UIButton buttonWithType:UIButtonTypeCustom];
        [marker setImage:markerImage forState:UIControlStateNormal];
        marker.frame = (CGRect){CGPointZero, kButtonSize};
        marker.center = kCenters[i];
        marker.tag = i;
        [marker addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:marker];

        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"%u", i];
        [label sizeToFit];
        label.frame = CGRectOffset(label.frame, kCenters[i].x + 5.0f, kCenters[i].y + 5.0f);
        [self.view addSubview:label];
    }

    UILabel *animateSwitchLabel = [UILabel new];
    animateSwitchLabel.backgroundColor = self.view.backgroundColor;
    animateSwitchLabel.text = @"Animation:";
    [animateSwitchLabel sizeToFit];
    CGRect frame = animateSwitchLabel.frame;
    frame.origin.x = 20.0f;
    frame.origin.y = roundf(kCenters[1].y + (kMarkerSize.height / 2.0f) + 40.0f);
    animateSwitchLabel.frame = frame;
    [self.view addSubview:animateSwitchLabel];

    UISwitch *animateSwitch = [UISwitch new];
    frame = animateSwitch.frame;
    frame.origin.x = roundf(CGRectGetMaxX(self.view.bounds) - 20.0f - CGRectGetWidth(frame));
    frame.origin.y = roundf(CGRectGetMidY(animateSwitchLabel.frame) - CGRectGetHeight(frame) / 2.0f);
    animateSwitch.frame = frame;
    [self.view addSubview:animateSwitch];
    self.animateSwitch = animateSwitch;

    UILabel *durationSliderLabel = [UILabel new];
    durationSliderLabel.backgroundColor = self.view.backgroundColor;
    frame = durationSliderLabel.frame;
    frame.origin.x = 20.0f;
    frame.origin.y = roundf(CGRectGetMaxY(animateSwitchLabel.frame) + 20.0f);
    durationSliderLabel.frame = frame;
    [self.view addSubview:durationSliderLabel];
    self.durationSliderLabel = durationSliderLabel;

    UISlider *durationSlider = [UISlider new];
    durationSlider.minimumValue = 0.0f;
    durationSlider.maximumValue = 20.0f;
    durationSlider.continuous = YES;
    durationSlider.value = 20.0f;
    [durationSlider addTarget:self action:@selector(durationSliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:durationSlider];
    self.durationSlider = durationSlider;

    [self durationSliderValueChanged];

    frame = durationSlider.frame;
    frame.size.width = roundf(CGRectGetMaxX(self.view.bounds) - 40.0f - CGRectGetMaxX(durationSliderLabel.frame));
    frame.origin.x = roundf(CGRectGetMaxX(self.view.bounds) - 20.0f - CGRectGetWidth(frame));
    frame.origin.y = roundf(CGRectGetMidY(durationSliderLabel.frame) - CGRectGetHeight(frame) / 2.0f);
    durationSlider.frame = frame;

    UILabel *layerDelegateLoggingSwitchLabel = [UILabel new];
    layerDelegateLoggingSwitchLabel.backgroundColor = self.view.backgroundColor;
    layerDelegateLoggingSwitchLabel.text = @"Layer delegate logging:";
    [layerDelegateLoggingSwitchLabel sizeToFit];
    frame = layerDelegateLoggingSwitchLabel.frame;
    frame.origin.x = 20.0f;
    frame.origin.y = roundf(CGRectGetMaxY(durationSliderLabel.frame) + 20.0f);
    layerDelegateLoggingSwitchLabel.frame = frame;
    [self.view addSubview:layerDelegateLoggingSwitchLabel];

    UISwitch *layerDelegateLoggingSwitch = [UISwitch new];
    frame = layerDelegateLoggingSwitch.frame;
    frame.origin.x = roundf(CGRectGetMaxX(self.view.bounds) - 20.0f - CGRectGetWidth(frame));
    frame.origin.y = roundf(CGRectGetMidY(layerDelegateLoggingSwitchLabel.frame) - CGRectGetHeight(frame) / 2.0f);
    layerDelegateLoggingSwitch.frame = frame;
    [layerDelegateLoggingSwitch addTarget:self action:@selector(layerDelegateLoggingSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:layerDelegateLoggingSwitch];
    [self layerDelegateLoggingSwitchValueChanged:layerDelegateLoggingSwitch];

    UILabel *layerInitializationLoggingSwitchLabel = [UILabel new];
    layerInitializationLoggingSwitchLabel.backgroundColor = self.view.backgroundColor;
    layerInitializationLoggingSwitchLabel.text = @"-initWithLayer: logging:";
    [layerInitializationLoggingSwitchLabel sizeToFit];
    frame = layerInitializationLoggingSwitchLabel.frame;
    frame.origin.x = 20.0f;
    frame.origin.y = roundf(CGRectGetMaxY(layerDelegateLoggingSwitchLabel.frame) + 20.0f);
    layerInitializationLoggingSwitchLabel.frame = frame;
    [self.view addSubview:layerInitializationLoggingSwitchLabel];

    UISwitch *layerInitializationLoggingSwitch = [UISwitch new];
    frame = layerInitializationLoggingSwitch.frame;
    frame.origin.x = roundf(CGRectGetMaxX(self.view.bounds) - 20.0f - CGRectGetWidth(frame));
    frame.origin.y = roundf(CGRectGetMidY(layerInitializationLoggingSwitchLabel.frame) - CGRectGetHeight(frame) / 2.0f);
    layerInitializationLoggingSwitch.frame = frame;
    [layerInitializationLoggingSwitch addTarget:self action:@selector(layerInitializationLoggingSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:layerInitializationLoggingSwitch];
    [self layerInitializationLoggingSwitchValueChanged:layerInitializationLoggingSwitch];
}

- (void)buttonTapped:(UIButton *)button
{
    [self logAnimationForTestViewWithTitle:[NSString stringWithFormat:@"Before moving to point %d", button.tag]];

    void(^animationBlock)(void) = ^{
        self.testView.center = button.center;
    };

    if (self.animateSwitch.isOn) {
        [UIView animateWithDuration:self.durationSlider.value
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:animationBlock
                         completion:^(BOOL finished) {
                             NSLog(@"animation to point %d finished: %@", button.tag, finished ? @"YES" : @"NO");
                             NSLog(@" ");
                         }];
    } else {
        animationBlock();
    }

    [self logAnimationForTestViewWithTitle:[NSString stringWithFormat:@"After moving to point %d", button.tag]];
}

- (void)logAnimationForTestViewWithTitle:(NSString *)title
{
    CALayer *presentationLayer = self.testView.layer.presentationLayer;
    CABasicAnimation *positionAnimation = ((CABasicAnimation *)[self.testView.layer animationForKey:@"position"]);

    NSLog(@"%@", title);
    NSLog(@"          testView: %@", self.testView);
    NSLog(@"position animation: %@", positionAnimation);
    NSLog(@"       - fromValue: %@", positionAnimation.fromValue);
    NSLog(@"       -   toValue: %@", positionAnimation.toValue);
    NSLog(@"       -   byValue: %@", positionAnimation.byValue);
    NSLog(@" presentationLayer: %@", presentationLayer);
    NSLog(@" ");
}

- (UIImage *)blackSquareImage
{
    UIGraphicsBeginImageContextWithOptions(kMarkerSize, YES, 0.0f);
    [[UIColor blackColor] setFill];
    UIRectFill((CGRect){CGPointZero, kMarkerSize});
    UIImage *blackSquareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blackSquareImage;
}

- (void)durationSliderValueChanged
{
    self.durationSliderLabel.text = [NSString stringWithFormat:@"Duration: %.1f s", self.durationSlider.value];
    [self.durationSliderLabel sizeToFit];
}

- (void)layerDelegateLoggingSwitchValueChanged:(UISwitch *)layerDelegateLoggingSwitch
{
    self.testView.loggingEnabled = layerDelegateLoggingSwitch.isOn;
}

- (void)layerInitializationLoggingSwitchValueChanged:(UISwitch *)layerInitializationLoggingSwitch
{
    [TestLayer setLoggingEnabled:layerInitializationLoggingSwitch.isOn];
}

@end
