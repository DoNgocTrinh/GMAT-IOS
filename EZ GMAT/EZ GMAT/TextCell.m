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
    _webViewQuestion.userInteractionEnabled = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

-(void)loadContentWithContent:(NSString *)content;{
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    content = [NSString stringWithFormat: @"%@  $a^2 + b^2 = c^2$ ", content];
    
    if([content rangeOfString:@"$"].location != NSNotFound) { // Expression inside text.
        NSRange r;
        BOOL intex = NO;
        while ((r = [content rangeOfString:@"$"]).location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:r
                                                       withString:(intex ? @"</span>" : @"<span class=\"tex\">")];
            intex = !intex;
        }
        if (intex) NSLog(@"Katex iOS: Error: No closing $.");
    } else { // Raw KaTeX.
        content = [NSString stringWithFormat:@"<span class=\"tex\">%@</span>", content];
    }
    
    // Place into HTML
    appHtml = [appHtml stringByReplacingOccurrencesOfString:@"$LATEX$"
                                                 withString:content];
    
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    
    [_webViewQuestion loadHTMLString:appHtml baseURL:baseURL];

}
@end
