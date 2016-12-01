//
//  XCTestCase+ALAsset.h
//  PoC
//
//  Created by Ben Fowler on 18/3/15.
//  Copyright (c) 2015 Maaii. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class ALAsset;

@interface XCTestCase (ALAsset)

- (void)loadALAssetForPropertyValue:(NSString*)ALAssetPropertyValue willHandleExpectations:(BOOL)willHandle OnComplete:(void (^)(ALAsset *result))onComplete;
- (void)loadALAssetForPropertyValue:(NSString*)ALAssetPropertyValue OnComplete:(void (^)(ALAsset *result))onComplete;
- (void)loadALAssetOnComplete:(void (^)(ALAsset *result))onComplete;
- (void)loadALAssetsMax:(NSInteger)max OnComplete:(void (^)(NSMutableArray *array))onComplete;

@end
