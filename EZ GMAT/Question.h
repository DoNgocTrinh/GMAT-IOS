//
//  Question.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answer, StudentAnswer;

NS_ASSUME_NONNULL_BEGIN

@interface Question : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (instancetype)createQuestionWithJson:(NSDictionary *)jsonDict;
@end

NS_ASSUME_NONNULL_END

#import "Question+CoreDataProperties.h"
