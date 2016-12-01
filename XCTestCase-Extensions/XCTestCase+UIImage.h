//
//  XCTestCase+UIImage.h
//  MaiiImagePicker
//
//  Created by Ben Fowler on 7/7/15.
//  Copyright (c) 2015 Maaii. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

@interface XCTestCase (UIImage)

- (UIImage*)testImage;
- (UIImage*)testImageForName:(NSString*)name type:(NSString*)type;

@end
