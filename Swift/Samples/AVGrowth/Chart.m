//
//  Chart.m
//  Example
//
//  Created by Smith_Yang on 01/11/2017.
//  Copyright © 2017 Smith_Yang. All rights reserved.
//

#import "Chart.h"
#import "Circle.h"
#import "BIDartGraph.h"

@implementation Chart


- (instancetype)initWithData:(NSArray *)data
{
    self = [super init];
    if (self) {
        
        [self initCircleWithData:data];
    }
    return self;
}

- (void)initCircleWithData:(NSArray * )data{
    
    _circles = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dataInfo in data) {
        CGPoint point = CGPointFromString([dataInfo objectForKey:@"center"]);
        CGFloat radius = [[dataInfo objectForKey:@"radius"] floatValue];
        UIColor * fillColor = [dataInfo objectForKey:@"color"];
        
        Circle *circle = [[Circle alloc] initWithRadius:radius point:point color:fillColor];

        BOOL isShow = [[dataInfo objectForKey:@"isShowLabel"] boolValue];
        circle.isShowLabel = isShow;
        if (isShow) {
            NSString * text = [dataInfo objectForKey:@"text"];
            CGFloat minRadius = [[dataInfo objectForKey:@"minRadius"] floatValue];
            UIFont * font = [dataInfo objectForKey:@"fontLabel"];
            UIColor * color = [dataInfo objectForKey:@"colorLabel"];
            CGPoint offset = CGPointFromString([dataInfo objectForKey:@"offsetLabel"]);
            BIDartGraphLabelPosition pos = [[dataInfo objectForKey:@"positionLabel"] integerValue];
            
            [circle setLabel:text minRadius:minRadius textFont:font textColor:color offsetPosition:offset position:pos];
        }
        
        [_circles addObject:circle];
    }
    
    [_circles sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Circle *c1 = (Circle*)obj1;
        Circle *c2 = (Circle*)obj2;
        
        return (c1.radius < c2.radius);
    }];
}



@end
