//
//  JNTravelListCell.h
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/19.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNTravelListModel.h"

typedef NS_ENUM(NSInteger, JNTravelListType) {
    JNTravelListTypeList = 0,
    JNTravelListTypeAdd
};

@interface JNTravelListCell : UICollectionViewCell

@property (nonatomic, assign) JNTravelListType cellType;

@property (nonatomic, strong) JNTravelListModel *model;

@property (nonatomic, assign) BOOL isEditingCell;

//@property (nonatomic, copy) void (^callBackLongPress)(UILongPressGestureRecognizer *longPress);

@property (nonatomic, copy) void (^deleteCellBlock)(JNTravelListModel *model);

- (void)deleteButtonHidden;

@end
