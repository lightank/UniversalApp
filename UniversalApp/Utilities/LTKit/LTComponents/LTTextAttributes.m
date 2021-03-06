//
//  LTTextAttributes.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/6/3.
//  Copyright © 2019 huanyu.li. All rights reserved.
//  富文本属性

#import "LTTextAttributes.h"

@implementation LTTextAttributes

- (NSDictionary *)textAttributes
{
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    textAttributes[NSFontAttributeName] = self.textFont;
    textAttributes[NSParagraphStyleAttributeName] = self.textParagraphStyle;
    textAttributes[NSForegroundColorAttributeName] = self.textColor;
    textAttributes[NSBackgroundColorAttributeName] = self.backgroundColor;
    textAttributes[NSLigatureAttributeName] = @(self.ligature);
    textAttributes[NSKernAttributeName] = @(self.characterSpacing);
    textAttributes[NSStrikethroughStyleAttributeName] = @(self.strikethroughStyle);
    textAttributes[NSStrikethroughColorAttributeName] = self.strikethroughColor;
    textAttributes[NSUnderlineStyleAttributeName] = @(self.underlineStyle);
    textAttributes[NSUnderlineColorAttributeName] = self.underlineColor;
    textAttributes[NSStrokeColorAttributeName] = self.strokeColor;
    textAttributes[NSStrokeWidthAttributeName] = @(self.strokeWidth);
    textAttributes[NSShadowAttributeName] = self.shadow;
    textAttributes[NSTextEffectAttributeName] = self.textEffect;
    textAttributes[NSAttachmentAttributeName] = self.attachment;
    textAttributes[NSLinkAttributeName] = self.link;
    textAttributes[NSBaselineOffsetAttributeName] = @(self.baselineOffset);
    textAttributes[NSObliquenessAttributeName] = @(self.obliqueness);
    textAttributes[NSExpansionAttributeName] = @(self.expansion);
    textAttributes[NSWritingDirectionAttributeName] = @(self.writingDirection);
    textAttributes[NSVerticalGlyphFormAttributeName] = @(self.verticalGlyph);
    return textAttributes.copy;
}

@end

/*
 声明位于 NSAttributedString.h

 // Predefined character attributes for text. If the key is not present in the dictionary, it indicates the default value described below.
 // 字体，对应value是UIFont
 UIKIT_EXTERN NSAttributedStringKey const NSFontAttributeName NS_AVAILABLE(10_0, 6_0);                // UIFont, default Helvetica(Neue) 12
 // 段落设置,默认是：defaultParagraphStyle
 UIKIT_EXTERN NSAttributedStringKey const NSParagraphStyleAttributeName NS_AVAILABLE(10_0, 6_0);      // NSParagraphStyle, default defaultParagraphStyle
 // 文字颜色，默认是黑色的
 UIKIT_EXTERN NSAttributedStringKey const NSForegroundColorAttributeName NS_AVAILABLE(10_0, 6_0);     // UIColor, default blackColor
 // 背景颜色，默认是没有背景颜色
 UIKIT_EXTERN NSAttributedStringKey const NSBackgroundColorAttributeName NS_AVAILABLE(10_0, 6_0);     // UIColor, default nil: no background
 // 网上说是连字功能，默认是关闭的，我试了一下，没啥用，可能没有看到可以连字的字母吧
 UIKIT_EXTERN NSAttributedStringKey const NSLigatureAttributeName NS_AVAILABLE(10_0, 6_0);            // NSNumber containing integer, default 1: default ligatures, 0: no ligatures
 // 字符间距，0表示字符间距不可用
 UIKIT_EXTERN NSAttributedStringKey const NSKernAttributeName NS_AVAILABLE(10_0, 6_0);                // NSNumber containing floating point value, in points; amount to modify default kerning. 0 means kerning is disabled.
 // 删除线的类型，只有0(无删除线)1(有删除线)两种样式
 UIKIT_EXTERN NSAttributedStringKey const NSStrikethroughStyleAttributeName NS_AVAILABLE(10_0, 6_0);  // NSNumber containing integer, default 0: no strikethrough
 // 下划线样式0(没有下划线),1(有下划线)
 UIKIT_EXTERN NSAttributedStringKey const NSUnderlineStyleAttributeName NS_AVAILABLE(10_0, 6_0);      // NSNumber containing integer, default 0: no underline
 // 文字的描边颜色，默认是没有描边颜色，也就是背景颜色
 UIKIT_EXTERN NSAttributedStringKey const NSStrokeColorAttributeName NS_AVAILABLE(10_0, 6_0);         // UIColor, default nil: same as foreground color
 // 文字的描边宽度，默认是0，没有描边
 UIKIT_EXTERN NSAttributedStringKey const NSStrokeWidthAttributeName NS_AVAILABLE(10_0, 6_0);         // NSNumber containing floating point value, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
 // 阴影，默认是没有阴影的
 UIKIT_EXTERN NSAttributedStringKey const NSShadowAttributeName NS_AVAILABLE(10_0, 6_0);              // NSShadow, default nil: no shadow
 // 文字效果，默认没有文字效果
 UIKIT_EXTERN NSAttributedStringKey const NSTextEffectAttributeName NS_AVAILABLE(10_10, 7_0);          // NSString, default nil: no text effect

 // 附件
 UIKIT_EXTERN NSAttributedStringKey const NSAttachmentAttributeName NS_AVAILABLE(10_0, 7_0);          // NSTextAttachment, default nil
 // 链接
 UIKIT_EXTERN NSAttributedStringKey const NSLinkAttributeName NS_AVAILABLE(10_0, 7_0);                // NSURL (preferred) or NSString
 // 基线的偏移量
 UIKIT_EXTERN NSAttributedStringKey const NSBaselineOffsetAttributeName NS_AVAILABLE(10_0, 7_0);      // NSNumber containing floating point value, in points; offset from baseline, default 0
 // 下划线颜色，默认是nil，背景颜色
 UIKIT_EXTERN NSAttributedStringKey const NSUnderlineColorAttributeName NS_AVAILABLE(10_0, 7_0);      // UIColor, default nil: same as foreground color
 // 删除线颜色，默认是nil，背景颜色
 UIKIT_EXTERN NSAttributedStringKey const NSStrikethroughColorAttributeName NS_AVAILABLE(10_0, 7_0);  // UIColor, default nil: same as foreground color
 // 字体倾斜度，默认是没有倾斜度
 UIKIT_EXTERN NSAttributedStringKey const NSObliquenessAttributeName NS_AVAILABLE(10_0, 7_0);         // NSNumber containing floating point value; skew to be applied to glyphs, default 0: no skew
 // 字体的伸缩，小于零是缩小，大于零是扩张
 UIKIT_EXTERN NSAttributedStringKey const NSExpansionAttributeName NS_AVAILABLE(10_0, 7_0);           // NSNumber containing floating point value; log of expansion factor to be applied to glyphs, default 0: no expansion

 // 字体方向，有LRE, RLE, LRO, 和RLO几种模式
 UIKIT_EXTERN NSAttributedStringKey const NSWritingDirectionAttributeName NS_AVAILABLE(10_6, 7_0);    // NSArray of NSNumbers representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.  The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.  LRE: NSWritingDirectionLeftToRight|NSWritingDirectionEmbedding, RLE: NSWritingDirectionRightToLeft|NSWritingDirectionEmbedding, LRO: NSWritingDirectionLeftToRight|NSWritingDirectionOverride, RLO: NSWritingDirectionRightToLeft|NSWritingDirectionOverride,

 // 文字的排版方向
 UIKIT_EXTERN NSAttributedStringKey const NSVerticalGlyphFormAttributeName NS_AVAILABLE(10_7, 6_0);   // An NSNumber containing an integer value.  0 means horizontal text.  1 indicates vertical text.  If not specified, it could follow higher-level vertical orientation settings.  Currently on iOS, it's always horizontal.  The behavior for any other value is undefined.


参考：https://www.jianshu.com/p/46d377ca2dfb
 */
