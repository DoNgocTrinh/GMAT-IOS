//
//  HomeViewController.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/26/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "HomeViewController.h"
#import "QuestionPackCLVCell.h"
#import "QuestionViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    NSArray *colorList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configCollectionView];
    [self customView];
    [sGmatAPI exploreQuestionPacksWithCompletionBlock:^(NSArray *question) {
        [self pullQuestionPacks];
    }];
    [self pullQuestionPacks];
    [sGmatAPI exploreQuestionWithCompletionBlock:^(NSArray *question) {
        
    }];
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
    
    //cell content----------------------------------------------------------------------------------
    QuestionPack *quetionPack = _questionPacks[indexPath.row];
    cell.lblAvailableTime.text = quetionPack.available_time;
    
    //cell.numberStar = 1;
    [cell layoutIfNeeded];
    [cell drawStarWithLightStar:indexPath.row%3 andTotal:3];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = _clvQuestionPack.frame.size.height*8/9;
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
        }];
    }];
    
    if([Question MR_countOfEntities] != 0){

        QuestionPack *selectedQuestionPack = _questionPacks[indexPath.row];
        
        NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"questionID" ascending:YES];
        NSArray *listID = [[selectedQuestionPack.questionIDs allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];

         QuestionViewController *questionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"question"];
        questionViewController.questions= [[NSMutableArray alloc]init];
        
        for (QuestionID *questionId in  listID) {
            
            Question *question = [Question MR_findFirstByAttribute:@"questionId" withValue: questionId.questionID];
            [questionViewController.questions addObject:question];
        }
        [self.navigationController pushViewController:questionViewController animated:YES];
    }
    else{
        NSLog(@"Chua co question nao trong DB");
    }
}
#pragma mark - Button Action
-(void)btnMoreDidTap:(id)sender;{
    [self showAlertWithMessage:@"More info"];
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
    NSLog(@"number pack : %ld", arrPacks.count);
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
    self.viewProgress.linePercentage          = 0.05;
    self.viewProgress.animationDuration       = 0.5;
    self.viewProgress.showTextLabel           = YES;
    self.viewProgress.animatesBegining        = YES;
    self.viewProgress.textLabel.font          = [UIFont systemFontOfSize:5];
    
    self.viewProgress.textLabel.textColor     = [UIColor orangeColor];
    self.viewProgress.fillColor               = [UIColor orangeColor];
    self.viewProgress.textLabel.font          = [UIFont systemFontOfSize:1.0];
    [self.viewProgress setInitialPercentage:0.5f];
    [self.viewProgress setPercentage:0.8];
    self.viewProgress.textLabel.text          = [NSString stringWithFormat:@" %.lf%% ", self.viewProgress.percentage*100];
    
    //bntMore
    self.btnMore.layer.cornerRadius           = 4.0f;
    self.viewBottomer.layer.cornerRadius      = 3.0f;
}
-(void)colorListConfig;{
    colorList = [[NSArray alloc]initWithObjects:
                 @"#2d5139",
                 @"#2d3f51",
                 @"#462e52",
                 @"#4e512d",
                 @"#512d2d",
                 @"#2e524f",
                 @"#52432e",
                 @"#522e42",
                 @"#3c6b4c",
                 @"#3c6b4c",
                 @"#5b3c6b",
                 @"#676b3c",
                 @"#6b3c3c",
                 @"#3c6b67",
                 @"#6b573c",
                 @"#6b3c56",
                 nil];
}
@end
