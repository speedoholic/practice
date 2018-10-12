//
//  BIUtility.m
//  BusinessIntelligence
//
//  Created by Kushal Ashok on 11/15/17.
//  Copyright © 2017 ANISH. All rights reserved.
//

#import "BIUtility.h"

@implementation BIUtility

+(UIColor *) colorFromHexString:(NSString *)hexString {
    if ([hexString isKindOfClass:[NSNull class]])
        return [UIColor whiteColor];
    
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3)
    {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6)
    {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+(NSString*)replace:(NSString*)input characterSet:(NSCharacterSet*)characterSet withString:(NSString *)replacement {
    //Replace spaces with newline
    NSArray *split = [input componentsSeparatedByCharactersInSet:characterSet];
    split = [split filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    NSString *output = [split componentsJoinedByString:replacement];
    return output;
}

+ (UIColor*)alterColor:(UIColor*)color withAmount:(CGFloat)amount
{
    CGFloat hue, saturation, brightness, alpha;
    if ([color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        if (saturation > 0.5) {
            brightness -= (amount);
            brightness = MAX(MIN(brightness, 1.0), 0.0);
        } else {
            saturation += (amount);
            saturation = MAX(MIN(saturation, 1.0), 0.0);
        }
        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    }
    
    CGFloat white;
    if ([color getWhite:&white alpha:&alpha]) {
        white -= (amount);
        white = MAX(MIN(white, 1.0), 0.0);
        return [UIColor colorWithWhite:white alpha:alpha];
    }
    return nil;
}

@end

//This is not a class method
CGPathRef CGPathCreateArrow(CGPoint center, CGFloat radius, CGFloat ringWidth,
                            CGFloat startAngle, CGFloat endAngle)
{
    double radiusOffset = (radius - ringWidth) / radius;
    double arrowHeight = ((ringWidth * 0.5) / radius) + 1.0;
    double arrowAngle = endAngle - ((9 * M_PI) / 180);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,
                      center.x + radius * cos(startAngle),
                      center.y + radius * sin(startAngle));
    CGPathAddLineToPoint(path, NULL,
                         center.x + radius * radiusOffset * cos(startAngle),
                         center.y + radius * radiusOffset * sin(startAngle));
    CGPathAddArc(path, NULL,
                 center.x, center.y, radius * radiusOffset,
                 startAngle, endAngle, false);
    
    CGPathAddLineToPoint(path, NULL,
                         center.x + radius * arrowHeight * cos(arrowAngle),
                         center.y + radius * arrowHeight * sin(arrowAngle));
    
    CGPathAddLineToPoint(path, NULL,
                         center.x + radius * cos(arrowAngle),
                         center.y + radius * sin(arrowAngle));
    
    CGPathAddArc(path, NULL,
                 center.x, center.y, radius,
                 arrowAngle, startAngle, true);
    return path;
}
