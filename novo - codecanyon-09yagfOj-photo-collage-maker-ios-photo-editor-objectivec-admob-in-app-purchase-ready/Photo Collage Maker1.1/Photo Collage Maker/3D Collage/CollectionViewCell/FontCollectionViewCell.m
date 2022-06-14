//
//  FontCollectionViewCell.m
//  WaterfallPhotoFrame
//
//  Created by Tejas vaghasiya on 09/06/16.
//  Copyright © 2016 Tejas vaghasiya. All rights reserved.
//

#import "FontCollectionViewCell.h"
#import "AppDelegate.h"

@implementation FontCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setSelected:(BOOL)selected
{
    if (selected) {
        _cellImage.layer.borderWidth = 1.5;
        _cellImage.layer.borderColor = TopColor.CGColor;
    }
    else{
        _cellImage.layer.borderWidth = 1.0;
        _cellImage.layer.borderColor = [UIColor blackColor].CGColor;
    }
}
@end
