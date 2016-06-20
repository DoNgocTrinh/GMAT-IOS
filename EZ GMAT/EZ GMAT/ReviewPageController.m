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
    int i;
}
@property UIImage *img;

@end

@implementation ReviewPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vTag.layer.borderWidth = 0.5;
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
    [_pageViewController.view setFrame:CGRectMake(_viewPage.bounds.origin.x, _viewPage.bounds.origin.y, _viewPage.bounds.size.width, _viewPage.bounds.size.height)];
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
    [self checkTagForQuestion:pageContentViewController.question];
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
    NSLog(@"questio tag %ld %ld",_currentPageIndex,[[(Question *)_questions[_currentPageIndex] tag] integerValue]);
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
        [tagView.btnRed addTarget:self action:@selector(redClick) forControlEvents:UIControlEventTouchUpInside];
        [tagView.btnGreen addTarget:self action:@selector(greenClick) forControlEvents:UIControlEventTouchUpInside];
        [tagView.btnYellow addTarget:self action:@selector(yellowClick) forControlEvents:UIControlEventTouchUpInside];
        [tagView.btnStar addTarget:self action:@selector(starClick) forControlEvents:UIControlEventTouchUpInside];
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
    if (sender.state == UIGestureRecognizerStateEnded) {
        for(UIView *tagView in self.view.subviews){
            if([tagView isKindOfClass:[TagButtonView class]]){
                [tagView removeFromSuperview];
                tagView.hidden = YES;
            }
        }
    }
}

-(void)share;{
    [TagButtonView showShareInViewController:self andWithView:_viewPage];
}
-(void)setTag:( NSInteger)tagNo forQuestion:(Question *)question;{
    NSPredicate *querry = [NSPredicate predicateWithFormat:@"self = %@", question];
    Question *questionDB = [Question MR_findFirstWithPredicate:querry];
    if(questionDB){
        if([question.tag integerValue]!=tagNo){
            questionDB.tag = [NSNumber numberWithInteger:tagNo];
        }
        else{
            questionDB.tag = [NSNumber numberWithInteger:-1];
        }
        [self checkTagForQuestion:questionDB];
        NSLog(@"tag of question %ld", [questionDB.tag integerValue]);
    }
    [self removeTagView];
}
-(void)removeTagView;{
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    for(UIView *tagView in self.view.subviews){
        if([tagView isKindOfClass:[TagButtonView class]]){
            [tagView removeFromSuperview];
            tagView.hidden = YES;
        }
    }
}
-(void)checkTagForQuestion:(Question *)question;{
    switch ([question.tag integerValue]) {
        case -1:
            self.imgTag.image = [UIImage imageNamed:@"grey"];
            break;
        case 0:
            self.imgTag.image = [UIImage imageNamed:@"red"];
            break;
        case 1:
            self.imgTag.image = [UIImage imageNamed:@"green"];
            break;
        case 2:
            self.imgTag.image = [UIImage imageNamed:@"yellow"];
            break;
            
        default:
            self.imgTag.image = [UIImage imageNamed:@"grey"];
            break;
    }
    switch ([question.bookMark integerValue]) {
        case 1:
            self.imgStar.image = [UIImage imageNamed:@"star"];
            break;
            
        default:
            self.imgStar.image = [UIImage imageNamed:@"nostar"];
            break;
    }
    
}

-(void)redClick{
    Question *selectedQuestion = (Question*)_questions[_currentPageIndex];
    [self setTag: 0 forQuestion:selectedQuestion];
}

-(void)greenClick{
    Question *selectedQuestion = (Question*)_questions[_currentPageIndex];
    [self setTag: 1 forQuestion:selectedQuestion];
}

-(void)yellowClick{
    Question *selectedQuestion = (Question*)_questions[_currentPageIndex];
    [self setTag: 2 forQuestion:selectedQuestion];
}

-(void)starClick{
    if(i%2 == 0){
        self.imgStar.image = [UIImage imageNamed:@"star"];
    }else{
        self.imgStar.image = [UIImage imageNamed:@"nostar"];
    }
    i++;
    Question *selectedQuestion = (Question*)_questions[_currentPageIndex];
    NSPredicate *querry = [NSPredicate predicateWithFormat:@"self = %@", selectedQuestion];
    Question *questionDB = [Question MR_findFirstWithPredicate:querry];
    if(questionDB){
        questionDB.bookMark = [NSNumber numberWithInteger:(i%2)];
        NSLog(@"bookMark of question %ld", [questionDB.bookMark integerValue]);
        [self checkTagForQuestion:questionDB];
    }
    [self removeTagView];
    
}


@end
