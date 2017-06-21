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
    self.categoryItemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*2/3)];
    self.categoryItemImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.categoryItemTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.categoryItemImageView.frame.size.height, frame.size.width, frame.size.height/3)];
    self.categoryItemTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.categoryItemImageView];
    [self.contentView addSubview:self.categoryItemTitleLabel];
    return self;
}
@end
