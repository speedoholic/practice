//
//  Circle.m
//  Example
//
//  Created by Smith_Yang on 01/11/2017.
//  Copyright © 2017 Smith_Yang. All rights reserved.
//

#import "Circle.h"

@implementation Circle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _radius = 10.0f;
        _fillColor = [UIColor blackColor];
        _identifer = [[NSUUID UUID] UUIDString];
        _minRadius = 0.f;
    }
    return self;
}

- (instancetype)initWithRadius:(CGFloat)radius point:(CGPoint)point color:(UIColor *)fillColor{

    self = [self init];
    
    if (self) {
        _radius = radius;
        _point = point;
        _fillColor = fillColor;
    }
    return self;
}


- (void)setLabel:(NSString *)text
       minRadius:(CGFloat)minRadius
        textFont:(UIFont *)font
       textColor:(UIColor *)color
  offsetPosition:(CGPoint)offset
        position:(BIDartGraphLabelPosition)position{

    _text = text;
    _textColor = color;
    _textFont = font;
    _offsetPosition = offset;
    _labelPosition = position;
    _minRadius = minRadius;


}



@end
