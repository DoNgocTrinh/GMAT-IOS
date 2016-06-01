//
//  QuestionsViewController.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/31/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionsViewController : UIViewController <UITableViewDataSource, UITabBarDelegate, UIWebViewDelegate>
@property (nonatomic, strong) NSMutableArray *questions;
@property (weak, nonatomic) IBOutlet UITableView *tbvQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIProgressView *progessBar;
- (IBAction)btnSubmitDidTouch:(id)sender;

@end
