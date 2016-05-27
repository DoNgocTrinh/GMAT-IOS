//
//  QuestionViewController.m
//  GMAT
//
//  Created by Trung Đức on 4/9/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "QuestionViewController.h"
#import "Constant.h"
#import "Question.h"
#import "MagicalRecord.h"
#import "TextCell.h"
#import "Answer.h"
#import "AnswerCell.h"
#import "StudentAnswer.h"
//#import "QuickReviewViewController.h"

#import "CustomTitleView.h"

@interface QuestionViewController ()

@property(nonatomic, assign) NSInteger displayIndex;

@property (nonatomic, strong) NSMutableArray *studentAnwsers;

@end

@implementation QuestionViewController
{
    NSTimer *timer;
    NSDate *startDate;
    BOOL isTimeRun;
    CustomTitleView *customTitleView;
    AnswerCell *answerCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
  
    _studentAnwsers = [[NSMutableArray alloc]init];
    
    [_btnSubmit setBackgroundColor:kAppColor];
    
    [self configTableView];
    
    self.navigationItem.hidesBackButton = YES;
    
    _displayIndex = 0;
    [self redisplayQuestion];
    
    [self startTimer];
    
    [self disableBtn];
    
    //custom title view
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 44);
    customTitleView = [CustomTitleView customViewWithFrame:rect];
    [customTitleView setCenter:self.navigationItem.titleView.center];
    self.navigationItem.titleView = customTitleView;
}

- (void) showRightAnswer; {
    Question *selectedQuestion = _questions[_displayIndex];
    NSLog(@"Right answer : %@", selectedQuestion.rightAnswerIdx);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 5;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Question *selectedQuestion = _questions[_displayIndex];
    
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *answers = [[selectedQuestion.answers allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];    static NSString *cellId = @"question";
    
    if (indexPath.section == 0) {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TextCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            [cell.webViewQuestion loadHTMLString:selectedQuestion.stimulus baseURL:nil];
        } else if (indexPath.row == 1) {
            if ([selectedQuestion.stem isEqualToString:@""]) {
                cell.hidden = YES;
            }
            cell.lblText.text = selectedQuestion.stem;
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AnswerCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.lblAnswer.text = [(Answer *)answers[0] choice];
            cell.imvAnswer.image = [[UIImage imageNamed:kImage_AnswerA] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else if (indexPath.row == 1) {
            cell.lblAnswer.text = [(Answer *)answers[1] choice];
            cell.imvAnswer.image = [[UIImage imageNamed:kImage_AnswerB] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else if (indexPath.row == 2) {
            cell.lblAnswer.text = [(Answer *)answers[2] choice];
            cell.imvAnswer.image = [[UIImage imageNamed:kImage_AnswerC] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else if (indexPath.row == 3) {
            cell.lblAnswer.text = [(Answer *)answers[3] choice];
            cell.imvAnswer.image = [[UIImage imageNamed:kImage_AnswerD] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else if (indexPath.row == 4) {
            cell.lblAnswer.text = [(Answer *)answers[4] choice];
            cell.imvAnswer.image = [[UIImage imageNamed:kImage_AnswerE] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        answerCell = cell;
        return cell;
        
    } else return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return kHeighQuesionWebView;
    }
    else{
        return 60.0f;
    }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:tableView.indexPathForSelectedRow];
    
    [cell setSelected:YES];
    if(indexPath.section!=0){
        [self enableBtn];
    }
}

#pragma mark - webViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [webView sizeThatFits:CGSizeZero];
}

#pragma mark - Timer

-(void)startTimer{
    startDate = [NSDate date];
    timer = [NSTimer scheduledTimerWithTimeInterval:24/60 target:self selector:@selector(timeTick:) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)stopTimer;{
    [timer invalidate];
    timer = nil;
}

-(void)timeTick:(id)sender{
    [self updateProgressBar];
    //if(!isTimeRun) return;
    NSDate *currentDate =[NSDate date];
    NSTimeInterval timeInterval  = [currentDate timeIntervalSinceDate:startDate];
    //    NSLog(@"\nTIME INTERVAL: %f\n",timeInterval);
    //reformat time from TimeInterval
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc]init];
    [dateFomatter setDateFormat:@"mm:ss"];
    [dateFomatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    NSString *time = [dateFomatter stringFromDate:timerDate];
    
    customTitleView.lblQuestionNumber.text = [NSString stringWithFormat:@"%ld/%ld",_displayIndex+1,_questions.count];
    customTitleView.lblTime.text = [NSString stringWithFormat:@"%@",time];
}


#pragma mark - Class funtions

- (void)redisplayQuestion;
{
    [_tbvQuestion reloadData];
    //[self showRightAnswer];
}
-(void)updateProgressBar;{
    [self.progessBar setProgress:((float)_displayIndex + 1.0f)/(float)_questions.count];
    
}

- (void)configTableView;
{
    // UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kImage_TableQuestionPacksBackground]];
    //[backgroundView setFrame:self.tbvQuestion.frame];
    
    //self.tbvQuestion.backgroundView = backgroundView;
    self.progessBar.progressTintColor = kAppColor;
    self.tbvQuestion.tableFooterView = [[UIView alloc]init];
    
    _tbvQuestion.estimatedRowHeight = 60.0f;
    _tbvQuestion.rowHeight = UITableViewAutomaticDimension;
    
}
-(void)configView;{
    [self configTableView];
}

- (IBAction)btnSubmitDidTouch:(id)sender {
    [self disableBtn];
    
    if (_tbvQuestion.indexPathForSelectedRow) {
        if (_displayIndex < _questions.count - 1) {
            Question *question = _questions[_displayIndex];
            
            StudentAnswer *newStudentAnswer = [StudentAnswer createStudentAnswerWithChoiceIndex:_tbvQuestion.indexPathForSelectedRow.row andQuestion:question];
            [_studentAnwsers addObject:newStudentAnswer];
            
            if (_displayIndex == _questions.count - 2) {
                [_btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
            }
            
            [self redisplayQuestion];
            
            _displayIndex+=1;
            
        } else {
            [self stopTimer];
            
            Question *question = _questions[_displayIndex];
            
            StudentAnswer *newStudentAnswer = [StudentAnswer createStudentAnswerWithChoiceIndex:_tbvQuestion.indexPathForSelectedRow.row andQuestion:question];
            [_studentAnwsers addObject:newStudentAnswer];
            
//            QuickReviewViewController *quickReviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"quickReview"];
//            
//            quickReviewController.studentAnswers = _studentAnwsers;
//            quickReviewController.questions = _questions;
//            
//            quickReviewController.lblTime = customTitleView.lblTime.text;
//            
//            CATransition* transition = [CATransition animation];
//            transition.duration = 1.0f;
//            transition.type = kCATransitionMoveIn;
//            transition.subtype = kCATransitionFade;
//            [self.navigationController.view.layer addAnimation:transition
//                                                        forKey:kCATransition];
//            [self.navigationController pushViewController:quickReviewController animated:NO];
            
        }
    }
}
-(void)enableBtn;{
    _btnSubmit.alpha = 1.0f;
    _btnSubmit.enabled = YES;
  //  [self customButton];
}
-(void)disableBtn;{
    _btnSubmit.alpha = 0.5f;
    _btnSubmit.enabled = NO;
   // [self customButton];
}
-(void)customButton;{
    
    _btnSubmit.layer.cornerRadius = 10.0f;
    _btnSubmit.clipsToBounds = YES;
}
@end
