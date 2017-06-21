/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Object encapsulating information about an iOS app in the 'Top Paid Apps' RSS feed.
 Each one corresponds to a row in the app's table.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageRecord : NSObject

@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *imageLocation;
@property (nonatomic, retain) UIImage *imageIcon;

-(NSString *)imageName;
@end
