//
//  ViewController.h
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 27/5/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullTileViewController.h"
@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, FullTileCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

