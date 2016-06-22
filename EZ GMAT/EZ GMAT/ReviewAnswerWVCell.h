//
//  ReviewAnswerWVCell.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/13/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewAnswerWVCell : UITableViewCell<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webViewAnswer;
@property (weak, nonatomic) IBOutlet UIImageView *imvAnswer;
@property (weak, nonatomic) IBOutlet UIImageView *imgExpand;
@property BOOL isExpaned;
-(void)cellWithAnswer: (Answer*)answer andIsSelected:(NSString *)isSelected;
-(void)compareImage:(UIImage *)img1 andImage:(UIImage *)img2;
-(void)checkExpand:(NSString *)string;
@end
