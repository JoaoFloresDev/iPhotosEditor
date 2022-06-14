//
//  TreeMainViewController.h
//  Photo Collage Maker
//
//  Created by Vaishu on 8/30/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MenuCollectionViewCell.h"
#import "EditViewController.h"
#import "ShareViewController.h"
#import "StickerViewController.h"
#import "ZDStickerView.h"
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol treestickerDelegate <NSObject>
-(void)didReceiveDelegateWith:(UIImage *)myimage;
@end

@protocol treeDelegate <NSObject>

-(void)didReceiveDelegateWithImage:(UIImage *)myimg;

@end

@interface TreeMainViewController : UIViewController<GADBannerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,treeDelegate,treestickerDelegate,ZDStickerViewDelegate,GADInterstitialDelegate>

@property (nonatomic,retain)NSMutableArray *mainArray;
@property (nonatomic,retain)NSMutableArray *imageArray;

@property (nonatomic,retain)IBOutlet UILabel *toplbl;
@property (nonatomic,retain)IBOutlet UIView *topView;

@property (nonatomic,retain)IBOutlet UIView *saveview;
@property (nonatomic,retain)IBOutlet UIView *allView;
@property (nonatomic,retain)IBOutlet UIImageView *imageview;
@property (nonatomic,retain)IBOutlet UILabel *borderlbl;

@property (nonatomic,retain)IBOutlet GADBannerView *bannerView;

@property (nonatomic,retain)IBOutlet UILabel *btmlbl;

@property (nonatomic,retain)IBOutlet UIView *btmView;
@property (nonatomic,retain)IBOutlet UICollectionView *btmcolView;

@property (nonatomic,retain) IBOutlet UIView *FilterView;
@property (nonatomic,retain) IBOutlet UICollectionView *filterColView;
@property (nonatomic,retain) NSMutableArray *filterArray;
@property (nonatomic,retain)IBOutlet UIButton *filterdonebtn;

@property (nonatomic,retain)IBOutlet UISlider *pinchslider;

@property (nonatomic,retain)UIImagePickerController *picker;


@end

NS_ASSUME_NONNULL_END
