//
//  smCollectionViewCell.m
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 27/5/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import "smCollectionViewCell.h"

@implementation smCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.categoryItemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 160, 150)];
    self.categoryItemImageView.image = [UIImage imageNamed:@"placeholder.png"];
    self.categoryItemTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 160, 30)];
    self.categoryItemTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.categoryItemImageView];
    [self addSubview:self.categoryItemTitleLabel];
    return self;
}
@end
