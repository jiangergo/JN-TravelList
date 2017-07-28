//
//  JNListDescription.m
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import "JNListDescription.h"

@implementation JNListDescription

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        NSLog(@"%@",dict);
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if (self) {
        
        self.isDone = [aDecoder decodeBoolForKey:@"isDone"];
        self.descriptionStr = [aDecoder decodeObjectForKey:@"descriptionStr"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeBool:self.isDone forKey:@"isDone"];
    [aCoder encodeObject:self.descriptionStr forKey:@"descriptionStr"];
}

- (NSString *)description{
    NSArray *keys = @[@"isDone", @"descriptionStr"];
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
