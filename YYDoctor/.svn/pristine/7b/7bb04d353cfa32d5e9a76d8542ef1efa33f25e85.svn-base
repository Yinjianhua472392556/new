//
//  HealthPermissionController.m
//  YYDoctor
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "HealthPermissionController.h"

@interface HealthPermissionController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation HealthPermissionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)loadWebView {
    NSURL *url = [NSURL URLWithString:self.healthUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

@end
