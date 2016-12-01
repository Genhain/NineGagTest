//
//  XCTestCase+ALAsset.m
//  PoC
//
//  Created by Ben Fowler on 18/3/15.
//  Copyright (c) 2015 Maaii. All rights reserved.
//

#import "XCTestCase+ALAsset.h"



@implementation XCTestCase (ALAsset)

- (void)loadALAssetForPropertyValue:(NSString*)ALAssetPropertyValue willHandleExpectations:(BOOL)willHandle OnComplete:(void (^)(ALAsset *result))onComplete
{
    XCTestExpectation *assetLoadExpectation;
    
    if(willHandle)
        assetLoadExpectation = [self expectationWithDescription:@"Asset Group Loaded"];
    
    ALAssetsLibrary *assets = [[ALAssetsLibrary alloc] init];
    
    [assets enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if(*stop)return;
         
         [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *innerStop)
          {
              if(*innerStop)return;
              
              if (result != nil)
              {
                  NSLog(@"%@",result);
                  BOOL doesAssetContainProperties = YES;
                  
                  id propertyValue = [result valueForProperty:ALAssetPropertyValue];
                  
                  if (propertyValue == nil || [self checkIsErrorString:propertyValue])
                      propertyValue = [result valueForProperty:ALAssetPropertyType];
                  
                  if ([propertyValue respondsToSelector:@selector(isEqualToString:)])
                      if(![propertyValue isEqualToString:ALAssetPropertyValue])
                          doesAssetContainProperties = NO;
                  
                  if(propertyValue == nil)
                      doesAssetContainProperties = NO;
                  
                  //    if the result contains all property keys passed in...complete and fulfill
                  if(doesAssetContainProperties)
                  {
                      *stop = YES;
                      *innerStop = YES;
                      
                      onComplete(result);
                      
                      if (assetLoadExpectation != nil)
                          [assetLoadExpectation fulfill];
                      
                      return;
                  }
              }
          }];
     }
                        failureBlock:^(NSError *error)
     {
         XCTFail(@"asset loading failed");
     }];
    
    if (assetLoadExpectation != nil)
    {
        [self waitForExpectationsWithTimeout:10 handler:^(NSError *error)
         {
             if (error != nil)
                 XCTFail(@"%@",error.description);
         }];
    }
}

- (BOOL)checkIsErrorString:(id)object
{
    BOOL retValue = NO;
    
    if([object respondsToSelector:@selector(isEqualToString:)])
    {
        if ([object isEqualToString:ALErrorInvalidProperty])
        {
            retValue = YES;
        }
    }
    
    return retValue;
}

- (void)loadALAssetForPropertyValue:(NSString*)ALAssetPropertyValue OnComplete:(void (^)(ALAsset *result))onComplete
{
    [self loadALAssetForPropertyValue:ALAssetPropertyValue willHandleExpectations:YES OnComplete:onComplete];
}

- (void)loadALAssetOnComplete:(void (^)(ALAsset *result))onComplete
{
    XCTestExpectation *assetLoadExpectation = [self expectationWithDescription:@"Asset Group Loaded"];
    
    ALAssetsLibrary *assets = [[ALAssetsLibrary alloc] init];
    
    [assets enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if(*stop)return;
         
         [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
          {
              if(*stop)return;
              
              if (result != nil)
              {
                  *stop = YES;
                  
                  onComplete(result);
                  
                  [assetLoadExpectation fulfill];
              }
          }];
         
         *stop = YES;
         
     }
                        failureBlock:^(NSError *error)
     {
         XCTFail(@"asset loading failed");
     }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error)
     {
         if (error != nil)
             XCTFail(@"%@",error.description);
         
     }];
}

- (void)loadALAssetsMax:(NSInteger)max OnComplete:(void (^)(NSMutableArray *array))onComplete
{
    XCTestExpectation *assetLoadExpectation = [self expectationWithDescription:@"Asset Group Loaded"];
    
    ALAssetsLibrary *assets = [[ALAssetsLibrary alloc] init];
    
    NSMutableArray *assetArray = [NSMutableArray array];
    
    [assets enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if(*stop)
         {
             [assetLoadExpectation fulfill];
             return;
         }
         
         [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
          {
              if(*stop)return;
              
              if (result != nil)
              {
                  [assetArray addObject:result];
                  if(assetArray.count >= max)
                  {
                      *stop = YES;
                      
                      onComplete(assetArray);
                  }
              }
          }];
         
         
         *stop = YES;
         
     }
                        failureBlock:^(NSError *error)
     {
         XCTFail(@"asset loading failed");
     }];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error)
     {
         if (error != nil)
             XCTFail(@"%@",error.description);
         
     }];
}

@end
