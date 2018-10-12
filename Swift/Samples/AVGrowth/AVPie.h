//
//  AVPie.h
//  EySight
//
//  Created by Kushal Ashok on 11/13/17.
//  Copyright © 2017 Essex Lake Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVCycle.h"

@interface AVPie : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *value;
@property(nonatomic, strong) NSString *colorHex;
@property(nonatomic, assign) CGFloat angle;

/**
 Initializes an instance of AVPie object

 @param pieDictionary dictionary containing required properties of AVPie
 @return instance of AVPie object
 */
-(id)initWithDictionary:(NSDictionary*)pieDictionary;

@end
