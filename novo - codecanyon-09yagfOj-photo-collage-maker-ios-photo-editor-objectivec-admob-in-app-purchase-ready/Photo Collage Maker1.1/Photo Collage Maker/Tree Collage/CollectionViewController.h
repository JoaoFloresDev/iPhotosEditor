//
//  CollectionViewController.h
//  Tree Collage Maker
//
//  Created by Tejas Vaghasiya on 10/04/17.
//  Copyright © 2017 Tejas Vaghasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCollectionViewCell.h"
#import "AppDelegate.h"
//#import "AlbumViewController.h"
//#import "MainViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "UIViewController+YMSPhotoHelper.h"
#import "TreeMainViewController.h"
#import "ViewController.h"
#import <Foundation/Foundation.h>

@protocol dismissDelegate;

@interface CollectionViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,GADBannerViewDelegate,YMSPhotoPickerViewControllerDelegate,dismissDelegate>

@property (nonatomic,retain)IBOutlet UIView *topView;
@property (nonatomic,retain)IBOutlet UILabel *toplbl;

@property (nonatomic,retain)IBOutlet UICollectionView *framecolview;
@property (nonatomic,retain)IBOutlet GADBannerView *bannerView;

@property (nonatomic,retain)id <dismissDelegate>delegate;

@end
