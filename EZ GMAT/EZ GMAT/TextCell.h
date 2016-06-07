//
//  TextCell.h
//  GMAT
//
//  Created by Trung Đức on 4/9/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
@interface TextCell : UITableViewCell<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UIWebView *webViewQuestion;
-(void)loadContentWithContent:(NSString *)content;
@end
