//
//  HomeViewController.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/26/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Circular/MCPercentageDoughnutView.h"

#import "GmatAPI.h"

@interface HomeViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *questionPacks;

#pragma mark - UIControl
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UILabel *lblSkillLevel;
@property (weak, nonatomic) IBOutlet MCPercentageDoughnutView *viewProgress;

@property (weak, nonatomic) IBOutlet UICollectionView *clvQuestionPack;
@property (weak, nonatomic) IBOutlet UIButton *btnReminder;
@property (weak, nonatomic) IBOutlet UIButton *btnAboutUs;
@property (weak, nonatomic) IBOutlet UIView *viewBottomer;

#pragma mark - Action
-(IBAction)btnMoreDidTap:(id)sender;
-(IBAction)btnReminderDidTap:(id)sender;
-(IBAction)btnAboutUsDidTap:(id)sender;


@end
