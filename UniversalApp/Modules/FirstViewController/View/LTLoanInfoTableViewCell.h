//
//  LTLoanInfoTableViewCell.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/7/8.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTloanDetailInfo;

NS_ASSUME_NONNULL_BEGIN

@interface LTLoanInfoTableViewCell : UITableViewCell

- (void)updateWithLoanInfo:(LTloanDetailInfo *)info index:(NSIndexPath *)index;

@end

NS_ASSUME_NONNULL_END
