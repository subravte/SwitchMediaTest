//
//  MyDataManager.m
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 21/6/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import "MyDataManager.h"
#import "XMLDictionary.h"
@implementation MyDataManager

+ (instancetype)sharedInstance
{
    static MyDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MyDataManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

+(NSMutableArray *) dataArray {
    return [[MyDataManager sharedInstance].dataArray mutableCopy];
}

+(NSArray *) categoryTitlesArray {
    return [MyDataManager sharedInstance].categoryTitlesArray;
}

-(NSString *)categoryTitleAtIndex:(NSInteger)anIndex {
    return [self.categoryTitlesArray objectAtIndex:anIndex];
}

-(NSInteger) categoryTitlesCount {
    return [self.categoryTitlesArray count];
}

- (void)initialiseDataArrayWithColors{
    [self initialiseCategoryTitlesArrayWithColors];
    self.dataArray = [NSArray generateRandomData];
}

- (void)initialiseCategoryTitlesArrayWithColors{
    self.categoryTitlesArray = [NSArray arrayWithObjects:@"Adventure", @"Children",@"Drama",@"Fantasy",@"Horror", @"Humor", @"Children", @"Drama", @"Mystery", @"Nonfiction", @"Romance", @"Sci-Fi", @"Politics", @"Suspense", @"Cooking", nil];
}

@end
