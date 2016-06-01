//
//  QuestionViewController.m
//  GMAT
//
//  Created by Trung Đức on 4/9/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "QuestionViewController.h"
#import "ReadingViewController.h"
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
    Question *selectQuestion;
    UIButton *button;
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
    
    [self createReadingButton];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 5;
            break;
        default:
            return 0;
            break;
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
        
    }else if (indexPath.section == 1){
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        //
        for(UIView *b in self.navigationController.view.subviews){
            if( [b isKindOfClass: [UIButton class]])
                [b removeFromSuperview];
        }
        
        if([selectedQuestion.type isEqualToString:@"RC"]){
            
            button.userInteractionEnabled = YES;
            
            UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(buttonDrag:)];
            [button addGestureRecognizer:gesture];
            
            
            [self.navigationController.view addSubview:button];
        }
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TextCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.webViewQuestion setBackgroundColor:[UIColor grayColor]];
        [cell.webViewQuestion setOpaque:NO];
        
        [cell.webViewQuestion loadHTMLString:selectedQuestion.stem baseURL:nil];
        return cell;
        
    }
    else if (indexPath.section == 2) {
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
    selectQuestion = _questions[_displayIndex];
    //NSLog(@"Question type: %@ - %ld", selectQuestion.type , _displayIndex+1);
    //NSLog(@"asdas + %ld %@", _displayIndex+1, typeQuestion);
#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT
    
    SWITCH (selectQuestion.type) {
        CASE (@"SC") {
            if(indexPath.section == 0){
                return kHeighQuesionWebView;
            }
            if(indexPath.section == 1){
                return 0;
            }
            else{
                return 60.0f;
            }
            break;
        }
        CASE (@"RC") {
            if(indexPath.section == 0){
                return 0;
            }
            if(indexPath.section == 1){
                return kHeighQuesionWebView;
            }
            else{
                return 60.0f;
            }
            break;
        }
        DEFAULT {
            if(indexPath.section == 0){
                return kHeighQuesionWebView;
            }
            if(indexPath.section == 1){
                return 0;
            }
            else{
                return 60.0f;
            }
            break;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView * footerview = (UITableViewHeaderFooterView *)view;
    footerview.contentView.backgroundColor = [UIColor lightGrayColor];
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
    NSDate *currentDate =[NSDate date];
    NSTimeInterval timeInterval  = [currentDate timeIntervalSinceDate:startDate];
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
    selectQuestion = _questions[_displayIndex];
    [_tbvQuestion reloadData];
    //[self showRightAnswer];
}
-(void)updateProgressBar;{
    [self.progessBar setProgress:((float)_displayIndex + 1.0f)/(float)_questions.count];
}

- (void)configTableView;
{
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
            selectQuestion = question;
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
            
        }
    }
}
-(void)enableBtn;{
    _btnSubmit.alpha = 1.0f;
    _btnSubmit.enabled = YES;
    // [self customButton];
}
-(void)disableBtn;{
    _btnSubmit.alpha = 0.5f;
    _btnSubmit.enabled = NO;
    //[self customButton];
}
-(void)customButton;{
    
    _btnSubmit.layer.cornerRadius = 10.0f;
    _btnSubmit.clipsToBounds = YES;
    
}
-(void)createReadingButton;{
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(presentViewReading)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Reading" forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 80.0, 40.0);
    //button.titleLabel.text = @"Reading";
    button.titleLabel.tintColor = [UIColor whiteColor];
    button.center = self.view.center;
    button.layer.cornerRadius = 2;//button.bounds.size.width/2;
    button.backgroundColor = [UIColor redColor];
    
    
    button.layer.shadowColor = [UIColor redColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0.0f,2.0f);
    button.layer.masksToBounds = NO;
    button.layer.shadowRadius = 0.0f;
    button.layer.shadowOpacity = 0.5;
}
-(void)buttonDePressed;{
    button.layer.opacity = 1;//.5;
}
-(void)buttonPressed;{
    button.layer.opacity = 1;
}
- (void)buttonDrag:(UIPanGestureRecognizer *)gesture
{
    UIButton *button_ = (UIButton *)gesture.view;
    CGPoint translation = [gesture translationInView:button_];
    
    // move button
    button_.center = CGPointMake(button_.center.x + translation.x,
                                 button_.center.y + translation.y);

    if( gesture.state == UIGestureRecognizerStateEnded){
        if(button_.center.y<self.view.frame.size.height/8){
            [UIView animateWithDuration:0.2 animations:^{
                button_.center = CGPointMake(button_.center.x, button_.frame.size.height);
            }];
        }else if(button_.center.y>self.view.frame.size.height*7/8){
            [UIView animateWithDuration:0.2 animations:^{
                button_.center = CGPointMake(button_.center.x, self.view.frame.size.height);
            }];
        }
        if(self.view.center.x<button_.center.x) {
            [UIView animateWithDuration:0.2 animations:^{
                button_.center = CGPointMake(self.view.frame.size.width-button_.frame.size.width/2 - 4, button_.center.y);
            }];
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                button_.center = CGPointMake(button_.frame.size.width/2 + 4, button_.center.y);
            }];
        }
    }
    // reset translation
    [gesture setTranslation:CGPointZero inView:button_];

}

-(void)presentViewReading;{
    ReadingViewController *readingView =  [[ReadingViewController alloc] initWithNibName:@"ReadingViewController" bundle:nil];
    readingView.content = selectQuestion.stimulus;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    if(self.childViewControllers.count<=0){
        [self addChildViewController:readingView];
        readingView.view.frame = self.view.bounds;
        [self.view addSubview:readingView.view];
        [readingView didMoveToParentViewController:self];
    }
    else{
        for (UIViewController *rv in self.childViewControllers) {
            if([rv isKindOfClass:[ReadingViewController class]]){
                NSLog(@"asdas");
                [rv.view setHidden: YES];
                [rv removeFromParentViewController];
                NSLog(@"count view child : %lu", (unsigned long)self.childViewControllers.count);
            }
        }
    }
}

@end
