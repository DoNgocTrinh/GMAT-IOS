//
//  AnswerWVCell.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/6/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@interface AnswerWVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *webViewAnswer;
@property (weak, nonatomic) IBOutlet UIImageView *imvAnswer;
-(void)cellWithAnswer: (Answer*)answer questionType: (NSString*) questionType;
@end
