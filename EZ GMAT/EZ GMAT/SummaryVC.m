//
//  SummaryVC.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/9/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "SummaryVC.h"
#import "SummaryCell.h"
#import "MagicalRecord.h"
#import "QuestionType.h"
#import "Question.h"
#import "StudentAnswer.h"
#import "SummaryDetailVC.h"
#import "QuickReviewViewController.h"
@interface SummaryVC ()
{
    NSArray *listTypes;
    NSArray *questions;
}
@end

@implementation SummaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
    [self setTargetForFilter];
    
    [self countTag];
    
    
    listTypes = [QuestionType MR_findAllSortedBy:@"code" ascending:YES];
    questions = [Question MR_findAll];
    //_lblUntag.text = [NSString stringWithFormat:@"% ld",(unsigned long)listTypes.count];
    [self progressForEachSubtype];
    [_tbvCategories reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)configView;{
    [self progressViewShow];
    _viewTag.backgroundColor = [kAppColor colorWithAlphaComponent:0.5];
    _tbvCategories.backgroundColor = [_viewTag.backgroundColor colorWithAlphaComponent:0.2];
}

#pragma mark - TableView Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return listTypes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID =[NSString stringWithFormat:@"%@",[SummaryCell class]];
    
    SummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    QuestionType *selectedType = listTypes[indexPath.row];
    [cell cellWithType:selectedType.detail andInfo:[self trueAnswerforType:selectedType]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SummaryDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryDetailVC"];
    QuestionType *selectedType = listTypes[indexPath.row];
    
    detailVC.type = selectedType;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - tag counter
-(void)countTag;{
    NSPredicate *querry = [NSPredicate predicateWithFormat:@"self.tag = %@", [NSNumber numberWithInteger:-1]];
    NSArray *questionUntag = [Question MR_findAllWithPredicate:querry];
    _lblUntag.text = [NSString stringWithFormat:@" %lu", (unsigned long)questionUntag.count];
    
    querry = [NSPredicate predicateWithFormat:@"self.bookMark = %@", [NSNumber numberWithInteger:1]];
    questionUntag = [Question MR_findAllWithPredicate:querry];
    _lblStar.text = [NSString stringWithFormat:@" %lu", (unsigned long)questionUntag.count];
    
    
    querry = [NSPredicate predicateWithFormat:@"self.tag = %@", [NSNumber numberWithInteger:0]];
    questionUntag = [Question MR_findAllWithPredicate:querry];
    _lblRed.text = [NSString stringWithFormat:@" %lu", (unsigned long)questionUntag.count];
    
    
    querry = [NSPredicate predicateWithFormat:@"self.tag = %@", [NSNumber numberWithInteger:1]];
    questionUntag = [Question MR_findAllWithPredicate:querry];
    _lblGreen.text = [NSString stringWithFormat:@" %lu", (unsigned long)questionUntag.count];
    
    querry = [NSPredicate predicateWithFormat:@"self.tag = %@", [NSNumber numberWithInteger:2]];
    questionUntag = [Question MR_findAllWithPredicate:querry];
    _lblYellow.text = [NSString stringWithFormat:@" %lu", (unsigned long)questionUntag.count];
    
    _lblAverageTime.text = [NSString stringWithFormat:@" %lu", (unsigned long)questionUntag.count];
}
#pragma mark - Progress View
-(void)progressViewShow;{
    self.viewProgress.textStyle               = MCPercentageDoughnutViewTextStyleUserDefined;
    self.viewProgress.linePercentage          = 0.1;
    self.viewProgress.animationDuration       = 0.5;
    self.viewProgress.showTextLabel           = YES;
    self.viewProgress.animatesBegining        = YES;
    self.viewProgress.textLabel.textColor     = [UIColor whiteColor];
    self.viewProgress.fillColor               = kAppColor;
    self.viewProgress.unfillColor             = [UIColor whiteColor];
    self.viewProgress.textLabel.font          = [UIFont systemFontOfSize:1.0];
    [self.viewProgress setInitialPercentage:0.5f];
    
    //count
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"result = %@", [NSNumber numberWithInt:1]];
    NSArray *trueAnswer = [StudentAnswer MR_findAllWithPredicate:pre];
    NSArray *totalQuestions = [Question MR_findAll];
    // NSLog(@"student answer count %lu", [StudentAnswer MR_findAll].count);
    [self.viewProgress setPercentage:(float)trueAnswer.count/totalQuestions.count];
    self.viewProgress.textLabel.text          = [NSString stringWithFormat:@" %.1lf%% ", self.viewProgress.percentage*100];
}
#pragma mark Button Filter
-(void)setTargetForFilter;{
    [_btnRed addTarget:self action:@selector(btnFilterDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [_btnGreen addTarget:self action:@selector(btnFilterDidTap:)forControlEvents:UIControlEventTouchUpInside];
    [_btnYellow addTarget:self action:@selector(btnFilterDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [_btnUnTag addTarget:self action:@selector(btnFilterDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBookMark addTarget:self action:@selector(btnFilterDidTap:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnFilterDidTap:(UIButton *)button;{
    NSInteger tag ;
    NSPredicate *pre;
    if(button == _btnRed){
        tag = 0;
    }else if(button == _btnGreen){
        tag = 1;
    }else if(button == _btnYellow){
        tag = 2;
    }else if (button == _btnUnTag){
        tag = -1;
    }
    pre = [NSPredicate predicateWithFormat:@"question.tag = %d", tag];
    if(button == _btnBookMark){
        pre = [NSPredicate predicateWithFormat:@"question.bookMark = %d", 1];
    }
    
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"question.questionId" ascending:YES];
    NSArray *studentsAnswers =[[StudentAnswer MR_findAllWithPredicate:pre] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    NSLog(@"So cau theo tag : %ld", studentsAnswers.count);
    NSMutableArray *sentQuestions = [[NSMutableArray alloc]init];
    NSMutableArray *sentStudentAnswers= [[NSMutableArray alloc]initWithArray:studentsAnswers];
    for(StudentAnswer *sta in sentStudentAnswers){
        [sentQuestions addObject:sta.question];
    }
    
    QuickReviewViewController *quickReviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickReviewViewController"];
    
    quickReviewController.studentAnswers = sentStudentAnswers;
    quickReviewController.questions = sentQuestions;
    
    quickReviewController.lblTime = @"000000";
    
    CATransition* transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController pushViewController:quickReviewController animated:NO];
    
    
}

#pragma mark Function
-(void) progressForEachSubtype;{
    
    NSLog(@"%lu", (unsigned long)listTypes.count);
    
//    for(QuestionType *type in listTypes){
//        NSPredicate *pre =  [NSPredicate predicateWithFormat:@"(question.type = %@)", type.code];
//        NSPredicate *preall =  [NSPredicate predicateWithFormat:@"(type = %@)", type.code];
//        
       // NSInteger trueAswer = [StudentAnswer MR_countOfEntitiesWithPredicate:pre];
        //NSInteger typeCount = [Question MR_countOfEntitiesWithPredicate:preall];
      //  NSLog(@"Count for subtype :%@  %ld in %ld",type.detail,(long)trueAswer, (long)typeCount);
//    }
}

-(NSDictionary *)trueAnswerforType:(QuestionType *)type;{
    NSPredicate *pre =  [NSPredicate predicateWithFormat:@"(question.type = %@)", type.code];
    NSPredicate *preall =  [NSPredicate predicateWithFormat:@"(type = %@)", type.code];
    
    NSInteger trueAswer = [StudentAnswer MR_countOfEntitiesWithPredicate:pre];
    NSInteger typeCount = [Question MR_countOfEntitiesWithPredicate:preall];
    
    if(typeCount==0) return @{@"percent":@0, @"total":@0};
    
    NSNumber *percent =[NSNumber numberWithDouble:(float)trueAswer/typeCount];
    NSNumber *total =[NSNumber numberWithInteger:typeCount];
    NSDictionary *dict =@{@"percent":percent,@"total":total};
    
    return dict;
}

@end
