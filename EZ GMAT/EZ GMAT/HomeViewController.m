//
//  HomeViewController.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/26/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "HomeViewController.h"
#import "SummaryVC.h"
#import "QuestionPackCLVCell.h"
#import "QuestionViewController.h"
#import "Question.h"
#import "StudentAnswer.h"

@interface HomeViewController ()


{
    UIActivityIndicatorView *loadingView;
}
@property int i;
@end

@implementation HomeViewController
{
    NSArray *colorList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:loadingView];
    
    [self configCollectionView];
    [self customView];
    [self pullQuestionPacks];
    [sGmatAPI exploreQuestionWithCompletionBlock:^(NSArray *question) {
        [sGmatAPI exploreQuestionPacksWithCompletionBlock:^(NSArray *question) {
            [self pullQuestionPacks];
        }];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    //caculate data
    NSPredicate *querry = [NSPredicate predicateWithFormat:@"result = %d",1];
    NSInteger trueAnswers = [StudentAnswer MR_countOfEntitiesWithPredicate:querry];
    NSInteger questions = [Question MR_countOfEntities];
    CGFloat percent =(float)trueAnswers/questions;
    
    [_viewProgress setPercentage:percent];
    if(percent<=.7){
        _lblSkillLevel.text =@"Newbie";
    }else if(percent>0.7 && percent <=0.9){
        _lblSkillLevel.text =@"Intermediate";
    }else{
        _lblSkillLevel.text =@"Expert";
    }
    self.viewProgress.textLabel.text = [NSString stringWithFormat:@" %.lf%% ", self.viewProgress.percentage*100];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark Collection View
#pragma mark - Collection View DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    return _questionPacks.count;
}

-(QuestionPackCLVCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"QuestionPackCLVCell";
    QuestionPackCLVCell *cell = [_clvQuestionPack dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    //color for cell----------------------------------------------------------------------------------
    UIColor *colorHeader = [UIColor hx_colorWithHexRGBAString:[colorList objectAtIndex:indexPath.row%colorList.count]];
    // NSLog(@"color at: %lu",indexPath.row%colorList.count);
    cell.viewHeader.backgroundColor = colorHeader;
    cell.viewFooter.backgroundColor = cell.viewHeader.backgroundColor;
    cell.contentView.backgroundColor = [colorHeader colorWithAlphaComponent:.7];
    //cell content----------------------------------------------------------------------------------
    QuestionPack *questionPack = _questionPacks[indexPath.row];
    //NSLog(@"pack Level : %ld", [questionPack.level integerValue]);
    cell.lblAvailableTime.text = questionPack.available_time;
    cell.lblNumberQuestion.text =[NSString stringWithFormat:@"%lu questions", questionPack.questions.count];
    cell.lblNumberQuestion.textColor = [UIColor whiteColor];
    //cell.numberStar = 1;
    [cell layoutIfNeeded];
    [cell drawStarsWithLightNumber:[questionPack.level integerValue]];
    //
    
    cell.lblNumberOfPack.text = [NSString stringWithFormat:@"%ld / %lu",indexPath.row + 1 , (unsigned long)_questionPacks.count];
    
    
    //Lock Pack
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    switch ([resultString compare:questionPack.available_time]) {
        case NSOrderedAscending:
            cell.imgLocked.hidden = NO;
            cell.lblNumberQuestion.text = @"";
            cell.viewHeader.backgroundColor = [UIColor grayColor];
            cell.viewFooter.backgroundColor = cell.viewHeader.backgroundColor;
            cell.contentView.backgroundColor = [cell.viewHeader.backgroundColor colorWithAlphaComponent:.8];
            break;
        case NSOrderedSame:
            cell.imgLocked.hidden = YES;
            break;
        case NSOrderedDescending:
            cell.imgLocked.hidden = YES;
            break;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = _clvQuestionPack.frame.size.width/2-6;
    return CGSizeMake(height,height);
}

#pragma mark - Collection View Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // animate the cell user tapped on
    QuestionPackCLVCell* cell = (QuestionPackCLVCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            cell.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
            if([Question MR_countOfEntities] != 0){
                if(cell.imgLocked.hidden == NO){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Lock" message:@"This pack is locked" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    return;
                }
                QuestionPack *selectedQuestionPack = _questionPacks[indexPath.row];
                
                NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"questionId" ascending:YES];
                NSArray *listID = [[selectedQuestionPack.questions allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
                
                QuestionViewController *questionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"question"];
                questionViewController.currentPack = selectedQuestionPack;
                questionViewController.questions= [[NSMutableArray alloc]init];
                
                for (Question *question in  listID) {
                    
                    Question *newQuestion = [Question MR_findFirstByAttribute:@"questionId" withValue: question.questionId];
                    [questionViewController.questions addObject:newQuestion];
                    
                }
                [self.navigationController pushViewController:questionViewController animated:YES];
            }
            else{
                NSLog(@"Chua co question nao trong DB");
            }
            
        }];
    }];
}
#pragma mark - Button Action
-(void)btnMoreDidTap:(id)sender;{
    [self showAlertWithMessage:@"More info"];
    SummaryVC *summaryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryVC"];
    NSLog(@"GO TO SUMMARY");
    [self.navigationController pushViewController:summaryVC animated:YES];
    
}
-(void)btnReminderDidTap:(id)sender;{
    [self showAlertWithMessage:@"Chua co cmm no gi ca"];
}
-(void)btnAboutUsDidTap:(id)sender;{
    [self showAlertWithMessage:@"GMAT app"];
}
#pragma mark - Data pulling
-(void)pullQuestionPacks;{
    
    NSArray *arrPacks=[QuestionPack MR_findAllSortedBy:@"packID" ascending:YES];
    NSLog(@"number pack : %lu", (unsigned long)arrPacks.count);
    
    if(arrPacks.count==0){
        loadingView.center = self.view.center;
        [loadingView startAnimating];
    }else{
        [loadingView stopAnimating];
        [loadingView removeFromSuperview];
    }
    
    self.questionPacks = [NSMutableArray arrayWithArray:arrPacks];
    [_clvQuestionPack reloadData];
    
}
-(void)pullQuestion;{
    
}
#pragma mark - Helper function
-(void)showAlertWithMessage:(NSString *)message;{
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //    [alert show];
}
-(void)configCollectionView;{
    _clvQuestionPack.dataSource = self;
    _clvQuestionPack.delegate = self;
    
    [self.clvQuestionPack registerNib:[UINib nibWithNibName:@"QuestionPackCLVCell" bundle:nil] forCellWithReuseIdentifier:@"QuestionPackCLVCell"];
}
//custom View
-(void)customView;{
    //color list
    [self colorListConfig];
    
    //circle
    self.viewProgress.textStyle               = MCPercentageDoughnutViewTextStyleUserDefined;
    self.viewProgress.linePercentage          = 0.1;
    self.viewProgress.animationDuration       = 0.5;
    self.viewProgress.showTextLabel           = YES;
    self.viewProgress.animatesBegining        = YES;
    self.viewProgress.textLabel.font          = [UIFont systemFontOfSize:5];
    
    self.viewProgress.textLabel.textColor     = [UIColor whiteColor];
    self.viewProgress.fillColor               = kAppColor;
    self.viewProgress.unfillColor             = [UIColor whiteColor];
    self.viewProgress.textLabel.font          = [UIFont systemFontOfSize:1.0];
    [self.viewProgress setInitialPercentage:0.5f];
    [self.viewProgress setPercentage:0];
    self.viewProgress.textLabel.text          = [NSString stringWithFormat:@" %.lf%% ", self.viewProgress.percentage*100];
    //view
    self.viewBottomer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    self.viewTop.backgroundColor = [kAppColor colorWithAlphaComponent:0.5];
    
    //bntMore
    self.btnMore.layer.cornerRadius           = 4.0f;
    self.viewBottomer.layer.cornerRadius      = 3.0f;
}
-(void)colorListConfig;{
    colorList = [[NSArray alloc]initWithObjects:
                 @"#E87328",
                 // @"#16a085",
                 //                 @"#27ae60",
                 //                 @"#2980b9",
                 //                 @"#8e44ad",
                 //                 @"#2c3e50",
                 //                 @"#f39c12",
                 //                 @"#d35400",
                 //                 @"#e74c3c",
                 //                 @"#c0392b",
                 //                 @"#3c6b4c",
                 //                 @"#5b3c6b",
                 //                 @"#676b3c",
                 //                 @"#6b3c3c",
                 //                 @"#3c6b67",
                 //                 @"#6b573c",
                 //                 @"#6b3c56",
                 nil];
}
@end
