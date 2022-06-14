//
//  MenuCollectionViewCell.m
//  Photo Collage Maker
//
//  Created by Vaishu on 8/27/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import "MenuCollectionViewCell.h"

@implementation MenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setSelected:(BOOL)selected
{
    if (selected) {
        _imgiew.layer.borderWidth = 1.5;
        _imgiew.layer.borderColor = TopColor.CGColor;
    }
    else{
        _imgiew.layer.borderWidth = 1.0;
        _imgiew.layer.borderColor = [UIColor blackColor].CGColor;
    }
}
@end
