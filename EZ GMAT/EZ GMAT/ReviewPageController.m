//
//  ReviewPageController.m
//  GMAT
//
//  Created by Do Ngoc Trinh on 5/13/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "ReviewPageController.h"
#import "ReviewPageContentVC.h"
#import "TagButtonView.h"

@interface ReviewPageController ()

@end

@implementation ReviewPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    [self.navigationController.view setAutoresizesSubviews:NO];
    
    ReviewPageContentVC *startingViewController = [self viewControllerAtIndex:self.currentPageIndex];
    self.navigationItem.title = [NSString stringWithFormat:@"%lu/%ld",startingViewController.pageindex+1,_questions.count];
    
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:_pageViewController];
    [self.viewPage addSubview:_pageViewController.view];
    _pageViewController.view.center = _viewPage.center;
    [_pageViewController.view setFrame:CGRectMake(_viewPage.frame.origin.x, _viewPage.frame.origin.y, _viewPage.frame.size.width, _viewPage.frame.size.height)];
    [self.pageViewController didMoveToParentViewController:self];
    //
    _btnBack.backgroundColor = kAppColor;
    _btnNext.backgroundColor = _btnBack.backgroundColor;
    _btnTag.backgroundColor = _btnBack.backgroundColor;
    
    [_btnTag addTarget:self action:@selector(showTagViewButton) forControlEvents:UIControlEventTouchUpInside];
    [_btnNext addTarget:self action:@selector(btnNextDidTap) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSInteger index = ((ReviewPageContentVC*) viewController).pageindex;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%lu/%ld",index+1,_questions.count];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = ((ReviewPageContentVC*) viewController).pageindex;
    self.navigationItem.title = [NSString stringWithFormat:@"%lu/%ld",index+1,_questions.count];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [self.questions count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (ReviewPageContentVC *)viewControllerAtIndex:(NSInteger)index
{
    
    if (([self.questions count] == 0) || (index >= [self.questions count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    ReviewPageContentVC *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"review"];
    
    
    pageContentViewController.pageindex = index;
    pageContentViewController.question = [_questions objectAtIndex:index];
    pageContentViewController.studentAnswer = [_studentAnswers objectAtIndex:index];
    return pageContentViewController;
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;//  return [self.questions count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(void)btnNextDidTap;{
    // _currentPageIndex = _currentPageIndex + 1;
    
    //NSLog(@"%d %d", _currentPageIndex);
    //    ReviewPageContentVC *view = [self viewControllerAtIndex:index];
    //    [self.pageViewController setViewControllers:[NSArray arrayWithObject:view]direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
    //    }];
}



-(void)btnBackDidTap;{
    
}

-(void)showTagViewButton;{
    int count = 0;
    for(UIView *tagView in self.view.subviews){
        if([tagView isKindOfClass:[TagButtonView class]]){
            count++;
            [tagView removeFromSuperview];
            tagView.hidden = YES;
            NSLog(@"removed");
        }
    }
    if(count==0){
        CGFloat x = 0;
        CGFloat y = 300;
        CGFloat width = self.view.frame.size.width;
        CGFloat height = 100;
        TagButtonView *tagView= [TagButtonView tagViewWithFrame:CGRectMake(x, y, width, height)];
        tagView.center = self.viewPage.center;
        tagView.alpha = 0.5;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view addSubview:tagView];
            tagView.alpha = 1;
        }];
        
    }
}

@end
