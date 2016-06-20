//
//  SummaryDetailVC.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/17/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "SummaryDetailVC.h"
#import "DetailSummaryCell.h"
#import "QuestionSubtype.h"
#import "QuickReviewViewController.h"
#import "StudentAnswer.h"
@interface SummaryDetailVC ()
{
    NSArray *sortedSubTypes;
    TWRChartView *chartView;
}
@end

@implementation SummaryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //sort
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    sortedSubTypes = [[_type.subTypes allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    
    
    //chart View
    chartView = [[TWRChartView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height*0.4 )];
    
    _graphView.backgroundColor = [UIColor clearColor];
    
    // User interaction is disabled by default. You can enable it again if you want
    chartView.userInteractionEnabled = YES;
    
    // Load chart by using a ChartJS javascript file
    NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:@"ChartNew.min" ofType:@"js"];
    [chartView setChartJsFilePath:jsFilePath];
    [self loadBarChart];
    [self loadBarChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadBarChart {
    NSMutableArray *listDids = [[NSMutableArray alloc]init];
    NSMutableArray *listTrues= [[NSMutableArray alloc]init];
    NSMutableArray *listSubtypes= [[NSMutableArray alloc]init];
    
    for(QuestionSubType *subtype in sortedSubTypes){
        [listSubtypes addObject:subtype.detail];
        
        NSPredicate *querry = [NSPredicate predicateWithFormat:@"question.subType = %@",subtype.code];
        NSArray *studentAnswers = [StudentAnswer MR_findAllWithPredicate:querry];
        [listDids addObject:[NSNumber numberWithUnsignedInteger: studentAnswers.count]];
        NSLog(@"did: %lu", studentAnswers.count);
        querry = [NSPredicate predicateWithFormat:@"question.subType = %@ AND answerChoiceIdx = %@", subtype.code, [NSNumber numberWithInteger:1]];
        studentAnswers = [StudentAnswer MR_findAllWithPredicate:querry];
        NSLog(@"true: %lu", studentAnswers.count);
        [listTrues addObject:[NSNumber numberWithUnsignedInteger:0]];
    }
    
    
    // Build chart data
    TWRDataSet *dataSet1 = [[TWRDataSet alloc] initWithDataPoints: listTrues fillColor:[UIColor orangeColor]                                                       strokeColor:[UIColor orangeColor]];
    
    TWRDataSet *dataSet2 = [[TWRDataSet alloc] initWithDataPoints:listDids fillColor:[UIColor redColor]
                                                      strokeColor:[UIColor redColor]];
    
   // NSArray *labels = [NSArray ar];
    TWRBarChart *bar = [[TWRBarChart alloc] initWithLabels:listSubtypes
                                                  dataSets:@[dataSet1, dataSet2]
                                                  animated:YES];
    // Load data
    [chartView loadBarChart:bar];
    [self.graphView addSubview:chartView];
}

#pragma mark - TableView DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID =[NSString stringWithFormat:@"%@",[DetailSummaryCell class]];
    DetailSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell cellWithSubtype:(QuestionSubType *)sortedSubTypes[indexPath.row]];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _type.subTypes.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - TalbeView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"question.questionId" ascending:YES];
    
    QuestionSubType *selectedSubType = sortedSubTypes[indexPath.row];
    NSPredicate *querry = [NSPredicate predicateWithFormat:@"question.subType = %@",selectedSubType.code];
    NSArray *studentAnswers = [StudentAnswer MR_findAllWithPredicate:querry];
    
    if(studentAnswers.count<= 0){
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"Empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [self.view addSubview:alert];
        [alert show];
        return;
    }
    
    studentAnswers =  [studentAnswers sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    
    querry = [NSPredicate predicateWithFormat:@"subType = %@",selectedSubType.code];
    NSMutableArray *questions = [[NSMutableArray alloc]init];
    for(StudentAnswer *sta in studentAnswers){
        Question *q = sta.question;
        [questions addObject:q];
    }
    
    QuickReviewViewController *quickReviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickReviewViewController"];
    
    quickReviewController.studentAnswers = [[NSMutableArray alloc]initWithArray: studentAnswers];
    quickReviewController.questions = questions;
    
    quickReviewController.lblTime = @"000000";
    
    CATransition* transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController pushViewController:quickReviewController animated:NO];
}

@end
