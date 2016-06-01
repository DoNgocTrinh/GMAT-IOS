//
//  Question.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "Question.h"
#import "Answer.h"
#import "MagicalRecord.h"

@implementation Question

// Insert code here to add functionality to your managed object subclass

+ (instancetype)createQuestionWithJson:(NSDictionary *)jsonDict;
{
    Question *newQuestion = [Question MR_createEntity];
    
    newQuestion.questionId = jsonDict[@"_id"][@"oid"];
    newQuestion.type = jsonDict[@"type"];
    newQuestion.stimulus = jsonDict[@"stimulus"];
    newQuestion.stem = jsonDict[@"stem"];
    newQuestion.rightAnswerIdx = [NSNumber numberWithInteger:[jsonDict[@"right_answer"] integerValue]];
    newQuestion.answers = [[NSSet alloc]init];
    
    for (NSDictionary *answerChoice in jsonDict[@"answer_choices"]) {
        Answer *newAnswer = [Answer createAnswerWithJson:answerChoice andQuestion:newQuestion];
        [newQuestion.answers setByAddingObject:newAnswer];
    }
    return newQuestion;
}

@end
