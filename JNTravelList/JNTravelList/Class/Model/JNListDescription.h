//
//  JNListDescription.h
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNListDescription : NSObject<NSCoding>

@property (nonatomic, assign) BOOL isDone;

@property (nonatomic, copy) NSString *descriptionStr;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
