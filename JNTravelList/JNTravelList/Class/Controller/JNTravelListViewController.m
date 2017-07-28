//
//  JNTravelListViewController.m
//  JNTravelList
//
//  Created by Jiangergo on 2016/12/19.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import "JNTravelListViewController.h"

// view
#import "JNTravelListCell.h"

// model
#import "JNListDataManager.h"

// controller
#import "JNCreateTravelListViewController.h"
#import "JNTravelListDescriptionViewController.h"


static NSString *const travelListCellID = @"travelListCellID";

@interface JNTravelListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray <JNTravelListModel *>*travelList;

//@property (nonatomic, strong) JNListDataManager *listDataManager;

@property (nonatomic, assign) BOOL isEditingCell;

@property (nonatomic, strong) NSIndexPath *originalIndexPath;

@property (nonatomic, strong) UIView *snapshotView;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JNTravelListViewController
//{
//    UICollectionView *_collectionView;
//}

- (void)setIsEditingCell:(BOOL)isEditingCell{
    _isEditingCell = isEditingCell;
    
    NSArray *cells = [_collectionView visibleCells];
    for (JNTravelListCell *cell in cells) {
        cell.isEditingCell = isEditingCell;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"旅行清单";
    
    [self initData];
    [self initCollectionView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.isEditingCell = NO;
    [[JNListDataManager sharedManager] saveDataWithTravelLists:self.travelList];
}


- (void)initData{
    
    self.travelList = [[NSMutableArray alloc]init];
    self.travelList = [JNListDataManager sharedManager].travelLists.mutableCopy;
}

- (void)initCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake((kSCREENW-60*kRATE-2)/3, (kSCREENW-60*kRATE-2)/3);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSCREENW, kSCREENH) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(37*kRATE, 30*kRATE, 0, 30*kRATE);
    [self.view addSubview:_collectionView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCollectionAction:)];
    tapGesture.delegate = self;
    [_collectionView addGestureRecognizer:tapGesture];
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPress.delegate = self;
    [_collectionView addGestureRecognizer:longPress];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:[JNTravelListCell class] forCellWithReuseIdentifier:travelListCellID];
    
}


#pragma mark - UICollectionView Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.travelList.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JNTravelListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:travelListCellID forIndexPath:indexPath];
    if (indexPath.item == self.travelList.count) {
        cell.cellType = JNTravelListTypeAdd;
        cell.deleteCellBlock = nil;
        cell.isEditingCell = NO;
    }else{
        cell.cellType = JNTravelListTypeList;
        cell.model = self.travelList[indexPath.item];
        cell.isEditingCell = self.isEditingCell;
        cell.deleteCellBlock = ^(JNTravelListModel *model){
            [self.travelList removeObjectAtIndex:indexPath.row];
            [_collectionView reloadData];
            [[JNListDataManager sharedManager] saveDataWithTravelLists:self.travelList];
        };
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isEditingCell && indexPath.item != self.travelList.count) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.item == self.travelList.count) {
        JNCreateTravelListViewController *createVC = [[JNCreateTravelListViewController alloc]init];
        
        createVC.callBackCreateList = ^(JNTravelListModel *list){
            
            if ([weakSelf.travelList containsObject:list]) {
                weakSelf.travelList[indexPath.item] = list;
            }else{
                
                [weakSelf.travelList insertObject:list atIndex:indexPath.item];
            }
            
            [[JNListDataManager sharedManager] saveDataWithTravelLists:weakSelf.travelList];
            [weakSelf.collectionView reloadData];
            
        };
        
        [self.navigationController pushViewController:createVC animated:YES];
    }else{
        
        JNTravelListDescriptionViewController *listDesVC = [[JNTravelListDescriptionViewController alloc]init];
        listDesVC.list = self.travelList[indexPath.item];
        
        listDesVC.callBackListBlock = ^(JNTravelListModel *list){
            
            if ([weakSelf.travelList containsObject:list]) {
                weakSelf.travelList[indexPath.item] = list;
            }else{
                [weakSelf.travelList insertObject:list atIndex:indexPath.item];
            }
            
            [[JNListDataManager sharedManager] saveDataWithTravelLists:weakSelf.travelList];
            [weakSelf.collectionView reloadData];
        };
        
        [self.navigationController pushViewController:listDesVC animated:YES];
    }
}

#pragma mark - UIGesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && self.isEditingCell && self.travelList.count > 0) {
        return YES;
    }
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press{
    return YES;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    
    self.isEditingCell = YES;
    
    CGPoint location = [longPress locationInView:_collectionView];
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:location];
    
    //如果没有数据，长按无效
    if (self.travelList.count) {
        
        switch (longPress.state) {
            case UIGestureRecognizerStateBegan:{
                if (indexPath) {
                    
                    if (indexPath.row == self.travelList.count) {
                        return;
                    }
                    
                    self.originalIndexPath = indexPath;
                    JNTravelListCell *cell = (JNTravelListCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                    self.snapshotView = [self customSnapshotFromView:cell];
                    __block CGPoint center = cell.center;
                    self.snapshotView.center = center;
                    self.snapshotView.alpha = 0.0f;
                    [_collectionView addSubview:self.snapshotView];
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        center.y = location.y;
                        _snapshotView.center = center;
                        _snapshotView.transform = CGAffineTransformMakeScale(1.03, 1.03);
                        _snapshotView.alpha = 0.99f;
                        cell.alpha = 0.0f;
                        cell.hidden = YES;
                    }];
                }
                break;
            }
                
            case UIGestureRecognizerStateChanged:{
                
                CGPoint center = self.snapshotView.center;
                center.y = location.y;
                center.x = location.x;
                self.snapshotView.center = center;
                
                if (indexPath && ![indexPath isEqual:self.originalIndexPath] && indexPath.row != self.travelList.count) {
                    
                    [self.travelList exchangeObjectAtIndex:indexPath.item withObjectAtIndex:self.originalIndexPath.item];
                    [[JNListDataManager sharedManager] saveDataWithTravelLists:self.travelList];
                    [_collectionView moveItemAtIndexPath:self.originalIndexPath toIndexPath:indexPath];
                    
                    self.originalIndexPath = indexPath;
                }
                break;
            }
                
            default:{
                JNTravelListCell *cell = (JNTravelListCell *)[_collectionView cellForItemAtIndexPath:self.originalIndexPath];
                cell.alpha = 0.0f;
                
                [UIView animateWithDuration:0.25 animations:^{
                    _snapshotView.center = cell.center;
                    _snapshotView.transform = CGAffineTransformIdentity;
                    _snapshotView.alpha = 0.0f;
                    cell.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    cell.hidden = NO;
                    self.originalIndexPath = nil;
                    [_snapshotView removeFromSuperview];
                    _snapshotView = nil;
                }];
                
                break;
            }
        }
    }
}

- (void)tapCollectionAction:(UITapGestureRecognizer *)tapGesture{
    
    self.isEditingCell = NO;
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
    
    return snapshot;
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
