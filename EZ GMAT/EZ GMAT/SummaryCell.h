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
@property (weak, nonatomic) IBOutlet UILabel *lblPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UIProgressView *progressDone;
- (void)cellWithType:(NSString *)type andInfo:(NSDictionary *)info;
@end
