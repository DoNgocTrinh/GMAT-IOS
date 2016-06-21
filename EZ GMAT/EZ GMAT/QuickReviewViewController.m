//
//  QuickReviewViewController.m
//  GMAT
//
//  Created by Trung Đức on 4/9/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "QuickReviewViewController.h"
//#import "QuickReviewCell.h"
//#import "StudentAnswer.h"
//#import "QuickReviewAnswerCell.h"
//#import "Question.h"
//#import "Constant.h"
#import "ReviewPageController.h"

@interface QuickReviewViewController ()
{
    double avgTime;
}
@end

@implementation QuickReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //calculate AVG time
avgTime = 0;
    for(Question *q in _questions){
        avgTime += [q.timeToFinish doubleValue];
    }
    avgTime = avgTime/_questions.count;
    
    NSLog(@"-----------%lu %lu", (unsigned long)_studentAnswers.count, (unsigned long)_questions.count);
    self.navigationItem.hidesBackButton = YES;
    
    self.title = @"Review";
    self.automaticallyAdjustsScrollViewInsets = false;
    _tbvQuickReview.tableFooterView = [[UIView alloc]init];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnDoneDidTouch)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    //sort array; 
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"questionId" ascending:YES];
    [_questions sortUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return _studentAnswers.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"quickReviewCell";
    
    if (indexPath.section == 0) {
        
        QuickReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"QuickReviewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            cell.preservesSuperviewLayoutMargins = NO;
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int numberOfRightAnswer = 0;
        
        for (StudentAnswer *studentAnswer in _studentAnswers) {
            if ([studentAnswer.result isEqualToNumber:Right]) {
                numberOfRightAnswer++;
            }
        }
        
        cell.viewCir.percentage = (float)numberOfRightAnswer/(float)_studentAnswers.count;
        CGFloat completePercent = ((float)numberOfRightAnswer)*100.0f/(float)_studentAnswers.count;
        cell.viewCir.textLabel.text = [NSString stringWithFormat:@" %.1lf%% ", completePercent];        
        cell.lblTime.text = [NSString stringWithFormat:@"Average time:  %.1fs",avgTime];
        
        return cell;
    } else if (indexPath.section == 1) {
        
        QuickReviewAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"QuickReviewAnswerCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.lblQuestion.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1, [_questions[indexPath.row] stimulus]];
        
        [cell cellWithResult:[_studentAnswers[indexPath.row] result]];

        return cell;
    } else {
        return nil;
    }
    
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
//        ReviewViewController *reviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"review"];
//        
//        reviewController.studentAnswer = _studentAnswers[indexPath.row];
//        reviewController.question = _questions[indexPath.row];
//        
//        [self.navigationController pushViewController:reviewController animated:YES];

        
        ReviewPageController *reviewPageController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewPageController"];
       
        reviewPageController.currentPageIndex  = indexPath.row;
        reviewPageController.questions = _questions;
        reviewPageController.studentAnswers = _studentAnswers;
        
       [self.navigationController pushViewController:reviewPageController animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    } else {
        return 50;
    }
}

#pragma mark - Class funtions
-(float)convertTimeFromString:(NSString *)string;{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSDate *currentDate = [dateFormatter dateFromString:string];
    NSDate *date = [dateFormatter dateFromString:@"00:00"];
    //NSLog(@"Date: %@", currentDate);
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:date];
   // NSLog(@"Time interval : %f", timeInterval);
    return timeInterval;
}
- (void)btnDoneDidTouch;
{
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[UIViewController class]]) {
            [self.navigationController popToViewController:aViewController animated:YES];
        }
    }
}


@end
