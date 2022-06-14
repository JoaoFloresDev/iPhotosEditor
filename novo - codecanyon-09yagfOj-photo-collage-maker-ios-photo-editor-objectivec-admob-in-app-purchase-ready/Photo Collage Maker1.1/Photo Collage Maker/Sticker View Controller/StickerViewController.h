//
//  StickerViewController.h
//  YouCamPerfect
//
//  Created by Tejas Vaghasiya on 06/08/16.
//  Copyright © 2016 Tejas Vaghasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorCollectionViewCell.h"
#import "ViewController.h"
#import "D3MainViewController.h"
#import "PhotoMainViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "TreeMainViewController.h"
#import <SVProgressHUD.h>

@protocol stickerDelegate;
@protocol photostickerDelegate;
@protocol treestickerDelegate;

typedef void(^amyCompletion)(NSDictionary *jsonResult);

@interface StickerViewController : UIViewController<GADBannerViewDelegate>

@property(nonatomic,retain)id <stickerDelegate>delegate;
@property(nonatomic,retain)id <photostickerDelegate>photodelegate;
@property(nonatomic,retain)id <treestickerDelegate>tstickerdelegate;

@property (nonatomic)NSInteger stickerindex;
@property (nonatomic,retain)IBOutlet UIView *topView;
@property (nonatomic,retain) IBOutlet UILabel *headerlbl;
@property (nonatomic,retain) IBOutlet UILabel *toplbl;

//@property(retain,nonatomic)IBOutlet UILabel *lblWarning;
//
@property(strong, nonatomic)IBOutlet GADBannerView *bannerView;
//@property(nonatomic, strong) GADInterstitial *interstitial;

@property(retain,nonatomic)IBOutlet UICollectionView *CatagoryCollection;
@property(retain,nonatomic)IBOutlet UICollectionView *StickerCollection;
//@property(retain,nonatomic)NSMutableArray *listArray;
//@property(retain,nonatomic)NSMutableArray *downloadArray;


//@property(strong, nonatomic)IBOutlet UIActivityIndicatorView *indicator;



@end
