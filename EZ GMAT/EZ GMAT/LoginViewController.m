//
//  LoginViewController.m
//  GMAT
//
//  Created by Trung Đức on 3/12/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "LoginViewController.h"
#import "Constant.h"
#import "AppDelegate.h"

#import "HomeViewController.h"

#import "MMDrawerController.h"
#import "GmatAPI.h"

#define kPlaceHolerLabelTexColorKeyPath                 @"_placeholderLabel.textColor"

@interface LoginViewController ()

#define SKIP_LOGIN 0

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [sGmatAPI exploreQuestionTypeWithCompletionBlock:^(NSArray *questionType) {
        
    }];
    // Do any additional setup after loading the view.
    
    _imvLoginBackGround.image = [UIImage imageNamed:kImage_LoginBackGround];
    _imvLoginAreBackground.image = [UIImage imageNamed:kImage_LoginAreaBackground];//kImage_LoginAreaBackground];
    _imvLogo.image = [UIImage imageNamed:kImage_Logo];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.txtEmail setValue:[UIColor whiteColor]
                 forKeyPath:kPlaceHolerLabelTexColorKeyPath];
    [self.txtPassword setValue:[UIColor whiteColor]
                    forKeyPath:kPlaceHolerLabelTexColorKeyPath];
    
    _txtEmail.delegate = self;
    _txtPassword.delegate = self;
    
    //    _txtEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    //    _txtPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //animation logo
    CATransition* transitionLogo = [CATransition animation];
    transitionLogo.duration = 1.3f;
    transitionLogo.type = kCATransitionMoveIn;
    transitionLogo.subtype = kCATransitionFromBottom;
    [_imvLogo.layer addAnimation:transitionLogo forKey:kCATransition];
    
    [self configView];
}

#pragma mark - TextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _txtEmail) {
        
        [self dismissKeyboard];
        
    } else {
        
        [self dismissKeyboard];
        
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Class Funtion

-(void)dismissKeyboard {
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

- (IBAction)btnLoginDidTouch:(id)sender {
  //  [self configView];
    [self loginAction];
}
#pragma mark - Left Menu
-(void)configView;{
    
    //config button
    _btnLogin.layer.cornerRadius = 10.0f;
    _btnLogin.clipsToBounds = YES;
    _btnLogin.backgroundColor = kAppColor;
   // MainViewController *mainViewController = [MainViewController sharedInstance];
    
  //  HomeViewController *home= [
    //                           HomeViewController sharedInstance];
    
   // UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    //setUP leftview
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:home];
//    
//    
//    LeftSideViewController * leftSideViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftSide"];
//    
//    //Create and config drawerController
//    self.drawerController = [[MMDrawerController alloc]
//                             initWithCenterViewController:navigationController
//                             leftDrawerViewController:leftSideViewController];
//    [self.drawerController setShowsShadow:YES];
//    [self.drawerController setMaximumLeftDrawerWidth:kWidth_LeftSide];
//    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}

#pragma mark Login Action
-(void)loginAction;{
    //activity indicator
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:loadingView];
    loadingView.hidesWhenStopped = YES;
    loadingView.center = self.view.center;
    [loadingView startAnimating];
    
    [_btnLogin setEnabled:NO];
    
    //send request and receive login result
#if SKIP_LOGIN == 0
    
    [self gotoHomeView];
#else
    
    NSDictionary *account = [self trimUsername: _txtEmail.text andPassword:_txtPassword.text];
    NSString *username = (NSString*)account[@"username"];
    NSString *password = (NSString*)account[@"password"];
    
    if(username.length == 0 || password.length == 0){
        [self notifyLoginFailWithTitle:@"Invalid input" andMessage:@"Please fill full username and password"];
        
        [_btnLogin setEnabled:YES];
        [loadingView stopAnimating];
        
    }else{
        
        [sGmatAPI postLoginWithUsername:username andPassword:password withCompletionBlock:^(int loginStatus) {
            switch (loginStatus) {
                case 1:
                    NSLog(@"LoginSuccess");
                    
                    [self gotoHomeView];
                    break;
                case 0:
                    NSLog(@"Wrong acc");
                    [self notifyLoginFailWithTitle:@"Login Fail" andMessage:@"Wrong passord or username"];
                    break;
                case -1:
                    NSLog(@"Connection Fail");
                    [self notifyLoginFailWithTitle:@"Login Fail" andMessage:@"Please network connection"];
                    break;
                default:
                    //  [self notifyLoginFailWithTitle:@"ERROR" andMessage:@"Please contact to developer"];
                    break;
            }
            
            [_btnLogin setEnabled:YES];
            
            [loadingView stopAnimating];
        }];
    }
#endif
    
    
}
-(void)gotoHomeView;{
    NSLog(@"GO TO HOMEVIEW");
    
//    [self presentViewController:_drawerController animated:YES completion:^{
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate.window setRootViewController:self.drawerController];
//    }];
    
//    [sGmatAPI exploreQuestionPacksWithCompletionBlock:^(NSArray *questionPacks) {
//       
//    }];
//    [sGmatAPI exploreQuestionWithCompletionBlock:^(NSArray *question) {
//        
//    }];
    HomeViewController *home= [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:home];
    navigationController.navigationBar.translucent = NO;
    [self presentViewController:navigationController animated:YES completion:^{
        
    }];
    
}

-(void)notifyLoginFailWithTitle:(NSString*)title andMessage:(NSString*)message;{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSDictionary *)trimUsername: (NSString*)username andPassword: (NSString*)password;{
    
    NSString *trimUsername = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimPassword = password;//[password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    trimUsername = [trimUsername stringByTrimmingCharactersInSet: [NSCharacterSet punctuationCharacterSet]];
    //trimPassword = [trimPassword stringByTrimmingCharactersInSet: [NSCharacterSet punctuationCharacterSet]];
    NSDictionary *validAccount = @{@"username":trimUsername,@"password":trimPassword};
    return validAccount;
}
@end
