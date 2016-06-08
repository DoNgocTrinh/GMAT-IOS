//
//  QuickReviewViewController.h
//  GMAT
//
//  Created by Trung Đức on 4/9/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickReviewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tbvQuickReview;

@property (nonatomic, strong) NSMutableArray *studentAnswers;

@property (nonatomic, strong) NSMutableArray *questions;

@property(nonatomic,strong)NSString *lblTime;
@end
