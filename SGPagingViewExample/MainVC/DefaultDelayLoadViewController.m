//
//  DefaultDelayLoadViewController.m
//  SGPagingViewExample
//
//  Created by bai on 2017/12/8.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "DefaultDelayLoadViewController.h"
#import "SGPagingView.h"

@interface DefaultDelayLoadViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentViewScrollView;

@end

@implementation DefaultDelayLoadViewController

- (void)dealloc {
    NSLog(@"DefaultScrollVC - - dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndex:) name:@"changeSelectedIndex" object:nil];
    
    [self setupPageView];
}

- (void)changeSelectedIndex:(NSNotification *)noti {
    _pageTitleView.resetSelectedIndex = [noti.object integerValue];
}

- (void)setupPageView {
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        pageTitleViewY = 64;
    } else {
        pageTitleViewY = 88;
    }
    
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会", @"VIP会员"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.indicatorAdditionalWidth = 10; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    
    
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentViewScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) childViewCount:titleArr.count];
    _pageContentViewScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentViewScrollView];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {

    [self.pageContentViewScrollView setPageCententScrollViewCurrentIndex:selectedIndex];
//    [self.pageContentViewScrollView setPageCententViewCurrentIndex:selectedIndex];
}

-(UIView *)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView viewForIndex:(NSInteger)index{
    //这里可以使用懒加载防止重复创建view
    UILabel *lable = [UILabel new];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = [NSString stringWithFormat:@"%ld",(long)index];
    lable.backgroundColor = [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
    return lable;
}

-(void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex{
     [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

//
//- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
//    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
//}

@end
