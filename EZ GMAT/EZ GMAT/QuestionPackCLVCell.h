//
//  QuestionPackCLVCell.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/26/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionPackCLVCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UILabel *lblAvailableTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgTheme;
@property (weak, nonatomic) IBOutlet UIView *viewStar;
@property(nonatomic, assign) NSInteger numberStar;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberQuestion;
@property (strong, nonatomic) IBOutlet UIButton *btnLock;
@property (strong, nonatomic) IBOutlet UILabel *lblNumberOfPack;
@property (strong, nonatomic) IBOutlet UIButton *btnLocked;
- (IBAction)btnLocked:(id)sender;

-(void)drawStarWithLightStar:(NSInteger)numberLight andTotal:(NSInteger)totalStars;
-(void)drawStarsWithLightNumber:(NSInteger)no_Light;



@end
