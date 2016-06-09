//
//  LoginViewController.h
//  GMAT
//
//  Created by Trung Đức on 3/12/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController/MMDrawerController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imvLoginBackGround;
@property (weak, nonatomic) IBOutlet UIImageView *imvLogo;
@property (weak, nonatomic) IBOutlet UIImageView *imvLoginAreBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (nonatomic,strong) MMDrawerController * drawerController;


@end
