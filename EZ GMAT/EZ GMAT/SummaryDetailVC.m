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
    self.title = _type.detail;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
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
    _tbvSubtype.backgroundColor = [kAppColor colorWithAlphaComponent:.2];
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
        
        NSPredicate *quer = [NSPredicate predicateWithFormat:@"type = %@ and subType = %@", _type.code,subtype.code];
        NSUInteger count = [Question MR_countOfEntitiesWithPredicate:quer];
        if(count>0){
            NSPredicate *querry = [NSPredicate predicateWithFormat:@"question.type = %@ and question.subType = %@",_type.code,subtype.code];
            NSArray *studentAnswers = [StudentAnswer MR_findAllWithPredicate:querry];
            [listDids addObject:[NSNumber numberWithFloat:(float)studentAnswers.count/count*100]];
            
            querry = [NSPredicate predicateWithFormat:@"question.type = %@ and question.subType = %@ and result = %d", _type.code,subtype.code, 1];
            studentAnswers = [StudentAnswer MR_findAllWithPredicate:querry];
            [listTrues addObject:[NSNumber numberWithFloat:(float)studentAnswers.count/count*100]];
        }
        else{
            [listDids addObject:[NSNumber numberWithFloat:0]];
            [listTrues addObject:[NSNumber numberWithFloat:0]];
        }
    }
    // Build chart data
    TWRDataSet *dataSet1 = [[TWRDataSet alloc] initWithDataPoints: listTrues fillColor:[UIColor colorWithRed:180.0/255 green:255.0/255 blue:136.0/255 alpha:1]                                                       strokeColor:[UIColor colorWithRed:180.0/255 green:255.0/255 blue:136.0/255 alpha:1]];
    
    TWRDataSet *dataSet2 = [[TWRDataSet alloc] initWithDataPoints:listDids fillColor:[UIColor colorWithRed:51.0/255 green:192.0/255 blue:152.0/255 alpha:1]
                                                      strokeColor:[UIColor colorWithRed:51.0/255 green:192.0/255 blue:152.0/255 alpha:1]];
    
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
    
    [cell cellWithType:_type andSubtype:(QuestionSubType *)sortedSubTypes[indexPath.row]];
    
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
    NSPredicate *querry = [NSPredicate predicateWithFormat:@"question.type = %@ and question.subType = %@",_type.code,selectedSubType.code];
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
