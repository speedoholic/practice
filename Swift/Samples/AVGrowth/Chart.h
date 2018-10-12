//
//  Chart.h
//  Example
//
//  Created by Smith_Yang on 01/11/2017.
//  Copyright © 2017 Smith_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Chart : NSObject

@property (nonatomic, copy)NSMutableArray * circles;

- (instancetype)initWithData:(NSArray *)data;

@end
