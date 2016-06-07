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
{NSMutableArray *heights;
    NSMutableArray *cellList;
    
    NSArray *array;
    
    CGFloat height;
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
    
    heights = [[NSMutableArray alloc]init];
    cellList = [[NSMutableArray alloc]init];
    
    
    heights =[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],nil ];
    NSLog(@"hihi :  %lf", [heights[6] floatValue]);
    self.navigationController.navigationBar.translucent = NO;
    
    //    [_tbvQuestion setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0)];
    //    [_tbvQuestion setScrollIndicatorInsets:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0)];
    
    _studentAnwsers = [[NSMutableArray alloc]init];
    
    [_btnSubmit setBackgroundColor:kAppColor];
    
    [self configTableView];
    
   // self.navigationItem.hidesBackButton = YES;
    
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
    //sort order items in NSSet
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *answers = [[selectedQuestion.answers allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];    static NSString *cellId = @"question";
    
    if (indexPath.section == 0) {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TextCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            //   NSLog(@"section : %ld row: %ld",indexPath.section, indexPath.row);
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            [cell loadContentWithContent: selectedQuestion.stimulus];
        } else if (indexPath.row == 1) {
            if ([selectedQuestion.stem isEqualToString:@""]) {
                cell.hidden = YES;
            }
            cell.lblText.text = selectedQuestion.stem;
        }
        cell.webViewQuestion.delegate = self;
        cell.webViewQuestion.tag = 0;
        // NSLog(@"Height update: %lf", height);
        cell.webViewQuestion.scrollView.scrollEnabled = NO;
        
        if(cellList.count < 2){
            NSDictionary *dict = @{@"index": [NSNumber numberWithInteger:indexPath.row] , @"section": [NSNumber numberWithInteger: indexPath.section]};
            [cellList addObject:dict];
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
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return [heights[0] floatValue];
    }else
        if(indexPath.section ==1 ){
            if ([heights[1]floatValue]<=8) {
                return 0;
            } else{
                return [heights[1]floatValue];
            }
        }
        else{
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:tableView.indexPathForSelectedRow];
    
    if([cell isKindOfClass:[TextCell class]]){
        NSLog(@"%ld" ,(long)[(TextCell*)cell webViewQuestion].tag);
    }
    
    //[cell setSelected:YES];
    if(indexPath.section!=0&&indexPath.section!=1){
        [self enableBtn];
    }
    else{
        cell.selected = NO;
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
    NSLog(@"tag : %ld - %lf", webView.tag, height);
    switch (webView.tag) {
        case 0:
            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:0] ]withRowAnimation:UITableViewRowAnimationNone];
            break;
        case 1:
            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:1] ]withRowAnimation:UITableViewRowAnimationNone];
            break;
        case 2:
            //            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
            //            break;
        case 3:
            //            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:1 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
            //            break;
        case 4:
            //            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:2 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
            //            break;
        case 5:
            //            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:3 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
            //            break;
        case 6:
            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:webView.tag-2 inSection:2] ]withRowAnimation:UITableViewRowAnimationMiddle];
            break;
            
        default:
            break;
    }
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
    [_progessBar removeFromSuperview];
    [_progessBar setFrame: CGRectMake(0, customTitleView.frame.origin.y, customTitleView.frame.size.width, customTitleView.frame.size.height)];
    customTitleView.lblQuestionNumber.text = [NSString stringWithFormat:@"%ld/%ld",_displayIndex+1,(unsigned long)_questions.count];
    customTitleView.lblTime.text = [NSString stringWithFormat:@"%@",time];
}


#pragma mark - Class funtions

- (void)redisplayQuestion;
{       selectQuestion = _questions[_displayIndex];
    [_tbvQuestion reloadData];
    heights =[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],nil ];
}
-(void)updateProgressBar;{
    [self.progessBar setProgress:((float)_displayIndex + 1.0f)/(float)_questions.count];
}

- (void)configTableView;
{
    self.progessBar.progressTintColor = kAppColor;
    self.tbvQuestion.tableFooterView = [[UIView alloc]init];
    _tbvQuestion.estimatedRowHeight = 44.0f;
    // _tbvQuestion.rowHeight = UITableViewAutomaticDimension;
    
}
-(void)configView;{
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
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
    UIImage *buttonBackground = [UIImage imageNamed:@"reading.png"];
    [button addTarget:self
               action:@selector(presentViewReading)
     forControlEvents:UIControlEventTouchUpInside];
    // [button setTitle:@"Reading" forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 60.0, 60.0);
    [button setImage:buttonBackground forState:UIControlStateNormal];
    //button.titleLabel.text = @"Reading";
    button.titleLabel.tintColor = [UIColor whiteColor];
    button.center = self.view.center;
    button.layer.cornerRadius = 20;//button.bounds.size.width/2;
    //button.backgroundColor = [UIColor redColor];
    //    button.layer.shadowColor = [UIColor redColor].CGColor;
    //    button.layer.shadowOffset = CGSizeMake(0.0f,2.0f);
    //    button.layer.masksToBounds = NO;
    //    button.layer.shadowRadius = 0.0f;
    //    button.layer.shadowOpacity = 0.5;
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
    if(self.childViewControllers.count<=0){
        button.alpha = 1;
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
                //NSLog(@"count view child : %lu", (unsigned long)self.childViewControllers.count);
            }
        }
    }
}

@end

////  QuestionViewController.m
////  GMAT
////
////  Created by Trung Đức on 4/9/16.
////  Copyright © 2016 Trung Đức. All rights reserved.
////
//
//#import "QuestionViewController.h"
//#import "ReadingViewController.h"
////#import "QuickReviewViewController.h"
//#import "CustomTitleView.h"
//
//@interface QuestionViewController ()
//
//@property(nonatomic, assign) NSInteger displayIndex;
//
//@property (nonatomic, strong) NSMutableArray *studentAnwsers;
//
//@end
//
//@implementation QuestionViewController
//{NSMutableArray *heights;
//    float heightList[7];
//    NSMutableArray *cellList;
//    
//    NSArray *array;
//    
//    CGFloat height;
//    NSTimer *timer;
//    NSDate *startDate;
//    BOOL isTimeRun;
//    CustomTitleView *customTitleView;
//    AnswerCell *answerCell;
//    Question *selectQuestion;
//    UIButton *button;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    heights = [[NSMutableArray alloc]init];
//    cellList = [[NSMutableArray alloc]init];
//    
//    
//    heights =[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],nil ];
//    NSLog(@"hihi :  %lf", [heights[6] floatValue]);
//    self.navigationController.navigationBar.translucent = NO;
//    
//    //    [_tbvQuestion setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0)];
//    //    [_tbvQuestion setScrollIndicatorInsets:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, 0, 0)];
//    
//    _studentAnwsers = [[NSMutableArray alloc]init];
//    
//    [_btnSubmit setBackgroundColor:kAppColor];
//    
//    [self configTableView];
//    
//    // self.navigationItem.hidesBackButton = YES;
//    
//    _displayIndex = 0;
//    [self redisplayQuestion];
//    
//    [self startTimer];
//    
//    [self disableBtn];
//    
//    //custom title view
//    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 44);
//    customTitleView = [CustomTitleView customViewWithFrame:rect];
//    [customTitleView setCenter:self.navigationItem.titleView.center];
//    self.navigationItem.titleView = customTitleView;
//    
//    [self createReadingButton];
//}
//
//- (void) showRightAnswer; {
//    Question *selectedQuestion = _questions[_displayIndex];
//    NSLog(@"Right answer : %@", selectedQuestion.rightAnswerIdx);
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//#pragma mark - TableView Datasource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return 1;
//            break;
//        case 1:
//            return 1;
//            break;
//        case 2:
//            return 5;
//            break;
//        default:
//            return 0;
//            break;
//    }
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    Question *selectedQuestion = _questions[_displayIndex];
//    //sort order items in NSSet
//    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
//    NSArray *answers = [[selectedQuestion.answers allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];    static NSString *cellId = @"question";
//    
//    if (indexPath.section == 0) {
//        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        
//        if (!cell) {
//            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TextCell" owner:self options:nil];
//            cell = [nib objectAtIndex:0];
//        }
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        if (indexPath.row == 0) {
//            [cell loadContentWithContent: selectedQuestion.stimulus];
//        } else if (indexPath.row == 1) {
//            if ([selectedQuestion.stem isEqualToString:@""]) {
//                cell.hidden = YES;
//            }
//            cell.lblText.text = selectedQuestion.stem;
//        }
//        cell.webViewQuestion.delegate = self;
//        cell.webViewQuestion.tag = 0;
//        cell.webViewQuestion.scrollView.scrollEnabled = NO;
//        
//        return cell;
//        
//    }else if (indexPath.section == 1){
//        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//       
//        for(UIView *b in self.navigationController.view.subviews){
//            if( [b isKindOfClass: [UIButton class]])
//                [b removeFromSuperview];
//        }
//        
//        if([selectedQuestion.type isEqualToString:@"RC"]){
//            
//            button.userInteractionEnabled = YES;
//            
//            UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
//                                               initWithTarget:self
//                                               action:@selector(buttonDrag:)];
//            [button addGestureRecognizer:gesture];
//            
//            [self.navigationController.view addSubview:button];
//        }
//        
//        if (!cell) {
//            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TextCell" owner:self options:nil];
//            cell = [nib objectAtIndex:0];
//        }
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        NSString *htmlString  = @"";
//        NSString *string = [NSString stringWithFormat:@" %@ %@", selectedQuestion.stem, htmlString];
//        [cell.webViewQuestion loadHTMLString:string baseURL:nil];
//        cell.webViewQuestion.delegate = self;
//        cell.webViewQuestion.tag = 1;
//        return cell;
//        
//    }
//    else if (indexPath.section == 2) {
//        AnswerWVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if (!cell) {
//            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AnswerWVCell" owner:self options:nil];
//            cell = [nib objectAtIndex:0];
//        }
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        [cell cellWithAnswer:(Answer *) answers[indexPath.row] questionType:selectedQuestion.type];
//        
//        cell.webViewAnswer.delegate = self;
//        
//        if(indexPath.row == 0){ cell.webViewAnswer.tag = 2;}
//        if(indexPath.row == 1){ cell.webViewAnswer.tag = 3;}
//        if(indexPath.row == 2){ cell.webViewAnswer.tag = 4;}
//        if(indexPath.row == 3){ cell.webViewAnswer.tag = 5;}
//        if(indexPath.row == 4){ cell.webViewAnswer.tag = 6;}
//        
//        return cell;
//        
//    } else return nil;
//    
//}
////- (void)webViewDidFinishLoad:(UIWebView *)webView{
////
////}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section == 0){
//        return [heights[0] floatValue];
//    }else
//        if(indexPath.section ==1 ){
//            if ([heights[1]floatValue]<=8) {
//                return 0;
//            } else{
//            return [heights[1]floatValue];
//            }
//        }
//        else{
//            if(indexPath.row+indexPath.section < heights.count)
//                // NSLog(@"%lu", (unsigned long)heights.count);
//                //;
//                return [heights[indexPath.row + indexPath.section] floatValue];
//            else{
//                return 0;
//            }
//        }
//    //NSLog(@"height count: %ld",heights.count);
//    //    if(indexPath.section == 0) return height;
//    //    else
//    // return 60;
//}- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.05;
//}
//-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
//    UITableViewHeaderFooterView * footerview = (UITableViewHeaderFooterView *)view;
//    footerview.contentView.backgroundColor = [UIColor lightGrayColor];
//}
//#pragma mark - TableView Delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:tableView.indexPathForSelectedRow];
//    
//    if([cell isKindOfClass:[TextCell class]]){
//        NSLog(@"%ld" ,(long)[(TextCell*)cell webViewQuestion].tag);
//    }
//    
//    //[cell setSelected:YES];
//    if(indexPath.section!=0&&indexPath.section!=1){
//        [self enableBtn];
//    }
//    else{
//        cell.selected = NO;
//    }
//}
//
//#pragma mark - webViewDelegate
//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    selectQuestion = _questions[_displayIndex];
//    
//    if([heights[webView.tag] floatValue] != 0){
//        return;
//    }
//    height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
//    heights[webView.tag] = [NSNumber numberWithFloat:height];
//    NSLog(@"tag : %ld - %lf", webView.tag, height);
//    switch (webView.tag) {
//        case 0:
//            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:0] ]withRowAnimation:UITableViewRowAnimationNone];
//            break;
//        case 1:
//            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:1] ]withRowAnimation:UITableViewRowAnimationNone];
//            break;
//        case 2:
////            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
////            break;
//        case 3:
////            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:1 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
////            break;
//        case 4:
////            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:2 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
////            break;
//        case 5:
////            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:3 inSection:2] ]withRowAnimation:UITableViewRowAnimationNone];
////            break;
//        case 6:
//            [_tbvQuestion reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:webView.tag-2 inSection:2] ]withRowAnimation:UITableViewRowAnimationMiddle];
//            break;
//            
//        default:
//            break;
//    }
//}
//
//#pragma mark - Timer
//
//-(void)startTimer{
//    startDate = [NSDate date];
//    timer = [NSTimer scheduledTimerWithTimeInterval:24/60 target:self selector:@selector(timeTick:) userInfo:nil repeats:YES];
//    [timer fire];
//}
//-(void)stopTimer;{
//    [timer invalidate];
//    timer = nil;
//}
//
//-(void)timeTick:(id)sender{
//    [self updateProgressBar];
//    NSDate *currentDate =[NSDate date];
//    NSTimeInterval timeInterval  = [currentDate timeIntervalSinceDate:startDate];
//    //reformat time from TimeInterval
//    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc]init];
//    [dateFomatter setDateFormat:@"mm:ss"];
//    [dateFomatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//    
//    NSString *time = [dateFomatter stringFromDate:timerDate];
//    [_progessBar removeFromSuperview];
//    [_progessBar setFrame: CGRectMake(0, customTitleView.frame.origin.y, customTitleView.frame.size.width, customTitleView.frame.size.height)];
//    customTitleView.lblQuestionNumber.text = [NSString stringWithFormat:@"%ld/%ld",_displayIndex+1,(unsigned long)_questions.count];
//    customTitleView.lblTime.text = [NSString stringWithFormat:@"%@",time];
//}
//
//
//#pragma mark - Class funtions
//
//- (void)redisplayQuestion;
//{       selectQuestion = _questions[_displayIndex];
//    [_tbvQuestion reloadData];
//    heights =[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],
//              [NSNumber numberWithFloat:0],nil ];
//}
//-(void)updateProgressBar;{
//    [self.progessBar setProgress:((float)_displayIndex + 1.0f)/(float)_questions.count];
//}
//
//- (void)configTableView;
//{
//    self.progessBar.progressTintColor = kAppColor;
//    self.tbvQuestion.tableFooterView = [[UIView alloc]init];
//    _tbvQuestion.estimatedRowHeight = 44.0f;
//    // _tbvQuestion.rowHeight = UITableViewAutomaticDimension;
//    
//}
//-(void)configView;{
//    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
//    [self configTableView];
//}
//
//- (IBAction)btnSubmitDidTouch:(id)sender {
//    [self disableBtn];
//    if (_tbvQuestion.indexPathForSelectedRow) {
//        if (_displayIndex < _questions.count - 1) {
//            Question *question = _questions[_displayIndex];
//            selectQuestion = question;
//            StudentAnswer *newStudentAnswer = [StudentAnswer createStudentAnswerWithChoiceIndex:_tbvQuestion.indexPathForSelectedRow.row andQuestion:question];
//            [_studentAnwsers addObject:newStudentAnswer];
//            
//            if (_displayIndex == _questions.count - 2) {
//                [_btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
//            }
//            
//            [self redisplayQuestion];
//            
//            _displayIndex+=1;
//            
//        } else {
//            [self stopTimer];
//            
//            Question *question = _questions[_displayIndex];
//            
//            StudentAnswer *newStudentAnswer = [StudentAnswer createStudentAnswerWithChoiceIndex:_tbvQuestion.indexPathForSelectedRow.row andQuestion:question];
//            [_studentAnwsers addObject:newStudentAnswer];
//            
//        }
//    }
//}
//-(void)enableBtn;{
//    _btnSubmit.alpha = 1.0f;
//    _btnSubmit.enabled = YES;
//    // [self customButton];
//}
//-(void)disableBtn;{
//    _btnSubmit.alpha = 0.5f;
//    _btnSubmit.enabled = NO;
//    //[self customButton];
//}
//-(void)customButton;{
//    
//    _btnSubmit.layer.cornerRadius = 10.0f;
//    _btnSubmit.clipsToBounds = YES;
//    
//}
//-(void)createReadingButton;{
//    
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button addTarget:self
//               action:@selector(presentViewReading)
//     forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:@"Reading" forState:UIControlStateNormal];
//    button.frame = CGRectMake(0,0, 80.0, 40.0);
//    //button.titleLabel.text = @"Reading";
//    button.titleLabel.tintColor = [UIColor whiteColor];
//    button.center = self.view.center;
//    button.layer.cornerRadius = 2;//button.bounds.size.width/2;
//    button.backgroundColor = [UIColor redColor];
//    button.layer.shadowColor = [UIColor redColor].CGColor;
//    button.layer.shadowOffset = CGSizeMake(0.0f,2.0f);
//    button.layer.masksToBounds = NO;
//    button.layer.shadowRadius = 0.0f;
//    button.layer.shadowOpacity = 0.5;
//}
//-(void)buttonDePressed;{
//    button.layer.opacity = 1;//.5;
//}
//-(void)buttonPressed;{
//    button.layer.opacity = 1;
//}
//- (void)buttonDrag:(UIPanGestureRecognizer *)gesture
//{
//    UIButton *button_ = (UIButton *)gesture.view;
//    CGPoint translation = [gesture translationInView:button_];
//    
//    // move button
//    button_.center = CGPointMake(button_.center.x + translation.x,
//                                 button_.center.y + translation.y);
//    
//    if( gesture.state == UIGestureRecognizerStateEnded){
//        if(button_.center.y<self.view.frame.size.height/8){
//            [UIView animateWithDuration:0.2 animations:^{
//                button_.center = CGPointMake(button_.center.x, button_.frame.size.height);
//            }];
//        }else if(button_.center.y>self.view.frame.size.height*7/8){
//            [UIView animateWithDuration:0.2 animations:^{
//                button_.center = CGPointMake(button_.center.x, self.view.frame.size.height);
//            }];
//        }
//        if(self.view.center.x<button_.center.x) {
//            [UIView animateWithDuration:0.2 animations:^{
//                button_.center = CGPointMake(self.view.frame.size.width-button_.frame.size.width/2 - 4, button_.center.y);
//            }];
//        }
//        else{
//            [UIView animateWithDuration:0.2 animations:^{
//                button_.center = CGPointMake(button_.frame.size.width/2 + 4, button_.center.y);
//            }];
//        }
//    }
//    // reset translation
//    [gesture setTranslation:CGPointZero inView:button_];
//    
//}
//
//-(void)presentViewReading;{
//    ReadingViewController *readingView =  [[ReadingViewController alloc] initWithNibName:@"ReadingViewController" bundle:nil];
//    readingView.content = selectQuestion.stimulus;
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.type = kCATransitionFade;
//    transition.subtype = kCATransitionFromTop;
//    [self.view.window.layer addAnimation:transition forKey:kCATransition];
//    if(self.childViewControllers.count<=0){
//        [self addChildViewController:readingView];
//        readingView.view.frame = self.view.bounds;
//        [self.view addSubview:readingView.view];
//        [readingView didMoveToParentViewController:self];
//    }
//    else{
//        for (UIViewController *rv in self.childViewControllers) {
//            if([rv isKindOfClass:[ReadingViewController class]]){
//                NSLog(@"asdas");
//                [rv.view setHidden: YES];
//                [rv removeFromParentViewController];
//                //NSLog(@"count view child : %lu", (unsigned long)self.childViewControllers.count);
//            }
//        }
//    }
//}
//
//@end
