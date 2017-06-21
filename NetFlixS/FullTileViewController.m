//
//  FullTileViewController.m
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 22/6/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import "FullTileViewController.h"

@interface FullTileViewController ()

@end

@implementation FullTileViewController
-(void)viewDidLoad{
    self.categoryItemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*4/5)];
    self.categoryItemImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.categoryItemTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.categoryItemImageView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/5)];
    self.categoryItemTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryItemTitleLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:84.0];
    [self.view addSubview:self.categoryItemImageView];
    [self.view addSubview:self.categoryItemTitleLabel];
    [self.view bringSubviewToFront:self.collapseButton];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)collapseBackToTableView:(UIButton *)sender {
    [self.delegate fullTileCellWillCollapse];
}


@end
