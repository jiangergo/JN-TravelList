//
//  JNListDataManager.h
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNTravelListModel.h"


@interface JNListDataManager : NSObject

@property (nonatomic, strong) NSArray <JNTravelListModel *>*travelLists;

@property (nonatomic, assign) BOOL isEditingCell;

+ (instancetype)sharedManager;

- (void)saveDataWithTravelLists:(NSArray *)travelList;

- (void)saveTravelListData;

@end
