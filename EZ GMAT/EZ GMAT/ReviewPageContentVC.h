//
//  ReviewPageContentVC.h
//  GMAT
//
//  Created by Do Ngoc Trinh on 5/13/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentAnswer.h"
#import "Question.h"

@interface ReviewPageContentVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger pageindex;
@property (nonatomic, strong) StudentAnswer *studentAnswer;
@property (nonatomic, strong) Question *question;

@property (weak, nonatomic) IBOutlet UITableView *tbvReview;

@end
