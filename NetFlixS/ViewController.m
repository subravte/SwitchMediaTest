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
#import "MyDataManager.h"
#import "IconDownloader.h"
#import "ImageRecord.h"
#import "XMLDictionary.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (nonatomic, strong) FullTileViewController *fullTile;
@property (nonatomic) CGRect chosenCellFrame;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
}

-(void)loadView
{
    [super loadView];
    [self createTableView];
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

#pragma mark TableViewDataSource Methods
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

#pragma mark CollectionViewDataSource Methods

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
            [self startIconDownload:imageRecord forCollectionViewItemIndexPath:indexPath andCollectionViewIndexPath:[(smCollectionView *)collectionView indexPath]];
        }
    }
    else{
    cell.categoryItemImageView.backgroundColor = [tempCategoryItemArray objectAtIndex:indexPath.row];
    cell.categoryItemImageView.image = [UIImage imageNamed:@"placeholder.png"];
    cell.categoryItemTitleLabel.backgroundColor = [tempCategoryItemArray objectAtIndex:indexPath.row];
    [self startImageURLDownloadForCollectionViewItemIndexPath:indexPath andCollectionViewIndexPath:[(smCollectionView *)collectionView indexPath]];
    }
    return cell;
}

#pragma mark - CollectionViewDelegate Methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *tempCategoryItemArray = [[MyDataManager sharedInstance].dataArray objectAtIndex:[(smCollectionView *)collectionView indexPath].section];
    if ([[tempCategoryItemArray objectAtIndex:indexPath.row] isKindOfClass:[ImageRecord class]]) {
        ImageRecord *imageRecord = (ImageRecord *)[tempCategoryItemArray objectAtIndex:indexPath.row];
        if (! self.fullTile) {
            self.fullTile = [self.storyboard instantiateViewControllerWithIdentifier:@"FullTile"];
            self.fullTile.delegate = self;
        }
        [self addChildViewController:self.fullTile];
        self.fullTile.view.frame = [self.tableView rectForRowAtIndexPath:indexPath];
        self.fullTile.view.center = CGPointMake(self.fullTile.view.center.x, self.fullTile.view.center.y - self.tableView.contentOffset.y); // adjusts for the offset of the cell when you select it
        self.chosenCellFrame = self.fullTile.view.frame;
        self.fullTile.categoryItemImageView.image = imageRecord.imageIcon;
        self.fullTile.categoryItemTitleLabel.text = [imageRecord imageName];
        [self.view addSubview:self.fullTile.view];
        [UIView animateWithDuration:.5 animations:^{
            self.fullTile.view.frame = self.tableView.frame;
            self.fullTile.collapseButton.alpha = 1;
        } completion:^(BOOL finished) {
            [self.fullTile didMoveToParentViewController:self];
        }];
    }
}

#pragma mark - FullTileCellViewControllerDelegate Methods

-(void)fullTileCellWillCollapse {
    [self.fullTile willMoveToParentViewController:nil];
    [UIView animateWithDuration:.5 animations:^{
        self.fullTile.view.frame = self.chosenCellFrame;
        self.fullTile.collapseButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self.fullTile.view removeFromSuperview];
        [self.fullTile removeFromParentViewController];
    }];
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
    [[MyDataManager sharedInstance] terminateAllDownloads];

}

- (void)dealloc
{
    // terminate all pending download connections
    [[MyDataManager sharedInstance] terminateAllDownloads];
}

#pragma mark - Table cell image support

-(smCollectionViewCell *)collectionViewCellForCollectionViewItemIndexPath:(NSIndexPath*)collectionViewItemIndexPath andCollectionViewIndexPath:(NSIndexPath*)collectionViewIndexPath{
    smTableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:collectionViewIndexPath];
    smCollectionViewCell *collectionViewCell = (smCollectionViewCell *)[tableViewCell.collectionView cellForItemAtIndexPath:collectionViewItemIndexPath];
    return collectionViewCell;
}

- (void)setImageRecord:(ImageRecord *)imageRecord forCollectionViewItemIndexPath:(NSIndexPath*)collectionViewItemIndexPath andCollectionViewIndexPath:(NSIndexPath*)collectionViewIndexPath{
    smCollectionViewCell *cell = [self collectionViewCellForCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath];
    cell.categoryItemTitleLabel.text = [imageRecord imageName];
    if (imageRecord.imageIcon!=nil) {
        cell.categoryItemImageView.image = imageRecord.imageIcon;
    }
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
}



- (void)startImageURLDownloadForCollectionViewItemIndexPath:(NSIndexPath*)collectionViewItemIndexPath andCollectionViewIndexPath:(NSIndexPath*)collectionViewIndexPath{
    [[MyDataManager sharedInstance] startImageURLDownloadForCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath completion:^(NSIndexPath *collectionViewItemIndexPath, NSIndexPath *collectionViewIndexPath, ImageRecord *imageRecord) {
        [self setImageRecord:imageRecord forCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath];
    }];
}

- (void)startIconDownload:(ImageRecord *)imageRecord
        forCollectionViewItemIndexPath:(NSIndexPath *)collectionViewItemIndexPath
            andCollectionViewIndexPath:(NSIndexPath *)collectionViewIndexPath
{
    
    [[MyDataManager sharedInstance] startIconDownload:imageRecord forCollectionViewItemIndexPath:collectionViewItemIndexPath
andCollectionViewIndexPath:collectionViewIndexPath completion:^(NSIndexPath *collectionViewItemIndexPath, NSIndexPath *collectionViewIndexPath, ImageRecord *imageRecord) {
    [self setImageRecord:imageRecord forCollectionViewItemIndexPath:collectionViewItemIndexPath andCollectionViewIndexPath:collectionViewIndexPath];
}];
}

@end
