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
#import "XMLDictionary.h"
#import "NFWebService.h"
#import "MyDataManager.h"

@interface ViewController ()

@property (nonatomic, retain) NFWebService *shared;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
}

-(void)loadView
{
    [super loadView];
    
    self.categoryArray = [MyDataManager sharedInstance].dataArray;
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
    NSMutableArray *tempCategoryItemArray = [self.categoryArray objectAtIndex:[(smCollectionView *)collectionView indexPath].section];
    cell.categoryItemImageView.backgroundColor = [tempCategoryItemArray objectAtIndex:indexPath.row];
    cell.categoryItemImageView.image = [UIImage imageNamed:@"placeholder.png"];
    cell.categoryItemTitleLabel.text = @"text";
    cell.categoryItemTitleLabel.backgroundColor = [tempCategoryItemArray objectAtIndex:indexPath.row];
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
}

@end
