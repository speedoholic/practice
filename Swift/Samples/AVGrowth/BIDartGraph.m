//
//  BIDartGraph.m
//  Example
//
//  Created by Smith_Yang on 01/11/2017.
//  Copyright © 2017 Smith_Yang. All rights reserved.
//

#import "BIDartGraph.h"
#import "Circle.h"
#import "BIDartCircleGraph.h"
#import "Chart.h"

@interface BIDartGraph ()<BIDartCircleGraphDelegate>

@property (nonatomic, strong)NSMutableArray * viewList;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)CGRect graphRect;
@property (nonatomic, assign)CGFloat labelLineWidth;
@property (nonatomic, strong)UIColor * labelLineColor;

@property (nonatomic, strong)Chart * chart;


@end


@implementation BIDartGraph

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor grayColor];
        self.clipsToBounds = YES;
        self.animationDuration = 0.5;
        _viewList = [NSMutableArray new];

    }
    return self;
}

- (void)redrawGraph{
    
    if (!_dataSource) {
        return;
    }
    
    
    _index = 0;
    
    NSMutableArray *data = [[NSMutableArray alloc]init];
    
    NSInteger num = [_dataSource numberOfCircleInDartChart:self];
    
    if (num == 0) {
        return;
    }
    
    if ([_dataSource respondsToSelector:@selector(widthOfIndicateLineInDartChart:)]) {
        _labelLineWidth = [_dataSource widthOfIndicateLineInDartChart:self];
    }
    
    if ([_dataSource respondsToSelector:@selector(colorOfIndicateLineInDartChart:)]) {
        _labelLineColor = [_dataSource colorOfIndicateLineInDartChart:self];
    }
    
    for (int i=0; i<num; i++) {
        
        NSMutableDictionary * dataDict = [NSMutableDictionary new];
        
        CGFloat radius = [_dataSource dartChart:self maxRadiusForCircleIndex:i];
        [dataDict setObject:[NSNumber numberWithFloat:radius] forKey:@"radius"];
        
        UIColor * fillColor = [_dataSource dartChart:self colorForCircleAtIndex:i];
        [dataDict setObject:fillColor forKey:@"color"];
        
        
        if ([_dataSource respondsToSelector:@selector(centerPointOfDartChart:)]) {
            CGPoint centerPosition = [_dataSource centerPointOfDartChart:self];
            [dataDict setObject:NSStringFromCGPoint(centerPosition) forKey:@"center"];
        }
        
        if ([_dataSource respondsToSelector:@selector(dartChart:isShowLabelForCircleAtIndex:)]) {
            BOOL isShowLabel = [_dataSource dartChart:self isShowLabelForCircleAtIndex:i];
            [dataDict setObject:[NSNumber numberWithBool:isShowLabel] forKey:@"isShowLabel"];
        }
        
        if ([_dataSource respondsToSelector:@selector(dartChart:minRadiusForCircleIndex:)]) {
            CGFloat minRadius = [_dataSource dartChart:self minRadiusForCircleIndex:i];
            [dataDict setObject:[NSNumber numberWithFloat:minRadius] forKey:@"minRadius"];

        }
        
        if ([_dataSource respondsToSelector:@selector(dartChart:textForCircleAtIndex:)]) {
            NSString * text = [_dataSource dartChart:self textForCircleAtIndex:i];
            if (text) {
                [dataDict setObject:text forKey:@"text"];
            }
            
        }

        if ([_dataSource respondsToSelector:@selector(dartChart:fontOfLabelForCircleAtIndex:)]) {
            UIFont * font = [_dataSource dartChart:self fontOfLabelForCircleAtIndex:i];
            if (font) {
                [dataDict setObject:font forKey:@"fontLabel"];
            }
        }
        
        if ([_dataSource respondsToSelector:@selector(dartChart:colorOfLabelForCircleAtIndex:)]) {
            UIColor * textColor = [_dataSource dartChart:self colorOfLabelForCircleAtIndex:i];
            if (textColor) {
                [dataDict setObject:textColor forKey:@"colorLabel"];
            }
        }
        
        if ([_dataSource respondsToSelector:@selector(dartChart:offsetPositionOfLabelForCircleAtIndex:)]) {
            CGPoint offset = [_dataSource dartChart:self offsetPositionOfLabelForCircleAtIndex:i];
            NSString * offsetStr = NSStringFromCGPoint(offset);
            if (offsetStr) {
                [dataDict setObject:offsetStr forKey:@"offsetLabel"];
            }
        }
        
        if ([_dataSource respondsToSelector:@selector(positionForLabelInDartChart:)]) {
            BIDartGraphLabelPosition pos = [_dataSource positionForLabelInDartChart:self];
            [dataDict setObject:[NSNumber numberWithInteger:pos] forKey:@"positionLabel"];
        }
        
        [data addObject:[NSDictionary dictionaryWithDictionary:dataDict]];
    }
    
    self.chart = [[Chart alloc] initWithData:data];
    
    [self drawChart];
}

- (void)drawChart {
    if (!self.chart) {
        return;
    }
    
    if (_viewList) {
        [_viewList removeAllObjects];
    }
    
    for (Circle * circle in self.chart.circles) {
        [self drawCircle:circle];
    }
    
    
}

- (void)drawCircle:(Circle *)circle{
    
    CGFloat x = circle.point.x - circle.radius;
    CGFloat y = circle.point.y - circle.radius;
    CGFloat width = circle.radius * 2;
    CGFloat height = circle.radius * 2;

    BIDartCircleGraph * circleGraph = [[BIDartCircleGraph alloc] initWithFrame:(CGRect){x, y, width, height} circle:circle];
    circleGraph.delegate = self;
    circleGraph.animationDuration = self.animationDuration;
    [circleGraph drawCircle];
    [self addSubview:circleGraph];

    circleGraph.tag = _viewList.count;
    
    [_viewList addObject:circleGraph];
    
    if (self.graphRect.size.width < width) {
        self.graphRect = (CGRect){x, y, width, height};
    }
    
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    int count = (int)_viewList.count - 1;
    for (int i = count; i >= 0; i--) {
        BIDartCircleGraph * circleGraph = [_viewList objectAtIndex:i];
        CGPoint viewPoint = [circleGraph convertPoint:point fromView:self];
        if ([circleGraph containsPoint:viewPoint]) {
            return circleGraph;
        }
    }
    return [super hitTest: point withEvent:event];
}

#pragma mark - draw outside label

- (void)drawLine:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:startPoint];
    [linePath addLineToPoint:endPoint];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = _labelLineWidth > 0 ? _labelLineWidth:3;
    lineLayer.strokeColor = _labelLineColor ? _labelLineColor.CGColor: [UIColor whiteColor].CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.masksToBounds = NO;
    lineLayer.shadowRadius = 5;
    lineLayer.shadowColor = [UIColor lightGrayColor].CGColor;
    lineLayer.shadowOpacity = 1.f;
    lineLayer.shadowOffset = CGSizeMake(0.0, 0.0);

    lineLayer.fillColor = nil;
    
    [self.layer addSublayer:lineLayer];
    
}

- (void)drawLabel:(CGRect)frame withCircle:(Circle *)circle{
    
    UILabel * labelTitle = [[UILabel alloc] initWithFrame:frame];
    labelTitle.font = [UIFont systemFontOfSize:18];
    labelTitle.numberOfLines = 0;
    switch (circle.labelPosition) {
        case LabelPosOutsideTopRight:
        case LabelPosOutsideBottomRight:
        {
            labelTitle.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case LabelPosOutsideTopLeft:
        case LabelPosOutsideBottomLeft:
        {
            labelTitle.textAlignment = NSTextAlignmentRight;
        }
            break;
        default:
            break;
    }
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor blackColor];
    labelTitle.numberOfLines = 0;
    [self addSubview:labelTitle];
    labelTitle.font = circle.textFont;
    labelTitle.textColor = circle.textColor;
    labelTitle.text = circle.text;
    
    CGPoint center = labelTitle.center;
    labelTitle.center = CGPointMake(center.x + circle.offsetPosition.x, center.y + circle.offsetPosition.y);

}

- (void)drawTitle{
    for (BIDartCircleGraph * circleGraph in _viewList) {
        
        if (circleGraph.circle.text.length == 0) {
            return;
        }
        
        CGPoint start = [circleGraph convertPoint:circleGraph.labelStartPoint toView:self];
        CGFloat marginX = MIN(self.frame.size.width/2.f, self.frame.size.height/2.f)/15;
        CGFloat spaceX = MIN(self.frame.size.width/2.f, self.frame.size.height/2.f)/20;
        CGFloat x = self.graphRect.origin.x + self.graphRect.size.width + marginX;
        CGPoint end = CGPointMake(x, start.y);
        
        CGRect labelFrame = (CGRect){end.x + spaceX, start.y - 23, self.frame.size.width - end.x - spaceX * 2, 45};
        
        switch (circleGraph.circle.labelPosition) {
            case LabelPosInsideVerticalTop:
            case LabelPosInsideHorizontalLeft:
            case LabelPosInsideVerticalBottom:
            case LabelPosInsideHorizontalRight:
                return;
                break;
            case LabelPosOutsideTopRight:
            case LabelPosOutsideBottomRight:
                break;
            case LabelPosOutsideTopLeft:
            case LabelPosOutsideBottomLeft:
            {
                x = self.graphRect.origin.x - marginX;
                end = CGPointMake(x, start.y);
                labelFrame = (CGRect){spaceX, start.y - 15, end.x - spaceX * 2, 50};
            }
                break;
            default:
                break;
        }
        
        
        [self drawLine:start endPoint:end];
        
        [self drawLabel:labelFrame withCircle:circleGraph.circle];
        
    }
}


#pragma mark - circleGraph Delegate

- (void)animationFinished:(id)received{
    
    NSInteger count = self.chart.circles.count;
    self.index++;
    if (count == self.index) {
        [self drawTitle];
    }
}


- (void)tapDartCircelGraph:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(tapDartCircelGraph:withComponent:index:title:)]) {
        BIDartCircleGraph * circleGraph = sender;
        [_delegate tapDartCircelGraph:self withComponent:circleGraph index:circleGraph.tag title:circleGraph.circle.text];
    }

}
- (void)longpressDartCircelGraph:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(longpressDartCircelGraph:withComponent:index:title:)]) {
        BIDartCircleGraph * circleGraph = sender;
        [_delegate longpressDartCircelGraph:self withComponent:circleGraph index:circleGraph.tag title:circleGraph.circle.text];
    }

}


@end
