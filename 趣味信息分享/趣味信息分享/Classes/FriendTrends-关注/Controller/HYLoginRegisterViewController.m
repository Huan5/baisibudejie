//
//  HYLoginRegisterViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/22.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYLoginRegisterViewController.h"
#import "HYTextField.h"
#import <SVProgressHUD.h>

@interface HYLoginRegisterViewController ()
/**
 *登录框距离左边的间距
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;
@property (weak, nonatomic) IBOutlet HYTextField *loginName;
@property (weak, nonatomic) IBOutlet HYTextField *loginPassword;
@property (weak, nonatomic) IBOutlet HYTextField *registerPassword;
@property (weak, nonatomic) IBOutlet HYTextField *registerName;


@end

@implementation HYLoginRegisterViewController
- (IBAction)back {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showLoginOrRegister:(UIButton *)button {
    //退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeftMargin.constant == 0) {//显示注册框
        self.loginViewLeftMargin.constant = -self.view.width;
        button.selected = YES;
        //        [button setTitle:@"已有账号？" forState:UIControlStateNormal];
    }else{//显示登录框
        self.loginViewLeftMargin.constant = 0;
        button.selected = NO;
        //        [button setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
/**
 *让当前控制器对应的状态栏是白色
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (IBAction)loginClick {
    if ([self.loginPassword.text isEqualToString:@""] || [self.loginName.text isEqualToString:@""] || (self.loginPassword.text.length < 6)) {
        [SVProgressHUD showErrorWithStatus:@"错误的用户"];
        HYLog(@"错误的用户");
        return;
    }
    //获取沙盒的路径
    NSString *plistPath = [self getSandboxPath];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    for (NSDictionary *dict in array) {
        if ([dict[@"name"] isEqualToString: self.loginName.text] && [dict[@"password"] isEqualToString:self.loginPassword.text]) {
            //发出一个通知
            [self sendNotification:self.loginName.text];
            [self back];
        }
    }
    
}
- (IBAction)registerClick {
    if ([self.registerName.text isEqualToString:@""] || [self.registerPassword.text isEqualToString:@""] || (self.registerPassword.text.length < 6)) {
        [SVProgressHUD showErrorWithStatus:@"注册失败"];
        HYLog(@"错误的用户");
        return;
    }
    //获取沙盒的路径
    NSString *plistPath = [self getSandboxPath];
    HYLog(@"%@",plistPath);
    
    NSDictionary *user = @{@"name":self.registerName.text,@"password":self.registerPassword.text};
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    //添加用户到plist文件
    //~/Library/Developer/Xcode/DerivedData
    [array addObject:user];
    if ([array writeToFile:plistPath atomically:YES]) {
        [self sendNotification:self.registerName.text];
        [self back];
    }else{
        HYLog(@"注册失败！");
    }
    
}
/**
 *  获取沙盒中user.plist的文件路径
 */
-(NSString *)getSandboxPath{
    //获取沙盒的路径
    NSArray *sandboxPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [sandboxPath objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"user.plist"];
    return plistPath;
}
/**
 *  发送一个通知
 */
-(void)sendNotification:(NSString *)name{
    NSDictionary *userInfo = @{@"name":name};
    [[NSNotificationCenter defaultCenter]postNotificationName:HYLogingSuccessNotfication object:nil userInfo:userInfo];
}
@end
