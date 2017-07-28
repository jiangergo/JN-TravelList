//
//  JNTravelListCell.m
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/19.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import "JNTravelListCell.h"

@interface JNTravelListCell () <UIAlertViewDelegate>

@end

@implementation JNTravelListCell{
    UIImageView *_listImageView;
    UILabel *_listTitlelabel;
    UIButton *_deleteCellButton;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
     
        [self setupUI];
    }
    return self;
}

- (void)deleteButtonHidden{
    _deleteCellButton.hidden = YES;
}

- (void)deleteCellAction:(UIButton *)sender{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"你确定要删除旅行清单‘%@’吗?",self.model.listTitle] message:@"删除此清单的同时删除其数据" delegate: self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alertView.delegate = self;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        if (self.deleteCellBlock) {
            self.deleteCellBlock(self.model);
        }
    }
    
    
}


- (void)setupUI{
    
    _listImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_listImageView];
    
    _listTitlelabel = [[UILabel alloc]init];
    _listTitlelabel.textAlignment = NSTextAlignmentCenter;
    _listTitlelabel.font = [UIFont systemFontOfSize:14*kRATE];
    _listTitlelabel.textColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.00];
    [self.contentView addSubview:_listTitlelabel];
    
    _deleteCellButton = [[UIButton alloc]init];
//    [_deleteCellButton setTitle:@"x" forState:UIControlStateNormal];
//    [_deleteCellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_deleteCellButton setBackgroundImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    _deleteCellButton.hidden = YES;
    [_deleteCellButton addTarget:self action:@selector(deleteCellAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteCellButton];
}

- (void)setCellType:(JNTravelListType)cellType{
    
    _cellType = cellType;
    
    if (cellType == JNTravelListTypeAdd) {
        _listTitlelabel.hidden = YES;
        _listImageView.image = [UIImage imageNamed:@"icon0"];
    }
}

- (void)setModel:(JNTravelListModel *)model{
    _model = model;
    
    _listTitlelabel.hidden = NO;
    _listTitlelabel.text = model.listTitle;
    _listImageView.image = [UIImage imageNamed:model.listImageName];
//    [_deleteCellButton setTitle:@"x" forState:UIControlStateNormal];
    
}

- (void)setIsEditingCell:(BOOL)isEditingCell{
    _isEditingCell = isEditingCell;
    if (self.cellType == JNTravelListTypeAdd) {
        _deleteCellButton.hidden = YES;
        return;
    }
    _deleteCellButton.hidden = !isEditingCell;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    _listImageView.frame = CGRectMake(30*kRATE, 12*kRATE, self.bounds.size.width-(60*kRATE), self.bounds.size.width-(60*kRATE));
    _listTitlelabel.frame = CGRectMake(0, CGRectGetMaxY(_listImageView.frame), self.bounds.size.width, 40*kRATE);
    _deleteCellButton.frame = CGRectMake(CGRectGetMaxX(_listImageView.frame), _listImageView.frame.origin.y - 12*kRATE, 24*kRATE, 24*kRATE);
}



@end
