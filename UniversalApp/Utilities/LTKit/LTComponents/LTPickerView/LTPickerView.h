//
//  LTPickerView.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/7/8.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LTPickerViewCancelHandler)();
typedef void(^LTPickerViewSubimtHandler)(id _Nullable obj, NSInteger index);

@interface LTPickerView : UIView

+ (void)showPickerViewWith:(NSString *)title
                      data:(NSArray<NSString *> *)datas
               selectIndex:(NSInteger)index
                    cancel:(LTPickerViewCancelHandler)cancel
                   confirm:(LTPickerViewSubimtHandler)confirmHandler;

@end

NS_ASSUME_NONNULL_END
