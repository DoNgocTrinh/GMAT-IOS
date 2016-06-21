//
//  QuestionViewController.m
//  GMAT
//
//  Created by Trung Đức on 4/9/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "QuestionViewController.h"
#import "ReadingViewController.h"
#import "QuickReviewViewController.h"
#import "CustomTitleView.h"

@interface QuestionViewController ()

@property(nonatomic, assign) NSInteger displayIndex;

@property (nonatomic, strong) NSMutableArray *studentAnwsers;

@end

@implementation QuestionViewController
{
    NSMutableArray *heights;
    
    CGFloat height;
    NSTimer *timer;
    NSDate *startDate;
    
    BOOL isTimeRun;
    //timer:
    NSDate *currentDate;// =[NSDate date];
    NSTimeInterval timeInterval;//  = [currentDate timeIntervalSinceDate:startDate];
    CGFloat startTimeInterval;
    NSDate *timerDate ; // = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFomatter;// = [[NSDateFormatter alloc]init];
    
    
    
    NSString *time ;//= [dateFomatter stringFromDate:timerDate];
    
    CustomTitleView *customTitleView;
    AnswerCell *answerCell;
    Question *selectQuestion;
    
    UIButton *button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _studentAnwsers = [[NSMutableArray alloc]init];
    startTimeInterval = [_currentPack.totalTimeToFinish floatValue];
    
    [self COUNTer];
    dateFomatter = [[NSDateFormatter alloc]init];
    [dateFomatter setDateFormat:@"mm:ss"];
    [dateFomatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    heights =[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],nil ];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //    [_tbvQuestion setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0)];
    //    [_tbvQuestion setScrollIndicatorInsets:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0)];
    //custom title view
    
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 44);
    customTitleView = [CustomTitleView customViewWithFrame:rect];
    [customTitleView setCenter:self.navigationItem.titleView.center];
    self.navigationItem.titleView = customTitleView;
    timerDate = [NSDate dateWithTimeIntervalSince1970:startTimeInterval];
    customTitleView.lblTime.text = [NSString stringWithFormat:@"%@", [dateFomatter stringFromDate:timerDate]];
    
    
    [_btnSubmit setBackgroundColor:kAppColor];
    
    [self configTableView];
    
    // self.navigationItem.hidesBackButton = YES;
    
    //_displayIndex = 0;
    [self redisplayQuestion];
    
    //[self startTimer];
    
    [self disableBtn];
    
    
    [self createReadingButton];
}
-(void)viewWillDisappear:(BOOL)animated{
    for(UIView *b in self.navigationController.view.subviews){
        if( [b isKindOfClass: [UIButton class]])
            [b removeFromSuperview];
    }
    [self stopTimer];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
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
    //sort order items in NSSet
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *answers = [[selectedQuestion.answers allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    static NSString *cellId = @"question";
    
    if (indexPath.section == 0) {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TextCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            //   NSLog(@"section : %ld row: %ld",indexPath.section, indexPath.row);
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell loadContentWithContent:selectedQuestion.stimulus questionType:selectedQuestion.type];
        cell.webViewQuestion.delegate = self;
        cell.webViewQuestion.tag = 0;
        // NSLog(@"Height update: %lf", height);
        //cell.webViewQuestion.scrollView.scrollEnabled = NO;
        if(![selectedQuestion.type isEqualToString:@"RC"])
        {
            cell.webViewQuestion.opaque = NO;
            cell.webViewQuestion.backgroundColor =[kAppColor colorWithAlphaComponent:.2];
        }
        return cell;
        
    }else if (indexPath.section == 1){
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
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
        
        NSString *htmlString  = @"";
        NSString *string = [NSString stringWithFormat:@" %@ %@", selectedQuestion.stem, htmlString];
        [cell.webViewQuestion loadHTMLString:string baseURL:nil];
        cell.webViewQuestion.delegate = self;
        cell.webViewQuestion.tag = 1;
        cell.webViewQuestion.opaque = NO;
        cell.webViewQuestion.backgroundColor =[kAppColor colorWithAlphaComponent:.2];
        return cell;
        
    }
    else if (indexPath.section == 2) {
        AnswerWVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AnswerWVCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell cellWithAnswer:(Answer *) answers[indexPath.row] questionType:selectedQuestion.type];
        
        cell.webViewAnswer.delegate = self;
        
        if(indexPath.row == 0){ cell.webViewAnswer.tag = 2;}
        if(indexPath.row == 1){ cell.webViewAnswer.tag = 3;}
        if(indexPath.row == 2){ cell.webViewAnswer.tag = 4;}
        if(indexPath.row == 3){ cell.webViewAnswer.tag = 5;}
        if(indexPath.row == 4){ cell.webViewAnswer.tag = 6;}
        
        return cell;
        
    } else return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        if([heights[0] floatValue] <= 0) return 100;
        if([heights[0] floatValue]>=500) return 158
            ;
        else
            return [heights[0] floatValue];
    }else
        if(indexPath.section ==1 ){
            //if([heights[1] floatValue] <= 0) return 100;
            if ([heights[1]floatValue]<=8) {
                return 0;
            } else{
                return [heights[1]floatValue];
            }
        }
        else{
            if([heights[indexPath.row + indexPath.section] floatValue] <=0)
                return 44;
            if(indexPath.row+indexPath.section < heights.count)
                // NSLog(@"%lu", (unsigned long)heights.count);
                //;
                return [heights[indexPath.row + indexPath.section] floatValue];
            else{
                return 0;
            }
        }
    //NSLog(@"height count: %ld",heights.count);
    //    if(indexPath.section == 0) return height;
    //    else
    // return 60;
}- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.05;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView * footerview = (UITableViewHeaderFooterView *)view;
    footerview.contentView.backgroundColor = [UIColor lightGrayColor];
}
#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    //
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:tableView.indexPathForSelectedRow];
    //
    //    if([cell isKindOfClass:[AnswerWVCell class]]){
    //        //  NSLog(@"%ld" ,(long)[(TextCell*)cell webViewQuestion].tag);
    //    }
    //[cell setSelected:YES];
    if(indexPath.section!=0&&indexPath.section!=1){
        [self enableBtn];
    }
    else{
        [self disableBtn];
    }
}

#pragma mark - webViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    selectQuestion = _questions[_displayIndex];
    
    if([heights[webView.tag] floatValue] != 0){
        return;
    }
    height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    heights[webView.tag] = [NSNumber numberWithFloat:height];
    //NSLog(@"tag : %ld - %lf", webView.tag, height);
    //[UIWebView animateWithDuration:0.2 animations:^{
    [_tbvQuestion beginUpdates];
    //        switch (webView.tag) {
    //            case 0:
    //                // webView.scrollView.scrollEnabled = YES;
    //                //
    //                [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:0] ]withRowAnimation:UITableViewRowAnimationNone];
    //                break;
    //            case 1:
    //                webView.userInteractionEnabled = YES;
    //                [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:1] ]withRowAnimation:UITableViewRowAnimationNone];
    //                break;
    //            case 2:
    //                //            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
    //                //            break;
    //            case 3:
    //                //            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:1 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
    //                //            break;
    //            case 4:
    //                //            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:2 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
    //                //            break;
    //            case 5:
    //                //            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:3 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
    //                //            break;
    //            case 6:
    //                [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:webView.tag-2 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
    //                break;
    //
    //            default:
    //                break;
    //        }
    [_tbvQuestion endUpdates];
    //  }];
}

#pragma mark - Timer

-(void)startTimer{
    startDate = [NSDate date];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeTick:) userInfo:nil repeats:YES];
    
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //NSLog(@"total time : %lf", );
    [timer fire];
}
-(void)stopTimer;{
    [timer invalidate];
    timer = nil;
}

-(void)timeTick:(id)sender{
    [self updateProgressBar];
    currentDate =[[NSDate date] dateByAddingTimeInterval:startTimeInterval];
    timeInterval  = [currentDate timeIntervalSinceDate:startDate];
    //reformat time from TimeInterval
    //NSLog(@"Time interval : %f", timeInterval);
    timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    time = [dateFomatter stringFromDate:timerDate];
    customTitleView.lblQuestionNumber.text = [NSString stringWithFormat:@"%ldd/%ld",_displayIndex+1,(unsigned long)_questions.count];
    customTitleView.lblTime.text = [NSString stringWithFormat:@"%@",time];
    
    _currentPack.totalTimeToFinish = [NSNumber numberWithDouble:timeInterval];
}


#pragma mark - Class funtions

- (void)redisplayQuestion;
{       selectQuestion = _questions[_displayIndex];
    
    heights =[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],nil ];
    customTitleView.lblQuestionNumber.text = [NSString stringWithFormat:@"%ld/%ld",_displayIndex+1,(unsigned long)_questions.count];
    
    [_tbvQuestion reloadData];
}
-(void)updateProgressBar;{
    [self.progessBar setProgress:((float)_displayIndex + 1.0f)/(float)_questions.count];
}

- (void)configTableView;
{
    self.progessBar.progressTintColor = kAppColor;
    self.tbvQuestion.tableFooterView = [[UIView alloc]init];
    _tbvQuestion.estimatedRowHeight = 44.0f;
    _tbvQuestion.rowHeight = UITableViewAutomaticDimension;
    
}
-(void)configView;{
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    [self configTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (IBAction)btnSubmitDidTouch:(id)sender {
    [self disableBtn];
    if (_tbvQuestion.indexPathForSelectedRow) {
        if (_displayIndex < _questions.count - 1) {
            Question *question = _questions[_displayIndex];
            selectQuestion = question;
            
            StudentAnswer *newStudentAnswer = [StudentAnswer createStudentAnswerWithChoiceIndex:_tbvQuestion.indexPathForSelectedRow.row andQuestion:question];
            [_studentAnwsers addObject:newStudentAnswer];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
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
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            QuickReviewViewController *quickReviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickReviewViewController"];
            
            quickReviewController.studentAnswers = _studentAnwsers;
            quickReviewController.questions = _questions;
            
            quickReviewController.lblTime = customTitleView.lblTime.text;
            
            CATransition* transition = [CATransition animation];
            transition.duration = 1.0f;
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFade;
            [self.navigationController.view.layer addAnimation:transition
                                                        forKey:kCATransition];
            [self.navigationController pushViewController:quickReviewController animated:NO];
            
            
        }
   
            _currentPack.totalTimeToFinish = [NSNumber numberWithDouble:timeInterval];
            [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    button.alpha = 0.25;
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
    
    // [button setTitle:@"Reading" forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 60.0, 60.0);
    UIImage *buttonBackground = [UIImage imageNamed:@"openReading.png"];
    [button setImage:buttonBackground forState:UIControlStateNormal];
    //button.titleLabel.text = @"Reading";
    button.titleLabel.tintColor = [UIColor whiteColor];
    button.center = self.view.center;
    button.layer.cornerRadius = 20;
    [button addTarget:self
               action:@selector(presentViewReading)
     forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:4 animations:^{
        button.center = CGPointMake(self.view.frame.size.width-button.frame.size.width/2 - 4, self.view.frame.size.height-button.frame.size.height/2);
        button.alpha = 0.25;
    }];
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
        if(button_.center.y<self.view.frame.size.height/8){ // button over top
            [UIView animateWithDuration:0.2 animations:^{
                button_.center = CGPointMake(button_.center.x, button_.frame.size.height);
            }];
        }else if(button_.center.y>self.view.frame.size.height*7/8){ // button over bottom
            [UIView animateWithDuration:0.2 animations:^{
                button_.center = CGPointMake(button_.center.x, self.view.frame.size.height + button.frame.size.height/2);
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
    button.alpha = 1;
    
}

-(void)presentViewReading;{
    ReadingViewController *readingView =  [[ReadingViewController alloc] initWithNibName:@"ReadingViewController" bundle:nil];
    readingView.content = selectQuestion.stimulus;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    if(!(self.childViewControllers.count>0)){
        
        button.alpha = 1;
        UIImage *buttonBackground = [UIImage imageNamed:@"closeReading.png"];
        [button setImage:buttonBackground forState:UIControlStateNormal];
        
        [self addChildViewController:readingView];
        readingView.view.frame = self.view.bounds;
        [self.view addSubview:readingView.view];
        [readingView didMoveToParentViewController:self];
    }
    else{
        UIImage *buttonBackground = [UIImage imageNamed:@"openReading.png"];
        [button setImage:buttonBackground forState:UIControlStateNormal];
        for (UIViewController *rv in self.childViewControllers) {
            if([rv isKindOfClass:[ReadingViewController class]]){
                [rv.view setHidden: YES];
                [rv removeFromParentViewController];
                //NSLog(@"count view child : %lu", (unsigned long)self.childViewControllers.count);
            }
        }
    }
}
#pragma mark - AlertView - Start Pack
-(void)COUNTer;{
    Question *newQuestion = _questions[_displayIndex];
    NSPredicate *querry = [NSPredicate predicateWithFormat:@"questions CONTAINS %@", newQuestion];
    QuestionPack *testQuestionPack =[QuestionPack MR_findFirstWithPredicate:querry];
    NSInteger i = 0;
    if(testQuestionPack){
        NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"questionId" ascending:YES];
        NSArray *tquestions = [[testQuestionPack.questions allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
        for(Question *q in tquestions){
            if(q.studentAnswer){
                [_studentAnwsers addObject:q.studentAnswer];
                NSLog(@"Student answer for QUestion : %@", q.studentAnswer.result);
                i++;
            }
        }
        
        if(i<10){
            _displayIndex = i;
            //[_tbvQuestion reloadData];
        }
        else{
            _displayIndex = i-1;
            //  NSLog(@"-------- %d",_studentAnwsers.count );
            
            
        }
        if([_currentPack.totalTimeToFinish floatValue]!= 0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Do Again" message:@"You did this pack"  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Start over",@"Continue",@"Review", nil];
            [self.view addSubview:alert];
            [alert show];
            [self stopTimer];
        }else{
            [self startTimer];
        }
        //  NSLog(@"COUNT SA %d", i);
    }
    else{
        NSLog(@"Have you any choice?");
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:// cancel
            [self.navigationController popViewControllerAnimated:YES];
            [self startTimer];
            break;
        case 1://start Over
        {
            Question *newQuestion = _questions[_displayIndex];
            NSPredicate *querry = [NSPredicate predicateWithFormat:@"questions CONTAINS %@", newQuestion];
            QuestionPack *testQuestionPack =[QuestionPack MR_findFirstWithPredicate:querry];
            if(testQuestionPack){
                NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"questionId" ascending:YES];
                NSArray *tquestions = [[testQuestionPack.questions allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
                for (Question *q in tquestions) {
                    NSPredicate *que = [NSPredicate predicateWithFormat:@"question = %@", q];
                    [StudentAnswer MR_deleteAllMatchingPredicate:que];
                    NSLog(@"Number of SA which you have deleted : %ld", (unsigned long)[StudentAnswer MR_countOfEntities]);
                }
                
                _currentPack.totalTimeToFinish = [NSNumber numberWithDouble:0];
                [_studentAnwsers removeAllObjects];
                startTimeInterval = 0;
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
            
            _displayIndex = 0;
            [self redisplayQuestion];
            [self stopTimer];
            [self startTimer];
        }
            
            break;
        case 2://continue
        {
            [self startTimer];
        }
            break;
        case 3: //review
        {
            QuickReviewViewController *quickReviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickReviewViewController"];
            
            quickReviewController.studentAnswers = _studentAnwsers;
            quickReviewController.questions = [[NSMutableArray alloc]init];
            //add questions
            Question *newQuestion = _questions[_displayIndex];
            NSPredicate *querry = [NSPredicate predicateWithFormat:@"questions CONTAINS %@", newQuestion];
            QuestionPack *testQuestionPack =[QuestionPack MR_findFirstWithPredicate:querry];
            if(testQuestionPack){
                for (Question *q in testQuestionPack.questions) {
                    NSPredicate *que = [NSPredicate predicateWithFormat:@"question = %@", q];
                    
                    if( [StudentAnswer MR_countOfEntitiesWithPredicate:que] !=0){
                        [quickReviewController.questions addObject:q];
                    }
                }
            }
            //quickReviewController.questions = _questions;
            
            quickReviewController.lblTime = [NSString stringWithFormat:@"%lf",[_currentPack.totalTimeToFinish floatValue]];
            
            CATransition* transition = [CATransition animation];
            transition.duration = 1.0f;
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFade;
            [self.navigationController.view.layer addAnimation:transition
                                                        forKey:kCATransition];
            
            NSLog(@"_studentcount : %ld",_studentAnwsers.count);
            [self.navigationController pushViewController:quickReviewController animated:NO];
        }
            break;
        default:
            
            break;
    }
}
@end