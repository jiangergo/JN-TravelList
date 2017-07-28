//
//  JNTravelListModel.h
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNTravelListModel : NSObject <NSCoding>


@property (nonatomic, copy) NSString *listImageName;

@property (nonatomic, copy) NSString *listTitle;

@property (nonatomic, strong) NSArray *listArr;



- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
