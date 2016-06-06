//
//  ReadingViewController.m
//  MathSolution
//
//  Created by Do Ngoc Trinh on 5/30/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "ReadingViewController.h"

@interface ReadingViewController ()

@end

@implementation ReadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webview layoutIfNeeded];
    //[self setInset];

   // self.navigationController.navigationBar.translucent = NO;
    _btnDismiss.layer.masksToBounds = YES;
    _btnDismiss.layer.cornerRadius = _btnDismiss.bounds.size.width/2;
    
    self.btnDismiss.layer.shadowColor = [UIColor blackColor].CGColor;
    self.btnDismiss.layer.shadowOffset = CGSizeMake(1.0f,1.0f);
    self.btnDismiss.layer.masksToBounds = NO;
    self.btnDismiss.layer.shadowRadius = 0.0f;
    self.btnDismiss.layer.shadowOpacity = 0.5;
    //self.btnDismiss.frame = CGRectMake(0,0, 20.0, 20.0);
    
    [_btnDismiss addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];

    _webview.delegate =self;
    // Round corners using CALayer property
    
    [[_webview layer] setCornerRadius:3];
    [_webview loadHTMLString:_content baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissView;{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];

    [self.view removeFromSuperview];
}
-(void)setInset;{
    [_webview.scrollView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0)];
    [_webview.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0)];

    //[_tbvQuestion setScrollIndicatorInsets:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
