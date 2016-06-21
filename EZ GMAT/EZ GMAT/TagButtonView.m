//
//  TagButtonView.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/8/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "TagButtonView.h"
#import "ReviewPageController.h"


@implementation TagButtonView


+ (id)tagViewWithFrame: (CGRect)frame;
{
    TagButtonView *tagButtonView = [[[NSBundle mainBundle] loadNibNamed:@"TagButtonView" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([tagButtonView isKindOfClass:[TagButtonView class]]){
        [tagButtonView setFrame:frame];
        
//        tagButtonView.btnStar.layer.cornerRadius = tagButtonView.btnStar.frame.size.height/4;
//        tagButtonView.btnRed.layer.cornerRadius = tagButtonView.btnStar.layer.cornerRadius;
//        tagButtonView.btnGreen.layer.cornerRadius = tagButtonView.btnStar.layer.cornerRadius;
//        tagButtonView.btnYellow.layer.cornerRadius = tagButtonView.btnStar.layer.cornerRadius;
//        tagButtonView.btnStar.backgroundColor = [UIColor whiteColor];
//        tagButtonView.btnRed.backgroundColor = tagButtonView.btnStar.backgroundColor;
//        tagButtonView.btnGreen.backgroundColor = tagButtonView.btnStar.backgroundColor;
//        tagButtonView.btnYellow.backgroundColor = tagButtonView.btnStar.backgroundColor;
        
        return tagButtonView;
    }
    else{
        NSLog(@"nil");
        return nil;
    }
}
+(void)showShareInViewController:(UIViewController *)viewController andWithView:(UIView *)view;
{
    CGRect rect = [[UIScreen mainScreen] bounds];
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    NSString *stringtoshare= @"This is a string to share";
        UIImage *imagetoshare = image; //This is an image to share.
    
        NSArray *activityItems = @[stringtoshare, imagetoshare];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo];
        [viewController presentViewController:activityVC animated:TRUE completion:nil];
}
////Save ScreenShot and share:
//
//- (UIImage*)captureView:(UIView *)view {
//    CGRect rect = [[UIScreen mainScreen] bounds];
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [view.layer renderInContext:context];
//    _img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSLog(@"tri ccc");
//    return _img;
//}
//
//- (void)saveScreenshotToPhotosAlbum:(UIView *)view {
//    UIImageWriteToSavedPhotosAlbum([self captureView:view], nil, nil, nil);
//    NSLog(@"tri tri");
//}
//
//- (void) compartir:(id)sender{
//    
//    //Si no
//    [self saveScreenshotToPhotosAlbum:self.view];
//    
//    NSLog(@"shareButton pressed");
//    
//    
//    NSString *stringtoshare= @"This is a string to share";
//    UIImage *imagetoshare = _img; //This is an image to share.
//    
//    NSArray *activityItems = @[stringtoshare, imagetoshare];
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
//    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo];
//    [self presentViewController:activityVC animated:TRUE completion:nil];
//}


@end
