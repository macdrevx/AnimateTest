//
//  TestView.m
//  AnimateTest
//
//  Created by Andrew Hershberger on 3/7/13.
//  Copyright (c) 2013 Two Toasters, LLC. All rights reserved.
//

#import "TestView.h"
#import "TestLayer.h"
#import <QuartzCore/QuartzCore.h>

@implementation TestView

+ (Class)layerClass
{
    return [TestLayer class];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    id<CAAction> action = [super actionForLayer:layer forKey:event];
    if (self.loggingEnabled) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        NSLog(@"             layer: %@", layer);
        NSLog(@"             event: %@", event);
        NSLog(@"            action: %@", action);
        NSLog(@" ");
    }
    return action;
}

@end
