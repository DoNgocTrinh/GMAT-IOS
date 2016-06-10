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
    listTypes = [QuestionType MR_findAll];
    questions = [Question MR_findAll];
    _lblUntag.text = [NSString stringWithFormat:@"% ld",(unsigned long)questions.count];

    NSString *attributeName  = @"type";
    NSString *attributeValue = @"Q";
    NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"%K like %@",
                                attributeName, attributeValue];
    
    Question *quesiton ;
    
   // [Question MR_deleteAllMatchingPredicate:predicate];
    
    NSLog(@"question: %ld", (unsigned long)questions.count);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)configView;{
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
    cell.textLabel.text = selectedType.detail;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
#pragma mark - TableView Delegate


@end
