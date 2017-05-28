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
#import "smCollectionViewCell.h"
#import "AFNetworking.h"
#import "XMLDictionary.h"
#import "NFWebService.h"

@interface ViewController ()

@property (nonatomic, retain) NFWebService *shared;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categoryTitles = [NSArray arrayWithObjects:@"Adventure", @"Children",@"Drama",@"Fantasy",@"Horror", @"Humor", @"Children", @"Drama", @"Mystery", @"Nonfiction", @"Romance", @"Sci-Fi", @"Politics", @"Suspense", @"Cooking", nil];
    self.categoryArray = [[NSArray generateRandomData] mutableCopy];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.estimatedRowHeight = 50;
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.bounces = YES;
    self.tableView.sectionIndexColor = [UIColor clearColor];
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
    return self.categoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.categoryTitles randomObject];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"categoryCellReuseIdentifier";
    smTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell prepareForReuse];
    if (cell == nil)
    {
        cell = [[smTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell setDataSourceDelegate:self withTag:indexPath.section];
    [cell.collectionView registerClass:[smCollectionViewCell class] forCellWithReuseIdentifier:@"categoryItemReuseIdentifier"];
    [cell.collectionView reloadData];
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    smCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"categoryItemReuseIdentifier" forIndexPath:indexPath];
    [cell prepareForReuse];
    if (cell == nil){
        cell = [[smCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    }
    cell.backgroundColor = [UIColor clearColor];

    NSMutableArray *tempCategoryItemArray = [self.categoryArray objectAtIndex:collectionView.tag];
    NSString *imageURL = [tempCategoryItemArray objectAtIndex:indexPath.row];
    
    if (![imageURL isKindOfClass:[NSString class]]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:@"http://www.colourlovers.com/api/patterns/random" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *imageURL = [[[NSDictionary dictionaryWithXMLData:responseObject] objectForKey:@"pattern"] objectForKey:@"imageUrl"];
            cell.categoryItemImageView.image = [UIImage imageWithContentsOfFile:imageURL];
            [tempCategoryItemArray replaceObjectAtIndex:indexPath.row withObject:imageURL];
            
            cell.categoryItemTitleLabel.text = [imageURL lastPathComponent];
            [cell setNeedsLayout];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^(void) {
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                
                UIImage* image = [[UIImage alloc] initWithData:imageData];
                NSString *path = [[self applicationDocumentsDirectory].path
                                  stringByAppendingPathComponent:imageURL.lastPathComponent];
                [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];

                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.categoryItemImageView.image = image;
                    [cell setNeedsLayout];
                });
            });
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else{
        NSString *imagePath = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:imageURL.lastPathComponent];
        cell.categoryItemTitleLabel.text = [imageURL lastPathComponent];
        if ([[NSFileManager defaultManager]fileExistsAtPath:imagePath]) {
            NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
            cell.categoryItemImageView.image = [[UIImage alloc] initWithData:imgData];
            [cell setNeedsLayout];
        }
        else{
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^(void) {
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                
                UIImage* image = [[UIImage alloc] initWithData:imageData];
                NSString *path = [[self applicationDocumentsDirectory].path
                                  stringByAppendingPathComponent:imageURL.lastPathComponent];
                [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.categoryItemImageView.image = image;
                    [cell setNeedsLayout];
                });
            });
  
            
        }
    }
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(180, 180);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
