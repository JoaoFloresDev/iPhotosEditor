//
//  ShareViewController.h
//  Tree Collage Maker
//
//  Created by Tejas Vaghasiya on 13/04/17.
//  Copyright © 2017 Tejas Vaghasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
//#import "MGInstagram.h"
#import "ZCPhotoLibrary.h"
#import "AppDelegate.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ShareViewController : UIViewController<GADBannerViewDelegate,GADInterstitialDelegate>

@property (nonatomic,retain)IBOutlet UIView *topView;
@property (nonatomic,retain)IBOutlet UILabel *toplbl;

@property (nonatomic,retain)IBOutlet GADBannerView *bannerView;

@property (nonatomic,retain)UIImage *saveimage;
//@property (nonatomic,retain) MGInstagram *instagram;

@property (nonatomic,retain)IBOutlet UIImageView *saveImgView;

@property (nonatomic,retain)IBOutlet UIView *btmView;
@property (nonatomic,retain)IBOutlet UIScrollView *btmscrollview;
@property (nonatomic,retain)IBOutlet UIButton *instabtn;
@property (nonatomic,retain)IBOutlet UIButton *morebtn;
@property (nonatomic,retain)IBOutlet UIButton *videotomp3btn;
@end
