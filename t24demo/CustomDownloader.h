//
//  CustomDownloader.h
//  t24demo
//
//  Created by Bilgehan IŞIKLI on 01/07/16.
//  Copyright © 2016 BYazilim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomDownloaderProtocol <NSObject>

- (void)newsDownloaded: (NSArray*) withArray;

@end

@interface CustomDownloader : NSObject 

@property id <CustomDownloaderProtocol> delegate;

@property NSMutableData* data;

-(void) t24Download ;

@end
