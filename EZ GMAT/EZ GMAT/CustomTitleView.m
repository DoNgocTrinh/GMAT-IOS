//
//  CustomTitleView.m
//  GMAT
//
//  Created by Do Ngoc Trinh on 5/17/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "CustomTitleView.h"

@implementation CustomTitleView

+ (id)customViewWithFrame: (CGRect)frame;
{
    CustomTitleView *customView = [[[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[CustomTitleView class]]){
        [customView setFrame:frame];
        return customView;
    }
    else{
        NSLog(@"nil");
        return nil;
    }
}


@end
