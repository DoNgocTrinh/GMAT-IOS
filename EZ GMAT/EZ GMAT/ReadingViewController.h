//
//  ReadingViewController.h
//  MathSolution
//
//  Created by Do Ngoc Trinh on 5/30/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadingViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnDismiss;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic)  NSString *content;

@end
