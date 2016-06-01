//
//  ReviewAnswerCell.h
//  GMAT
//
//  Created by Trung Đức on 4/11/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewAnswerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imvAnswer;
@property (weak, nonatomic) IBOutlet UILabel *lblAnswer;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *lblExplanation;
@property (nonatomic, strong) NSString *explanation;

@end
