//
//  AVGrowthView.m
//  EySight
//
//  Created by Kushal Ashok on 11/13/17.
//  Copyright © 2017 Essex Lake Group. All rights reserved.
//

#import "AVGrowthView.h"
#import "GrowthDataParser.h"
#import "AVCycle.h"
#import "AVPie.h"
#import "BIUtility.h"

@interface AVGrowthView()

@property(nonatomic) CGPoint centerPoint;
@property(nonatomic) CGFloat lastAngle;
@property(nonatomic) NSMutableArray *arrayOfPies;
@property(nonatomic) NSMutableArray *arrayOfCycles;

@property(nonatomic) CGFloat cycleLineWidth;
@property(nonatomic) CGFloat animationDuration;
@property(nonatomic) CGFloat outerLabelRadius;
@property(nonatomic, strong) UIFont *textFont;
@property(nonatomic, strong) UIFont *centerTextFont;
@property(nonatomic, strong) UIFont *outsideTextFont;
@property(nonatomic, strong) UIColor *centerTextColor;

@property(nonatomic) NSUInteger numberOfCenterCircles;


@end

@implementation AVGrowthView
@synthesize radius;
@synthesize cycleLineWidth;
@synthesize multiSelectable;

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(!self)
        return nil;
    [self setBackgroundColor:[UIColor clearColor]];
    [self initializeAssets];
    return self;
}

- (void) drawRect: (CGRect) rect
{
    [self drawGrowthForRect:self.bounds];
}

-(void)initializeAssets
{
    self.arrayOfPies = [[NSMutableArray alloc] init];
    self.arrayOfCycles = [[NSMutableArray alloc] init];
}

- (void)reloadData{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(loadGrowthChartWithData)]){
        [self reloadGrowthData:[self.dataSource loadGrowthChartWithData]];
    }
}

-(void)reloadGrowthData:(NSData *)growthData {
    GrowthDataParser *parser = [[GrowthDataParser alloc] init];
    NSDictionary *responseDictionary = [parser getDictionaryUsingData:growthData];

    //Data
    self.arrayOfCycles = [responseDictionary valueForKey:@"Data"];
    for (NSDictionary *cycle in self.arrayOfCycles) {
        [self.arrayOfPies addObjectsFromArray: [cycle valueForKey:@"pies"]];
    }
    [self setPieAngles];

    //Settings
    NSDictionary *settings = [responseDictionary valueForKey:@"Settings"];
    self.multiSelectable = [[settings valueForKey:@"MultiSelectable"]boolValue];
}

-(void)setPieAngles {
    CGFloat sum = 0.0;
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int index = 0; index < self.arrayOfPies.count; index++)
    {
        [values addObject:[self.arrayOfPies[index] valueForKey:@"value"]];
        
        sum += [values[index] floatValue];
    }
    
    for (int index = 0; index < self.arrayOfPies.count; index++) {
        double div;
        if (sum == 0)
        div = 0;
        else
        div = [values[index] floatValue] / sum;
        CGFloat angle = M_PI * 2 * div;
        
        NSMutableDictionary * dict = _arrayOfPies[index];
        [dict setObject:[NSNumber numberWithFloat:angle] forKey:@"angle"];
        
        [_arrayOfPies replaceObjectAtIndex:index withObject:dict];
    }
}

-(void)checkDataSource {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(radiusOfGrowthChart:)])
    {
        CGFloat radius = [self.dataSource radiusOfGrowthChart:self];
        if(radius > 0.000001) {
            self.radius = radius;
        }
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cycleLineWidthOfGrowthChart:)])
    {
        CGFloat value = [self.dataSource cycleLineWidthOfGrowthChart:self];
        if(value > 0.000001) {
            self.cycleLineWidth = value;
        }
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(outerLabelRadiusOfGrowthChart:)])
    {
        CGFloat value = [self.dataSource outerLabelRadiusOfGrowthChart:self];
        if(value > 0.000001) {
            self.outerLabelRadius = value;
        }
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(textFontOfGrowthChart:)])
    {
        UIFont *font = [self.dataSource textFontOfGrowthChart:self];
        if(font) {
            self.textFont = font;
        }
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(outsideTextFontOfGrowthChart:)])
    {
        UIFont *font = [self.dataSource outsideTextFontOfGrowthChart:self];
        if(font) {
            self.outsideTextFont = font;
        }
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(centerTextFontOfGrowthChart:)])
    {
        UIFont *font = [self.dataSource centerTextFontOfGrowthChart:self];
        if(font) {
            self.centerTextFont = font;
        }
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(centerTextColorOfGrowthChart:)])
    {
        UIColor *color = [self.dataSource centerTextColorOfGrowthChart:self];
        if(color) {
            self.centerTextColor = color;
        }
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(animationDurationOfGrowthChart:)])
    {
        CGFloat duration = [self.dataSource animationDurationOfGrowthChart:self];
        if(duration > 0.000001) {
            self.animationDuration = duration;
        }
    }
}

-(void)drawGrowthForRect:(CGRect)rect {
    
    self.radius = MIN(rect.size.width,rect.size.height) / 3.0;
    self.cycleLineWidth = self.radius / 10.0;
    self.lastAngle = 0.0;
    self.centerPoint = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    self.numberOfCenterCircles = 2;

    //Defaults
    self.textFont = [UIFont fontWithName:@"MyriadPro-Cond" size:MAX((int)self.radius/8, 5)];
    self.outsideTextFont = [UIFont fontWithName:@"MyriadPro-Cond" size:MAX((int)self.radius/8, 5)];
    self.centerTextFont = [UIFont fontWithName:@"MyriadPro-BoldCond" size:MAX((int)self.radius/6, 5)];
    self.centerTextColor = [BIUtility colorFromHexString:@"1e79ef"];
    self.animationDuration = 0.5;
    
    [self checkDataSource];
    
    [self drawPieChart];
    [self drawDartCircles];
    
    for(NSDictionary *cycleDictionary in self.arrayOfCycles) {
        AVCycle *cycle = [[AVCycle alloc] initWithDictionary:cycleDictionary];
        [self drawArrowForCycle:cycle];
    }
}

-(void)drawPieChart {
    self.pieChart = [[AVPieChart alloc] initWithFrame:self.bounds Center:self.centerPoint Radius:self.radius];
    self.pieChart.animationSpeed = self.animationDuration;
    self.pieChart.dataSource = self;
    self.pieChart.delegate = self;
    self.pieChart.labelColor = [UIColor blackColor];
    self.pieChart.labelRadius = self.radius / 1.4;
    self.pieChart.labelFont = self.textFont;
    self.pieChart.strokeColor = [UIColor whiteColor];
    self.pieChart.sliceStroke = self.radius / 150;
    self.pieChart.selectedSliceStroke = self.radius / 100;
    [self addSubview:self.pieChart];
    [self.pieChart reloadData];
}

-(void)drawDartCircles {
    self.dartGraph = [[BIDartGraph alloc] initWithFrame:self.bounds];
    self.dartGraph.animationDuration = self.animationDuration;
    //Disable user interaction for the darGraph view since it overlaps the underlying pies.
    self.dartGraph.userInteractionEnabled = false;
    self.dartGraph.dataSource = self;
    self.dartGraph.delegate = self;
    
    [self addSubview:self.dartGraph];
    [self.dartGraph redrawGraph];
}

-(void)drawArrowForCycle:(AVCycle*)cycle {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [BIUtility colorFromHexString:cycle.colorHex].CGColor);
    CGFloat startAngle;
    if (self.lastAngle == 0.0) {
        startAngle = -M_PI_2;
    } else {
        startAngle = self.lastAngle;
    }
    CGFloat angle = 0.0;
    for (NSDictionary *pie in cycle.pies) {
        angle += [[pie valueForKey:@"angle"] floatValue];
    }
    
    //Add pieAngle for each of the pies in the current cycle
    CGFloat endAngle = startAngle + angle;
    self.lastAngle = endAngle;
    CGFloat arrowRadius = (self.radius + self.cycleLineWidth) * 1.05;
    CGPathRef cgPath = CGPathCreateArrow(self.center,arrowRadius,self.cycleLineWidth,startAngle,endAngle);
    
    CGContextAddPath(context, cgPath);
    CGContextClosePath(context);

    CGContextDrawPath(context, kCGPathFill);
    
    //Draw label
    UILabel *cycleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    cycleLabel.textAlignment = NSTextAlignmentCenter;
    cycleLabel.font = self.outsideTextFont;
    cycleLabel.text = cycle.title;
    cycleLabel.numberOfLines = 0;
    [cycleLabel sizeToFit];
    
    CGFloat interpolatedMidAngle = (startAngle + endAngle) / 2;
    CGFloat cycleLabelRadius = self.radius * 1.2;
    cycleLabelRadius += cycleLabel.frame.size.width / 2;
    CGPoint labelCenterPoint = CGPointMake(_centerPoint.x + (cycleLabelRadius * cos(interpolatedMidAngle)), _centerPoint.y + (cycleLabelRadius * sin(interpolatedMidAngle)));
    cycleLabel.center = labelCenterPoint;
    [self addSubview:cycleLabel];
    
    
}


#pragma mark - BIDartChart data source

-(NSString*)dartChart:(id)graph textForCircleAtIndex:(NSUInteger)index {
    return @"CVM";
}

- (BOOL)dartChart:(id)graph isShowLabelForCircleAtIndex:(NSUInteger)index{
    return YES;
}

- (UIFont *)dartChart:(id)graph fontOfLabelForCircleAtIndex:(NSUInteger)index{
    return self.centerTextFont;
}

- (UIColor *)dartChart:(id)graph colorOfLabelForCircleAtIndex:(NSUInteger)index{
    return self.centerTextColor;
}

- (NSUInteger)numberOfCircleInDartChart:(id)graph{
    return self.numberOfCenterCircles;
}

- (CGFloat)dartChart:(id)graph maxRadiusForCircleIndex:(NSUInteger)index{
    CGFloat maxRadius = self.radius / 2.3;
    if (index == self.numberOfCenterCircles - 1) {
        return maxRadius - 5.0;
    } else {
        return maxRadius;
    }
}


- (CGPoint)centerPointOfDartChart:(id)graph{
    return self.centerPoint;
}

- (UIColor *)dartChart:(id)graph colorForCircleAtIndex:(NSUInteger)index{
    if (index == self.numberOfCenterCircles - 1) {
        return [UIColor whiteColor];
    } else {
        return [UIColor lightGrayColor];
    }
}

#pragma mark - BIDartGraph Delegate

- (void)tapDartCircelGraph:(id)sender withComponent:(UIView*)component index:(NSInteger)index title:(NSString *)title {
    NSLog(@"user tapped on circle number: %ld", index);
    [self.delegate pieCenterTapped:nil];
}
- (void)longpressDartCircelGraph:(id)sender withComponent:(UIView*)component index:(NSInteger)index title:(NSString *)title {
    NSLog(@"user long pressed on circle number: %ld", index);
}

#pragma mark - AVPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(AVPieChart *)pieChart
{
    return self.arrayOfPies.count;
}

- (CGFloat)pieChart:(AVPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[[self.arrayOfPies objectAtIndex:index] valueForKey:@"value"] floatValue];
}

- (NSString *)pieChart:(AVPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    return [[self.arrayOfPies objectAtIndex:index] valueForKey:@"name"];
}

- (UIColor *)pieChart:(AVPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [BIUtility colorFromHexString:[[self.arrayOfPies objectAtIndex:index] valueForKey:@"colorHex"]];
}

#pragma mark - AVPieChart delegate

- (void)pieChart:(AVPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.arrayOfPies[index]];
    NSNumber *indexNum = [[NSNumber alloc] initWithUnsignedLong:index];
    [dic setObject:indexNum forKey:@"index"];
    [self.delegate pieTapped: dic];
}

//TODO: If long press delegate is to be used, more changes are required in AVPieChart since it is removing the gesture recognizer.
//- (void)pieChart:(AVPieChart *)pieChart didLongPressedSliceAtIndex:(NSUInteger)index {
//    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:self.arrayOfPies[index]];
//    [self.delegate pieLongPressed: dic];
//}

#pragma mark - CSS

-(void)updateCss:(NSDictionary*)cssSettings {
    
}

@end
