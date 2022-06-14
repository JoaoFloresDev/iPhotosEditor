//
//  ColorCollectionViewCell.m
//  Finger Art
//
//  Created by Divyesh Dobariya on 29/09/17.
//  Copyright © 2017 Divyesh. All rights reserved.
//

#import "ColorCollectionViewCell.h"
#import "AppDelegate.h"

@implementation ColorCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
//    _cellImage.layer.borderColor=[UIColor whiteColor].CGColor;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
//        _botomLine.hidden=false;

        _botomLine.backgroundColor=TopColor;//[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        _cellLabel.textColor=TopColor;//[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
    else
    {
//        _botomLine.hidden=true;
        _botomLine.backgroundColor = [UIColor clearColor];
        _cellLabel.textColor = [UIColor blackColor];
    }
}

@end
