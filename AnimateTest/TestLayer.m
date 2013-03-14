//
//  TestLayer.m
//  AnimateTest
//
//  Created by Andrew Hershberger on 3/8/13.
//  Copyright (c) 2013 Two Toasters, LLC. All rights reserved.
//

#import "TestLayer.h"

static BOOL sLoggingEnabled = NO;

@implementation TestLayer

+ (BOOL)loggingEnabled
{
    return sLoggingEnabled;
}

+ (void)setLoggingEnabled:(BOOL)loggingEnabled
{
    sLoggingEnabled = loggingEnabled;
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        if (sLoggingEnabled) {
            NSLog(@"%s", __PRETTY_FUNCTION__);
            NSLog(@"             layer: %@", layer);
            NSLog(@"              self: %@", self);
            NSLog(@" ");
        }
    }
    return self;
}

@end
