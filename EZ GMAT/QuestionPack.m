//
//  QuestionPack.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "QuestionPack.h"
#import "QuestionID.h"

@implementation QuestionPack

// Insert code here to add functionality to your managed object subclass

+ (instancetype)createQuestionPackWithJson:(NSDictionary *)jsonDict;
{
    QuestionPack *newQuestionPack = [QuestionPack MR_createEntity];
    newQuestionPack.packID = jsonDict[@"_id"][@"oid"];
    newQuestionPack.available_time = jsonDict[@"available_time"];
    
    for (NSString *stringID in jsonDict[@"question_ids"]) {
        QuestionID *questionID = [QuestionID createAnswerWithStringID:stringID andQuestionPack:newQuestionPack];
        [newQuestionPack.questionIDs setByAddingObject:questionID];
    }
    //NSLog(@"Number of questions: %ld", newQuestionPack.questionIDs.count);
    return newQuestionPack;
}
@end