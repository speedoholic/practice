//
//  AVCycle.h
//  EySight
//
//  Created by Kushal Ashok on 11/13/17.
//  Copyright © 2017 Essex Lake Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVCycle : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *colorHex;
@property(nonatomic,strong) NSMutableArray *pies;

/**
 Initializes an instance of AVCycle

 @param pieDictionary dictionary containing required properties of AVCycle
 @return AVCycle object
 */
-(id)initWithDictionary:(NSDictionary*)pieDictionary;

@end
