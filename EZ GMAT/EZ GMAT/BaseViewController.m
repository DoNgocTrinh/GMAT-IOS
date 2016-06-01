//
//  BaseViewController.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
{
    NSArray *colorList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    colorList = [[NSArray alloc]initWithObjects:
                 @"#2d5139",
                 @"#2d3f51",
                 @"#462e52",
                 @"#4e512d",
                 @"#512d2d",
                 @"#2e524f",
                 @"#52432e",
                 @"#522e42",
                 @"#3c6b4c",
                 @"#3c6b4c",
                 @"#5b3c6b",
                 @"#676b3c",
                 @"#6b3c3c",
                 @"#3c6b67",
                 @"#6b573c",
                 @"#6b3c56",
                 nil];
    
   
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: kColor_background };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
