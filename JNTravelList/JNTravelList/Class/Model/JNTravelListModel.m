//
//  JNTravelListModel.m
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import "JNTravelListModel.h"
#import "JNListDescription.h"
#import "MJExtension.h"

@implementation JNTravelListModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    self = [super init];
    if (self) {
//        NSLog(@"%@",dict );
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setListArr:(NSArray *)listArr{
    
//    NSLog(@"%@",listArr);
    
    NSMutableArray *ArrM = [NSMutableArray array];
    [listArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        JNListDescription *listDes = [JNListDescription mj_objectWithKeyValues:obj];
        
        [ArrM addObject:listDes];
    }];
    _listArr = ArrM;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if (self) {
        
        self.listImageName = [aDecoder decodeObjectForKey:@"listImageName"];
        self.listTitle = [aDecoder decodeObjectForKey:@"listTitle"];
        self.listArr = [aDecoder decodeObjectForKey:@"listArr"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.listImageName forKey:@"listImageName"];
    [aCoder encodeObject:self.listTitle forKey:@"listTitle"];
    [aCoder encodeObject:self.listArr forKey:@"listArr"];
    
}

- (NSString *)description{
    NSArray *keys = @[@"listImageName", @"listTitle", @"listArr"];
    return [self dictionaryWithValuesForKeys:keys].description;
}


@end
