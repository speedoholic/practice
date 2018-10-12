//
//  AVPie.m
//  EySight
//
//  Created by Kushal Ashok on 11/13/17.
//  Copyright © 2017 Essex Lake Group. All rights reserved.
//

#import "AVPie.h"

@implementation AVPie

-(id)initWithDictionary:(NSDictionary*)pieDictionary {
    if (self = [super init]) {
        self.name = [pieDictionary valueForKey:@"name"];
        self.value = [pieDictionary valueForKey:@"value"];
        self.colorHex = [pieDictionary valueForKey:@"colorHex"];
        self.angle = [[pieDictionary valueForKey:@"angle"] floatValue];
    }
    return self;
}

@end
