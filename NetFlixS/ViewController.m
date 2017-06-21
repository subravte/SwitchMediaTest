//
//  ViewController.m
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 27/5/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+Utilities.h"
#import "smTableViewCell.h"
#import "AFNetworking.h"
#import "MyDataManager.h"
#import "IconDownloader.h"
#import "ImageRecord.h"
#import "XMLDictionary.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageDownloadsInProgress = [NSMutableDictionary dictionary];

    [self createTableView];
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
}

-(void)loadView
{
    [super loadView];
    
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];

}

- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.bounces = YES;
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[smTableViewCell class] forCellReuseIdentifier:@"categoryCellReuseIdentifier"];
    [self.view addSubview:self.tableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [MyDataManager sharedInstance].categoryTitlesCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[MyDataManager sharedInstance] categoryTitleAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"categoryCellReuseIdentifier";
    smTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell prepareForReuse];
    if (cell == nil)
    {
        cell = [[smTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(smTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    NSInteger index = cell.collectionView.indexPath.section;
    
    CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
    [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[MyDataManager sharedInstance].dataArray objectAtIndex:[(smCollectionView *)collectionView indexPath].section] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    smCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"categoryItemReuseIdentifier" forIndexPath:indexPath];
//    [cell prepareForReuse];
//    if (cell == nil){
//        cell = [[UICollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
//    }
    
    NSMutableArray *tempCategoryItemArray = [[MyDataManager sharedInstance].dataArray objectAtIndex:[(smCollectionView *)collectionView indexPath].section];
    if ([[tempCategoryItemArray objectAtIndex:indexPath.row] isKindOfClass:[ImageRecord class]]) {
        ImageRecord *imageRecord = (ImageRecord *)[tempCategoryItemArray objectAtIndex:indexPath.row];
        cell.categoryItemTitleLabel.text = [imageRecord imageName];
        if (imageRecord.imageIcon) {
            cell.categoryItemImageView.image = imageRecord.imageIcon;
        }
        else{
            [self startIconDownload:imageRecord ForCollectionViewItemIndexPath:indexPath andCollectionViewIndexPath:[(smCollectionView *)collectionView indexPath]];
        }
    }
    else{
    cell.categoryItemImageView.backgroundColor = [tempCategoryItemArray objectAtIndex:indexPath.row];
    cell.categoryItemImageView.image = [UIImage imageNamed:@"placeholder.png"];
    cell.categoryItemTitleLabel.text = @"text";
    cell.categoryItemTitleLabel.backgroundColor = [tempCategoryItemArray objectAtIndex:indexPath.row];
    [self startImageURLDownloadForCollectionViewItemIndexPath:indexPath andCollectionViewIndexPath:[(smCollectionView *)collectionView indexPath]];
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    smCollectionView *collectionView = (smCollectionView *)scrollView;
    NSInteger index = collectionView.indexPath.section;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self terminateAllDownloads];

}

- (void)terminateAllDownloads
{
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

- (void)dealloc
{
    // terminate all pending download connections
    [self terminateAllDownloads];
}

#pragma mark - Table cell image support

-(smCollectionViewCell *)collectionViewCellForCollectionViewItemIndexPath:(NSIndexPath*)collectionViewItemIndexPath andCollectionViewIndexPath:(NSIndexPath*)collectionViewIndexPath{
    smTableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:collectionViewIndexPath];
    smCollectionViewCell *collectionViewCell = (smCollectionViewCell *)[tableViewCell.collectionView cellForItemAtIndexPath:collectionViewItemIndexPath];
    return collectionViewCell;
}

- (void)setImageTitleLabel:(ImageRecord *)imageRecord ForCollectionViewItemIndexPath:(NSIndexPath*)collectionViewItemIndexPath andCollectionViewIndexPath:(NSIndexPath*)collectionViewIndexPath{
    smCollectionViewCell *cell = [self collectionViewCellForCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath];
    cell.categoryItemTitleLabel.text = [imageRecord imageName];
    [cell.categoryItemTitleLabel reloadInputViews];
}

- (void)saveImageRecord:(ImageRecord *)imageRecord ForCollectionViewItemIndexPath:(NSIndexPath*)collectionViewItemIndexPath andCollectionViewIndexPath:(NSIndexPath*)collectionViewIndexPath{
    NSMutableArray *tempCategoryItemArray = [[MyDataManager sharedInstance].dataArray objectAtIndex:collectionViewIndexPath.section];
    [tempCategoryItemArray replaceObjectAtIndex:collectionViewItemIndexPath.row withObject:imageRecord];
    [[MyDataManager sharedInstance].dataArray replaceObjectAtIndex:collectionViewIndexPath.section withObject:tempCategoryItemArray];
}

- (void)startImageURLDownloadForCollectionViewItemIndexPath:(NSIndexPath*)collectionViewItemIndexPath andCollectionViewIndexPath:(NSIndexPath*)collectionViewIndexPath{
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://www.colourlovers.com/api/patterns/random"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *imageURLString = [[[NSDictionary dictionaryWithXMLData:data] objectForKey:@"pattern"] objectForKey:@"imageUrl"];
        ImageRecord *imageRecord =[[ImageRecord alloc]init];
        imageRecord.imageURLString = imageURLString;
        [self setImageTitleLabel:imageRecord ForCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath];
        [self startIconDownload:imageRecord ForCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath];
    }] resume];
}

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(ImageRecord *)imageRecord ForCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath
{
    NSString *indexPath = [NSString stringWithFormat:@"%@-%@", collectionViewIndexPath, collectionViewItemIndexPath];
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imageRecord = imageRecord;
        [iconDownloader setCompletionHandler:^{
            
            smCollectionViewCell *cell = [self collectionViewCellForCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath];
            
            // Display the newly loaded image
            cell.categoryItemImageView.image = imageRecord.imageIcon;
            cell.categoryItemTitleLabel.text = [imageRecord imageName];
            [cell reloadInputViews];
            [self saveImageRecord:imageRecord ForCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath];
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

@end
