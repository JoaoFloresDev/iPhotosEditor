//
//  CropViewController.h
//  ShapeCrop
//
//  Created by escrow on 8/22/16.
//  Copyright © 2016 escrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CHTStickerView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "PhotoMainViewController.h"
#import "MenuCollectionViewCell.h"

@protocol ViewControllerBDelegate;

@interface CropViewController : UIViewController<CHTStickerViewDelegate>

@property (nonatomic, weak) id <ViewControllerBDelegate> delegate;

@property(nonatomic,retain)UIImage *imageA;
@property(nonatomic,retain)UIImage *imageB;

@property(nonatomic,retain)IBOutlet UIImageView *imageViewA;

@property(nonatomic,retain)IBOutlet UILabel *lbl;

@property (nonatomic,retain)IBOutlet UIView *btmView;
@property(nonatomic,retain)IBOutlet UICollectionView *collectionShapes;

@property (nonatomic,retain)IBOutlet UIView *topView;
@property (nonatomic,retain)IBOutlet UILabel *toplbl;
@property (nonatomic,retain)IBOutlet UILabel *btmlbl;

@property (nonatomic,retain) CHTStickerView *imagestickerview;
@property (nonatomic,retain) UIImageView *imgstickerimgview;
@property (nonatomic,retain) UIImageView *imgstickerimgview2;

@property (nonatomic, strong) CHTStickerView *selectedView;

@property(nonatomic,retain)IBOutlet UIView *ViewA;

@end
