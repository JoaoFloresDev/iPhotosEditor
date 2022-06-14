//
//  PhotoMainViewController.h
//  Photo Collage Maker
//
//  Created by Vaishu on 8/29/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MenuCollectionViewCell.h"
#import "ZDStickerView.h"
#import "StickerViewController.h"
#import "IQLabelView.h"
#import "CropViewController.h"
#import "SimpleColorView.h"
#import "ShareViewController.h"
#import <DRColorPicker.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ViewControllerBDelegate <NSObject>
- (void)addItemViewControllerdidFinishEnteringItem:(UIImage *)item;
@end

@protocol photostickerDelegate <NSObject>
-(void)didReceiveDelegateWith:(UIImage *)myimage;
@end

@interface PhotoMainViewController : UIViewController<GADBannerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZDStickerViewDelegate,photostickerDelegate,IQLabelViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ViewControllerBDelegate,SimpleColorViewDelegate,UIScrollViewDelegate,GADInterstitialDelegate>{
    UIView *selView;
    SimpleColorView *simplecolorview;
}

@property (nonatomic,retain)NSMutableArray *MainimagesArray;
@property (nonatomic,retain)NSMutableArray *imagesArray;
@property (nonatomic,retain)NSMutableArray *originalArray;

@property (nonatomic,retain)IBOutlet UILabel *toplbl;
@property (nonatomic,retain)IBOutlet UIView *topView;

@property IBOutlet UIView *saveView;
@property IBOutlet UIView *saveInsideview;
@property (nonatomic,retain) IBOutlet UIImageView *mainbgimgview;
@property (nonatomic,retain) IBOutlet UIImageView *selectedViewlayer;

@property(strong, nonatomic)IBOutlet GADBannerView *adBanner;

@property (nonatomic,retain)IBOutlet UIView *bottomView;
@property (nonatomic,retain)IBOutlet UICollectionView *btmColView;

@property (nonatomic,retain) IBOutlet UIView *FilterView;
@property (nonatomic,retain) IBOutlet UICollectionView *filterColView;
@property (nonatomic,retain) NSMutableArray *filterArray;
@property (nonatomic,retain)IBOutlet UIButton *filterdonebtn;

@property (nonatomic,retain) IBOutlet UIView *layoutView;
@property (nonatomic,retain) IBOutlet UICollectionView *layoutColView;
@property (nonatomic,retain) NSMutableArray *layoutArray;
@property (nonatomic,retain)IBOutlet UIButton *layoutdonebtn;

@property (nonatomic,retain) UIScrollView *scrollview;
@property (nonatomic,retain) UIImageView *imageview;
@property (nonatomic,retain) NSMutableArray *zoomscaleArray;
@property (nonatomic,retain) NSMutableArray *scrollviewArray;
@property (nonatomic,retain) NSMutableArray *imgviewFrameArray;
@property (nonatomic,retain) NSMutableArray *maskingLayerArray;
@property NSMutableArray *imgviewArray;
@property NSMutableArray *frameArray;
@property NSMutableArray *viewArray;

@property (nonatomic,retain) IBOutlet UIButton *btnDelete;
@property (nonatomic,retain) IBOutlet UIButton *btnAddM;

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

@property (nonatomic,retain)IBOutlet UIView *borderView;
@property (nonatomic,retain)IBOutlet UISlider *gridcornerSlider;
@property (nonatomic,retain)IBOutlet UISlider *gridoutsideSlider;
@property (nonatomic,retain)IBOutlet UIButton *borderdonebtn;

@property (nonatomic,retain)IBOutlet UIView *bguiView;
@property (nonatomic,retain)IBOutlet UIButton *bgdonebtn;
@property (nonatomic,retain) NSMutableArray *bgArray;
@property (nonatomic,retain)IBOutlet UICollectionView *bgcolView;

@property (nonatomic,retain)IBOutlet UILabel *btmlbl;

@property (nonatomic, strong) DRColorPickerColor* color;
@property (nonatomic, weak) DRColorPickerViewController* colorPickerVC;

@end

NS_ASSUME_NONNULL_END
