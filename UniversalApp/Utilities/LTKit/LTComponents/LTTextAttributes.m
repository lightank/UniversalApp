//
//  LTTextAttributes.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/6/3.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

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
