//
//  BIDartGraph.h
//  Example
//
//  Created by Smith_Yang on 01/11/2017.
//  Copyright © 2017 Smith_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BIController.h"

typedef NS_ENUM(NSInteger, BIDartGraphLabelPosition)
{
    LabelPosInsideVerticalBottom = 0,
    LabelPosInsideVerticalTop,
    LabelPosInsideHorizontalLeft,
    LabelPosInsideHorizontalRight,
    LabelPosOutsideTopLeft,
    LabelPosOutsideTopRight,
    LabelPosOutsideBottomLeft,
    LabelPosOutsideBottomRight
};

@protocol BIDartChartDataSource <NSObject>
@required
- (NSUInteger)numberOfCircleInDartChart:(id)graph;
- (CGFloat)dartChart:(id)graph maxRadiusForCircleIndex:(NSUInteger)index;

@optional
- (CGPoint)centerPointOfDartChart:(id)graph;
- (UIColor *)dartChart:(id)graph colorForCircleAtIndex:(NSUInteger)index;
- (NSUInteger)positionForLabelInDartChart:(id)graph;
- (CGFloat)dartChart:(id)graph minRadiusForCircleIndex:(NSUInteger)index;
- (NSString *)dartChart:(id)graph textForCircleAtIndex:(NSUInteger)index;
- (BOOL)dartChart:(id)graph isShowLabelForCircleAtIndex:(NSUInteger)index;
- (UIFont *)dartChart:(id)graph fontOfLabelForCircleAtIndex:(NSUInteger)index;
- (UIColor *)dartChart:(id)graph colorOfLabelForCircleAtIndex:(NSUInteger)index;
- (CGPoint)dartChart:(id)graph offsetPositionOfLabelForCircleAtIndex:(NSUInteger)index;

- (CGFloat)widthOfIndicateLineInDartChart:(id)graph;
- (UIColor *)colorOfIndicateLineInDartChart:(id)graph;
- (CGFloat)dartChart:(id)graph linecolorOfIndicateLineForCircleIndex:(NSUInteger)index;
@end

@protocol BIDartGraphDelegate <NSObject>

- (void)tapDartCircelGraph:(id)sender withComponent:(UIView*)component index:(NSInteger)index title:(NSString *)title;
- (void)longpressDartCircelGraph:(id)sender withComponent:(UIView*)component index:(NSInteger)index title:(NSString *)title;

@end


@interface BIDartGraph : UIView

@property (nonatomic, weak)id<BIDartGraphDelegate>delegate;
@property (nonatomic, weak)id<BIDartChartDataSource>dataSource;
@property (nonatomic, assign)CGFloat animationDuration;

- (void)redrawGraph;

@end
