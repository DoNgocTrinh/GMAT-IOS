//
//  QuestionID.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuestionPack;

NS_ASSUME_NONNULL_BEGIN

@interface QuestionID : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (instancetype)createAnswerWithStringID: (NSString *)stringID andQuestionPack:(QuestionPack *)questionPack;
@end

NS_ASSUME_NONNULL_END

#import "QuestionID+CoreDataProperties.h"
