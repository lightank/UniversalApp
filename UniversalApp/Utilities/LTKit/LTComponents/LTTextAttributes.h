//
//  LTTextAttributes.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/6/3.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTTextAttributes : NSObject

/**  文字字体,默认值：字体：Helvetica(Neue) 字号：12  */
@property (nonatomic, strong) UIFont *textFont;
/**  文本段落排版格式,默认为 defaultParagraphStyle  */
@property (nonatomic, strong) NSParagraphStyle *textParagraphStyle;
/**  文字颜色,默认值为黑色  */
@property (nonatomic, strong) UIColor *textColor;
/**  字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色  */
@property (nonatomic, strong) UIColor *backgroundColor;
/**  连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符  */
@property (nonatomic, assign) NSInteger ligature;
/**  字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄,0表示字符间距不可用   */
@property(nonatomic, assign) CGFloat characterSpacing;
/**  删除线类型，默认为0表示没有删除线,取值是 NSUnderlineStyle   */
@property(nonatomic, assign) NSUnderlineStyle strikethroughStyle;
/**  删除线颜色   */
@property (nonatomic, strong) UIColor *strikethroughColor;
/**  下滑线类型，默认为0表示没有删除线   */
@property(nonatomic, assign) NSUnderlineStyle underlineStyle;
/**  下滑线颜色   */
@property (nonatomic, strong) UIColor *underlineColor;
/**  文字的描边颜色，默认是没有描边颜色，也就是背景颜色  */
@property (nonatomic, strong) UIColor *strokeColor;
/**  文字的描边宽度，默认是0，没有描边，负值填充效果，正值中空效果  */
@property(nonatomic, assign) CGFloat strokeWidth;
/**  阴影  */
@property (nonatomic, strong) NSShadow *shadow;
/**  文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果 NSTextEffectLetterpressStyle 可用  */
@property (nonatomic, strong) NSTextEffectStyle textEffect;
/**  附件  */
@property (nonatomic, strong) NSTextAttachment *attachment;
/**  链接,点击后调用浏览器打开指定URL地址   */
@property (nonatomic, strong) NSURL *link;
/**  基线偏移量，正值上偏，负值下偏   */
@property(nonatomic, assign) CGFloat baselineOffset;
/**  字形倾斜度,正值右倾，负值左倾    */
@property(nonatomic, assign) CGFloat obliqueness;
/**  文本横向拉伸属性,正值横向拉伸文本，负值横向压缩文本  */
@property(nonatomic, assign) CGFloat expansion;
/**  文字书写方向，从左向右书写或者从右向左书写   */
@property(nonatomic, assign) NSWritingDirectionFormatType writingDirection;
/**  文字排版方向，0 表示横排文本，1 表示竖排文本  */
@property(nonatomic, assign) NSInteger verticalGlyph;


/**  最终的字典  */
@property (nonatomic, strong, readonly) NSDictionary *textAttributes;

@end

NS_ASSUME_NONNULL_END
