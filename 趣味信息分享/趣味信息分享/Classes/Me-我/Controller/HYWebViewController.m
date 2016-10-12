//
//  HYWebViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/5/4.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYWebViewController.h"
#import <NJKWebViewProgress.h>

@interface HYWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/**进度代理对象*/
@property(nonatomic,strong)NJKWebViewProgress *progress;
@end

@implementation HYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progress = [[NJKWebViewProgress alloc]init];
    self.webView.delegate = self.progress;
    __weak typeof (self) weakSelf = self;
    self.progress.progressBlock = ^(float progress){
        weakSelf.progressView.progress = progress;
        weakSelf.progressView.hidden = (progress == 1.0);
    };
    self.progress.webViewProxyDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)refresh:(id)sender {
    [self.webView reload];
}
- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}
- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}


#pragma mark - <UIWebViewDelegate>
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.goBackItem.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
}

@end
