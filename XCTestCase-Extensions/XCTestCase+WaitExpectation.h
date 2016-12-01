//
//  XCTestCase+WaitExpectation.h
//  PoC
//
//  Created by Ben Fowler on 18/5/15.
//  Copyright (c) 2015 Maaii. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (WaitExpectation)

- (void)waitForExpectationsWithTimeout:(NSTimeInterval)timeout;

@end
