//
//  AnswerCell.m
//  GMAT
//
//  Created by Trung Đức on 4/9/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "AnswerCell.h"
#import "Constant.h"

@implementation AnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
   // self.lblAnswer.numberOfLines = 1;
   // self.lblAnswer.minimumFontSize = 8;
    self.lblAnswer.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (self.selected) {
        _lblAnswer.textColor = kAppColor;
        _imvAnswer.tintColor = kAppColor;
    } else {
        _lblAnswer.textColor = [UIColor blackColor];
        _imvAnswer.tintColor = [UIColor blackColor];
    }
}

@end
