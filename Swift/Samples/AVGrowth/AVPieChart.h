//
//  AVPieChart.h
//  EsxEyeSi
//
//  Created by ANISH on 04/06/14.
//  Copyright (c) 2014 ANISH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPieChart;
@protocol AVPieChartDataSource <NSObject>
@required
- (NSUInteger)numberOfSlicesInPieChart:(AVPieChart *)pieChart;
- (CGFloat)pieChart:(AVPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index;
@optional
- (UIColor *)pieChart:(AVPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index;
- (UIColor *)pieChart:(AVPieChart *)pieChart selectedColorForSliceAtIndex:(NSUInteger)index;
- (UIColor *)pieChart:(AVPieChart *)pieChart highlitedColorAtLongPressForSliceAtIndex:(NSUInteger)index;
- (NSInteger)selectedStateInPieChart:(AVPieChart *)pieChart;
- (NSString *)pieChart:(AVPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index;
- (NSDictionary *)pieChart:(AVPieChart *)pieChart valueDictForSliceAtIndex:(NSUInteger)index;
- (void)pieChartReloaded:(AVPieChart *)pieChart;
@end

@protocol AVPieChartDelegate <NSObject>
@optional
- (void)pieChart:(AVPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(AVPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(AVPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(AVPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(AVPieChart *)pieChart didLongPressedSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(AVPieChart *)pieChart focusEyeSelectedInMode:(NSUInteger)mode;
- (void)pieChartWillOpen:(AVPieChart *)pieChart;
- (void)pieChartDidOpen:(AVPieChart *)pieChart;
- (void)pieChartWillClose:(AVPieChart *)pieChart;
- (void)pieChartDidClose:(AVPieChart *)pieChart;

@end

@interface SliceLayer : CAShapeLayer
@property (nonatomic, assign) CGFloat   value;
@property (nonatomic, assign) CGFloat   percentage;
@property (nonatomic, assign) double    startAngle;
@property (nonatomic, assign) double    endAngle;
@property (nonatomic, assign) BOOL      isSelected;
@property (nonatomic, strong) NSString  *text;

@property (nonatomic, assign) NSInteger section; //smith add for pie circl graph.

- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate;
@end

@interface AVPieChart : UIView
{
    NSUInteger sliceCount;
    double     sliceValuesSum;
}

@property(nonatomic, weak) id<AVPieChartDataSource> dataSource;
@property(nonatomic, weak) id<AVPieChartDelegate> delegate;
@property(nonatomic, assign) CGFloat startPieAngle;
@property(nonatomic, assign) CGFloat animationSpeed;
@property(nonatomic, assign) CGPoint pieCenter;
@property(nonatomic, assign) CGFloat pieRadius;
@property(nonatomic, assign) BOOL    showLabel;
@property(nonatomic, strong) UIFont  *labelFont;
@property(nonatomic, strong) UIColor *labelColor;
@property(nonatomic, strong) UIColor *labelShadowColor;
@property(nonatomic, assign) CGFloat labelRadius;
@property(nonatomic, assign) CGFloat sliceStroke;
@property(nonatomic, assign) CGFloat selectedSliceStroke;
@property(nonatomic, assign) CGFloat selectedSliceOffsetRadius;
@property(nonatomic, assign)  BOOL    showPercentage;
@property(nonatomic, strong)  UIView  *pieView;
@property(nonatomic, strong)  UIColor  *strokeColor;

//smith add for circle graph
@property (nonatomic, assign) NSInteger circleIndex;
@property (nonatomic, assign) BOOL isNonSelection;
@property (nonatomic, assign) BOOL isShowLineShadow;

- (id)initWithFrame:(CGRect)frame Center:(CGPoint)center Radius:(CGFloat)radius;
- (void)reloadData;
- (void)setPieBackgroundColor:(UIColor *)color;
- (void)resize:(int)radDiff;
- (SliceLayer*)getSliceLayerAtIndex:(NSInteger)index;
- (void)setSliceSelectedAtIndex:(NSInteger)index withEyeState:(NSInteger)eyeState;
- (void)setSliceDeselectedAtIndex:(NSInteger)index;
- (void)showPieSelectionAnimation;
- (void)addInfolabelForSliceAtIndex:(NSInteger)index;
- (void)removeInfoLabels:(NSInteger)index;
- (void)animateToFrame:(CGRect)frame;

- (BOOL)containsPoint:(CGPoint)point;//smith add for judge point is in the slice.

@end

