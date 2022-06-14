//
//  MenuCollectionViewCell.h
//  Photo Collage Maker
//
//  Created by Vaishu on 8/27/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuCollectionViewCell : UICollectionViewCell

@property (nonatomic,retain)IBOutlet UILabel *txtlbl;
@property (nonatomic,retain)IBOutlet UIImageView *imgiew;

@end

NS_ASSUME_NONNULL_END
