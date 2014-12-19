//
//  UIImage.m
//  ScoreMoniter
//
//  Created by yincheng on 12/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageCrop.h"


@implementation UIImage (Crop)

- (UIImage *) crop:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}
- (UIImage *) getContryImg:(NSInteger)countryId
{
    CGRect rect = CGRectMake(0.0f, 1.0f+countryId, 16.0f, 11.0f);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}
@end

@implementation NSDate (gmt)

+ (NSDate *)gmtNow
{
    NSDate *today = [NSDate date];
    NSTimeZone *currentTimeZone = [NSTimeZone systemTimeZone];
    NSInteger currentGMToffset = [currentTimeZone secondsFromGMTForDate:today];
    NSDate *gmtDate = [today dateByAddingTimeInterval:currentGMToffset];
    return gmtDate;
}

@end


