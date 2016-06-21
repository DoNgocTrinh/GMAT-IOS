//
//  SummaryCell.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/9/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "SummaryCell.h"

@implementation SummaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellWithType:(NSString *)type andInfo:(NSDictionary *)info;{
    _lblType.text = type;
    NSNumber *percent = info[@"percent"];
    NSNumber *total = info[@"total"];
    [_progressDone setProgress:[percent floatValue]];
    [_progressDone setProgressTintColor:kAppColor];
    if([total integerValue]==0){
        _lblTotal.text =@"Empty";
    }
    else{
        _lblTotal.text = [NSString stringWithFormat:@"Total question : %ld", (long)[total integerValue]];
    }
    _lblPercent.text = [NSString stringWithFormat:@"%.f%%", [percent floatValue]*100];
}

@end
