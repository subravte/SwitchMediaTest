//
//  smTableViewCell.h
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 27/5/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface smTableViewCell : UITableViewCell 
@property (strong, nonatomic ) UICollectionView *collectionView;

- (void)setDataSourceDelegate:(id)view withTag:(NSInteger)rowID;
@end
