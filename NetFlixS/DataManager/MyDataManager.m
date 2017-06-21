//
//  MyDataManager.m
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 21/6/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import "MyDataManager.h"
#import "XMLDictionary.h"
#import "IconDownloader.h"

@interface MyDataManager ()
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) NSMutableDictionary *imageRecordsCollection;

@end
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
    return [self.dataArray mutableCopy];
}

+(NSArray *) categoryTitlesArray {
    return self.categoryTitlesArray;
}

-(NSString *)categoryTitleAtIndex:(NSInteger)anIndex {
    return [self.categoryTitlesArray objectAtIndex:anIndex];
}

-(NSInteger) categoryTitlesCount {
    return [self.categoryTitlesArray count];
}

- (void)initialiseDataArrayWithColors{
    _imageDownloadsInProgress = [NSMutableDictionary dictionary];
    _imageRecordsCollection = [NSMutableDictionary dictionary];
    
    [self initialiseCategoryTitlesArrayWithColors];
    self.dataArray = [[NSArray generateRandomData] mutableCopy];
}

- (void)initialiseCategoryTitlesArrayWithColors{
    self.categoryTitlesArray = [NSArray arrayWithObjects:@"Adventure", @"Children",@"Drama",@"Fantasy",@"Horror", @"Humor", @"Children", @"Drama", @"Mystery", @"Nonfiction", @"Romance", @"Sci-Fi", @"Politics", @"Suspense", @"Cooking", nil];
}

- (void)startIconDownload:(ImageRecord *)imageRecord
forCollectionViewItemIndexPath:(NSIndexPath *)collectionViewItemIndexPath
andCollectionViewIndexPath:(NSIndexPath *)collectionViewIndexPath
               completion:(void (^)(NSIndexPath *collectionViewItemIndexPath, NSIndexPath *collectionViewIndexPath,  ImageRecord *imageRecord))completionBlock
{
    NSString *indexPath = [NSString stringWithFormat:@"%@-%@", collectionViewIndexPath, collectionViewItemIndexPath];
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imageRecord = imageRecord;
        [iconDownloader setCompletionHandler:^{
            [self saveImageRecord:imageRecord ForCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath];
            if (completionBlock!=nil) {
                completionBlock(collectionViewItemIndexPath, collectionViewIndexPath, imageRecord);
            }
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

- (void)startImageURLDownloadForCollectionViewItemIndexPath:(NSIndexPath*)collectionViewItemIndexPath andCollectionViewIndexPath:(NSIndexPath*)collectionViewIndexPath completion:(void (^)(NSIndexPath *collectionViewItemIndexPath, NSIndexPath *collectionViewIndexPath,  ImageRecord *imageRecord))completionBlock{
    NSString *indexPath = [NSString stringWithFormat:@"%@-%@", collectionViewIndexPath, collectionViewItemIndexPath];
    if (!self.imageRecordsCollection[indexPath]) {
        
        
        NSURLSessionDataTask *downloadImageURL = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://www.colourlovers.com/api/patterns/random"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *imageURLString = [[[NSDictionary dictionaryWithXMLData:data] objectForKey:@"pattern"] objectForKey:@"imageUrl"];
            ImageRecord *imageRecord =[[ImageRecord alloc]init];
            imageRecord.imageURLString = imageURLString;
            
            if (completionBlock!=nil) {
                completionBlock(collectionViewItemIndexPath, collectionViewIndexPath, imageRecord);
                [self startIconDownload:imageRecord forCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath completion:completionBlock];
            }
            if (error) {
                NSString *indexPath = [NSString stringWithFormat:@"%@-%@", collectionViewIndexPath, collectionViewItemIndexPath];
                [self.imageRecordsCollection removeObjectForKey:indexPath];
            }
        }];
        (self.imageRecordsCollection)[indexPath] = @"YES";
        [downloadImageURL resume];
    }
}

- (void)saveImageRecord:(ImageRecord *)imageRecord ForCollectionViewItemIndexPath:(NSIndexPath*)collectionViewItemIndexPath andCollectionViewIndexPath:(NSIndexPath*)collectionViewIndexPath{
    
    NSMutableArray *tempCategoryItemArray = [self.dataArray objectAtIndex:collectionViewIndexPath.section];
    if ([[tempCategoryItemArray objectAtIndex:collectionViewItemIndexPath.row] isKindOfClass:[ImageRecord class]]) {
        ImageRecord *imageRecordTemp = [[ImageRecord alloc]init];
        if ([[imageRecord imageName] isEqualToString:[imageRecordTemp imageName]]) {
            [tempCategoryItemArray replaceObjectAtIndex:collectionViewItemIndexPath.row withObject:imageRecord];
            [self.dataArray replaceObjectAtIndex:collectionViewIndexPath.section withObject:tempCategoryItemArray];
        }
        else{
            
        }
    }
    else{
        [tempCategoryItemArray replaceObjectAtIndex:collectionViewItemIndexPath.row withObject:imageRecord];
        [self.dataArray replaceObjectAtIndex:collectionViewIndexPath.section withObject:tempCategoryItemArray];
    }
}

- (void)terminateAllDownloads
{
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

@end
