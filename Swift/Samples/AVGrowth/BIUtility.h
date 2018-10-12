//
//  BIUtility.h
//  BusinessIntelligence
//
//  Created by Kushal Ashok on 11/15/17.
//  Copyright © 2017 ANISH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIUtility : NSObject

/**
 Method get UIColor using hexstring

 @param hexString hexadecimal string representing a color
 @return UIColor instance
 */
+(UIColor *) colorFromHexString:(NSString *)hexString;

/**
 Method to replace a characterset with the provided string

 @param input the string that requires replacement
 @param characterSet characterSet which needs to be found and replaced
 @param replacement replacement string
 @return string after replacement is done
/Users/kushalashok/Documents/Kushal/Personal/Interviews/XcodePractice/Swift/Samples/AVGrowth/BIUtility.h */
+(NSString*)replace:(NSString*)input characterSet:(NSCharacterSet*)characterSet withString:(NSString *)replacement;

/**
 Method to change brightness or saturation level of a UIColor

 @param color UIColor which requires change in brightness / saturation
 @param amount amount of change required as a factor
 @return UIColor instance with the required change
 */
+ (UIColor*)alterColor:(UIColor*)color withAmount:(CGFloat)amount;

@end

CGPathRef CGPathCreateArrow(CGPoint center, CGFloat radius, CGFloat ringWidth,
                            CGFloat startAngle, CGFloat endAngle);

