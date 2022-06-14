//
//  ColorCollectionViewCell.h
//  Finger Art
//
//  Created by Divyesh Dobariya on 29/09/17.
//  Copyright © 2017 Divyesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic)IBOutlet UIImageView *cellImage;
@property(strong,nonatomic)IBOutlet UILabel *cellLabel;
@property(strong,nonatomic)IBOutlet UILabel *botomLine;
//
//@property(strong,nonatomic)IBOutlet UILabel *bglbl;

@end
