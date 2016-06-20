//
//  DetailSummaryCell.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/19/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionSubType.h"

@interface DetailSummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSubType;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
-(void)cellWithSubtype:(QuestionSubType *)subtype;
@end
