//
//  BIDartCircleGraph.m
//  Example
//
//  Created by Smith_Yang on 01/11/2017.
//  Copyright © 2017 Smith_Yang. All rights reserved.
//

#import "BIDartCircleGraph.h"
#import "Circle.h"

@interface BIDartCircleGraph ()

@property (nonatomic, assign)CGPoint cgPointCenter;
@property (nonatomic, assign)CGFloat radius;
@property (nonatomic, assign)CGFloat startAngle;
@property (nonatomic, assign)CGFloat endAngle;
@property (nonatomic, assign)BOOL clockWise;
@property (nonatomic, assign)CGFloat lineWith;
@property (nonatomic, assign)CGFloat minRadius;

@property (nonatomic, strong)UIBezierPath * curBezierPath;

@property (nonatomic, strong)UILabel * labelTitle;

@property (nonatomic, assign)BOOL isShowLabel;
@property (nonatomic, strong)UIFont * textFont;
@property (nonatomic, strong)UIColor * textColor;
@property (nonatomic, assign)CGPoint offsetPoint;
@property (nonatomic, assign)BIDartGraphLabelPosition labelPosition;

@property (nonatomic, strong)CALayer  *anmiateLayer;
@property (nonatomic, strong)CALayer  *anmiateLineLayer;
@property (nonatomic, strong)CALayer  *LineLayer;



@end


@implementation BIDartCircleGraph

- (instancetype)initWithFrame:(CGRect)frame circle:(Circle *)circle
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _circle = circle;
        
        self.animationDuration = 0.5;
        self.startAngle = 0;
        self.endAngle = M_PI * 2;
        self.cgPointCenter = (CGPoint){circle.radius, circle.radius};
        self.clockWise = YES;
        self.lineWith = circle.radius;
        self.radius = circle.radius/2.f;
        self.minRadius = circle.minRadius;
        self.isShowLabel = circle.isShowLabel;
        self.textColor = circle.textColor;
        self.textFont = circle.textFont;
        self.offsetPoint = circle.offsetPosition;
        self.labelPosition = circle.labelPosition;
        
        self.backgroundColor = [UIColor clearColor];
        self.accessibilityIdentifier = circle.identifer;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
        
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPressGesture];
        
    }
    return self;
}

- (UILabel *)labelTitle{
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelTitle.font = [UIFont systemFontOfSize:12.f];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textColor = [UIColor whiteColor];
        
    }
    return _labelTitle;
}


- (void)tapAction:(UITapGestureRecognizer *)gesture{
    
    CGPoint tapPoint = [gesture locationInView:self];
    
    if (![_curBezierPath containsPoint:tapPoint]) {
        return;
    }
    
    self.alpha = .5;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
    }];
    
    NSLog(@"Tap:%@", gesture.view.accessibilityIdentifier);
    
    if (_delegate && [_delegate respondsToSelector:@selector(tapDartCircelGraph:)]) {
        [_delegate tapDartCircelGraph:self];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint tapPoint = [gesture locationInView:self];
        
        if (![_curBezierPath containsPoint:tapPoint]) {
            return;
        }
        
        self.alpha = .5;
        
        NSLog(@"LongPress:%@", gesture.view.accessibilityIdentifier);
        
        if (_delegate && [_delegate respondsToSelector:@selector(longpressDartCircelGraph:)]) {
            [_delegate longpressDartCircelGraph:self];
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.alpha = 1.;
    }
    
}

-(void )drawCircle{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.cgPointCenter radius:_radius  startAngle:self.startAngle endAngle:self.endAngle clockwise:self.clockWise];
    
    CAShapeLayer *layer =  [CAShapeLayer layer];
    layer.lineWidth = self.lineWith;
    layer.strokeColor = self.circle.fillColor.CGColor;
    layer.fillColor = nil;
    layer.path = path.CGPath;
    layer.masksToBounds = NO;
    layer.shadowRadius = 10;
    layer.shadowColor = [UIColor lightGrayColor].CGColor;
    layer.shadowOpacity = 1.0;
    layer.shadowOffset = CGSizeMake(0.0, 0.0);
    
    _curBezierPath = [UIBezierPath bezierPathWithArcCenter:self.cgPointCenter radius:_circle.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:self.clockWise];
    
    
    CAShapeLayer *linelayer =  [CAShapeLayer layer];
    linelayer.lineWidth = 1.f;
    linelayer.strokeColor = [UIColor whiteColor].CGColor;;
    linelayer.fillColor = [UIColor clearColor].CGColor;
    linelayer.path = _curBezierPath.CGPath;
    linelayer.masksToBounds = NO;
    
    [self.layer addSublayer:layer];
    [self.layer addSublayer:linelayer];
    
    self.anmiateLayer = layer;
    self.anmiateLineLayer = linelayer;
    
    [self addAnimationOneOnLayer:layer duration:_animationDuration];
    [self addAnimationOneOnLayer:linelayer duration:_animationDuration];
    
}

- (void)drawLabel{
    if (self.isShowLabel) {
        CGFloat heigh = _circle.minRadius > 0 ? _circle.radius - _circle.minRadius : 0;
        
        CGFloat lx = 0;
        CGFloat ly = 0;
        
        switch (self.labelPosition) {
            case LabelPosInsideVerticalTop:
            {
                lx = self.frame.size.width/2.f;
                ly = self.frame.size.height/2.f - _circle.minRadius - heigh/2.f;
            }
                break;
            case LabelPosInsideHorizontalLeft:
            {
                lx = self.frame.size.width/2.f - _circle.minRadius - heigh/2.f;
                ly = self.frame.size.height/2.f;
            }
                break;
            case LabelPosInsideHorizontalRight:
            {
                lx = self.frame.size.width/2.f + _circle.minRadius + heigh/2.f;
                ly = self.frame.size.height/2.f;
            }
                break;
            case LabelPosInsideVerticalBottom:
            {
                lx = self.frame.size.width/2.f;
                ly = self.frame.size.height/2.f + _circle.minRadius + heigh/2.f;
                
            }
                break;
            case LabelPosOutsideTopLeft:
            {
                lx = self.frame.size.width/2.f;
                ly = self.frame.size.height/2.f - _circle.minRadius - heigh/2.f;
                
                _labelStartPoint = [self rotationPoint:CGPointMake(lx, ly) center:(CGPoint){self.frame.size.width/2.f, self.frame.size.height/2.f} radius:_circle.minRadius + heigh/2.f angle:-120];
                
                return;
                
            }
                break;
                
            case LabelPosOutsideTopRight:
            {
                lx = self.frame.size.width/2.f;
                ly = self.frame.size.height/2.f - _circle.minRadius - heigh/2.f;
                
                _labelStartPoint = [self rotationPoint:CGPointMake(lx, ly) center:(CGPoint){self.frame.size.width/2.f, self.frame.size.height/2.f} radius:_circle.minRadius + heigh/2.f angle:-60];
                
                return;
                
            }
                break;
                
            case LabelPosOutsideBottomLeft:
            {
                lx = self.frame.size.width/2.f;
                ly = self.frame.size.height/2.f - _circle.minRadius - heigh/2.f;
                
                _labelStartPoint = [self rotationPoint:CGPointMake(lx, ly) center:(CGPoint){self.frame.size.width/2.f, self.frame.size.height/2.f} radius:_circle.minRadius + heigh/2.f angle:-240];
                
                return;
                
            }
                break;
            
                
            case LabelPosOutsideBottomRight:
            {
                lx = self.frame.size.width/2.f;
                ly = self.frame.size.height/2.f - _circle.minRadius - heigh/2.f;
                
                _labelStartPoint = [self rotationPoint:CGPointMake(lx, ly) center:(CGPoint){self.frame.size.width/2.f, self.frame.size.height/2.f} radius:_circle.minRadius + heigh/2.f angle:60];
                
                return;
                
            }
                break;

            default:
                break;
                
        }
        
        [self addSubview:self.labelTitle];
        self.labelTitle.font = self.textFont;
        self.labelTitle.textColor = self.textColor;
        self.labelTitle.text = self.circle.text;
        [self.labelTitle sizeToFit];
        self.labelTitle.center = (CGPoint){lx + self.offsetPoint.x, ly + self.offsetPoint.y};
        
    }
}


- (void)addAnimationOneOnLayer:(CAShapeLayer *)layer duration:(CFTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = duration;
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^
     {
         
         if (!self.LineLayer) {
             CAShapeLayer *linelayer =  [CAShapeLayer layer];
             linelayer.lineWidth = 1.f;
             linelayer.strokeColor = [UIColor whiteColor].CGColor;;
             linelayer.fillColor = self.circle.fillColor.CGColor;
             linelayer.path = _curBezierPath.CGPath;
             linelayer.masksToBounds = NO;
             linelayer.shadowRadius = 10;
             linelayer.shadowColor = [UIColor lightGrayColor].CGColor;
             linelayer.shadowOpacity = 1.0;
             linelayer.shadowOffset = CGSizeMake(0.0, 0.0);
             self.LineLayer = linelayer;
             [self.layer addSublayer:linelayer];
             
             [self drawLabel];
             
             if (_delegate && [_delegate respondsToSelector:@selector(animationFinished:)]) {
                 [_delegate animationFinished:self];
             }

         }
         
         if (self.anmiateLayer) {
             [self.anmiateLayer removeFromSuperlayer];
             self.anmiateLayer = nil;
         }
         
         if (self.anmiateLineLayer) {
             [self.anmiateLineLayer removeFromSuperlayer];
             self.anmiateLineLayer = nil;
         }
     }];
    
    [layer addAnimation:animation forKey:nil];
    [CATransaction commit];
}

- (BOOL)containsPoint:(CGPoint)point{
    
    if ([_curBezierPath containsPoint:point]) {
        return YES;
    }
    return NO;
}
- (CGPoint)rotationPoint:(CGPoint)point center:(CGPoint)center radius:(CGFloat)radius angle:(NSInteger)angle{
    
    double r = sqrt((center.x - point.x) * (center.x - point.x) + (center.y - point.y) * (center.y - point.y));
    
    CGFloat x = center.x + r * cos(angle * M_PI/180);
    CGFloat y = center.y + r * sin(angle * M_PI/180);

    return CGPointMake(x, y);
}

- (CGPoint)rotationPoint:(CGPoint)point radius:(CGFloat)radius angle:(NSInteger)angle{
    
    CGPoint rotatedPoint = CGPointZero;
    NSInteger degree = -45*M_PI/180;
    rotatedPoint.x = point.x+radius*cos(degree);
    rotatedPoint.y = point.y+radius*sin(degree);

    return rotatedPoint;
}

@end

