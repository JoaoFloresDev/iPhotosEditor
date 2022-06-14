//
//  AppDelegate.h
//  Photo Collage Maker
//
//  Created by Vaishu on 8/27/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
#define STATUSBARHEIGHT 30

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON)
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_IPHONE_X ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )812 ) < DBL_EPSILON)
#define IS_IPHONE_XS_MAX  ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )896 ) < DBL_EPSILON)
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)

#define TopColor [UIColor colorWithRed:255.0/255.0 green:67.0/255.0 blue:85.0/255.0 alpha:1.0]
#define BottomBGColor [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]

#define APPLICATION_NAME @"Photo Collage Maker"

#define ITUNESLINKDEVELOPER @"itms-apps://itunes.apple.com/developer/id1471399238"
#define REVIEWURL @"itms-apps://itunes.apple.com/app/id1481321587"
#define APPID @"1481321587"
#define ProductID @"meet.collage.removeads"

//#define FOnt @"Avenir LT Std"
//#define FOntSize 18

#define Duration 0.3f
#define IPhoneHeight 120
#define IPADHeight 150
#define XHeight 140

#define AppDelObj ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define Banner_ID @"ca-app-pub-3940256099942544/6300978111"
#define Inter_ID @"ca-app-pub-3940256099942544/1033173712"
#define native @"ca-app-pub-3940256099942544/2247696110"

#define DEFAULT [NSUserDefaults standardUserDefaults]
#define AD_COUNT         @"AD_COUNT"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GADBannerViewDelegate,GADInterstitialDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UIViewController *viewcntr;

@property(retain,nonatomic) GADInterstitial *inter_View;
-(void)loadBannerAds : (GADBannerView *)bannerView;
-(UIImage *)LoadAllEffectWithImage:(UIImage *)thumbImg WithIndex:(NSInteger)index;
- (UIImage *) screenshotimageWithView:(UIView *)view;
-(void)createInterView;

@end

