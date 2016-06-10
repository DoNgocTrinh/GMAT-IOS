//
//  Question+CoreDataProperties.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/9/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Question.h"

NS_ASSUME_NONNULL_BEGIN

@interface Question (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *explanation;
@property (nullable, nonatomic, retain) NSString *questionId;
@property (nullable, nonatomic, retain) NSNumber *rightAnswerIdx;
@property (nullable, nonatomic, retain) NSString *stem;
@property (nullable, nonatomic, retain) NSString *stimulus;
@property (nullable, nonatomic, retain) NSString *subType;
@property (nullable, nonatomic, retain) NSNumber *tag;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSSet<Answer *> *answers;
@property (nullable, nonatomic, retain) NSSet<StudentAnswer *> *studentAnswer;

@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(Answer *)value;
- (void)removeAnswersObject:(Answer *)value;
- (void)addAnswers:(NSSet<Answer *> *)values;
- (void)removeAnswers:(NSSet<Answer *> *)values;

- (void)addStudentAnswerObject:(StudentAnswer *)value;
- (void)removeStudentAnswerObject:(StudentAnswer *)value;
- (void)addStudentAnswer:(NSSet<StudentAnswer *> *)values;
- (void)removeStudentAnswer:(NSSet<StudentAnswer *> *)values;

@end

NS_ASSUME_NONNULL_END
