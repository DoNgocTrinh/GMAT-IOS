//
//  QuickReviewCell.h
//  GMAT
//
//  Created by Trung Đức on 4/9/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPercentageDoughnutView.h"

@interface QuickReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MCPercentageDoughnutView *viewCir;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end
