//
//  Circle.h
//  Example
//
//  Created by Smith_Yang on 01/11/2017.
//  Copyright © 2017 Smith_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BIDartGraph.h"

@interface Circle : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat minRadius;
@property (nonatomic, strong) UIColor * fillColor;
@property (nonatomic, strong) NSString * identifer;

@property (nonatomic, copy) NSString * text;
@property (nonatomic, assign)BOOL isShowLabel;
@property (nonatomic, strong)UIFont * textFont;
@property (nonatomic, strong)UIColor * textColor;
@property (nonatomic, assign)CGPoint offsetPosition;
@property (nonatomic, assign)BIDartGraphLabelPosition labelPosition;


- (instancetype)initWithRadius:(CGFloat)radius
                         point:(CGPoint)point
                         color:(UIColor *)fillColor;

- (void)setLabel:(NSString *)text
       minRadius:(CGFloat)minRadius
        textFont:(UIFont *)font
       textColor:(UIColor *)color
  offsetPosition:(CGPoint)offset
        position:(BIDartGraphLabelPosition)position;

@end
