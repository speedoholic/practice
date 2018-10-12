//
//  ViewController.h
//  SampleProject
//
//  Created by Kushal Ashok on 7/18/18.
//  Copyright © 2018 speed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong) NSString *firstName;
@property (strong) NSString *middleName;
@property (strong) NSString *lastName;
@property (readonly) NSString *fullName;

- (NSString *)polygonCountsFromLines:(NSArray *)lines;

@end

