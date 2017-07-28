//
//  JNSelectImageView.m
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import "JNSelectImageView.h"

@implementation JNSelectImageView{
//    UIImageView *_selectImageView;
//    UIButton *_selectImageButton;
}

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName isSelect:(BOOL)isSelect{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _selectImageView = [[UIImageView alloc]init];
        _selectImageView.image = [UIImage imageNamed:imageName];
        [self addSubview:_selectImageView];
        
        _selectImageButton = [[UIButton alloc]init];
        [_selectImageButton setBackgroundImage:[UIImage imageNamed:@"gouxuan2"] forState:UIControlStateNormal];
        [_selectImageButton setBackgroundImage:[UIImage imageNamed:@"gouxuan1"] forState:UIControlStateSelected];
        _selectImageButton.userInteractionEnabled = NO;
        _selectImageButton.selected = isSelect;
        [self addSubview:_selectImageButton];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    _selectImageView.frame = CGRectMake((self.frame.size.width-44*kRATE)/2, 0, 44*kRATE, 44*kRATE);
    _selectImageButton.frame = CGRectMake(CGRectGetMidX(_selectImageView.frame)-12*kRATE/2, CGRectGetMaxY(_selectImageView.frame)+15*kRATE, 12*kRATE, 12*kRATE);
    
}

@end
