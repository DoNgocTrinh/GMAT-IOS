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
#import "ReviewAnswerWVCell.h"
#import "SCLAlertView.h"


@interface ReviewPageContentVC ()
{
    NSMutableArray *selectedRows;
    NSMutableArray *heights;
    NSMutableArray *expandheights;
    CGFloat height;
}
@end

@implementation ReviewPageContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _studentAnswer = _question.studentAnswer;
    NSLog(@"tag: %ld; bookMark: %ld", [_question.tag integerValue], [_question.bookMark integerValue]);
    selectedRows = [[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0", nil];
    
    heights =[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],
              [NSNumber numberWithFloat:0],nil ];
    expandheights =[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],nil ];
    
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
        return 2;
    } else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *answers = [[_question.answers allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    
    static NSString *cellId = @"question";
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TextCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.webViewQuestion.tag = 0;
            cell.webViewQuestion.delegate = self;
            if(![_question.type isEqualToString:@"RC"])
            {
                cell.webViewQuestion.opaque = NO;
                cell.webViewQuestion.backgroundColor =[kAppColor colorWithAlphaComponent:.2];
                cell.webViewQuestion.scrollView.scrollEnabled = NO;
            }
            else{
                cell.webViewQuestion.scrollView.scrollEnabled = YES;
            }
            NSString *stringImage = @"<img src='downloaded.png' width='50' height='50';>";
            NSString *content = [NSString stringWithFormat:@"%@ %@", _question.stimulus, stringImage];
            //[cell loadContentWithContent:_question.stimulus questionType:_question.type];
            [cell loadContentWithContent:content questionType:_question.type];
            return cell;
        } else if (indexPath.row == 1) {
            TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TextCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.webViewQuestion.tag = 1;
            cell.webViewQuestion.delegate = self;
            cell.webViewQuestion.opaque = NO;
            cell.webViewQuestion.backgroundColor =[kAppColor colorWithAlphaComponent:.2];
            [cell loadContentWithContent:_question.stem questionType:_question.type];
            cell.webViewQuestion.scrollView.scrollEnabled = NO;
            return cell;
        }
        else return nil;
        
    } else if (indexPath.section == 1) {
        ReviewAnswerWVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ReviewAnswerWVCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tintColor = [UIColor blackColor];
        cell.webViewAnswer.tag = indexPath.row +2;
        cell.webViewAnswer.delegate = self;
        [cell cellWithAnswer:  (Answer *)answers[indexPath.row] andIsSelected:selectedRows[indexPath.row]];
        //         cell.explanation = [(Answer *)answers[indexPath.row] explanation];
        //
        if ((int)[_studentAnswer.answerChoiceIdx intValue] == (int)indexPath.row) {
            cell.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#FFCDD2"];
            cell.webViewAnswer.backgroundColor = cell.contentView.backgroundColor ;
        }
        
        if ((int)[_question.rightAnswerIdx intValue] == (int)indexPath.row) {
            cell.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#C8E6C9"] ;
            cell.webViewAnswer.backgroundColor = cell.contentView.backgroundColor;
        }
        //cell.contentView.layer.borderWidth = 0.5;
        //cell.contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
        return cell;
        
    } else return nil;
    
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section != 0){
        
        //* sort NSSet
        NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        NSArray *answers = [[_question.answers allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([selectedRows[indexPath.row] isEqualToString:@"0"]){
            selectedRows[indexPath.row] = @"1";
        }
        else{
            selectedRows[indexPath.row] = @"0";
        }
        [(ReviewAnswerWVCell *) cell cellWithAnswer:  (Answer *)answers[indexPath.row] andIsSelected:selectedRows[indexPath.row]];
        [_tbvReview beginUpdates];
        [_tbvReview endUpdates];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row==0){
            if([heights[0] floatValue] <= 0) return 100;
            if([heights[0] floatValue]>=500) return 158
                ;
            else
                return [heights[0] floatValue];
        }else{
            if ([heights[1]floatValue]<=8) {
                return 0;
            } else{
                return [heights[1]floatValue];
            }
        }
    }
    if(indexPath.section == 1){
        if([heights[indexPath.row +2] floatValue] <=0){
            return 44;
        }
        if([selectedRows[indexPath.row] isEqualToString:@"0"])
        {
            return [heights[indexPath.row + 2] floatValue];
        }
        else{
            return [expandheights[indexPath.row + 2] floatValue];
        }
    }
    return 0;
}

#pragma mark - WebView Delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    // if([heights[webView.tag] floatValue]!=height){
    // heights[webView.tag] = [NSNumber numberWithFloat:height];
    if(webView.tag>=2){
        if([selectedRows[webView.tag-2] isEqualToString:@"1"]){
            if([expandheights[webView.tag] floatValue] == 0){
                expandheights[webView.tag] = [NSNumber numberWithFloat:height];
                [_tbvReview beginUpdates];
                [_tbvReview endUpdates];
            }
            
            
            //            [_tbvReview reloadRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:webView.tag-2 inSection:1] ]withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    //    if([expandheights[webView.tag] floatValue]!=0){
    //
    //    }
    
    if([heights[webView.tag] floatValue]==0){
        heights[webView.tag] = [NSNumber numberWithFloat:height];
        [_tbvReview beginUpdates];
        [_tbvReview endUpdates];
    }
    
    //  }
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
