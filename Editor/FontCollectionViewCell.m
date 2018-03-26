//
//  FontCollectionViewCell.m
//  Editor
//
//  Created by Mohammed Aslam on 01/03/18.
//  Copyright © 2018 Oottru. All rights reserved.
//

#import "FontCollectionViewCell.h"

@implementation FontCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 36, 36)];
        _label.text = @"Aa";
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = [UIColor darkGrayColor];
        [self addSubview:_label];
       
    }
    return self;
}

@end
