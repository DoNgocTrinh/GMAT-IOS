//
//  QuestionSubType.m
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/9/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import "QuestionSubType.h"
#import "QuestionType.h"

@implementation QuestionSubType

// Insert code here to add functionality to your managed object subclass
+(instancetype)createSubTypeWithCode:(NSString *)code andDetail: (NSString *)detail;
{
    QuestionSubType *subtype = [QuestionSubType MR_createEntity];
    subtype.code = code;
    subtype.detail = detail;
    
    return subtype;
}
@end
