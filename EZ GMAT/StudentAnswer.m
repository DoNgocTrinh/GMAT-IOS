//
//  StudentAnswer.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "StudentAnswer.h"
#import "Question.h"

@implementation StudentAnswer

// Insert code here to add functionality to your managed object subclass

+ (instancetype)createStudentAnswerWithChoiceIndex:(NSInteger)index andQuestion:(Question *)question;
{
    
    StudentAnswer *newStudentAnswer = [StudentAnswer MR_createEntity];
    
    newStudentAnswer.question = question;
    newStudentAnswer.answerChoiceIdx = [NSNumber numberWithInteger:index];
    if ([question.rightAnswerIdx isEqualToNumber:newStudentAnswer.answerChoiceIdx]) {
        newStudentAnswer.result = Right;
    } else {
        newStudentAnswer.result = Wrong;
    }
    
    
    return newStudentAnswer;
}

@end
