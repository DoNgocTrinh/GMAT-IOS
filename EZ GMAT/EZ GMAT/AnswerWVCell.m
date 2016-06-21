//
//  AnswerWVCell.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/6/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "AnswerWVCell.h"

@implementation AnswerWVCell
{
    int indexAnswer;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    _webViewAnswer.userInteractionEnabled = NO;
    _webViewAnswer.delegate = self;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.3].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if(selected){
        //  self.backgroundView.backgroundColor = kSelectedColor;
        self.contentView.backgroundColor = kSelectedColor;
        _webViewAnswer.backgroundColor = kSelectedColor;
    }
    else{
        self.contentView.backgroundColor = [UIColor whiteColor];
        _webViewAnswer.backgroundColor = [UIColor whiteColor];
    }
    _webViewAnswer.opaque = NO;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
}
-(void)cellWithAnswer: (Answer*)answer questionType: (NSString*) questionType;{
    
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
    [self loadContentWithContent:answer.choice];
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
