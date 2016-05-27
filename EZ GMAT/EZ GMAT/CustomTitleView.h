//
//  CustomTitleView.h
//  GMAT
//
//  Created by Do Ngoc Trinh on 5/17/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTitleView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestionNumber;
+ (id)customViewWithFrame: (CGRect)frame;
@end

