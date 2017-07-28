//
//  JNCreateTravelListViewController.m
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import "JNCreateTravelListViewController.h"
#import "JNTravelListDescriptionViewController.h"
#import "JNSelectImageView.h"
#import "MBProgressHUD.h"

@interface JNCreateTravelListViewController ()<UITextFieldDelegate>

/// 图片的名字
@property (nonatomic, strong) NSArray <NSString *>*listImageNames;

/// 上次选择的图片
@property (nonatomic, strong) JNSelectImageView *selectImage;


@property (nonatomic, strong) JNTravelListModel *list;

@end

@implementation JNCreateTravelListViewController{
    UITextField *_listTitleTextField;
    UIButton *_nextButton;
}

- (JNTravelListModel *)list{
    if (!_list) {
        _list = [[JNTravelListModel alloc]init];
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建清单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.listImageNames = @[@"icon1",@"icon2",@"icon3"];
    
    [self setupViewUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listTextFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)listTextFieldChange:(NSNotification *)info{
    
    NSString *textFieldStr = [_listTitleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textFieldStr.length > 0 && _listTitleTextField.text.length <= 8 && self.selectImage) {
        _nextButton.selected = NO;
    }else{
        _nextButton.selected = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


- (void)setupViewUI{
    
    _listTitleTextField = [[UITextField alloc]initWithFrame:CGRectMake(24*kRATE, 64 + 29*kRATE, kSCREENW-24*kRATE *2, 33*kRATE)];
    _listTitleTextField.leftViewMode = UITextFieldViewModeAlways;
    _listTitleTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 32*kRATE)];
    _listTitleTextField.placeholder = @"请输入清单名称（必填）";
    _listTitleTextField.font = [UIFont systemFontOfSize:12*kRATE];
    _listTitleTextField.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    _listTitleTextField.layer.borderWidth = 0.8;
    _listTitleTextField.layer.borderColor = [[UIColor colorWithRed:0.58 green:0.57 blue:0.57 alpha:1.00]CGColor];
    _listTitleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _listTitleTextField.delegate = self;
    [self.view addSubview:_listTitleTextField];
    
    
    UILabel *pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(_listTitleTextField.frame.origin.x, CGRectGetMaxY(_listTitleTextField.frame) + 38*kRATE, _listTitleTextField.bounds.size.width, 16*kRATE)];
    pointLabel.font = [UIFont systemFontOfSize:14*kRATE];
    pointLabel.text = @"请选择列表图标样式";
    pointLabel.textAlignment = NSTextAlignmentCenter;
    pointLabel.textColor = [UIColor colorWithRed:0.37 green:0.37 blue:0.37 alpha:1.00];
    [self.view addSubview:pointLabel];
    
    
    [self.listImageNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        JNSelectImageView *selectImageView = [[JNSelectImageView alloc]initWithFrame:CGRectMake(30*kRATE + 100*kRATE *idx, CGRectGetMaxY(pointLabel.frame)+32*kRATE, 100*kRATE, 70*kRATE) imageName:obj isSelect:NO];
        selectImageView.tag = idx;
        [self.view addSubview:selectImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
        [selectImageView addGestureRecognizer:tapGesture];
    }];
    
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(kSCREENW-25*kRATE-60*kRATE, kSCREENH-32*kRATE-30*kRATE, 60*kRATE, 30*kRATE)];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor colorWithRed:0.96 green:0.30 blue:0.38 alpha:1.00] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    nextButton.selected = YES;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14*kRATE];
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    _nextButton = nextButton;
    
}

- (void)nextAction:(UIButton *)sender{
    
    if (sender.selected) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
    
        NSString *textFieldStr = [_listTitleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (textFieldStr.length <= 0) {
            hud.labelText = @"清单名称不能为空";
            [hud hide:YES afterDelay:1.0];
        }
        
        if (_listTitleTextField.text.length > 8) {
            hud.labelText = @"名字太长了，不能大于8个字符哟~";
            [hud hide:YES afterDelay:1.0];
        }
        
        if (self.selectImage == nil) {
            hud.labelText = @"请给清单选个图标吧！";
            [hud hide:YES afterDelay:1.0];
        }
        return;
    }
    
    self.list.listTitle = _listTitleTextField.text;
    self.list.listImageName = self.listImageNames[self.selectImage.tag];
    
    JNTravelListDescriptionViewController *DesVC = [[JNTravelListDescriptionViewController alloc]init];
    DesVC.list = self.list;
    
    __weak typeof(self) weakSelf = self;
    DesVC.callBackCreateList = ^(JNTravelListModel *list){
        
        weakSelf.list = list;
        
        if (weakSelf.callBackCreateList) {
            weakSelf.callBackCreateList(self.list);
        }
    };

    [self.navigationController pushViewController:DesVC animated:YES];
}

- (void)selectImage:(UITapGestureRecognizer *)sender{
    
    self.selectImage.selectImageButton.selected = NO;
    
    JNSelectImageView *selectImageView = (JNSelectImageView *)sender.view;
    selectImageView.selectImageButton.selected = YES;
    self.selectImage = selectImageView;
    
    NSString *textFieldStr = [_listTitleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textFieldStr.length > 0 && _listTitleTextField.text.length <= 8 && _listTitleTextField.text != nil) {
        _nextButton.selected = NO;
    }else{
        _nextButton.selected = YES;
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
