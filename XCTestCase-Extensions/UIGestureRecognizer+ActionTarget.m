//
//  UIGestureRecognizer+ActionTarget.m
//  PoC
//
//  Created by Ben Fowler on 27/4/15.
//  Copyright (c) 2015 Maaii. All rights reserved.
//
@import ObjectiveC;

#import "UIGestureRecognizer+ActionTarget.h"

@implementation UIGestureRecognizer (ActionTarget)

- (NSString*)targetAtIndex:(NSInteger)index
{
    NSDictionary *dict = [self actionTargets][index];
    id target = dict[@"target"];
    return [NSString stringWithFormat:@"%@",target];
}

- (NSString*)actionAtIndex:(NSInteger)index
{
    NSDictionary *dict = [self actionTargets][index];
    NSString *action = dict[@"action"];
    return action;
}

- (NSArray*)actionTargets
{
    Ivar targetsIvar = class_getInstanceVariable([self class], "_targets");
    id targetActionPairs = object_getIvar(self, targetsIvar);
    
    Class targetActionPairClass = NSClassFromString(@"UIGestureRecognizerTarget");
    Ivar targetIvar = class_getInstanceVariable(targetActionPairClass, "_target");
    Ivar actionIvar = class_getInstanceVariable(targetActionPairClass, "_action");
    
    NSMutableDictionary *actionTarget = [NSMutableDictionary dictionary];
    NSMutableArray *retValue = [NSMutableArray array];
    
    for (id targetActionPair in targetActionPairs)
    {
        id target = object_getIvar(targetActionPair, targetIvar);
        SEL action = (__bridge void *)object_getIvar(targetActionPair, actionIvar);
        
        [actionTarget setValue:target forKey:@"target"];
        [actionTarget setValue:NSStringFromSelector(action) forKey:@"action"];
        
        [retValue addObject:actionTarget];
    }
    
    return retValue;
}

@end
