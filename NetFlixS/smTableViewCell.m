//
//  smTableViewCell.m
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 27/5/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import "smTableViewCell.h"
#import "smCollectionViewCell.h"

@implementation smTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(40, 0, 960, 200);
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView=[[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        [self.collectionView registerClass:[smCollectionViewCell class] forCellWithReuseIdentifier:@"categoryItemReuseIdentifier"];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:self.collectionView];
    }
    // Initialization code
    return self;
}

- (void)setDataSourceDelegate:(id)view withTag:(NSInteger)rowID{
    [self.collectionView setDataSource:view];
    [self.collectionView setDelegate:view];
    [self.collectionView setTag:rowID];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
