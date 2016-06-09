//
//  TagButtonView.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/8/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "TagButtonView.h"

@implementation TagButtonView

+ (id)tagViewWithFrame: (CGRect)frame;
{
    TagButtonView *tagButtonView = [[[NSBundle mainBundle] loadNibNamed:@"TagButtonView" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([tagButtonView isKindOfClass:[TagButtonView class]]){
        [tagButtonView setFrame:frame];
        
        tagButtonView.btnGrey.layer.cornerRadius = tagButtonView.btnGrey.frame.size.height/4;
        tagButtonView.btnRed.layer.cornerRadius = tagButtonView.btnGrey.layer.cornerRadius;
        tagButtonView.btnGreen.layer.cornerRadius = tagButtonView.btnGrey.layer.cornerRadius;
        tagButtonView.btnYellow.layer.cornerRadius = tagButtonView.btnGrey.layer.cornerRadius;
        tagButtonView.btnGrey.backgroundColor = kAppColor;
        tagButtonView.btnRed.backgroundColor = tagButtonView.btnGrey.backgroundColor;
        tagButtonView.btnGreen.backgroundColor = tagButtonView.btnGrey.backgroundColor;
        tagButtonView.btnYellow.backgroundColor = tagButtonView.btnGrey.backgroundColor;
        
        
        return tagButtonView;
    }
    else{
        NSLog(@"nil");
        return nil;
    }
}


@end
