//
//  QuestionItem.h
//  VocabularyStudyForChild_Objective-C
//
//  Created by Mac on 2016. 8. 6..
//  Copyright © 2016년 Hosung, Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionItem : NSObject
@property (strong, nonatomic) NSString* question;
@property (strong, nonatomic)  NSString* question_type;
@property (strong, nonatomic)  NSString* question_img;
@property (strong, nonatomic)  NSMutableDictionary<NSString*, NSString*>* answers;
@property (strong, nonatomic)  NSString* collect_answer;
@property (strong, nonatomic)  NSString* user_answer;
@end
