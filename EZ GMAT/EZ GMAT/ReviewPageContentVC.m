//
//  ReviewPageContentVC.m
//  GMAT
//
//  Created by Do Ngoc Trinh on 5/13/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "ReviewPageContentVC.h"
#import "Constant.h"
#import "TextCell.h"
#import "AnswerCell.h"
#import "Answer.h"
#import "ReviewAnswerCell.h"
#import "SCLAlertView.h"


@interface ReviewPageContentVC ()

@end

@implementation ReviewPageContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tbvReview.tableFooterView = [[UIView alloc]init];
    _tbvReview.estimatedRowHeight = 60.0f;
    _tbvReview.rowHeight = UITableViewAutomaticDimension;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.view.layer.shadowOpacity = 0.5f;
    self.view.layer.shadowPath = shadowPath.CGPath;
    
    self.tbvReview.estimatedRowHeight = 80;
    self.tbvReview.rowHeight = UITableViewAutomaticDimension;
    
    [self reload];
    
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *answers = [[_question.answers allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    
    static NSString *cellId = @"question";
    
    if (indexPath.section == 0) {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TextCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            [cell loadContentWithContent:_question.stimulus questionType:_question.type];
            //cell.lblText.text = _question.stimulus;
        } else if (indexPath.row == 1) {
            if ([_question.stem isEqualToString:@""]) {
                cell.hidden = YES;
            }
            cell.lblText.text = _question.stem;
        }
        return cell;
        
    } else if (indexPath.section == 1) {
        ReviewAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ReviewAnswerCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tintColor = [UIColor blackColor];
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
        
        cell.explanation = [(Answer *)answers[indexPath.row] explanation];
        
        if ((int)[_studentAnswer.answerChoiceIdx intValue] == (int)indexPath.row) {
            cell.lblAnswer.textColor = [UIColor redColor];
            cell.imvAnswer.tintColor = [UIColor redColor];
            cell.contentView.backgroundColor = [cell.lblAnswer.textColor colorWithAlphaComponent:0.1];
        }
        
        if ((int)[_question.rightAnswerIdx intValue] == (int)indexPath.row) {
            cell.lblAnswer.textColor = [UIColor greenColor];
            cell.imvAnswer.tintColor = [UIColor greenColor];
            cell.contentView.backgroundColor = [cell.lblAnswer.textColor colorWithAlphaComponent:0.1];

        }
        
        cell.line.hidden = YES;
        
        return cell;
        
    } else return nil;
    
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section != 0){
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.tintTopCircle = YES;
        alert.useLargerIcon = NO;
        alert.cornerRadius = 13.0f;
        alert.showAnimationType = SlideOutFromCenter;
        
        alert.customViewColor = kAppColor;
        
        [alert addButton:@"Close" actionBlock:^{
            
        }];
        
        NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        NSArray *answers = [[_question.answers allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
        
        [alert showInfo:nil subTitle:[answers[indexPath.row] explanation] closeButtonTitle:nil duration:0.0f];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return kHeighQuesionWebView;
    }
    else{
        return UITableViewAutomaticDimension;
    }
}

#pragma mark - Class Funtion

- (void)reload;
{
    if ([_studentAnswer.result isEqual:Right]) {
        self.title = @"Correct";
    } else {
        self.title = @"Incorrect";
    }
}

-(void)setInsetTableView;{
    UIEdgeInsets insets = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.tbvReview setContentInset:insets];
    [self.tbvReview setScrollIndicatorInsets:insets];
}
@end
