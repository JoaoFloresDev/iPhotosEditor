//
//  ViewController.h
//  Photo Collage Maker
//
//  Created by Vaishu on 8/27/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "D3MainViewController.h"
#import "UIViewController+YMSPhotoHelper.h"
#import "CollectionViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "TreeMainViewController.h"
#import "RMStore.h"
#import <StoreKit/StoreKit.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>

@protocol dismissDelegate <NSObject>
-(void)didReceiveDelegateWith:(NSArray *)myArray;
@end

@interface ViewController : UIViewController<YMSPhotoPickerViewControllerDelegate,GADInterstitialDelegate,GADUnifiedNativeAdLoaderDelegate,GADVideoControllerDelegate,GADUnifiedNativeAdDelegate,dismissDelegate,FBInterstitialAdDelegate>

@property (nonatomic,retain)IBOutlet UIImageView *bgimgview;
@property (nonatomic,retain)IBOutlet UILabel *toplbl;

@property (nonatomic,retain)IBOutlet UIView *btmView;
@property (nonatomic,retain)IBOutlet UIButton *photobtn;
@property (nonatomic,retain)IBOutlet UIButton *treebtn;
@property (nonatomic,retain)IBOutlet UIButton *d3btn;
@property (nonatomic,retain)IBOutlet UIButton *morebtn;

@property (nonatomic,retain)IBOutlet UIView *mainAdView;
@property(nonatomic, strong) GADAdLoader *adLoader;
@property(nonatomic, strong) GADUnifiedNativeAdView *nativeAdView;

@property (nonatomic,retain)IBOutlet UIButton *adsbtn;

@property (nonatomic,retain)IBOutlet UIView *AdsView;
@property (nonatomic,retain)IBOutlet UILabel *pricelbl;
@property (nonatomic,retain)IBOutlet UIButton *purchasebtn;
@property (nonatomic,retain)IBOutlet UIButton *restorebtn;
@property (nonatomic,retain)IBOutlet UIButton *adsclosebtn;

@property (nonatomic, strong) FBInterstitialAd *interstitialAd;

@end

