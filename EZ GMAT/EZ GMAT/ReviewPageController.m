//
//  ReviewPageController.m
//  GMAT
//
//  Created by Do Ngoc Trinh on 5/13/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "ReviewPageController.h"
#import "ReviewPageContentVC.h"

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
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
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

@end
