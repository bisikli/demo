//
//  ViewController.m
//  t24demo
//
//  Created by Bilgehan IŞIKLI on 01/07/16.
//  Copyright © 2016 BYazilim. All rights reserved.
//

#import "ViewController.h"
#import "CustomDownloader.h"
#import "SwipeView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController () <CustomDownloaderProtocol,SwipeViewDelegate,SwipeViewDataSource>

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property NSMutableArray* newsArray;
@property NSTimer* timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeView.pagingEnabled = YES;
    self.swipeView.delegate = self;
    self.swipeView.dataSource = self;
    //[self.swipeView reloadData];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)downloadAction:(id)sender {
    
    CustomDownloader* downloader = [[CustomDownloader alloc] init];
    
    downloader.delegate = self;
    
    [downloader t24Download];
    
}

-(void) newsDownloaded:(NSArray *)withArray{
    NSLog(@"newsDownloaded");
    self.newsArray = (NSMutableArray*)withArray;
    [self.swipeView reloadData];
}

-(NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    NSLog(@"numberOfItemsInSwipeView: %lu",[self.newsArray count]);
    return [self.newsArray count];
}

-(UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    NSLog(@"Index num: %ld", (long)index);
    UIImageView *imageView = nil;
    UILabel *label = nil;
    NSDictionary* newsItem = (NSDictionary*) self.newsArray[index];
    NSString* url = (NSString*)[[newsItem objectForKey:@"images"] objectForKey:@"box"];
    //create new view if no view is available for recycling
    if (view == nil)
    {

        view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        CGRect imageRect = CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height * 0.7);
        
        imageView = [[UIImageView alloc] initWithFrame: imageRect];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        imageView.tag = 1;
        
        CGRect labelRect = CGRectMake(view.bounds.origin.x,( view.bounds.origin.y + imageView.bounds.size.height), view.bounds.size.width, view.bounds.size.height * 0.2);
        
        label = [[UILabel alloc] initWithFrame:labelRect];
        label.text = @"hebele hubele";
        label.textAlignment = NSTextAlignmentLeft;
        label.tag = 2;
        
        NSLayoutConstraint* vertical = [ NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        
        
        [view addSubview:imageView];
        [view addSubview:label];
        [label addConstraint:vertical];
    }
    else
    {
        //get a reference to the label in the recycled view
        imageView = (UIImageView *)[view viewWithTag:1];
        label = (UILabel*) [view viewWithTag:2];
        
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[url substringFromIndex:2]]] placeholderImage:[UIImage imageNamed:@"logo-t24"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSLog(@"%@",error.description);
    }];
    
    return view;
    
}
- (IBAction)buttonAction:(id)sender {
    [self.swipeView scrollToItemAtIndex:0 duration: 0.5];
}

-(void) swipeToBeginning {
    NSLog(@"swipeToBeginning");
    
    [self.swipeView scrollToItemAtIndex:0 duration: 0.5];
}

- (void)swipeViewWillBeginDragging:(SwipeView *)swipeView {
    
    if (self.swipeView.currentPage == (self.swipeView.numberOfItems-1)) {
        NSLog(@"LAST PAGE!!");
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(swipeToBeginning) userInfo:nil repeats:NO];
    }
}






@end
