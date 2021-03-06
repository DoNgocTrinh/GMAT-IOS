//
//  QuestionPackCLVCell.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/26/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "QuestionPackCLVCell.h"

@implementation QuestionPackCLVCell

- (void)awakeFromNib {
    [super awakeFromNib];
 //   self.layer.masksToBounds = NO;
    self.layer.cornerRadius=10.0f;
    self.layer.borderColor=[UIColor blueColor].CGColor;
    // Initialization code
    self.viewHeader.layer.cornerRadius = 5.0f;
    self.viewFooter.layer.cornerRadius = 5.0f;
    self.viewStar.layer.cornerRadius = 2.50f;
}


-(void)drawStarWithLightStar:(NSInteger)numberLight andTotal:(NSInteger)totalStars;
{
    NSLog(@"");
    //draw star
    for(UIImageView *imgView in _viewStar.subviews){
        [imgView removeFromSuperview];
    }
    UIImageView *imageView;
    float width = _viewStar.frame.size.height;
    float height = width;
    //NSLog(@"Height : %lf", height);
    for(int i = 0 ;i < totalStars;i++)
    {
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(width*i, 0, width, height)];
        
        if(i<numberLight) {
            imageView.image=[UIImage imageNamed:@"starLight"];
        }
        else{
            imageView.image=[UIImage imageNamed:@"starBlank"];
        }
        [imageView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [_viewStar addSubview:imageView];
    }
}
-(void)drawStarsWithLightNumber:(NSInteger)no_Light;{
    [self drawStarWithLightStar:no_Light andTotal:3];
}


@end
