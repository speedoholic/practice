//
//  AVCycle.m
//  EySight
//
//  Created by Kushal Ashok on 11/13/17.
//  Copyright © 2017 Essex Lake Group. All rights reserved.
//

#import "AVCycle.h"
#import "AVPie.h"

@implementation AVCycle

-(id)initWithDictionary:(NSDictionary*)cycleDictionary {
    if (self = [super init])
    {
        self.pies = [[NSMutableArray alloc] init];
        self.colorHex = [cycleDictionary valueForKey:@"colorHex"];
        self.title = [cycleDictionary valueForKey:@"title"];
        NSArray *pies = [cycleDictionary valueForKey:@"pies"];
        for (NSDictionary *pieDictionary in pies) {
            AVPie *pie = [[AVPie alloc] initWithDictionary:pieDictionary];
            [self.pies addObject:pie];
        }
    }
    return self;
}

@end
