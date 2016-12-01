//
//  UIGestureRecognizer+ActionTarget.h
//  PoC
//
//  Created by Ben Fowler on 27/4/15.
//  Copyright (c) 2015 Maaii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (ActionTarget)

- (NSString*)targetAtIndex:(NSInteger)index;
- (NSString*)actionAtIndex:(NSInteger)index;

@end
