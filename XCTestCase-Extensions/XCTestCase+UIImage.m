//
//  XCTestCase+UIImage.m
//  MaiiImagePicker
//
//  Created by Ben Fowler on 7/7/15.
//  Copyright (c) 2015 Maaii. All rights reserved.
//

#import "XCTestCase+UIImage.h"


@implementation XCTestCase (UIImage)

- (UIImage*)testImage
{
    return [self testImageForName:@"test" type:@"png"];
}

- (UIImage*)testImageForName:(NSString*)name type:(NSString*)type
{
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:type];
    
    return [[UIImage alloc]initWithContentsOfFile:imagePath];
}

@end
