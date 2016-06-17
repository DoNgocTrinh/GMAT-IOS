//
//  SummaryVC.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/9/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *viewTag;
@property (weak, nonatomic) IBOutlet UITableView *tbvCategories;
@property (weak, nonatomic) IBOutlet UILabel *lblNoStar;
@property (weak, nonatomic) IBOutlet UILabel *lblAverageTime;
@property (weak, nonatomic) IBOutlet UILabel *lblUntag;
@property (weak, nonatomic) IBOutlet UILabel *lblRed;
@property (weak, nonatomic) IBOutlet UILabel *lblYellow;

@property (weak, nonatomic) IBOutlet UILabel *lblGreen;
@property (weak, nonatomic) IBOutlet UILabel *lblStar;
@property (weak, nonatomic) IBOutlet MCPercentageDoughnutView *viewProgress;

@end
