//
//  JNTravelListDescriptionViewController.h
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNTravelListModel.h"


@interface JNTravelListDescriptionViewController : UIViewController

@property (nonatomic, strong) JNTravelListModel *list;

@property (nonatomic, copy) void (^callBackListBlock)(JNTravelListModel *list);

@property (nonatomic, copy) void (^callBackCreateList)(JNTravelListModel *list);

@end
