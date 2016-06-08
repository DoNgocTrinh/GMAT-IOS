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
   // _webViewQuestion.userInteractionEnabled = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

-(void)loadContentWithContent:(NSString *)content questionType:(NSString*)questionType;{
//    if([questionType isEqualToString:@"Q"]){
        [self loadContentWithLocalHTML:content];
//    }
//    else{
//        [_webViewQuestion loadHTMLString:content baseURL:nil];
//    }
    

}
-(void)loadContentWithLocalHTML:(NSString *)content;{
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    content = [NSString stringWithFormat: @"%@ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ $\\frac{1}{2}$ ", content];
    
    if([content rangeOfString:@"$"].location != NSNotFound) { // Expression inside text.
        NSRange r;
        BOOL intex = NO;
        while ((r = [content rangeOfString:@"$"]).location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:r
                                                       withString:(intex ? @"</span>" : @"<span class=\"tex\">")];
            intex = !intex;
        }
        if (intex) NSLog(@"Katex iOS: Error: No closing $.");
        // Place into HTML
        appHtml = [appHtml stringByReplacingOccurrencesOfString:@"$LATEX$"
                                                     withString:content];
        
        NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
        
        [_webViewQuestion loadHTMLString:appHtml baseURL:baseURL];
    } else { // Raw KaTeX.
        [_webViewQuestion loadHTMLString:content baseURL:nil];
        //  content = [NSString stringWithFormat:@"<span class=\"tex\">%@</span>", content];
    }
    
   
}
@end
