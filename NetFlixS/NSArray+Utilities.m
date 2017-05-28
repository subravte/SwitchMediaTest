//
//  NSArray+Utilities.m
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 27/5/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import "NSArray+Utilities.h"
#import "UIColor+Utilities.h"z
@implementation NSArray (Utilities)

+(NSArray *)generateRandomData{
    int numberOfRows = 15;
    int numberOfItemsPerRow = 20;
    NSMutableArray *categoryArray = [NSMutableArray arrayWithCapacity:numberOfRows];
    for (int rowL = 0; rowL < numberOfRows; rowL++)
    {
        NSMutableArray *categoryItemArray = [NSMutableArray arrayWithCapacity:numberOfItemsPerRow];
        for (int itemL = 0; itemL < numberOfItemsPerRow; itemL++) {
            [categoryItemArray addObject: [UIColor generateRandomColor]];
        }
        [categoryArray addObject:categoryItemArray];
    }
    return categoryArray;
}

-(NSString *)randomObject{
    NSUInteger myCount = [self count];
    if (myCount)
        return [self objectAtIndex:arc4random_uniform(myCount)];
    else
        return nil;
}
@end
