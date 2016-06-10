//
//  SummaryCell.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/9/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblPercent;
@property (weak, nonatomic) IBOutlet UIProgressView *progressDone;

@end
