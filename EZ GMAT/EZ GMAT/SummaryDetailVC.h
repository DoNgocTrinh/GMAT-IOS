//
//  SummaryDetailVC.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/17/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionType.h"
#import "TWRCharts/TWRChart.h"

@interface SummaryDetailVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbvSubtype;
@property (weak, nonatomic) IBOutlet UIView *graphView;

@property QuestionType *type;
@end
