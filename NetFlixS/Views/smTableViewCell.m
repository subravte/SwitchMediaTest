//
//  smTableViewCell.m
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 27/5/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import "smTableViewCell.h"
@implementation smCollectionView

@end

@implementation smTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.itemSize = CGSizeMake(190, 190);
        self.collectionView=[[smCollectionView alloc] initWithFrame:CGRectZero
                                               collectionViewLayout:layout];
        [self.collectionView registerClass:[smCollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:self.collectionView];
    }
    // Initialization code
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.contentView.bounds;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    
    [self.collectionView reloadData];
}

@end
