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
{
    
}
@property UIImage *img;

@end

@implementation ReviewPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create Share-Button:
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(share)];
    
    self.navigationItem.rightBarButtonItem = shareButton;
    
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
    [_btnBack addTarget:self action:@selector(btnBackDidTap) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSInteger index = ((ReviewPageContentVC*) viewController).pageindex;
     _currentPageIndex = index;
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
    _currentPageIndex = index;
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
    _currentPageIndex = (_currentPageIndex + 1)%_questions.count;
   
    self.navigationItem.title = [NSString stringWithFormat:@"%lu/%ld",_currentPageIndex+1,_questions.count];
    ReviewPageContentVC *view = [self viewControllerAtIndex:_currentPageIndex];
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:view]direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
    }];
}



-(void)btnBackDidTap;{
    if(_currentPageIndex ==0 )
        _currentPageIndex = 10;
    _currentPageIndex = (_currentPageIndex - 1)%_questions.count;
    
    NSLog(@"Back %ld", (long)_currentPageIndex);
    
    self.navigationItem.title = [NSString stringWithFormat:@"%lu/%ld",_currentPageIndex+1,_questions.count];
    ReviewPageContentVC *view = [self viewControllerAtIndex:_currentPageIndex];
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:view]direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
    }];
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
        CGFloat y = 0;
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height;
        TagButtonView *tagView= [TagButtonView tagViewWithFrame:CGRectMake(x, y, width, height)];
        tagView.center = self.viewPage.center;
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.view addSubview:tagView];
            
        } completion:^(BOOL finished) {
            
        }];
        UITapGestureRecognizer *tapGR;
        tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGR.numberOfTapsRequired = 1;
        [tagView addGestureRecognizer:tapGR];
    }
    
}

-(void)handleTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"dmm®");
    if (sender.state == UIGestureRecognizerStateEnded) {
        for(UIView *tagView in self.view.subviews){
            if([tagView isKindOfClass:[TagButtonView class]]){
                [tagView removeFromSuperview];
                tagView.hidden = YES;
                NSLog(@"removed");
            }
        }
    }
}
-(void)share;{
    [TagButtonView showShareInViewController:self andWithView:_viewPage];
}
@end
