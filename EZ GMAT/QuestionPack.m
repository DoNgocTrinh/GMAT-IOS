//
//  QuestionPack.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "QuestionPack.h"
#import "QuestionID.h"
#import "Question.h"

@implementation QuestionPack

// Insert code here to add functionality to your managed object subclass

+ (instancetype)createQuestionPackWithJson:(NSDictionary *)jsonDict;
{
    QuestionPack *newQuestionPack = [QuestionPack MR_createEntity];
    newQuestionPack.packID = jsonDict[@"_id"][@"oid"];
    newQuestionPack.available_time = jsonDict[@"available_time"];
    newQuestionPack.level = jsonDict[@"level"];
    newQuestionPack.totalTimeToFinish = [NSNumber numberWithFloat:0.0];
    for (NSString *stringID in jsonDict[@"question_ids"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(questionId=%@)", stringID];
        Question *newQuestion = [Question MR_findFirstWithPredicate:predicate];
        [newQuestionPack addQuestionsObject:newQuestion]
        ;
    }
    //   NSLog(@"Number of questions: %ld", newQuestionPack.questions.count);
    return newQuestionPack;
}
@end