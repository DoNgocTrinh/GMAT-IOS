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
  //  cell.textLabel.text = [NSString stringWithFormat:@"%.1lf%% - %@",[self trueAnswerforType:selectedType], selectedType.detail];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SummaryDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryDetailVC"];
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - tag counter
-(void)countTag;{
    NSPredicate *querry = [NSPredicate predicateWithFormat:@"self.tag = %@", [NSNumber numberWithInteger:-1]];
    NSArray *questionUntag = [Question MR_findAllWithPredicate:querry];
    _lblUntag.text = [NSString stringWithFormat:@" %d", questionUntag.count];
    
    querry = [NSPredicate predicateWithFormat:@"self.tag = %@", [NSNumber numberWithInteger:0]];
    questionUntag = [Question MR_findAllWithPredicate:querry];
    _lblStar.text = [NSString stringWithFormat:@" %d", questionUntag.count];
    
    
    querry = [NSPredicate predicateWithFormat:@"self.tag = %@", [NSNumber numberWithInteger:1]];
    questionUntag = [Question MR_findAllWithPredicate:querry];
    _lblRed.text = [NSString stringWithFormat:@" %d", questionUntag.count];
    
    
    querry = [NSPredicate predicateWithFormat:@"self.tag = %@", [NSNumber numberWithInteger:2]];
    questionUntag = [Question MR_findAllWithPredicate:querry];
    _lblGreen.text = [NSString stringWithFormat:@" %d", questionUntag.count];
    
    querry = [NSPredicate predicateWithFormat:@"self.tag = %@", [NSNumber numberWithInteger:3]];
    questionUntag = [Question MR_findAllWithPredicate:querry];
    _lblYellow.text = [NSString stringWithFormat:@" %d", questionUntag.count];
    
    querry = [NSPredicate predicateWithFormat:@"self.tag = %@", [NSNumber numberWithInteger:4]];
    questionUntag = [Question MR_findAllWithPredicate:querry];
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
-(void) progressForEachSubtype;{
    
    NSLog(@"%d", listTypes.count);
    
    for(QuestionType *type in listTypes){
        NSPredicate *pre =  [NSPredicate predicateWithFormat:@"(question.type = %@)", type.code];
        NSPredicate *preall =  [NSPredicate predicateWithFormat:@"(type = %@)", type.code];
        
        NSInteger trueAswer = [StudentAnswer MR_countOfEntitiesWithPredicate:pre];
        NSInteger typeCount = [Question MR_countOfEntitiesWithPredicate:preall];
        NSLog(@"Count for subtype :%@  %d in %d",type.detail,trueAswer, typeCount);
    }
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
