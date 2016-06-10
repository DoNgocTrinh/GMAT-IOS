//
//  QuestionType.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/9/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuestionSubType;

NS_ASSUME_NONNULL_BEGIN

@interface QuestionType : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (instancetype)createQuestionTypeWithJson:(NSDictionary *)jsonDict;
@end

NS_ASSUME_NONNULL_END

#import "QuestionType+CoreDataProperties.h"
