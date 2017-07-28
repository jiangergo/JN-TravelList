//
//  JNTravelListDescriptionViewController.m
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/20.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import "JNTravelListDescriptionViewController.h"
#import "JNTravelListDescriptionCell.h"
#import "JNListDescription.h"
#import "MBProgressHUD.h"

@class JNCreateTravelListViewController;
static NSString *const travelListDescriptionCellID = @"travelListDescriptionCellID";
@interface JNTravelListDescriptionViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray <JNListDescription *>*listArr;

/// 截图
@property (nonatomic, strong) UIView *snapshotView;

/// 选择的 cell IndexPath
@property (nonatomic, strong) NSIndexPath *selectCellIndexPath;

@property (nonatomic, assign) BOOL isEditingCell;

/// 编辑状态时的蒙版
@property (nonatomic, strong) UIView *dimView;

@end

@implementation JNTravelListDescriptionViewController{
    UITextField *_descriptionTextField;
    UITableView *_listTableView;
}


- (NSMutableArray *)listArr{
    if (!_listArr) {
        NSArray *arr = self.list.listArr;
        if (arr) {
            _listArr = arr.mutableCopy;
            return _listArr;
        }
        
        _listArr = [NSMutableArray array];
        
    }
    return _listArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.list.listTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupNavBar];
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self saveData];
}

- (void)saveData{
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers[self.navigationController.viewControllers.count-1] isKindOfClass:[viewControllers[0] class]]) {
        if (self.callBackListBlock) {
            self.callBackListBlock(self.list);
        }
    }else {
        if (self.callBackCreateList) {
            self.callBackCreateList(self.list);
        }
    }
}

- (void)setupUI{
    
    _descriptionTextField = [[UITextField alloc]initWithFrame:CGRectMake(24*kRATE, 64 + 29*kRATE, kSCREENW-24*kRATE *2, 33*kRATE)];
    _descriptionTextField.leftViewMode = UITextFieldViewModeAlways;
    UIButton *addDescriptionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36*kRATE, 33*kRATE)];
    [addDescriptionButton addTarget:self action:@selector(addDescriptionAction:) forControlEvents:UIControlEventTouchUpInside];
    [addDescriptionButton setImage:[UIImage imageNamed:@"add_description"] forState:UIControlStateNormal];
    _descriptionTextField.leftView = addDescriptionButton;
    _descriptionTextField.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    _descriptionTextField.layer.borderWidth = 0.8;
    _descriptionTextField.layer.borderColor = [[UIColor colorWithRed:0.58 green:0.57 blue:0.57 alpha:1.00]CGColor];
    _descriptionTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _descriptionTextField.delegate = self;
    [self.view addSubview:_descriptionTextField];
    
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_descriptionTextField.frame)+23*kRATE, kSCREENW, kSCREENH-CGRectGetMaxY(_descriptionTextField.frame))];
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.bounces = NO;
    [self.view addSubview:_listTableView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPress.delegate = self;
    [_listTableView addGestureRecognizer:longPress];
    
    
    self.dimView = [[UIView alloc]initWithFrame:CGRectMake(40*kRATE, 0, kSCREENW-40*kRATE*2, kSCREENH)];
    self.dimView.alpha = 0.2;
    self.dimView.hidden = YES;
    [self.view addSubview:self.dimView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.dimView addGestureRecognizer:tapGestureRecognizer];
    
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    
    [_listTableView registerClass:[JNTravelListDescriptionCell class] forCellReuseIdentifier:travelListDescriptionCellID];
}


- (void)setupNavBar{
    
    UIButton *restoreButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [restoreButton setTitleColor:[UIColor colorWithRed:0.96 green:0.30 blue:0.38 alpha:1.00] forState:UIControlStateNormal];
    [restoreButton setTitle:@"还原" forState:UIControlStateNormal];
    restoreButton.titleLabel.font = [UIFont systemFontOfSize:14*kRATE];
    [restoreButton addTarget:self action:@selector(restoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:restoreButton];
}


- (void)setIsEditingCell:(BOOL)isEditingCell{
    _isEditingCell = isEditingCell;
    
    [self.view endEditing:!isEditingCell];
    [_listTableView setEditing:isEditingCell animated:YES];
}

#pragma mark - Textfield method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self addDescriptionAction:nil];
    self.isEditingCell = NO;
    return YES;
}


#pragma mark - Gesture method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && self.isEditingCell) {
        
        return YES;
    }
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    }
    
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.isEditingCell = NO;
}

- (void)hideKeyBoard:(UITapGestureRecognizer *)tapGesture{
    
//    if (self.isEditingCell) {
//        return;
//    }
    self.isEditingCell = NO;
    self.dimView.hidden = YES;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
    
    [_listTableView setEditing:YES animated:YES];
    self.dimView.hidden = NO;
    
//    CGPoint location = [sender locationInView:_listTableView];
//    NSIndexPath *cellIndexPath = [_listTableView indexPathForRowAtPoint:location];
//    
//    switch (sender.state) {
//        case UIGestureRecognizerStateBegan:{
//            if (cellIndexPath) {
//                self.selectCellIndexPath = cellIndexPath;
//                
//                JNTravelListDescriptionCell *cell = [_listTableView cellForRowAtIndexPath:self.selectCellIndexPath];
//                self.snapshotView = [self customSnapshotFromView:cell];
//                __block CGPoint center = cell.center;
//                _snapshotView.center = center;
//                _snapshotView.alpha = 0.0f;
//                [_listTableView addSubview:_snapshotView];
//                
//                [UIView animateWithDuration:0.25 animations:^{
//                    center.y = location.y;
//                    _snapshotView.center = center;
//                    _snapshotView.transform = CGAffineTransformMakeScale(1.05, 1.05);
//                    _snapshotView.alpha = 0.98f;
//                    cell.alpha = 0.0f;
//                    cell.hidden = YES;
//                }];
//                
//            }
//            break;
//        }
//            
//        case UIGestureRecognizerStateChanged:{
//            CGPoint center = _snapshotView.center;
//            center.y = location.y;
//            _snapshotView.center = center;
//            
//            if (cellIndexPath && ![cellIndexPath isEqual:self.selectCellIndexPath]) {
//                
//                [self.listArr exchangeObjectAtIndex:cellIndexPath.row withObjectAtIndex:self.selectCellIndexPath.row];
//                self.list.listArr = self.listArr;
//                
//                [_listTableView moveRowAtIndexPath:self.selectCellIndexPath toIndexPath:cellIndexPath];
//                
//                self.selectCellIndexPath = cellIndexPath;
//            }
//            break;
//        }
//            
//        default: {
//            JNTravelListDescriptionCell *cell = [_listTableView cellForRowAtIndexPath:self.selectCellIndexPath];
//            cell.alpha = 0.0f;
//            
//            [UIView animateWithDuration:0.25 animations:^{
//                
//                _snapshotView.center = cell.center;
//                _snapshotView.transform = CGAffineTransformIdentity;
//                _snapshotView.alpha = 0.0f;
//                cell.alpha = 1.0f;
//                
//            } completion:^(BOOL finished) {
//                cell.hidden = NO;
//                self.selectCellIndexPath = nil;
//                [_snapshotView removeFromSuperview];
//                _snapshotView = nil;
//            }];
//            
//            
//            break;
//        }
//    }
}

//自定制快照样式
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.center = inputView.center;
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

#pragma mark - Button Action

- (void)addDescriptionAction:(UIButton *)sender{
    
     NSString *textFieldStr = [_descriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textFieldStr.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"描述内容不能为空哟";
        [hud hide:YES afterDelay:1.0];
        return;
    }
    
    if (_descriptionTextField.text.length > 25) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"描述内容不能超过25个字";
        [hud hide:YES afterDelay:1.0];
        return;
    }
    
    JNListDescription *addDes = [[JNListDescription alloc]init];
    addDes.isDone = NO;
    addDes.descriptionStr = _descriptionTextField.text;
    [self.listArr addObject:addDes];
    self.list.listArr = self.listArr;
    [_listTableView reloadData];
    
    if (self.callBackListBlock) {
        self.callBackListBlock(self.list);
    }
    _descriptionTextField.text = @"";
}

- (void)restoreButtonAction:(UIBarButtonItem *)sender{
    
    self.isEditingCell = NO;
    
    [self.listArr enumerateObjectsUsingBlock:^(JNListDescription * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isDone = NO;
    }];
    
    [_listTableView reloadData];
    if (self.callBackListBlock) {
        self.callBackListBlock(self.list);
    }

    if (self.callBackCreateList) {
        self.callBackCreateList(self.list);
    }
}


#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JNTravelListDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:travelListDescriptionCellID];

    if (indexPath.row != self.listArr.count) {
        cell.listDescription = self.listArr[indexPath.row];
    }
    
    return cell;
}


#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isEditingCell == YES) {
        return;
    }
    
    JNTravelListDescriptionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell selectCell];
    
    self.listArr[indexPath.row] = cell.listDescription;
    
    self.list.listArr = self.listArr;
    
    if (self.callBackListBlock) {
        self.callBackListBlock(self.list);
    }
    
    if (self.callBackCreateList) {
        self.callBackCreateList(self.list);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34*kRATE;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    self.selectCellIndexPath = sourceIndexPath;
    
    JNListDescription *model = self.listArr[sourceIndexPath.row];
    
    [self.listArr removeObjectAtIndex:sourceIndexPath.row];
    [self.listArr insertObject:model atIndex:destinationIndexPath.row];
    self.list.listArr = self.listArr;
    
    if (self.callBackListBlock) {
        self.callBackListBlock(self.list);
    }
    
    if (self.callBackCreateList) {
        self.callBackCreateList(self.list);
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.listArr removeObjectAtIndex:indexPath.row];
        self.list.listArr = self.listArr;
        [_listTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [_listTableView reloadData];
    }
    
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
