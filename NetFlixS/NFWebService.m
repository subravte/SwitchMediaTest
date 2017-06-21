//
//  NFWebService.m
//  NetFlixS
//
//  Created by TEJASWINI SUBRAVETI on 29/5/17.
//  Copyright © 2017 TEJASWINI SUBRAVETI. All rights reserved.
//

#import "NFWebService.h"
#import "XMLDictionary.h"
@implementation NFWebService


+ (NFWebService *) sharedService
{
    static NFWebService *nfWebService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nfWebService = [[self alloc] init];
    });
    return nfWebService;
}

- (void) fetchDataFromURL:(NSString *)aURLString withCallback:(void (^)(NSString *, NSError *))aCallback
{
    NSURL *theURL = [NSURL URLWithString:aURLString];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:theURL]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSHTTPURLResponse *statusResponse = (NSHTTPURLResponse *)response;
         if (statusResponse.statusCode >= 200 && statusResponse.statusCode < 300) {
             if (data.length > 0 && connectionError == nil) {
                 NSString *imageURLString = [[[NSDictionary dictionaryWithXMLData:data] objectForKey:@"pattern"] objectForKey:@"imageUrl"];;
                 if (aCallback) {
                     aCallback(imageURLString, nil);
                 }
             } else {
                 if (aCallback) {
                     aCallback(nil, connectionError);
                 }
             }
         } else {
             NSString *statusMessage = [NSString stringWithFormat:@"Invalid status response code: %ld", (unsigned long)statusResponse.statusCode];
             NSError *statusError = [[NSError alloc] initWithDomain:@"com.somedomain" code:10001 userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(statusMessage, nil)}];
             if (aCallback) {
                 aCallback(nil, statusError);
             }
         }
     }];

}

@end
