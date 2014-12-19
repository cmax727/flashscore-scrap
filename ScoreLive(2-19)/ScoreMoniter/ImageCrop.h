//
//  UIImage.h
//  ScoreMoniter
//
//  Created by yincheng on 12/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Crop)

- (UIImage *) crop:(CGRect)rect;
- (UIImage *) getContryImg:(NSInteger)countryId;
@end

@interface NSDate (gmt)

+ (NSDate *) gmtNow;
@end