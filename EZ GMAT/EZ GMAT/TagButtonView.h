//
//  TagButtonView.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/8/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnStar;
@property (weak, nonatomic) IBOutlet UIButton *btnRed;
@property (weak, nonatomic) IBOutlet UIButton *btnGreen;
@property (weak, nonatomic) IBOutlet UIButton *btnYellow;
@property UIImage *img;
+ (id)tagViewWithFrame: (CGRect)frame;
+(void)showShareInViewController:(UIViewController *)viewController andWithView:(UIView *)view;
+(BOOL)disappearFromView:(UIView *)superView;
@end
