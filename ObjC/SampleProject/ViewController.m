//
//  ViewController.m
//  SampleProject
//
//  Created by Kushal Ashok on 7/18/18.
//  Copyright © 2018 speed. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

@synthesize firstName, middleName, lastName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)execute:(id)sender {
    
    [self foo];

    
//    NSArray *lines = [[NSArray alloc] initWithObjects:@"36 30 36 30",
//                      @"15 15 15 15",
//                      @"46 96 90 100",
//                      @"86 86 86 86",
//                      @"100 200 100 200",
//                      @"-100 200 -100 200", nil];
//    NSLog(@"%@",[self polygonCountsFromLines:lines]);
    
//    self.firstName = @"Homer";
//    self.middleName = @"";
//    self.lastName = @"";
//    NSLog(@"fullName = %@", self.fullName);
    
//    [self executeFunction];
//    [self mainfunction];
}

//ByteDance: What will be printed in following Obj-c Code?
- (void)foo {

    __weak NSArray *array;

    for (int i = 0; i < 1; i++) {
        array = [NSArray arrayWithObjects:@YES, nil];
    }
    NSLog(@"%@", array); //Prints 1 = @YES
}

- (NSString *)polygonCountsFromLines:(NSArray *)lines {
    NSMutableString *solution = [[NSMutableString alloc]init];
    NSInteger numberOfSquares = 0;
    NSInteger numberOfRectangles = 0;
    NSInteger numberOfPolygons = 0;
    
    for (NSString *line in lines) {
        NSArray *array = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        //Check if there are only 4 sides
        if ([array count] != 4) {
            NSLog(@"Number of sides are not 4");
            numberOfPolygons += 1;
            break;
        }
        //Sort the array
        array = [array sortedArrayUsingSelector:@selector(compare:)];
        
//        int maxOccurence = 0;
        BOOL didFindDoubleOccurence = false;
        //Only need to check 2 of the elements
        for (int i = 0; i < 2; i++) {
            NSString *numberString = array[i];
            
            //Check if any of the sides are negative
            NSInteger integerValue = numberString.integerValue;
            if (integerValue < 0) {
                numberOfPolygons += 1;
                break;
            }
            
            int occurrences = 0;
            for(NSString *string in array){
                occurrences += ([string isEqualToString:numberString]?1:0);
            }
            
            if (occurrences == 4) {
                numberOfSquares += 1;
                break;
            } else if (occurrences == 2) {
                if (didFindDoubleOccurence) {
                    numberOfRectangles += 1;
                    break;
                } else {
                    didFindDoubleOccurence = TRUE;
                }
            } else {
                numberOfPolygons += 1;
                break;
            }
//            if (occurrences > maxOccurence) {
//                maxOccurence = occurrences;
//            }
        }
        
//        switch (maxOccurence) {
//            case 4:
//                numberOfSquares += 1;
//                break;
//            case 2:
//                numberOfRectangles += 1;
//                break;
//            default:
//                numberOfPolygons += 1;
//                break;
//        }
        
    }
    
    [solution appendString:[[NSString alloc] initWithFormat:@"%li ", (long)numberOfSquares]];
    [solution appendString:[[NSString alloc] initWithFormat:@"%li ", (long)numberOfRectangles]];
    [solution appendString:[[NSString alloc] initWithFormat:@"%li ", (long)numberOfPolygons]];
    
    return [[NSString alloc]initWithString:solution];
}

- (NSArray *)executeFunction {
    NSLog(@"Executing");
    
    NSArray *numbers = [[NSArray alloc]initWithObjects:
                        [NSNumber numberWithLongLong:25626],
                        [NSNumber numberWithLongLong:25757],
                        [NSNumber numberWithLongLong:24367],
                        [NSNumber numberWithLongLong:24267],
                        [NSNumber numberWithLongLong:16],
                        [NSNumber numberWithLongLong:100],
                        [NSNumber numberWithLongLong:2],
                        [NSNumber numberWithLongLong:7277], nil];
    
    NSNumber *escapeToken = [NSNumber numberWithInteger:-128];
    
    NSMutableArray *arrayWithEscapes = [[NSMutableArray alloc]init];
    [arrayWithEscapes addObject: numbers[0]];
    NSInteger referenceNumberA = [numbers[0] integerValue];
    for (int i = 1; i < numbers.count; i++) {
        NSInteger referenceNumberB = [numbers[i] integerValue];
        NSInteger difference = referenceNumberB - referenceNumberA;
        //Single Byte Check
        if (difference <= -127 || difference >= 127) {
            //Insert escapeToken
            [arrayWithEscapes addObject: escapeToken];
        }
        [arrayWithEscapes addObject: [NSNumber numberWithInteger:difference]];
        referenceNumberA = referenceNumberB;
    }
    NSArray *results = [[NSArray alloc]initWithArray:arrayWithEscapes];
    return results;
}

- (NSString *)fullName {
    NSMutableString *fullNameString = [[NSMutableString alloc]init];
    NSMutableArray *arrayOfStrings = [[NSMutableArray alloc]init];
    if ([[self firstName] length] != 0) {
        [arrayOfStrings addObject:firstName];
    }
    if ([[self middleName] length] != 0) {
        [arrayOfStrings addObject:middleName];
    }
    if ([[self lastName] length] != 0) {
        [arrayOfStrings addObject:lastName];
    }
    
    for (NSString *eachString in arrayOfStrings) {
        if ([fullNameString length] != 0) {
            [fullNameString appendString:@" "];
        }
        [fullNameString appendString:eachString];
    }
    
    return fullNameString;
}


- (void)mainfunction {
    @autoreleasepool {
        NSFileHandle *stdIn = [NSFileHandle fileHandleWithStandardInput];
        NSData *inputData = [stdIn readDataToEndOfFile];
        NSString *inputStr = [[NSString alloc] initWithData:inputData
                                                   encoding:NSUTF8StringEncoding];
        NSArray *tokens = [inputStr componentsSeparatedByString:@" "];
        NSMutableArray *numbers = [NSMutableArray array];
        for (NSString *token in tokens) {
            [numbers addObject:@(token.intValue)];
        }
        for (NSNumber *number in [self executeFunction]) {
            printf("%d ", number.intValue);
        }
    }
}

@end
