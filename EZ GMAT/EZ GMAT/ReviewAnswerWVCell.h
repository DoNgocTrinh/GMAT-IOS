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
@property BOOL isExpaned;
-(void)cellWithAnswer: (Answer*)answer andIsSelected:(NSString *)isSelected;
@end
