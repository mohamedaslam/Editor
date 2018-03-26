//
//  NSAttributedString+MemobirdEditor.h
//  Editor
//
//  Created by Mohammed Aslam on 01/03/18.
//  Copyright © 2018 Oottru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIFont+MemobirdEditor.h"

@interface NSAttributedString (MemobirdEditor)
- (NSRange)firstParagraphRangeFromTextRange:(NSRange)range;
- (NSArray *)rangeOfParagraphsFromTextRange:(NSRange)textRange;
@end
