//
//  GrowthDataParser.m
//  EySight
//
//  Created by Kushal Ashok on 11/13/17.
//  Copyright © 2017 Essex Lake Group. All rights reserved.
//

#import "GrowthDataParser.h"
#import "BIUtility.h"

@implementation GrowthDataParser

-(id)getDictionaryUsingData:(NSData*)data {
    NSMutableDictionary *responseDictionary = [[NSMutableDictionary alloc] init];

    //Data array
    NSArray *allData =  [(NSDictionary*)data objectForKey:@"Data"];
    NSMutableDictionary *valueDictionary = [[NSMutableDictionary alloc] init];
    for (NSDictionary *item in allData) {
        [valueDictionary setObject:item.allValues[0] forKey:item.allKeys[0]];
    }

    [responseDictionary setObject:valueDictionary forKey:@"Values"];

    //Schema
    NSDictionary *schema = [(NSDictionary*)data objectForKey:@"Schema"];
    NSMutableArray *fieldDataArray = [[NSMutableArray alloc] init];
    NSArray *fieldListArray = [schema valueForKey:@"FieldList"];
    if (fieldListArray != nil && fieldListArray.count > 0) {
        NSArray *fieldArray = fieldListArray[0];
        for (NSDictionary *item in fieldArray) {
            NSDictionary *fieldDictionary = [self createSafeDictionaryFrom:item withValue:valueDictionary];
            if (fieldDictionary && ![fieldDictionary isKindOfClass:[NSNull class]]) {
                [fieldDataArray addObject:fieldDictionary];
            }
        }
    }

    NSMutableSet *groupSet = [[NSMutableSet alloc] init];
    NSMutableArray *arrayOfCycles = [[NSMutableArray alloc] init];
    for (NSDictionary *item in fieldDataArray) {
        NSString *group = [item valueForKey:@"Group"];
        if(![groupSet containsObject:group]) {
            [groupSet addObject:group];
            NSMutableDictionary *cycle = [[NSMutableDictionary alloc] init];
            [cycle setObject:group forKey:@"title"];
            [cycle setObject:[item valueForKey:@"colorHex"] forKey:@"colorHex"];
            [arrayOfCycles addObject:cycle];
        }
    }

    for(NSMutableDictionary *cycle in arrayOfCycles) {
        NSString *groupName = [cycle valueForKey:@"title"];
        NSMutableArray *arrayOfPies = [[NSMutableArray alloc] init];
        for(NSDictionary *item in fieldDataArray) {
            if ([[item valueForKey:@"Group"] isEqualToString:groupName]) {
                [arrayOfPies addObject:item];
            }
        }
        [cycle setObject:arrayOfPies forKey:@"pies"];
    }

    [responseDictionary setObject:arrayOfCycles forKey:@"Data"];

    //Settings
    NSDictionary *settings = [self getSafeSettingsFrom:[schema objectForKey:@"Settings"]];

    [responseDictionary setObject:settings forKey:@"Settings"];

    return responseDictionary;
}

-(id)createSafeDictionaryFrom:(NSDictionary *) dictionary withValue:(NSDictionary*)valueDictionary {
    NSMutableDictionary *safeDictionary = [[NSMutableDictionary alloc] init];

    NSString * group = dictionary[@"Group"];
    if (group && ![group isKindOfClass:[NSNull class]]) {
        [safeDictionary setObject:group forKey:@"Group"];
    } else {
        return nil;
    }
    NSString * title = dictionary[@"name"];
    if (title && ![title isKindOfClass:[NSNull class]]) {
        [safeDictionary setObject:[valueDictionary valueForKey:title] forKey:@"value"];
        NSString *result = [BIUtility replace:title characterSet:[NSCharacterSet whitespaceCharacterSet] withString:@"\n"];
        [safeDictionary setObject:result forKey:@"name"];
    }

    NSString * colorHex = dictionary[@"color"];
    if (colorHex && ![colorHex isKindOfClass:[NSNull class]]) {
        [safeDictionary setObject:colorHex forKey:@"colorHex"];
    }
    NSDictionary * navigation = dictionary[@"Navigation"];
    if (navigation && ![navigation isKindOfClass:[NSNull class]]) {
        [safeDictionary setObject:navigation forKey:@"navigation"];
    }
    if (dictionary[@"selectable"] && ![dictionary[@"selectable"] isKindOfClass:[NSNull class]]) {
        [safeDictionary setObject:dictionary[@"selectable"] forKey:@"selectable"];
    }
    return safeDictionary;
}

-(id)getSafeSettingsFrom:(NSDictionary *) dictionary {
    NSMutableDictionary *safeDictionary = [[NSMutableDictionary alloc] init];
    if (dictionary[@"MultiSelectable"] && ![dictionary[@"MultiSelectable"] isKindOfClass:[NSNull class]]) {
        [safeDictionary setObject:dictionary[@"MultiSelectable"] forKey:@"MultiSelectable"];
    }
    return safeDictionary;
}




@end
