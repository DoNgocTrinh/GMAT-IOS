//
//  QuestionSubType.h
//  EZ GMAT
//
//  Created by Do Ngoc Trinh on 6/9/16.
//  Copyright © 2016 Do Ngoc Trinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuestionType;

NS_ASSUME_NONNULL_BEGIN

@interface QuestionSubType : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(instancetype)createSubTypeWithCode:(NSString *)code andDetail: (NSString *)detail;
@end

NS_ASSUME_NONNULL_END

#import "QuestionSubType+CoreDataProperties.h"
