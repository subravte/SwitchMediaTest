//
//  NFWebService.h
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 29/5/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFWebService : NSObject

+ (NFWebService *) sharedService;
- (void) fetchDataFromURL:(NSString *)aURL withCallback:(void (^)(NSString *, NSError *))aCallback;

@end
