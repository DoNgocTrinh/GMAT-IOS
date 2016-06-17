//
//  QuestionPack+CoreDataProperties.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/17/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "QuestionPack.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionPack (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *available_time;
@property (nullable, nonatomic, retain) NSNumber *level;
@property (nullable, nonatomic, retain) NSString *packID;
@property (nullable, nonatomic, retain) NSNumber *totalTimeToFinish;
@property (nullable, nonatomic, retain) NSSet<Question *> *questions;

@end

@interface QuestionPack (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet<Question *> *)values;
- (void)removeQuestions:(NSSet<Question *> *)values;

@end

NS_ASSUME_NONNULL_END
