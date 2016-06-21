//
//  ReviewAnswerWVCell.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/13/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "ReviewAnswerWVCell.h"

@implementation ReviewAnswerWVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    _webViewAnswer.userInteractionEnabled = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
    _webViewAnswer.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.3].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if(selected){
        //  self.backgroundView.backgroundColor = kSelectedColor;
//        self.contentView.backgroundColor = kSelectedColor;
//        _webViewAnswer.backgroundColor = kSelectedColor;
        //®[self loadContentWithContent:[NSString stringWithFormat:@"-------%@", @"choice"]];
        
    }
    else{
//        self.contentView.backgroundColor = [UIColor whiteColor];
//        _webViewAnswer.backgroundColor = [UIColor whiteColor];
        //[self loadContentWithContent:[NSString stringWithFormat:@"%@", @"choice"]];
    }
    _webViewAnswer.opaque = NO;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
}
-(void)cellWithAnswer: (Answer*)answer andIsSelected:(NSString *)isSelected;{
    
    switch ([answer.index intValue]) {
        case 0:
            _imvAnswer.image = [UIImage imageNamed:kImage_AnswerA];
            break;
        case 1:
            _imvAnswer.image = [UIImage imageNamed:kImage_AnswerB];
            break;
        case 2:
            _imvAnswer.image = [UIImage imageNamed:kImage_AnswerC];
            break;
        case 3:
            _imvAnswer.image = [UIImage imageNamed:kImage_AnswerD];
            break;
        case 4:
            _imvAnswer.image = [UIImage imageNamed:kImage_AnswerE];
            break;
        default:
            break;
    }
    // if(self.expanded == 1){
    if(![isSelected isEqualToString:@"1"]){
        [self loadContentWithContent:[NSString stringWithFormat:@"%@", answer.choice]];
    }
    else{
        [self loadContentWithContent:[NSString stringWithFormat:@"%@<hr> %@", answer.choice, answer.explanation]];
    }
}

-(void)loadContentWithContent:(NSString *)content;{
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    content = [NSString stringWithFormat: @"%@", content];
    
    if([content rangeOfString:@"$"].location != NSNotFound) { // Expression inside text.
        NSRange r;
        BOOL intex = NO;
        while ((r = [content rangeOfString:@"$"]).location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:r
                                                       withString:(intex ? @"</span>" : @"<span class=\"tex\">")];
            intex = !intex;
        }
        if (intex) NSLog(@"Katex iOS: Error: No closing $.");
        
        appHtml = [appHtml stringByReplacingOccurrencesOfString:@"$LATEX$"
                                                     withString:content];
        
        NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
        
        [_webViewAnswer loadHTMLString:appHtml baseURL:baseURL];
        
    } else {
        [_webViewAnswer loadHTMLString:content baseURL:nil];
    }
}

@end
