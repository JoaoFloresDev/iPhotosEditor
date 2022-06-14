//
//  FrameViewController.h
//  WaterfallPhotoFrame
//
//  Created by Tejas vaghasiya on 11/06/16.
//  Copyright © 2016 Tejas vaghasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "D3MainViewController.h"
#import "FrameCollectionViewCell.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@protocol frameDelegate;

@interface FrameViewController : UIViewController<GADBannerViewDelegate>

@property(nonatomic,retain)id <frameDelegate>delegate;

@property (nonatomic,retain)IBOutlet UILabel *toplbl;

@property (nonatomic,retain) IBOutlet UICollectionView *collectionFrame;
@property (nonatomic,retain)IBOutlet UIView *topView;
@property (nonatomic,retain) IBOutlet UIButton *btnBAck;
@property (nonatomic,retain) IBOutlet UILabel *lblTOp;
@property(strong, nonatomic)IBOutlet GADBannerView *bannerView;


@end
