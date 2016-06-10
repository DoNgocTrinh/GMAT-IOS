//
//  QuestionType.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/9/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "QuestionType.h"
#import "QuestionSubType.h"

@implementation QuestionType

// Insert code here to add functionality to your managed object subclass
+ (instancetype)createQuestionTypeWithJson:(NSDictionary *)jsonDict;
{
    QuestionType *newQuestionType = [QuestionType MR_createEntity];
    
    newQuestionType.code = jsonDict[@"code"];
    newQuestionType.detail = jsonDict[@"detail"];
    
    for (NSDictionary *subtype in jsonDict[@"sub_types"]) {
        QuestionSubType *newSubType = [QuestionSubType createSubTypeWithCode:subtype[@"code"] andDetail:subtype[@"detail"]];
        [newQuestionType.subTypes setByAddingObject:newSubType];
    }
    return newQuestionType;
}
@end
