//
//  D3MainViewController.h
//  Photo Collage Maker
//
//  Created by Vaishu on 8/27/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "IQLabelView.h"
#import "MenuCollectionViewCell.h"
#import "FontCollectionViewCell.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "FrameViewController.h"
#import "DTColorPickerImageView.h"
#import "StickerViewController.h"
#import "ZDStickerView.h"
#import "ShareViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol stickerDelegate <NSObject>
-(void)didReceiveDelegateWith:(UIImage *)myimage;
@end

@protocol frameDelegate <NSObject>

-(void)didReceiveDelegateWithINT:(int)myint;

@end

@interface D3MainViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,IQLabelViewDelegate,GADBannerViewDelegate,frameDelegate,DTColorPickerImageViewDelegate,stickerDelegate,ZDStickerViewDelegate,GADInterstitialDelegate>

@property (nonatomic,retain)UIImage *mainImage;

@property(retain,nonatomic)IBOutlet UILabel *headerLabel;
@property (nonatomic,retain)IBOutlet UIView *topUIView;

@property(retain,nonatomic)IBOutlet UIView *saveView;
@property (nonatomic,retain)IBOutlet UIView *insideSaveView;
@property (nonatomic,retain)IBOutlet UIImageView *frameImageView;
@property (nonatomic,retain)IBOutlet UIImageView *backImageView;

@property (nonatomic,retain)IBOutlet UIView *menubtmView;
@property (nonatomic,retain)IBOutlet UICollectionView *menuColView;

@property (nonatomic,retain) IBOutlet UIView *MainToolbarView;
@property (nonatomic,retain) IBOutlet UIView *MainTextUIView;
@property (nonatomic,retain) IBOutlet UIView *MainTextColorPicker;
@property (nonatomic,retain) IBOutlet UIView *MainTextPickerView;
@property (nonatomic,retain) IBOutlet UICollectionView *pickerview;
@property (nonatomic,retain) NSArray *fontArray;

@property (nonatomic,retain) IBOutlet UIButton *textkbdbtn;
@property (nonatomic,retain) IBOutlet UIButton *textcolorbtn;
@property (nonatomic,retain) IBOutlet UIButton *textfontbtn;
@property (nonatomic,retain) IBOutlet UIButton *textdonebtn;

@property (nonatomic,retain) IBOutlet UIView *FilterView;
@property (nonatomic,retain) IBOutlet UICollectionView *filterColView;
@property (nonatomic,retain) NSMutableArray *filterArray;
@property (nonatomic,retain)IBOutlet UIButton *filterdonebtn;

//@property (nonatomic,retain) IBOutlet UIView *BokehView;
//@property (nonatomic,retain) IBOutlet UICollectionView *bokehColView;
//@property (nonatomic,retain) NSMutableArray *bokehArray;
//@property (nonatomic,retain)IBOutlet UIButton *bokehdonebtn;

@property (nonatomic,retain)IBOutlet UILabel *btmlbl;

@property (nonatomic,retain)IBOutlet GADBannerView *bannerView;

@end

NS_ASSUME_NONNULL_END
