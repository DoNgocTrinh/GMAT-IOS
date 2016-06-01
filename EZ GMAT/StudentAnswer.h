//
//  StudentAnswer.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define Right                       [NSNumber numberWithInt:1]
#define Wrong                       [NSNumber numberWithInt:0]


@class Question;

NS_ASSUME_NONNULL_BEGIN

@interface StudentAnswer : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (instancetype)createStudentAnswerWithChoiceIndex:(NSInteger)index andQuestion:(Question *)question;

@end

NS_ASSUME_NONNULL_END

#import "StudentAnswer+CoreDataProperties.h"
