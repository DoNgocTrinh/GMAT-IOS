//
//  Constant.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//
//


#ifndef Constant_h
#define Constant_h


#define kWidth_LeftSide                                  265.0f
#define kHeighQuesionWebView                             160.0f

//MARK: Title

#define kTitle_MainView                                 @"GMAT"

//MARK: Color

#define kColor_NavigationBarBackground                  [UIColor orangeColor]
#define kColor_background                               [UIColor whiteColor]

#define kColor_Window                                   [UIColor whiteColor]

#define kAppColor      [UIColor hx_colorWithHexRGBAString: @"#CA6924"]
#define kGreenColor    [UIColor colorWithRed:63.0/255  green:175.0/255 blue:102.0/255 alpha:1.0]
#define kSelectedColor  [UIColor hx_colorWithHexRGBAString:@"#FFECB3"];
//MARK: API

#define kGmatAPIExploreQuestionUrl                      @"https://g-service.herokuapp.com/api/questions"

#define kGmatAPIExploreQuestionPackUrl                  @"https://g-service.herokuapp.com/api/question_packs"

#define kGmatAPIExploreQuestionTypeURL                  @"https://g-service.herokuapp.com/api/question_type"

#define kGmatAPIVersionUrl                              @"https://g-service.herokuapp.com/api/version"

//MARK: Image

#define kImage_TableQuestionPacksBackground             @"LoginBackground"

#define kImage_LoginBackGround                          @"LoginBackground"

#define kImage_LoginAreaBackground                      @"LoginAreaBackground"

#define kImage_Logo                                     @"iliatLogo"

#define kImage_BtnLoginBackground                       @"Background Login"

#define kImage_AnswerA                                  @"a"
#define kImage_AnswerB                                  @"b"
#define kImage_AnswerC                                  @"c"
#define kImage_AnswerD                                  @"d"
#define kImage_AnswerE                                  @"e"

#define kImage_Right                                    @"Right"
#define kImage_Wrong                                    @"Wrong"

//MARK: Database

#define kDatabaseName                                   @"GMATDatabase"


#endif /* Constant_h */
