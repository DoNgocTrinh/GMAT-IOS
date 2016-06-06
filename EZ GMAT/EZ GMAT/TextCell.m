//
//  TextCell.m
//  GMAT
//
//  Created by Trung Đức on 4/9/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "TextCell.h"

@implementation TextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
  //  _webViewQuestion.delegate  = self;
    _webViewQuestion.userInteractionEnabled = NO;
//    CGFloat output = [[_webViewQuestion stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
//    NSLog(@"height %lf", output);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
   // [super setSelected:selected animated:animated];
    if(selected){
    self.backgroundView.backgroundColor = kAppColor;
        _webViewQuestion.backgroundColor = kAppColor;}
    else{
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        _webViewQuestion.backgroundColor = [UIColor whiteColor];
    }
    _webViewQuestion.opaque = NO;

}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSLog(@"Load view");
//    CGFloat output = [[_webViewQuestion stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
//    NSLog(@"height of webview %lf %lf", output, _webViewQuestion.scrollView.contentSize.height);
//    
//    
//    
//    _heightweb = output;
//    UITableView *parentTable = (UITableView *)self.superview;
//    if (![parentTable isKindOfClass:[UITableView class]]) {
//        parentTable = (UITableView *) parentTable.superview;
//    }
//    
//    [self reloadInputViews];
//    
//    
//}

@end
