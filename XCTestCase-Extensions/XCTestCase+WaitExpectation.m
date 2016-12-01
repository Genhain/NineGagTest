//
//  XCTestCase+WaitExpectation.m
//  PoC
//
//  Created by Ben Fowler on 18/5/15.
//  Copyright (c) 2015 Maaii. All rights reserved.
//

#import "XCTestCase+WaitExpectation.h"

@implementation XCTestCase (WaitExpectation)

- (void)waitForExpectationsWithTimeout:(NSTimeInterval)timeout
{
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError *error)
    {
       if (error != nil)
           XCTFail(@"%@",error.description);
    }];
}

@end
