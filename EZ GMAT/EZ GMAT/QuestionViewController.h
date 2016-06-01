//
//  QuestionViewController.h
//  GMAT
//
//  Created by Trung Đức on 4/9/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionPack.h"

@interface QuestionViewController : UIViewController<UITableViewDataSource, UITabBarDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray *questions;
@property (weak, nonatomic) IBOutlet UITableView *tbvQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIProgressView *progessBar;
- (IBAction)btnSubmitDidTouch:(id)sender;

@end
