//
//  JNListDataManager.m
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import "JNListDataManager.h"
#import "JNListDescription.h"
#import "MJExtension.h"


@implementation JNListDataManager{
    NSString *_pathStr;
}

+ (instancetype)sharedManager{
    
    static JNListDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JNListDataManager alloc]init];
    });
    return instance;
}

- (void)initData{
    
    _pathStr = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"travelList.data"];
    
    self.travelLists = [NSArray array];
    
    NSMutableArray *dataMArr = [NSMutableArray array];
    [[NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:_pathStr]] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JNTravelListModel *model = [JNTravelListModel mj_objectWithKeyValues:obj];
        [dataMArr addObject:model];
    }];
    
    self.travelLists = dataMArr.copy;
    
    
    
//    if (self.travelLists.count <= 0) {
//        
//        NSArray *dataArr = @[
//                             @{@"listImageName" : @"icon1", @"listTitle" : @"清单名称", @"listArr" : @[
//                                       @{@"isDone":@NO,@"descriptionStr":@"白色衬衣   2件"},
//                                       @{@"isDone":@NO,@"descriptionStr":@"西裤   1条"},
//                                       @{@"isDone":@YES,@"descriptionStr":@"西裤   1条"}]},
//                             @{@"listImageName" : @"icon2", @"listTitle" : @"清单名称"},
//                             @{@"listImageName" : @"icon3", @"listTitle" : @"清单名称",@"listArr" : @[
//                                       @{@"isDone":@YES,@"descriptionStr":@"白色衬衣   2件"},
//                                       @{@"isDone":@YES,@"descriptionStr":@"西裤   1条"},
//                                       @{@"isDone":@YES,@"descriptionStr":@"西裤   1条"}]}
//                             ];
//        
//        
//        NSMutableArray *Marr = [NSMutableArray array];
//        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            JNTravelListModel *model = [JNTravelListModel mj_objectWithKeyValues:obj];
//            [Marr addObject:model];
//        }];
//        
//        self.travelLists = Marr.copy;
//        
//        [NSKeyedArchiver archiveRootObject:dataArr toFile:_pathStr];
//    }
}

- (NSArray<JNTravelListModel *> *)travelLists{
    
    [self initData];
//    if (!_travelLists) {
//    }
    return _travelLists;
}

- (void)saveTravelListData{
    
    [self saveDataWithTravelLists:self.travelLists];
}

- (void)saveDataWithTravelLists:(NSArray *)travelList{
    
    NSMutableArray *dataArr = [NSMutableArray array];
    [travelList enumerateObjectsUsingBlock:^(JNListDescription *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JNListDescription *desModel = travelList[idx];
        NSDictionary *dict = desModel.mj_keyValues;
        [dataArr addObject:dict];
    }];
    
    [NSKeyedArchiver archiveRootObject:dataArr.copy toFile:_pathStr];
}

@end
