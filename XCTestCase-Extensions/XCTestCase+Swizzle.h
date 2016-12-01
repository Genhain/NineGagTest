//
//  XCTestCase+Swizzle.h
//  PoC
//
//  Created by Ben Fowler on 19/5/15.
//  Copyright (c) 2015 Maaii. All rights reserved.
//

@import XCTest;
@import ObjectiveC;

@interface SwizzleInformation : NSObject

@property (assign,    nonatomic) SEL originalSelector;
@property (assign,    nonatomic) SEL replacementSelector;
@property (assign,    nonatomic) Method originalMethod;
@property (assign,    nonatomic) Method replacementMethod;
@property (weak,      nonatomic) Class class;

- (instancetype)initWithOriginalSelector:(SEL) originalSelector
                     replacementSelector:(SEL) replacementSelector
                          originalMethod:(Method) originalMethod
                       replacementMethod:(Method) replacementMethod
                                   class:(Class) class;

@end


@interface XCTestCase (Swizzle)

+ (SwizzleInformation*)swizzleSelector:(SEL)originalSelector with:(SEL)replacementSelector forClass:(Class)class;
+ (void)swizzleImplementation:(SwizzleInformation*)swizzleInformation;

@end

