//
//  QuestionType+CoreDataProperties.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/9/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "QuestionType.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionType (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSSet<QuestionSubType *> *subTypes;

@end

@interface QuestionType (CoreDataGeneratedAccessors)

- (void)addSubTypesObject:(QuestionSubType *)value;
- (void)removeSubTypesObject:(QuestionSubType *)value;
- (void)addSubTypes:(NSSet<QuestionSubType *> *)values;
- (void)removeSubTypes:(NSSet<QuestionSubType *> *)values;

@end

NS_ASSUME_NONNULL_END
