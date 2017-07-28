//
//  JNTravelListDescriptionCell.m
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import "JNTravelListDescriptionCell.h"

@implementation JNTravelListDescriptionCell{
    UIButton *_selectButton;
    UILabel *_descriptionLabel;
    UIView *_doneLineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{
    
    _selectButton = [[UIButton alloc]init];
    [_selectButton setBackgroundImage:[UIImage imageNamed:@"gouxuan2"] forState:UIControlStateNormal];
    [_selectButton setBackgroundImage:[UIImage imageNamed:@"gouxuan1"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.hidden = YES;
    [self.contentView addSubview:_selectButton];
    
    _descriptionLabel = [[UILabel alloc]init];
    _descriptionLabel.font = [UIFont systemFontOfSize:14*kRATE];
    _descriptionLabel.textColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.00];

    [self.contentView addSubview:_descriptionLabel];
    
    _doneLineView = [[UIView alloc]init];
    _doneLineView.backgroundColor = _descriptionLabel.textColor;
    _doneLineView.hidden = YES;
    [self.contentView addSubview:_doneLineView];
    
}

- (void)selectButtonAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    _doneLineView.hidden = !sender.selected;
    self.listDescription.isDone = sender.selected;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _selectButton.frame = CGRectMake(28*kRATE, 10*kRATE, 14*kRATE, 14*kRATE);
    _descriptionLabel.frame = CGRectMake(CGRectGetMaxX(_selectButton.frame)+13*kRATE, 0, 100, self.bounds.size.height);
    [_descriptionLabel sizeToFit];
    CGPoint desLabelCenter = _descriptionLabel.center;
    desLabelCenter.y = _selectButton.center.y;
    _descriptionLabel.center = desLabelCenter;
    
    _doneLineView.frame = CGRectMake(_descriptionLabel.frame.origin.x, CGRectGetMidY(_descriptionLabel.frame)-1, _descriptionLabel.bounds.size.width, 1);
}

- (void)setListDescription:(JNListDescription *)listDescription{
    _listDescription = listDescription;
    
    _selectButton.hidden = listDescription == nil ? YES : NO;
    _selectButton.selected = listDescription.isDone;
    
    _doneLineView.hidden = !listDescription.isDone;
    _descriptionLabel.hidden = _selectButton.hidden;
    _descriptionLabel.text = listDescription.descriptionStr;
    
}

- (void)selectCell{
    
    [self selectButtonAction:_selectButton];
}

@end
