//
//  BIDartCircleGraph.h
//  Example
//
//  Created by Smith_Yang on 01/11/2017.
//  Copyright © 2017 Smith_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Circle;

@protocol BIDartCircleGraphDelegate <NSObject>

- (void)tapDartCircelGraph:(id)sender;
- (void)longpressDartCircelGraph:(id)sender;
- (void)animationFinished:(id)received;

@end

@interface BIDartCircleGraph : UIView

@property (nonatomic, strong)Circle * circle;
@property (nonatomic, weak)id<BIDartCircleGraphDelegate>delegate;
@property (nonatomic, assign)CGPoint labelStartPoint;
@property (nonatomic, assign)CGFloat animationDuration;

- (instancetype)initWithFrame:(CGRect)frame circle:(Circle *)circle;

- (void)drawCircle;

- (BOOL)containsPoint:(CGPoint)point;

@end
