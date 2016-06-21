//
//  ReviewPageController.h
//  GMAT
//
//  Created by Do Ngoc Trinh on 5/13/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewPageController : UIViewController
                                  <UIPageViewControllerDataSource,UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) IBOutlet UIView *viewPage;
@property (weak, nonatomic) IBOutlet UIButton *btnTag;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIView *viewShowTag;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) NSArray *studentAnswers;
@property (nonatomic, strong) NSArray *questions;
@property (strong, nonatomic) IBOutlet UIImageView *imgStar;
@property (strong, nonatomic) IBOutlet UIImageView *imgTag;
@property (weak, nonatomic) IBOutlet UIButton *btnHeaderTag;

//- (void)saveScreenshotToPhotosAlbum:(UIView *)view;

@end
