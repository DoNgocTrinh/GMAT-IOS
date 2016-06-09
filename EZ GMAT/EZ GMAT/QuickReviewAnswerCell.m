//
//  QuickReviewAnswerCell.m
//  GMAT
//
//  Created by Trung Đức on 4/11/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "QuickReviewAnswerCell.h"

@implementation QuickReviewAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellWithResult:(NSNumber *) result;{
    switch ([result intValue]) {
        case 0:
            _imvResult.image = [[UIImage imageNamed:kImage_Wrong] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            _imvResult.tintColor = [UIColor redColor];
            
            //self.contentView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
            break;
        case 1:
            _imvResult.image = [[UIImage imageNamed:kImage_Right] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            //self.contentView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
              _imvResult.tintColor = [UIColor greenColor];
           
            break;
        default:
            _imvResult.tintColor = [UIColor clearColor];
            break;
    }
     self.contentView.backgroundColor = [_imvResult.tintColor colorWithAlphaComponent:.2];
}

@end
