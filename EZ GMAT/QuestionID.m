//
//  QuestionID.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//


#import "QuestionID.h"
#import "QuestionPack.h"
#import "MagicalRecord.h"

@implementation QuestionID

// Insert code here to add functionality to your managed object subclass
+ (instancetype)createAnswerWithStringID: (NSString *)stringID andQuestionPack:(QuestionPack *)questionPack;
{
    QuestionID *newQuestionID = [QuestionID MR_createEntity];
    newQuestionID.questionPack = questionPack;
    newQuestionID.questionID = stringID;
    
    return newQuestionID;
}
@end
