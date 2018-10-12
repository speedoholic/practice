//
//  AVPieChart.m
//  EsxEyeSi
//
//  Created by ANISH on 04/06/14.
//  Copyright (c) 2014 ANISH. All rights reserved.
//

#import "AVPieChart.h"
#import <QuartzCore/QuartzCore.h>

@implementation SliceLayer
@synthesize text = _text;
@synthesize value = _value;
@synthesize percentage = _percentage;
@synthesize startAngle = _startAngle;
@synthesize endAngle = _endAngle;
@synthesize isSelected = _isSelected;
- (NSString*)description
{
    return [NSString stringWithFormat:@"value:%f, percentage:%0.0f, start:%f, end:%f", _value, _percentage, _startAngle/M_PI*180, _endAngle/M_PI*180];
}
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"]) {
        return YES;
    }
    else {
        return [super needsDisplayForKey:key];
    }
}
- (id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer:layer])
    {
        if ([layer isKindOfClass:[SliceLayer class]]) {
            self.startAngle = [(SliceLayer *)layer startAngle];
            self.endAngle = [(SliceLayer *)layer endAngle];
        }
    }
    return self;
}
- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate
{
    CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
    NSNumber *currentAngle = [[self presentationLayer] valueForKey:key];
    if(!currentAngle) currentAngle = from;
    [arcAnimation setFromValue:currentAngle];
    [arcAnimation setToValue:to];
    [arcAnimation setDelegate:delegate];
    [arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self addAnimation:arcAnimation forKey:key];
    [self setValue:to forKey:key];
}
@end

@interface AVPieChart (Private)
- (void)updateTimerFired:(NSTimer *)timer;
- (SliceLayer *)createSliceLayer;
- (CGSize)sizeThatFitsString:(NSString *)string;
- (void)updateLabelForLayer:(SliceLayer *)pieLayer value:(CGFloat)value;
- (void)notifyDelegateOfSelectionChangeFrom:(NSUInteger)previousSelection to:(NSUInteger)newSelection;
@end

@implementation AVPieChart

{
    NSInteger _selectedSliceIndex;
    //pie view, contains all slices
    
    
    //animation control
    NSTimer *_animationTimer;
    NSMutableArray *_animations;
    
    //smith add for remove line when slice only one.
    CAShapeLayer * outsideLineLayer;

}

static NSUInteger kDefaultSliceZOrder = 100;

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize startPieAngle = _startPieAngle;
@synthesize animationSpeed = _animationSpeed;
@synthesize pieCenter = _pieCenter;
@synthesize pieRadius = _pieRadius;
@synthesize showLabel = _showLabel;
@synthesize labelFont = _labelFont;
@synthesize labelColor = _labelColor;
@synthesize labelShadowColor = _labelShadowColor;
@synthesize labelRadius = _labelRadius;
@synthesize selectedSliceStroke = _selectedSliceStroke;
@synthesize selectedSliceOffsetRadius = _selectedSliceOffsetRadius;
@synthesize showPercentage = _showPercentage;
@synthesize pieView = _pieView;
@synthesize strokeColor = _strokeColor;

static CGPathRef CGPathCreateArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y);
    
    CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
    CGPathCloseSubpath(path);
    
    return path;
}

-(CGRect)frameWithScalingFrame:(CGRect)frame
{
    float scale = [UIScreen mainScreen].bounds.size.width / 1024.0f;
    CGRect temp = CGRectMake(floorf(frame.origin.x * scale), floorf(frame.origin.y * scale), ceilf( frame.size.width * scale), ceilf(frame.size.height * scale));
    return temp;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask=(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _pieView = [[UIView alloc] initWithFrame:frame];
        _pieView.autoresizingMask=(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
        [_pieView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_pieView];
        
        _selectedSliceIndex = -1;
        _animations = [[NSMutableArray alloc] init];
        
        _animationSpeed = 0.5;
        _startPieAngle = M_PI_2*3;
        _selectedSliceStroke = 3.0;
        
        // Contstant is changed
        if ([UIScreen mainScreen].bounds.size.width == 1366.0f)
        {
            self.pieRadius = MIN(frame.size.width/2, frame.size.height/2) - 17;
            self.pieRadius = self.pieRadius > 72.0f ? self.pieRadius : 72.0f;
        }
        else
        {
            self.pieRadius = MIN(frame.size.width/2, frame.size.height/2) - 13;
            self.pieRadius = self.pieRadius > 50.0f ? self.pieRadius : 50.0f;
        }
        
        //        if (self.pieRadius < 150)
        //            self.pieCenter = CGPointMake((frame.size.width * 51.0f)/80.0f, frame.size.height/2 + 8);
        //        else
        self.pieCenter = CGPointMake((frame.size.width * 50.9f)/80.0f, frame.size.height/2);// 50.9f from 51.0f
        if (self.pieRadius == 72.0f) {
            self.pieRadius  =   68.0f;
            self.pieCenter = CGPointMake((frame.size.width * 50.0f)/70.0f, frame.size.height * 0.65f);
        }
        self.labelFont = [UIFont systemFontOfSize:MAX((int)self.pieRadius/10-2, 5)];
        _labelColor = [UIColor whiteColor];
        _labelRadius = _pieRadius/1.5;
        _selectedSliceOffsetRadius = MAX(10, _pieRadius/10);
        
        _showLabel = YES;
        _showPercentage = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Center:(CGPoint)center Radius:(CGFloat)radius
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.pieCenter = center;
        self.pieRadius = radius;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.autoresizingMask=(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
        _pieView = [[UIView alloc] initWithFrame:self.bounds];
        _pieView.autoresizingMask=(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
        [_pieView setBackgroundColor:[UIColor clearColor]];
        [self insertSubview:_pieView atIndex:0];
        
        _selectedSliceIndex = -1;
        _animations = [[NSMutableArray alloc] init];
        
        _animationSpeed = 0.5;
        _startPieAngle = M_PI_2*3;
        _selectedSliceStroke = 3.0;
        
        CGRect bounds = [[self layer] bounds];
        self.pieRadius = MIN(bounds.size.width/2, bounds.size.height/2) - 10;
        self.pieCenter = CGPointMake(bounds.size.width/2, bounds.size.height/2);
        self.labelFont = [UIFont systemFontOfSize:MAX((int)self.pieRadius/10-2, 5)];
        _labelColor = [UIColor whiteColor];
        _labelRadius = _pieRadius/1.5;
        _selectedSliceOffsetRadius = MAX(10, _pieRadius/10);
        
        _showLabel = YES;
        _showPercentage = YES;
        _strokeColor = [UIColor lightGrayColor];
        _sliceStroke = 0.6;
    }
    return self;
}

-(void)animateToFrame:(CGRect)frame
{
    self.autoresizingMask=(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    _pieView = [[UIView alloc] initWithFrame:frame];
    _pieView.autoresizingMask=(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
    [_pieView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_pieView];
    
    _selectedSliceIndex = -1;
    _animations = [[NSMutableArray alloc] init];
    
    _animationSpeed = 0.5;
    _startPieAngle = M_PI_2*3;
    _selectedSliceStroke = 3.0;
    
    self.pieRadius = MIN(frame.size.width/2, frame.size.height/2) - 13;
    self.pieRadius = self.pieRadius > 50.0f ? self.pieRadius : 50.0f;
    self.pieCenter = CGPointMake((frame.size.width * 51.0f)/80.0f, frame.size.height/2);
    self.labelFont = [UIFont systemFontOfSize:MAX((int)self.pieRadius/10-2, 5)];
    _labelColor = [UIColor whiteColor];
    _labelRadius = _pieRadius/1.5;
    _selectedSliceOffsetRadius = MAX(10, _pieRadius/10);
    
    [self sendSubviewToBack:_pieView];
}

-(void)resize:(int)radDiff
{
    self.autoresizingMask=(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
    if(_pieView)
        [_pieView removeFromSuperview];
    _pieView = [[UIView alloc] initWithFrame:self.bounds];
    _pieView.autoresizingMask=(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
    [_pieView setBackgroundColor:[UIColor clearColor]];
    [self insertSubview:_pieView atIndex:0];
    
    _selectedSliceIndex = -1;
    _animations = [[NSMutableArray alloc] init];
    
    _animationSpeed = 0.5;
    //    _startPieAngle = M_PI_2*3;
    _selectedSliceStroke = 3.0;
    
    CGRect bounds = [[self layer] bounds];
    self.pieRadius = MIN(bounds.size.width/2, bounds.size.height/2)-radDiff;
    self.pieCenter = CGPointMake(bounds.size.width/2, bounds.size.height/2);
    self.labelFont = [UIFont systemFontOfSize:MAX((int)self.pieRadius/10-2, 5)];
    _labelColor = [UIColor whiteColor];
    _labelRadius = _pieRadius/1.5;
    _selectedSliceOffsetRadius = MAX(10, _pieRadius/10);
    
    //    _showLabel = YES;
    //    _showPercentage = YES;
}

- (void)setPieCenter:(CGPoint)pieCenter
{
    [_pieView setCenter:pieCenter];
    _pieCenter = CGPointMake(_pieView.frame.size.width/2, _pieView.frame.size.height/2);
}

- (void)setPieRadius:(CGFloat)pieRadius
{
    _pieRadius = pieRadius;
    CGPoint origin = _pieView.frame.origin;
    CGRect frame = CGRectMake(origin.x+_pieCenter.x-pieRadius, origin.y+_pieCenter.y-pieRadius, pieRadius*2, pieRadius*2);
    _pieCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
    [_pieView setFrame:frame];
    [_pieView.layer setCornerRadius:_pieRadius];
}

- (void)setPieBackgroundColor:(UIColor *)color
{
    [_pieView setBackgroundColor:color];
}

#pragma mark - manage settings

- (void)setShowPercentage:(BOOL)showPercentage
{
    _showPercentage = showPercentage;
    if (_showPercentage == NO)
        return;
    
    for(SliceLayer *layer in _pieView.layer.sublayers)
    {
        CATextLayer *textLayer = (CATextLayer*)[[layer sublayers] objectAtIndex:0];
        [textLayer setHidden:!_showLabel];
        if(!_showLabel) return;
        NSString *label;
        if(_showPercentage)
            label = [NSString stringWithFormat:@"%0.0f", layer.percentage*100];
        else
            label = (layer.text)?layer.text:[NSString stringWithFormat:@"%0.0f", layer.value];
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:layer.text attributes:@{NSFontAttributeName: self.labelFont}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){125, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size=rect.size;
        
        //        CGSize size = [label sizeWithFont:self.labelFont];
        
        if(M_PI*2*_labelRadius*layer.percentage < MAX(size.width,size.height))
        {
            [textLayer setString:@""];
        }
        else
        {
            [textLayer setString:label];
            [textLayer setBounds:CGRectMake(0, 0, size.width, size.height)];
        }
    }
}

#pragma mark - Pie Reload Data With Animation

- (void)reloadData
{
    if (_dataSource)
    {
        for (UIGestureRecognizer *gesture in _pieView.gestureRecognizers)
        {
            [_pieView removeGestureRecognizer:gesture];
        }
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [_pieView addGestureRecognizer:longPressGesture];
        
        CALayer *parentLayer = [_pieView layer];
        NSArray *slicelayers = [parentLayer sublayers];
        
        _selectedSliceIndex = -1;
        [slicelayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SliceLayer *layer = (SliceLayer *)obj;
            if(layer.isSelected)
                [self setSliceDeselectedAtIndex:idx];
        }];
        
        double startToAngle = 0.0;
        double endToAngle = startToAngle;
        
        sliceCount = [_dataSource numberOfSlicesInPieChart:self];
        double sum = 0.0;
        double values[sliceCount];
        for (int index = 0; index < sliceCount; index++)
        {
            values[index] = [_dataSource pieChart:self valueForSliceAtIndex:index];
            sum += values[index];
        }
        double angles[sliceCount];
        for (int index = 0; index < sliceCount; index++) {
            double div;
            if (sum == 0)
                div = 0;
            else
                div = values[index] / sum;
            angles[index] = M_PI * 2 * div;
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:_animationSpeed];
        
        [_pieView setUserInteractionEnabled:NO];
        
        __block NSMutableArray *layersToRemove = nil;
        
        BOOL isOnStart = ([slicelayers count] == 0 && sliceCount);
        NSInteger diff = sliceCount - [slicelayers count];
        layersToRemove = [NSMutableArray arrayWithArray:slicelayers];
        
        BOOL isOnEnd = ([slicelayers count] && (sliceCount == 0 || sum <= 0));
        if(isOnEnd)
        {
            for(SliceLayer *layer in _pieView.layer.sublayers){
                [self updateLabelForLayer:layer value:0];
                [layer createArcAnimationForKey:@"startAngle"
                                      fromValue:[NSNumber numberWithDouble:_startPieAngle]
                                        toValue:[NSNumber numberWithDouble:_startPieAngle]
                                       Delegate:self];
                [layer createArcAnimationForKey:@"endAngle"
                                      fromValue:[NSNumber numberWithDouble:_startPieAngle]
                                        toValue:[NSNumber numberWithDouble:_startPieAngle]
                                       Delegate:self];
            }
            [CATransaction commit];
            return;
        }
        
        for(int index = 0; index < sliceCount; index ++)
        {
            SliceLayer *layer;
            double angle = angles[index];
            endToAngle += angle;
            double startFromAngle = _startPieAngle + startToAngle;
            double endFromAngle = _startPieAngle + endToAngle;
            
            if( index >= [slicelayers count] )
            {
                layer = [self createSliceLayer];
                if (isOnStart)
                    startFromAngle = endFromAngle = _startPieAngle;
                [parentLayer addSublayer:layer];
                diff--;
            }
            else
            {
                SliceLayer *onelayer = [slicelayers objectAtIndex:index];
                if(diff == 0 || onelayer.value == (CGFloat)values[index])
                {
                    layer = onelayer;
                    [layersToRemove removeObject:layer];
                }
                else if(diff > 0)
                {
                    layer = [self createSliceLayer];
                    [parentLayer insertSublayer:layer atIndex:index];
                    diff--;
                }
                else if(diff < 0)
                {
                    while(diff < 0)
                    {
                        [onelayer removeFromSuperlayer];
                        [parentLayer addSublayer:onelayer];
                        diff++;
                        onelayer = [slicelayers objectAtIndex:index];
                        if(onelayer.value == (CGFloat)values[index] || diff == 0)
                        {
                            layer = onelayer;
                            [layersToRemove removeObject:layer];
                            break;
                        }
                    }
                }
            }
            
            layer.value = values[index];
            layer.percentage = (sum)?layer.value/sum:0;
            UIColor *color = nil;
            if([_dataSource respondsToSelector:@selector(pieChart:colorForSliceAtIndex:)])
            {
                color = [_dataSource pieChart:self colorForSliceAtIndex:index];
            }
            
            if(!color)
            {
                color = [UIColor colorWithHue:((index/8)%20)/20.0+0.02 saturation:(index%8+3)/10.0 brightness:91/100.0 alpha:1];
            }
            
            [layer setFillColor:color.CGColor];
            if([_dataSource respondsToSelector:@selector(pieChart:textForSliceAtIndex:)])
            {
                layer.text = [_dataSource pieChart:self textForSliceAtIndex:index];
            }
            
            [self updateLabelForLayer:layer value:values[index]];
            [layer createArcAnimationForKey:@"startAngle"
                                  fromValue:[NSNumber numberWithDouble:startFromAngle]
                                    toValue:[NSNumber numberWithDouble:startToAngle+_startPieAngle]
                                   Delegate:self];
            [layer createArcAnimationForKey:@"endAngle"
                                  fromValue:[NSNumber numberWithDouble:endFromAngle]
                                    toValue:[NSNumber numberWithDouble:endToAngle+_startPieAngle]
                                   Delegate:self];
            startToAngle = endToAngle;
        }
        [CATransaction setDisableActions:YES];
        for(SliceLayer *layer in layersToRemove)
        {
            [layer setFillColor:[self backgroundColor].CGColor];
            [layer setDelegate:nil];
            [layer setZPosition:0];
            CATextLayer *textLayer = (CATextLayer*)[[layer sublayers] objectAtIndex:0];
            [textLayer setHidden:YES];
        }
        
        [layersToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperlayer];
        }];
        
        [layersToRemove removeAllObjects];
        
        for(SliceLayer *layer in _pieView.layer.sublayers)
        {
            [layer setZPosition:kDefaultSliceZOrder];
        }
        
        [_pieView setUserInteractionEnabled:YES];
        
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
        
        [self performSelector:@selector(callReloadingCompleteDelegate) withObject:self afterDelay:1.0];
        //Reload the info Labels
        
        
    }
}

- (void)callReloadingCompleteDelegate
{
    //Smith add for slice only one.
    if (_isNonSelection) {
        if (sliceCount == 1) {
            if (!outsideLineLayer) {
                CAShapeLayer *lineLayer = [CAShapeLayer layer];
                lineLayer.fillColor = [UIColor clearColor].CGColor;
                [lineLayer setZPosition:MAXFLOAT];
                [lineLayer setLineWidth:1.0];
                [lineLayer setStrokeColor:[UIColor whiteColor].CGColor];
                UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:_pieCenter radius:_pieRadius startAngle:0.0 endAngle: 2 * M_PI clockwise:YES];
                lineLayer.path = bezierPath.CGPath;
                
                outsideLineLayer = lineLayer;
                
                [_pieView.layer addSublayer:outsideLineLayer];
            }
        } //end.
    }
    
    if([_dataSource respondsToSelector:@selector(pieChartReloaded:)])
    {
        [_dataSource pieChartReloaded:self];
    }
}


- (void)removeInfoLabels:(NSInteger)index
{
    [[self.superview viewWithTag:(2000 + index)] removeFromSuperview];
    for (int i = 0; i < [_dataSource pieChart:self valueDictForSliceAtIndex:index].allKeys.count; i++)
    {
        [[self.superview viewWithTag:(3000 + i)] removeFromSuperview];
        [[self.superview viewWithTag:(4000 + i)] removeFromSuperview];
        [[self.superview viewWithTag:(5000 + i)] removeFromSuperview];
    }
}

#pragma mark - Animation Delegate + Run Loop Timer

- (void)updateTimerFired:(NSTimer *)timer;
{
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    
    [pieLayers enumerateObjectsUsingBlock:^(CAShapeLayer * obj, NSUInteger idx, BOOL *stop) {
        
        NSNumber *presentationLayerStartAngle = [[obj presentationLayer] valueForKey:@"startAngle"];
        CGFloat interpolatedStartAngle = [presentationLayerStartAngle doubleValue];
        
        NSNumber *presentationLayerEndAngle = [[obj presentationLayer] valueForKey:@"endAngle"];
        CGFloat interpolatedEndAngle = [presentationLayerEndAngle doubleValue];
        
        CGPathRef path = CGPathCreateArc(_pieCenter, _pieRadius, interpolatedStartAngle, interpolatedEndAngle);
        [obj setPath:path];
        CFRelease(path);
        
        {
            CALayer *labelLayer = [[obj sublayers] objectAtIndex:0];
            CGFloat interpolatedMidAngle = (interpolatedEndAngle + interpolatedStartAngle) / 2;
            [CATransaction setDisableActions:YES];
            [labelLayer setPosition:CGPointMake(_pieCenter.x + (_labelRadius * cos(interpolatedMidAngle)), _pieCenter.y + (_labelRadius * sin(interpolatedMidAngle)))];
            [CATransaction setDisableActions:NO];
        }
    }];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if (_animationTimer == nil) {
        static float timeInterval = 1.0/60.0;
        // Run the animation timer on the main thread.
        // We want to allow the user to interact with the UI while this timer is running.
        // If we run it on this thread, the timer will be halted while the user is touching the screen (that's why the chart was disappearing in our collection view).
        _animationTimer= [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
    }
    
    [_animations addObject:anim];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)animationCompleted
{
    [_animations removeObject:anim];
    
    if ([_animations count] == 0) {
        [_animationTimer invalidate];
        _animationTimer = nil;
    }
}

#pragma mark - Touch Handing (Selection Notification)

- (NSInteger)getCurrentSelectedOnTouch:(CGPoint)point
{
    __block NSUInteger selectedIndex = -1;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    
    [pieLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SliceLayer *pieLayer = (SliceLayer *)obj;
        CGPathRef path = [pieLayer path];
        
        if (!_isNonSelection) {//smith add this judge for selection or only tap.
            if (CGPathContainsPoint(path, &transform, point, 0)) {
                [pieLayer setLineWidth:_selectedSliceStroke];
                [pieLayer setStrokeColor:[UIColor whiteColor].CGColor];
                [pieLayer setLineJoin:kCALineJoinBevel];
                [pieLayer setZPosition:MAXFLOAT];
                selectedIndex = idx;
            } else {
                [pieLayer setZPosition:kDefaultSliceZOrder];
                [pieLayer setLineWidth:0.0];
            }
        }else{// smith add tap.
            if (CGPathContainsPoint(path, &transform, point, 0)) {
                [pieLayer setZPosition:MAXFLOAT];
                if (pieLayer != outsideLineLayer) {
                    UIColor * color = [UIColor colorWithCGColor:pieLayer.fillColor];
                    color = [color colorWithAlphaComponent:0.5];
                    [pieLayer setFillColor:color.CGColor];
                    selectedIndex = idx;
                }
            } else {
                [pieLayer setZPosition:kDefaultSliceZOrder];
            }
        }
        
    }];
    return selectedIndex;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_pieView];
    [self getCurrentSelectedOnTouch:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_pieView];
    NSInteger selectedIndex = [self getCurrentSelectedOnTouch:point];
    if(selectedIndex >= 0)
        [self notifyDelegateOfSelectionChangeFrom:_selectedSliceIndex to:selectedIndex];
    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    
    for (SliceLayer *pieLayer in pieLayers) {
        [pieLayer setZPosition:kDefaultSliceZOrder];
        //        [pieLayer setLineWidth:0.0];
        
        if (!_isNonSelection) {//smith add this judge for selection or only tap.
            [pieLayer setLineWidth:_sliceStroke];
            [pieLayer setStrokeColor:_strokeColor.CGColor];
        }else{// smith add tap.
            if (pieLayer != outsideLineLayer) {
                UIColor * color = [UIColor colorWithCGColor:pieLayer.fillColor];
                color = [color colorWithAlphaComponent:1.0];
                [pieLayer setFillColor:color.CGColor];
            }
            _selectedSliceIndex = -1;
        }
    }
}

#pragma mark - Selection Notification

- (void)notifyDelegateOfSelectionChangeFrom:(NSUInteger)previousSelection to:(NSUInteger)newSelection
{
    if (previousSelection != newSelection){
        if(previousSelection != -1){
            NSUInteger tempPre = previousSelection;
            if ([_delegate respondsToSelector:@selector(pieChart:willDeselectSliceAtIndex:)])
                [_delegate pieChart:self willDeselectSliceAtIndex:tempPre];
            
            if (!_isNonSelection) {
                [self setSliceDeselectedAtIndex:tempPre];
                previousSelection = newSelection;
            }
            
            if([_delegate respondsToSelector:@selector(pieChart:didDeselectSliceAtIndex:)])
                [_delegate pieChart:self didDeselectSliceAtIndex:tempPre];
        }
        
        if (newSelection != -1){
            if([_delegate respondsToSelector:@selector(pieChart:willSelectSliceAtIndex:)])
                [_delegate pieChart:self willSelectSliceAtIndex:newSelection];
            
            if (!_isNonSelection) {
                [self setSliceSelectedAtIndex:newSelection withEyeState:0];
                _selectedSliceIndex = newSelection;
            }

            if([_delegate respondsToSelector:@selector(pieChart:didSelectSliceAtIndex:)])
                [_delegate pieChart:self didSelectSliceAtIndex:newSelection];
        }
    }else if (newSelection != -1){
        SliceLayer *layer = (SliceLayer*)[_pieView.layer.sublayers objectAtIndex:newSelection];
        if(_selectedSliceOffsetRadius > 0 && layer){
            if (layer.isSelected) {
                if ([_delegate respondsToSelector:@selector(pieChart:willDeselectSliceAtIndex:)])
                    [_delegate pieChart:self willDeselectSliceAtIndex:newSelection];
                [self setSliceDeselectedAtIndex:newSelection];
                if (newSelection != -1 && [_delegate respondsToSelector:@selector(pieChart:didDeselectSliceAtIndex:)])
                    [_delegate pieChart:self didDeselectSliceAtIndex:newSelection];
                previousSelection = _selectedSliceIndex = -1;
            }else{
                if ([_delegate respondsToSelector:@selector(pieChart:willSelectSliceAtIndex:)])
                    [_delegate pieChart:self willSelectSliceAtIndex:newSelection];
                
                if (!_isNonSelection) {
                    [self setSliceSelectedAtIndex:newSelection withEyeState:0];
                    previousSelection = _selectedSliceIndex = newSelection;
                }

                if (newSelection != -1 && [_delegate respondsToSelector:@selector(pieChart:didSelectSliceAtIndex:)])
                    [_delegate pieChart:self didSelectSliceAtIndex:newSelection];
            }
        }
    }
}


#pragma mark - Selection Programmatically Without Notification
- (void)setSliceSelectedAtIndex:(NSInteger)index withEyeState:(NSInteger)eyeState
{
    if(_selectedSliceOffsetRadius <= 0)
        return;
    SliceLayer *layer = (SliceLayer*)[_pieView.layer.sublayers objectAtIndex:index];
    if (layer && !layer.isSelected)
    {
        CGPoint currPos = layer.position;
        double middleAngle = (layer.startAngle + layer.endAngle)/2.0;
        CGPoint newPos = CGPointZero;
        if (eyeState == 1)
        {
            //            if (self.frame.size.height < 350)
            //                newPos = CGPointMake(currPos.x + 3*cos(middleAngle), currPos.y + 3*sin(middleAngle));
            //            else
            newPos = CGPointMake(currPos.x + sliceCount*cos(middleAngle)*0.5f, currPos.y + sliceCount*sin(middleAngle)*0.5f);// changed from 7.5 and prior to that 7
        }
        else
        {
            //            newPos = CGPointMake(currPos.x + 3*cos(middleAngle), currPos.y + 3*sin(middleAngle));
            newPos = CGPointMake(currPos.x + sliceCount*cos(middleAngle)*0.5f, currPos.y + sliceCount*sin(middleAngle)*0.5f);// changed from .5 to .75 for radius. For default effect uncomment the above code and comment this line
        }
        
        layer.position = newPos;
        layer.isSelected = YES;
    }
}

- (void)addInfolabelForSliceAtIndex:(NSInteger)index
{
    SliceLayer *layer = (SliceLayer*)[_pieView.layer.sublayers objectAtIndex:index];
    CGPoint currPos = [layer convertPoint:layer.position toLayer:self.layer.superlayer];
    
    double middleAngle = (layer.startAngle + layer.endAngle)/2.0;
    
    CGRect labelFrame = CGRectMake(currPos.x + _labelRadius -50 + _labelRadius*cos(middleAngle) * 2.0, currPos.y +15 + _labelRadius*sin(middleAngle) * 1.8, 70, 20);
    if ([self viewWithTag:2000 + index])
        [[self viewWithTag:2000 + index]removeFromSuperview];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:labelFrame];
    infoLabel.font = [UIFont fontWithName:@"MyriadPro-Light" size:20.0];
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.tag = 2000 + index;
    if (_showPercentage)
        infoLabel.text = [[NSString stringWithFormat:@"%0.2f",[self percentageValueOfSliceShare:index]] stringByAppendingString:@" %"];
    else
        infoLabel.text = @"";
    [self addSubview:infoLabel];
    
    NSDictionary *valuesDict = [_dataSource pieChart:self valueDictForSliceAtIndex:index];
    NSUInteger numberOfKeys = valuesDict.allKeys.count;
    if ([valuesDict.allKeys containsObject:@"SlicePercent"])
        numberOfKeys--;
    
    NSMutableDictionary *legendInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    for(NSString *parse in valuesDict.allKeys)
    {
        if ([parse containsString:@"LegendColor"])
        {
            numberOfKeys--;
            [legendInfo setObject:[valuesDict valueForKey:parse] forKey:parse];
        }
        else if ([parse isEqualToString:@"SlicePercent"] == NO)
            [tempDict setObject:[valuesDict objectForKey:parse] forKey:parse];
    }
    valuesDict = [NSDictionary dictionaryWithDictionary:tempDict];
    
    float widthOfLegends = 0.0f;
    for (int i = 0; i < numberOfKeys; i++)
    {
        widthOfLegends += 50;
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16.0];
        label.text = [NSString stringWithFormat:@"%@ ",[valuesDict.allKeys objectAtIndex:i]];
        [label sizeToFit];
        widthOfLegends += label.frame.size.width;
        widthOfLegends += 50;
    }
    widthOfLegends -= 50;
    
    CGPoint startPoint = CGPointMake(([UIScreen mainScreen].bounds.size.width - widthOfLegends) * 0.5f, 550);
    startPoint.x -= 50;
    
    UIColor *infoColor = nil;
    for (int i = 0; i < numberOfKeys; i++)
    {
        if ([self viewWithTag:5000 + i])
            [[self viewWithTag:5000 + i]removeFromSuperview];
        
        UIView *colorLabel = [[UIView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, 30, 16)];
        
        NSString *key = [NSString stringWithFormat:@"LegendColor_%d",i];
        NSString *colorKey = [legendInfo valueForKey:key];
        NSString *field = nil;
        for (NSString *parse in valuesDict.allKeys)
        {
            if ([colorKey containsString:parse])
            {
                field = parse;
                break;
            }
        }
        
        colorLabel.backgroundColor = [self colorFromHexString:[legendInfo valueForKey:colorKey]];
        
        if (i == 0)
            infoColor = [_dataSource pieChart:self colorForSliceAtIndex:index];
        else
            infoColor = colorLabel.backgroundColor;
        
        colorLabel.tag = 5000 + i;
        [self addSubview:colorLabel];
        
        startPoint.x += 50;
        
        if ([self viewWithTag:3000+i])
            [[self viewWithTag:3000+i]removeFromSuperview];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y + 2, 0, 30)];
        titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.tag = 3000 + i;
        titleLabel.text = [NSString stringWithFormat:@"%@ ",field];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        
        startPoint.x += titleLabel.frame.size.width;
        startPoint.x += 50;
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoLabel.frame.origin.x + 20, infoLabel.frame.origin.y + 20*(i + 1) - 50, 200, 20)];
        valueLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15.0];
        valueLabel.textColor = infoColor;
        valueLabel.textAlignment = NSTextAlignmentLeft;
        valueLabel.tag = 4000 + i;
        valueLabel.text = [NSString stringWithFormat:@"%@",[valuesDict objectForKey:field ]];
        [self addSubview:valueLabel];
    }
}

-(UIColor *) colorFromHexString:(NSString *)hexString
{
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
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (double)percentageValueOfSliceShare:(NSUInteger)index
{
    double percentageShare;
    percentageShare = 100 *[_dataSource pieChart:self valueForSliceAtIndex:index]/sliceValuesSum;
    return percentageShare;
}

-(SliceLayer*)getSliceLayerAtIndex:(NSInteger)index
{
    SliceLayer *layer = (SliceLayer*)[_pieView.layer.sublayers objectAtIndex:index];
    return layer;
}

- (void)setSliceDeselectedAtIndex:(NSInteger)index
{
    if(_selectedSliceOffsetRadius <= 0)
        return;
    SliceLayer *layer = (SliceLayer*)[_pieView.layer.sublayers objectAtIndex:index];
    if (layer && layer.isSelected)
    {
        layer.position = CGPointMake(0, 0);
        layer.isSelected = NO;
    }
}

#pragma mark - Pie Layer Creation Method

- (SliceLayer *)createSliceLayer
{
    SliceLayer *pieLayer = [SliceLayer layer];
    [pieLayer setZPosition:0];
    [pieLayer setStrokeColor:NULL];
    [pieLayer setLineWidth:_sliceStroke];
    [pieLayer setStrokeColor:_strokeColor.CGColor];
    
    if (_isNonSelection) {
        if (sliceCount == 1) { //smith add for only one slice remove the line and add shadow.
            [pieLayer setLineWidth:0.0];
        }
    }
    if (_isShowLineShadow) {
        pieLayer.masksToBounds = NO;
        pieLayer.shadowRadius = 10;
        pieLayer.shadowColor = [UIColor lightGrayColor].CGColor;
        pieLayer.shadowOpacity = 1.0;
        pieLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    }
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    CGFontRef font = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        font = CGFontCreateCopyWithVariations((__bridge CGFontRef)(self.labelFont), (__bridge CFDictionaryRef)(@{}));
    } else {
        font = CGFontCreateWithFontName((__bridge CFStringRef)[self.labelFont fontName]);
    }
    if (font) {
        [textLayer setFont:font];
        CFRelease(font);
    }
    [textLayer setFontSize:self.labelFont.pointSize];
    [textLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [textLayer setForegroundColor:self.labelColor.CGColor];
    if (self.labelShadowColor) {
        [textLayer setShadowColor:self.labelShadowColor.CGColor];
        [textLayer setShadowOffset:CGSizeZero];
        [textLayer setShadowOpacity:1.0f];
        [textLayer setShadowRadius:2.0f];
    }
    //    CGSize size = [@"0" sizeWithFont:self.labelFont];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:@"Hello I think it works now perfectly" attributes:@{NSFontAttributeName: self.labelFont}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){125, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size=rect.size;
    [CATransaction setDisableActions:YES];
    [textLayer setFrame:CGRectMake(0, 0, size.width, size.height)];
    [textLayer setPosition:CGPointMake(_pieCenter.x + (_labelRadius * cos(0)), _pieCenter.y + (_labelRadius * sin(0)))];
    [CATransaction setDisableActions:NO];
    
    [pieLayer addSublayer:textLayer];
    return pieLayer;
}

- (void)updateLabelForLayer:(SliceLayer *)pieLayer value:(CGFloat)value
{
    CATextLayer *textLayer = (CATextLayer*)[[pieLayer sublayers] objectAtIndex:0];
    [textLayer setHidden:!_showLabel];
    if(!_showLabel) return;
    NSString *label;
    if(_showPercentage)
        label = [NSString stringWithFormat:@"%0.0f", pieLayer.percentage*100];
    else
        label = (pieLayer.text)?pieLayer.text:[NSString stringWithFormat:@"%0.0f", value];
    
    [textLayer setForegroundColor:self.labelColor.CGColor];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:pieLayer.text attributes:@{NSFontAttributeName: self.labelFont, NSForegroundColorAttributeName: _labelColor}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){125, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size=rect.size;
    
    [CATransaction setDisableActions:YES];
    if(M_PI*2*_labelRadius*pieLayer.percentage < MAX(size.width,size.height) || value <= 0)
    {
        [textLayer setString:@""];
    }
    else
    {
        [textLayer setString:attributedText];
        [textLayer setBounds:CGRectMake(0, 0, size.width, size.height)];
    }
    [CATransaction setDisableActions:NO];
}


-(void)showPieSelectionAnimation{
    
    [self setSliceSelectedAtIndex:0 withEyeState:0];
}


#pragma mark - Long press gesture
-(void)longPress:(UIGestureRecognizer*)sender
{
    if (_isNonSelection) {
        return;
    }

    [_pieView removeGestureRecognizer:sender];
    if (_delegate && [_delegate respondsToSelector:@selector(pieChart:didLongPressedSliceAtIndex:)])
    {
        CGPoint pointOfTouch = [sender locationInView:self.pieView];
        NSInteger index = [self getCurrentSelectedOnTouch:pointOfTouch];
        if (index >= 0)
        {
            for (SliceLayer *layer in self.pieView.layer.sublayers)
            {
                NSInteger currentIndex = [self.pieView.layer.sublayers indexOfObject:layer];
                if(index != currentIndex)
                {
                    if (_dataSource && [_dataSource respondsToSelector:@selector(pieChart:highlitedColorAtLongPressForSliceAtIndex:)])
                    {
                        UIColor *color = [_dataSource pieChart:self highlitedColorAtLongPressForSliceAtIndex:currentIndex];
                        if (color)
                            [layer setFillColor:color.CGColor];
                        else
                            [layer setFillColor:[UIColor grayColor].CGColor];
                    }
                    else
                        [layer setFillColor:[UIColor grayColor].CGColor];
                }
                else
                {
                    if([_dataSource respondsToSelector:@selector(pieChart:selectedColorForSliceAtIndex:)]) {
                        UIColor *color = [_dataSource pieChart:self selectedColorForSliceAtIndex:currentIndex];
                        [layer setFillColor:color.CGColor];
                    }
                }
            }
        }
        [_delegate pieChart:self didLongPressedSliceAtIndex:index];
    }
}

#pragma mark - test point in this view
//smith add this method to judage the touch in this layer.
- (BOOL)containsPoint:(CGPoint)point{
    
    CALayer *parentLayer = [_pieView layer];
    NSArray *slicelayers = [parentLayer sublayers];
    
    for (SliceLayer *layer in slicelayers) {
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithCGPath:layer.path];
        if([bezierPath containsPoint:point])
            return YES;
    }
    return NO;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

