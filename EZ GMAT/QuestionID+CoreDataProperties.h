//
//  QuestionID+CoreDataProperties.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 5/27/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "QuestionID.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionID (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *questionID;
@property (nullable, nonatomic, retain) QuestionPack *questionPack;

@end

NS_ASSUME_NONNULL_END
