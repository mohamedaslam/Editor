//
//  UIFont+MemobirdEditor.h
//  Editor
//
//  Created by Mohammed Aslam on 01/03/18.
//  Copyright © 2018 Oottru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIFont (MemobirdEditor)
+ (NSString *)postscriptNameFromFullName:(NSString *)fullName;
+ (UIFont *)fontWithName:(NSString *)name size:(CGFloat)size boldTrait:(BOOL)isBold italicTrait:(BOOL)isItalic;
- (UIFont *)fontWithBoldTrait:(BOOL)bold italicTrait:(BOOL)italic andSize:(CGFloat)size;
- (UIFont *)fontWithBoldTrait:(BOOL)bold andItalicTrait:(BOOL)italic;
- (BOOL)isBold;
- (BOOL)isItalic;
@end
