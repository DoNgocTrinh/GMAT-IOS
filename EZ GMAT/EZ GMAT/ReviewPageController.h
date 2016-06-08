//
//  ReviewPageController.h
//  GMAT
//
//  Created by Do Ngoc Trinh on 5/13/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewPageController : UIViewController
                                  <UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, assign) NSInteger *currentPageIndex;
@property (nonatomic, strong) NSArray *studentAnswers;
@property (nonatomic, strong) NSArray *questions;
@end
