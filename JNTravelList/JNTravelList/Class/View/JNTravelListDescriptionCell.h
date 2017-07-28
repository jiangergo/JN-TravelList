//
//  JNTravelListDescriptionCell.h
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNListDescription.h"

@interface JNTravelListDescriptionCell : UITableViewCell

@property (nonatomic, strong) JNListDescription *listDescription;

- (void)selectCell;

@end
