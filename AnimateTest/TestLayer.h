//
//  TestLayer.h
//  AnimateTest
//
//  Created by Andrew Hershberger on 3/8/13.
//  Copyright (c) 2013 Two Toasters, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface TestLayer : CALayer

+ (BOOL)loggingEnabled;
+ (void)setLoggingEnabled:(BOOL)loggingEnabled;

@end
