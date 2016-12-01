//
//  XCTestCase+Swizzle.m
//  PoC
//
//  Created by Ben Fowler on 19/5/15.
//  Copyright (c) 2015 Maaii. All rights reserved.
//

#import "XCTestCase+Swizzle.h"

@implementation XCTestCase (Swizzle)

+ (SwizzleInformation*)swizzleSelector:(SEL)originalSelector with:(SEL)replacementSelector forClass:(__unsafe_unretained Class)class
{    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, replacementSelector);
    
    SwizzleInformation *swizzleInfo =
    [[SwizzleInformation alloc] initWithOriginalSelector:originalSelector
                                     replacementSelector:replacementSelector
                                          originalMethod:originalMethod
                                       replacementMethod:swizzledMethod
                                                   class:class];
    
    return swizzleInfo;
}

+ (void)swizzleImplementation:(SwizzleInformation *)swizzleInformation
{
    BOOL didAddMethod =
    class_addMethod(swizzleInformation.class,
                    swizzleInformation.originalSelector,
                    method_getImplementation(swizzleInformation.replacementMethod),
                    method_getTypeEncoding(swizzleInformation.replacementMethod));
    
    if (didAddMethod)
    {
        class_replaceMethod(swizzleInformation.class,
                            swizzleInformation.replacementSelector,
                            method_getImplementation(swizzleInformation.originalMethod),
                            method_getTypeEncoding(swizzleInformation.originalMethod));
    }
    else
    {
        method_exchangeImplementations(swizzleInformation.originalMethod, swizzleInformation.replacementMethod);
    }
}

@end

@implementation SwizzleInformation

- (instancetype)initWithOriginalSelector:(SEL) originalSelector
                     replacementSelector:(SEL) replacementSelector
                          originalMethod:(Method) originalMethod
                       replacementMethod:(Method) replacementMethod
                                   class:(__unsafe_unretained Class)class
{
    self = [super init];
    if (self)
    {
        [self setOriginalSelector:originalSelector];
        [self setReplacementSelector:replacementSelector];
        [self setOriginalMethod:originalMethod];
        [self setReplacementMethod:replacementMethod];
    }
    return self;
}

@end
