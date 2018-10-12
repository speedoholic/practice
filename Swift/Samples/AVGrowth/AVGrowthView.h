//
//  AVGrowthView.h
//  EySight
//
//  Created by Kushal Ashok on 11/13/17.
//  Copyright © 2017 Essex Lake Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVPieChart.h"
#import "BIDartGraph.h"

@protocol AVGrowthDelegate  <NSObject>

/**
 Called when user taps a pie

 @param dictionary Dictionary contianing properties corresponding to the pie tapped
 */
-(void)pieTapped:(NSDictionary *)dictionary;


/**
 Called when user taps a pie
 
 @param dictionary Dictionary contianing properties corresponding to the pie Center tapped
 */
-(void)pieCenterTapped:(NSDictionary *)dictionary;

/**
 Called when user long presss a pie

 @param dictionary Dictionary contianing properties corresponding to the pie long pressed
 */
-(void)pieLongPressed:(NSDictionary *)dictionary;
@end

@protocol AVGrowthDataSource <NSObject>

-(NSData *)loadGrowthChartWithData;

@optional

-(CGFloat)radiusOfGrowthChart:(id)growthChart;
-(CGFloat)cycleLineWidthOfGrowthChart:(id)growthChart;
-(UIFont*)textFontOfGrowthChart:(id)growthChart;
-(UIFont*)centerTextFontOfGrowthChart:(id)growthChart;
-(UIFont*)outsideTextFontOfGrowthChart:(id)growthChart;
-(UIColor*)centerTextColorOfGrowthChart:(id)growthChart;
-(CGFloat)animationDurationOfGrowthChart:(id)growthChart;
-(CGFloat)outerLabelRadiusOfGrowthChart:(id)growthChart;

@end

@interface AVGrowthView : UIView <AVPieChartDataSource, AVPieChartDelegate, BIDartChartDataSource, BIDartGraphDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, weak)id <AVGrowthDelegate>delegate;
@property(nonatomic, weak)id <AVGrowthDataSource>dataSource;

@property(nonatomic) CGFloat radius;
@property(nonatomic) BOOL multiSelectable;
@property(nonatomic, strong) AVPieChart *pieChart;
@property(nonatomic, strong) BIDartGraph *dartGraph;

/**
 Reloads the growth view as per provided data

 @param growthData data for GrowthView
 */
-(void)reloadGrowthData:(NSData *)growthData;

-(void)reloadData;

@end
