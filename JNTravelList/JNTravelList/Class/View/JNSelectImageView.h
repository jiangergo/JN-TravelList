//
//  JNSelectImageView.h
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNSelectImageView : UIView

@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) UIButton *selectImageButton;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName isSelect:(BOOL)isSelect;

@end
