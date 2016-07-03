//
//  CustomDownloader.m
//  t24demo
//
//  Created by Bilgehan IŞIKLI on 01/07/16.
//  Copyright © 2016 BYazilim. All rights reserved.
//

#import "CustomDownloader.h"


@implementation CustomDownloader

-(instancetype)init{
    self = [super init];
    
    self.data = [[NSMutableData alloc] init];
    
    return self;
}

-(void) t24Download{

    
    NSURL* url = [NSURL URLWithString: @"http://t24.com.tr/api/v3/stories.json?paging=1" ];
    NSURLSession* session = [[NSURLSession alloc] init];
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    [[session dataTaskWithURL:url] resume];
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"Did received data!!");
    [self.data appendData:data];
    
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    //NSString* jsonStr = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@",jsonStr);
    
    NSArray* mainDic = [[NSArray alloc] init];
    
    NSError* errorDic ;
    
    NSMutableArray* returnArray = [[NSMutableArray alloc] init];
    
    mainDic = (NSArray*)[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:&errorDic];
    
    if(errorDic){
        NSLog(@"There is some error: %@",errorDic.description);
    }
    else{
        
        NSArray* data = (NSArray*)[mainDic valueForKey:@"data"];
        
        for (id items in data) {
            
            [returnArray addObject:(NSDictionary*)items];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate newsDownloaded:returnArray];
        });
        
        
    }
    

}

@end
