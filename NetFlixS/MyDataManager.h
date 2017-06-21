//
//  MyDataManager.h
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 21/6/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+Utilities.h"
#import "ImageRecord.h"

@interface MyDataManager : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *imagesArray;

@property (nonatomic, retain) NSArray *categoryTitlesArray;

- (void)initialiseDataArrayWithColors;
- (void)initialiseCategoryTitlesArrayWithColors;
- (NSString *)categoryTitleAtIndex:(NSInteger)anIndex;
- (NSInteger)categoryTitlesCount;

- (void)startIconDownload:(ImageRecord *)imageRecord
    forCollectionViewItemIndexPath:(NSIndexPath *)collectionViewItemIndexPath
        andCollectionViewIndexPath:(NSIndexPath *)collectionViewIndexPath
                        completion:(void (^)(NSIndexPath *collectionViewItemIndexPath, NSIndexPath *collectionViewIndexPath,  ImageRecord *imageRecord))completionBlock;

- (void)startImageURLDownloadForCollectionViewItemIndexPath:(NSIndexPath*)collectionViewItemIndexPath andCollectionViewIndexPath:(NSIndexPath*)collectionViewIndexPath  completion:(void (^)(NSIndexPath *collectionViewItemIndexPath, NSIndexPath *collectionViewIndexPath,  ImageRecord *imageRecord))completionBlock;
- (void)terminateAllDownloads;
@end
