//
//  LTTableViewCellItem.h
//  UniversalApp
//
//  Created by huanyu.li on 2020/5/8.
//  Copyright © 2020 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LTTableViewCellItemBlock)(LTTableViewCellItem cellItem, UITableView *tableView, UITableViewCell *tableViewCell, NSIndexPath *indexPath);

@interface LTTableViewCellItem : NSObject

/// cellClass，将会用 NSStringFromClass(cellItem.cellClass) 的字符串去 tableview 注册 cell
@property (nonatomic, strong) Class cellClass;
/// 默认值为-1，需要 cell 获得数据源后给这个赋值
@property (nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, copy, nullable) LTTableViewCellItemBlock cellSettingBlock;
@property(nonatomic, copy, nullable) LTTableViewCellItemBlock cellSelectedBlock;

/// 构建一个cellitem，同时设置 cellSettingBlock、cellSelectedBlock
/// @param cellClass cellClass
/// @param cellSettingBlock cell 设置数据源 block
/// @param cellSelectedBlock cell 选中的 block
+ (instancetype)itemWithCellClass:(Class)cellClass
                 cellSettingBlock:(nullable LTTableViewCellItemBlock)cellSettingBlock
                cellSelectedBlock:(nullable LTTableViewCellItemBlock)cellSelectedBlock;

/// 构建一个cellitem，同时设置 cellSettingBlock
/// @param cellClass cellClass
/// @param cellSettingBlock cell 设置数据源 block
+ (instancetype)itemWithCellClass:(Class)cellClass
                 cellSettingBlock:(nullable LTTableViewCellItemBlock)cellSettingBlock;

/// 构建一个cellitem
/// @param cellClass cellClass
+ (instancetype)itemWithCellClass:(Class)cellClass;

/// 构建一个cellitem，同时设置 cellSettingBlock、cellSelectedBlock
/// @param cellClass cellClass
/// @param cellSettingBlock cell 设置数据源 block
/// @param cellSelectedBlock cell 选中的 block
- (instancetype)initWithCellClass:(Class)cellClass
                 cellSettingBlock:(nullable LTTableViewCellItemBlock)cellSettingBlock
                cellSelectedBlock:(nullable LTTableViewCellItemBlock)cellSelectedBlock;

/// 构建一个cellitem，同时设置 cellSettingBlock
/// @param cellClass cellClass
/// @param cellSettingBlock cell 设置数据源 block
- (instancetype)initWithCellClass:(Class)cellClass
                 cellSettingBlock:(nullable LTTableViewCellItemBlock)cellSettingBlock;

/// 构建一个cellitem
/// @param cellClass cellClass
- (instancetype)initWithCellClass:(Class)cellClass;

@end

NS_ASSUME_NONNULL_END


/*
 使用说明
 
 #define lt_weakSelf(type)  __weak typeof(type) weak##type = type;
 
 @property (nonatomic, strong) NSMutableArray<LTTableViewCellItem *> *cellItems;
 @property (nonatomic, strong) UITableView *tableView;

 
 - (void)updateUI {
     [self.cellItems removeAllObjects];
     
     {
        id dataSource = xxxx;
        LTTableViewCellItem *cellItem = [LTTableViewCellItem itemWithCellClass:[LTTestTableViewCell class] cellSettingBlock:^(LTTableViewCellItem cellItem, UITableView * _Nonnull tableView, UITableViewCell * _Nonnull tableViewCell, NSIndexPath * _Nonnull indexPath) {
            if ([tableViewCell isKindOfClass:[LTTestTableViewCell class]]) {
                LTTestTableViewCell *cell = (LTTestTableViewCell *)tableViewCell;
                [cell updateWithDataSource:dataSource];
            }
        }];
        
        [self.cellItems addObject:cellItem];
     }

     [self registerCellClass];
     [self.tableView reloadData];
 }
 
 - (void)registerCellClass {
     if (self.cellItems.count <= 0) {
         return;
     }
     
     for (LTTableViewCellItem *cellItem in self.cellItems) {
         [self.tableView registerClass:cellItem.cellClass forCellReuseIdentifier:NSStringFromClass(cellItem.cellClass)];
     }
 }
 
 #pragma mark - UITableViewDelegate/UITableViewDatasource

 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
 }

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.cellItems.count;
 }

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     LTTableViewCellItem *cellItem = self.cellItems[indexPath.row];
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellItem.cellClass)];
     if (cellItem.cellSettingBlock) {
         lt_weakSelf(cellItem)
         lt_weakSelf(tableView)
         lt_weakSelf(cell)
         cellItem.cellSettingBlock(weakcellItem ,weaktableView, weakcell, indexPath);
     }
     
     return cell;
 }

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     LTTableViewCellItem *cellItem = self.cellItems[indexPath.row];
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     if (cellItem.cellSelectedBlock) {
         lt_weakSelf(cellItem)
         lt_weakSelf(tableView)
         lt_weakSelf(cell)
         cellItem.cellSettingBlock(weakcellItem ,weaktableView, weakcell, indexPath);
     }
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     LTTableViewCellItem *cellItem = self.cellItems[indexPath.row];
     CGFloat rowHeight = cellItem.cellHeight >= 0 ? cellItem.cellHeight : UITableViewAutomaticDimension;
     return rowHeight;
 }

 */
