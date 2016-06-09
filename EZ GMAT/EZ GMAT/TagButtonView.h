//
//  TagButtonView.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/8/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnGrey;
@property (weak, nonatomic) IBOutlet UIButton *btnRed;
@property (weak, nonatomic) IBOutlet UIButton *btnGreen;
@property (weak, nonatomic) IBOutlet UIButton *btnYellow;

+ (id)tagViewWithFrame: (CGRect)frame;
@end
