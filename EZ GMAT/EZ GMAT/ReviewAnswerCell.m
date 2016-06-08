//
//  ReviewAnswerCell.m
//  GMAT
//
//  Created by Trung Đức on 4/11/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "ReviewAnswerCell.h"

@implementation ReviewAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imgMore.image =[[UIImage imageNamed:@"moreInfo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _imgMore.tintColor = kAppColor;
    
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
     self.lblAnswer.adjustsFontSizeToFitWidth = YES;
    //self.lblAnswer.numberOfLines = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
