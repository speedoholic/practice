//
//  GrowthDataParser.h
//  EySight
//
//  Created by Kushal Ashok on 11/13/17.
//  Copyright © 2017 Essex Lake Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrowthDataParser : NSObject


/**
 Converts the response data into a safe dictionary with required values

 @param data Service data response
 @return Safe dictionary containing required data
 */
-(id)getDictionaryUsingData:(NSData*)data;

@end
