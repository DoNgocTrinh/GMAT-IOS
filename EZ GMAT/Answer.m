//
//  Answer.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "Answer.h"
#import "Question.h"
#import "MagicalRecord.h"

@implementation Answer

// Insert code here to add functionality to your managed object subclass

+ (instancetype)createAnswerWithJson:(NSDictionary *)jsonDict andQuestion:(Question *)question;
{
    Answer *newAnswer = [Answer MR_createEntity];
    
    newAnswer.question = question;
    newAnswer.index = [NSNumber numberWithInteger:[jsonDict[@"index"] integerValue]];
    newAnswer.choice = jsonDict[@"choice"];
    newAnswer.explanation = jsonDict[@"explanation"];
    newAnswer.note = jsonDict[@"note"];
    
    return newAnswer;
}

@end
