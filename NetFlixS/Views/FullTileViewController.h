//
//  FullTileViewController.h
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 22/6/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FullTileCellDelegate <NSObject>

-(void)fullTileCellWillCollapse;

@end

@interface FullTileViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UIView *cell;
@property (weak, nonatomic) IBOutlet UIButton *collapseButton;
@property (weak,nonatomic) id <FullTileCellDelegate> delegate;
@property (nonatomic, retain) UILabel *categoryItemTitleLabel;
@property (nonatomic, retain) UIImageView *categoryItemImageView;


@end
