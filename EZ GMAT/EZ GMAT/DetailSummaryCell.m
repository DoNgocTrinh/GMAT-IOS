//
//  DetailSummaryCell.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/19/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "DetailSummaryCell.h"
#import "QuestionSubType.h"
#import "StudentAnswer.h"

@implementation DetailSummaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellWithSubtype:(QuestionSubType *)subtype;{
    _lblSubType.text = [NSString stringWithFormat:@" %@", subtype.detail];
    
    //find question have  subtype ...
    NSPredicate *querry = [NSPredicate predicateWithFormat:@"subType = %@", subtype.code];
    NSUInteger count = [Question MR_countOfEntitiesWithPredicate:querry];
    
     _lblTotal.text = [NSString stringWithFormat:@"Total question : %ld", count];
    
}
@end
