//
//  LTLoanCalculationViewController.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/7/8.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTLoanCalculationViewController : UIViewController

@end

typedef NS_ENUM(NSUInteger, LTLoanType) {
    LTLoanTypeEqualInterest = 0,   // 等额本息:还款期内，每月偿还同等数额的贷款(本金+利息)
    LTLoanTypeEqualPrincipal = 1,  // 等额本金:每个月还的本金是固定的，但利息不固定，所以每个月的还款额（本金+利息）就不固定
};

@interface LTLoanCalculationController : UIViewController

@end

@interface LTloanType : NSObject

/**  title  */
@property (nonatomic, copy) NSString *title;
/**  subTitle  */
@property (nonatomic, copy) NSString *subTitle;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end

@interface LTloanDetailInfo : NSObject

/**  title1:期数  */
@property (nonatomic, copy) NSString *title1;
/**  title2:本金(元)  */
@property (nonatomic, copy) NSString *title2;
/**  title3:利息(元)  */
@property (nonatomic, copy) NSString *title3;
/**  title4:总计(元)  */
@property (nonatomic, copy) NSString *title4;

- (instancetype)initWithTitle1:(NSString *)title1
                        title2:(NSString *)title2
                        title3:(NSString *)title3
                        title4:(NSString *)title4;

@end

@interface LTloanLiteInfo : NSObject

/**  标题  */
@property (nonatomic, copy) NSString *title;
/**  内容  */
@property (nonatomic, copy) NSString *content;

@end

@interface LTloanInfo : NSObject

#pragma mark - 原始数据
/**  计算类型:  */
@property(nonatomic, assign) LTLoanType loanType;

- (instancetype)initWithLTLoanType:(LTLoanType)type
                         loanAmount:(NSInteger)loanAmount
                          loanMonth:(NSInteger)loanMonth
                 annualInterestRate:(CGFloat)annualInterestRate;

#pragma mark - 计算后结果
/**  简介信息数组  */
@property (nonatomic, strong, readonly) NSArray<LTloanLiteInfo *> *liteInfoArray;
/**  详情数组  */
@property(nonatomic, strong, readonly) NSArray<LTloanDetailInfo *> *infoArray;
/**  等额本金需要还款总额  */
@property (nonatomic, assign,readonly) CGFloat equalPrincipalPayMoneyAmount;
/**  额本息需要还款总额  */
@property (nonatomic, assign,readonly) CGFloat equalInterestPayMoneyAmount;

@end


NS_ASSUME_NONNULL_END
