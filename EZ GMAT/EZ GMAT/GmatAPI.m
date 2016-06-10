//
//  GmatAPI.m
//  GMAT
//
//  Created by Trung Đức on 3/12/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "GmatAPI.h"
#import "AFNetworking/AFNetworking.h"
#import "Constant.h"
#import "Question.h"
#import "QuestionPack.h"
#import "QUestionType.h"
#import "MagicalRecord/MagicalRecord.h"



@interface GmatAPI ()

@property NSURLSessionConfiguration *configuration;
@property AFHTTPSessionManager *httpSessionManager;

@end


@implementation GmatAPI

+ (instancetype)sharedInstance;
{
    static dispatch_once_t onceToken;
    static GmatAPI *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GmatAPI alloc]init];
    });
    
    return sharedInstance;
    
}

- (instancetype)init;
{
    self = [super init];
    
    if (self) {
        
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _httpSessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:_configuration];
        
        _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", nil];
        
        
    }
    
    return self;
}


- (void)exploreQuestionWithCompletionBlock:(void(^)(NSArray *question))completion;
{
    
    [_httpSessionManager GET:kGmatAPIVersionUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion && responseObject) {
            NSString *currentVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"version"]];
            
            NSString *apiVersion = [NSString stringWithFormat:@"%@",responseObject[@"value"][0] ];
            
            if (![currentVersion isEqualToString:apiVersion]) {
                
                [_httpSessionManager GET:kGmatAPIExploreQuestionUrl
                              parameters:nil
                                progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                     
                                     [Question MR_truncateAll];
                                     
                                     for (NSDictionary *jsonDict in responseObject[@"questions"]) {
                                         [Question createQuestionWithJson:jsonDict];
                                     }
                                     
                                     [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave,NSError* error) {
                                         NSLog(@"\n\nQUESTIONS SAVED !!!\n\n");
                                     }];
                                     
                                     [[NSUserDefaults standardUserDefaults]setObject:apiVersion forKey:@"version"];
                                     
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                     
                                     NSLog(@"So cau hoi %lu",(unsigned long)[Question MR_countOfEntities]);
                                     
                                     completion(responseObject[@"questions"]);
                                     
                                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     if (error) {
                                         NSLog(@"error: %@",error);
                                     }
                                 }];
            } else{
                NSLog(@"\n\nVERSION IS UPDATED!!\n\n");
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"error: %@",error);
        }
    }];
}


- (void)exploreQuestionPackWithCompletionBlock:(void(^)(NSArray *questionPacks))completion;
{
    
    NSURLSessionDataTask *dataTask = [_httpSessionManager GET:kGmatAPIExploreQuestionPackUrl
                                                   parameters:nil
                                                     progress:nil
                                                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                          
                                                          if (completion && responseObject) {
                                                              completion(responseObject[@"question_packs"]);
                                                          }
                                                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                          if (error) {
                                                              NSLog(@"error: %@",error);
                                                          }
                                                      }];
    [dataTask resume];
}

- (void)exploreQuestionPacksWithCompletionBlock:(void(^)(NSArray *question))completion;
{
    
    [_httpSessionManager GET:kGmatAPIVersionUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion && responseObject) {
            NSString *currentVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"version"]];
            NSString *apiVersion = [NSString stringWithFormat:@"%@",responseObject[@"value"][0] ];
            
            if (![currentVersion isEqualToString:apiVersion]) {
                NSURLSessionTask *datatask = [_httpSessionManager GET:kGmatAPIExploreQuestionPackUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if(completion && responseObject){
                        
                        [QuestionPack MR_truncateAll];
                        
                        for (NSDictionary *question_pack in responseObject[@"question_packs"]) {
                            [QuestionPack createQuestionPackWithJson:question_pack];
                        }
                        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave,NSError* error) {
                            NSLog(@"\nQUESTION PACK SAVED !!!!\n\n");
                        }];
                        completion(responseObject[@"question_packs"]);
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"_____________ERROR______________: %@", error);
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please check network connection to update" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
                    
                }];
                
                [datatask resume];
            }
            else{
                NSLog(@"\n\nVERSION IS UPDATED!!\n\n");
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"error: %@",error);
        }
    }];
}
#pragma mark - getQuestionType
- (void)exploreQuestionTypeWithCompletionBlock:(void(^)(NSArray *questionType))completion;
{
    
    [_httpSessionManager GET:kGmatAPIVersionUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion && responseObject) {
            NSString *currentVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"version"]];
            NSString *apiVersion = [NSString stringWithFormat:@"%@",responseObject[@"value"][0] ];
            
            if ([currentVersion isEqualToString:apiVersion]) {
                NSURLSessionTask *datatask = [_httpSessionManager GET:kGmatAPIExploreQuestionTypeURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if(completion && responseObject){
                        
                        [QuestionType MR_truncateAll];
                        
                        for (NSDictionary *questionType in responseObject[@"type"]) {
                            
                            [QuestionType createQuestionTypeWithJson:questionType];
                        }
                        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave,NSError* error) {
                            NSLog(@"\nQUESTION TYPE SAVED !!!!\n\n");
                        }];
                        completion(responseObject[@"type"]);
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"_____________ERROR______________: %@", error);
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please check network connection to update" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
                    
                }];
                
                [datatask resume];
            }
            else{
                NSLog(@"\n\nVERSION IS UPDATED!!\n\n");
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"error: %@",error);
        }
    }];
}
#pragma mark - Login
-(void)postLoginWithUsername:(NSString*)username andPassword:(NSString*)password withCompletionBlock:(void(^)(int loginStatus))completion
{
    
    [_httpSessionManager.requestSerializer setTimeoutInterval:5.0f];
    [_httpSessionManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [_httpSessionManager setResponseSerializer:responseSerializer];
    [_httpSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"charset=utf-8", nil];
    
    NSDictionary *acc = @{@"username":username, @"password":password};
    
    [_httpSessionManager POST:@"https://g-service.herokuapp.com/api/login" parameters:acc constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(completion&&responseObject)
        {
            if([[NSString stringWithFormat:@"%@",responseObject[@"login_status"]] isEqualToString:@"1"])
            {
                completion(1); //sucess
            }
            else{
                completion(0); //wrong acc
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(-1); //error or no connection
    }];
    
}

@end
