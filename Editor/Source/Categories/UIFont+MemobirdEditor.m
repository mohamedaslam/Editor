//
//  UIFont+MemobirdEditor.m
//  Editor
//
//  Created by Mohammed Aslam on 01/03/18.
//  Copyright © 2018 Oottru. All rights reserved.
//

#import "UIFont+MemobirdEditor.h"

@implementation UIFont (MemobirdEditor)
+ (NSString *)postscriptNameFromFullName:(NSString *)fullName
{
    UIFont *font = [UIFont fontWithName:fullName size:1];
    return (__bridge NSString *)(CTFontCopyPostScriptName((__bridge CTFontRef)(font)));
}

+ (UIFont *)fontWithName:(NSString *)name size:(CGFloat)size boldTrait:(BOOL)isBold italicTrait:(BOOL)isItalic
{
    NSString *postScriptName = [UIFont postscriptNameFromFullName:name];
    CTFontSymbolicTraits traits = 0;
    CTFontRef newFontRef;
    UIFontDescriptor *desc;
    CTFontRef fontWithoutTrait = CTFontCreateWithName((__bridge CFStringRef)(postScriptName), size, NULL);
    CGAffineTransform matrix;
  
    if (isItalic == YES)
    {
         traits |= kCTFontItalicTrait;
         matrix = CGAffineTransformMake(1, 0, tanf(15* (CGFloat)M_PI / 180), 1, 0, 0);
    }else
    {
         matrix = CGAffineTransformMake(1, 0,0, 1, 0, 0);
    }
    if (isBold == YES)
    {
        traits |= kCTFontBoldTrait;
    }else
    {
        
    }
   
    if (traits == 0)
    {
        newFontRef= CTFontCreateCopyWithAttributes(fontWithoutTrait, 0.0, NULL, NULL);
    }
    else
    {
        newFontRef = CTFontCreateCopyWithSymbolicTraits(fontWithoutTrait, 0.0, NULL, traits, traits);

    }
    
    if (newFontRef)
    {
        NSString *fontNameKey = (__bridge NSString *)(CTFontCopyName(newFontRef, kCTFontPostScriptNameKey));
        desc = [UIFontDescriptor fontDescriptorWithName:fontNameKey matrix:matrix];
        return [UIFont fontWithDescriptor:desc size:CTFontGetSize(newFontRef)];
    }
    return nil;
}

- (UIFont *)fontWithBoldTrait:(BOOL)bold italicTrait:(BOOL)italic andSize:(CGFloat)size
{
    CTFontRef fontRef = (__bridge CTFontRef)self;
    NSString *familyName = (__bridge NSString *)(CTFontCopyName(fontRef, kCTFontFamilyNameKey));
    NSString *postScriptName = [UIFont postscriptNameFromFullName:familyName];

    return [[self class] fontWithName:postScriptName size:size boldTrait:bold italicTrait:italic];
}

- (UIFont *)fontWithBoldTrait:(BOOL)bold andItalicTrait:(BOOL)italic
{
    return [self fontWithBoldTrait:bold italicTrait:italic andSize:self.pointSize];
}

- (BOOL)isBold
{
    CTFontRef fontRef = (CTFontRef)CFBridgingRetain(self);
    CTFontSymbolicTraits trait = CTFontGetSymbolicTraits(fontRef);
    if ((trait & kCTFontTraitBold) == kCTFontTraitBold)
        return YES;
    
    return NO;
}

- (BOOL)isItalic
{
    CTFontRef fontRef = (CTFontRef)CFBridgingRetain(self);
    CTFontSymbolicTraits trait = CTFontGetSymbolicTraits(fontRef);
    if ((trait & kCTFontTraitItalic) == kCTFontTraitItalic){
        return YES;
    }else{
        return NO;
    }
}
@end
