//
//  EditViewController.h
//  Tree Collage Maker
//
//  Created by Tejas Vaghasiya on 11/04/17.
//  Copyright © 2017 Tejas Vaghasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PECropViewController.h"
#import "FrameCollectionViewCell.h"
#import "GPUImage.h"
#import "DidImageFilters.h"
#import "IQLabelView.h"
#import "DidImageView.h"
#import "DTColorPickerImageView.h"
#import "UITextField+DynamicFontSize.h"
#import "TreeMainViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@protocol treeDelegate;

@interface EditViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,IQLabelViewDelegate,DTColorPickerImageViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate>
{
    DidImageFilters *didImageFilter;
    IQLabelView *currentlyEditingLabel;
    NSMutableArray *labels;
    IQLabelView *labelView;

}

@property (nonatomic,retain)id <treeDelegate>delegate;

@property (nonatomic,retain)UIImage *mainImage;

@property (nonatomic,retain)IBOutlet UIView *topView;
@property (nonatomic,retain)IBOutlet UILabel *toplbl;
@property (nonatomic,retain)IBOutlet UILabel *btmlbl;

@property (nonatomic,retain)IBOutlet UIView *saveview;
@property (nonatomic,retain)IBOutlet UIImageView *mainimgview;
@property (nonatomic,retain)IBOutlet UIImageView *effectimgview;

@property (nonatomic,retain)IBOutlet GADBannerView *bannerView;

@property (nonatomic,retain)IBOutlet UIView *btmmainview;
@property (nonatomic,retain)IBOutlet UIButton *cropbtn;
@property (nonatomic,retain)IBOutlet UIButton *effectbtn;
@property (nonatomic,retain)IBOutlet UIButton *maindrawbtn;
@property (nonatomic,retain)IBOutlet UIButton *textbtn;

@property (nonatomic,retain)IBOutlet UIView *effectview;
@property (nonatomic,retain)IBOutlet UISlider *effectslider;
@property (nonatomic,retain)IBOutlet UICollectionView *effectcolview;
@property (nonatomic,retain) IBOutlet UIButton *effectdonebtn;

@property (nonatomic,retain)IBOutlet UIView *drawview;
@property (nonatomic,retain)IBOutlet UISlider *opacityslider;
@property (nonatomic,retain)IBOutlet UISlider *sizeslider;
@property (weak, nonatomic) IBOutlet DidImageView *frontImageView;
@property (nonatomic,retain)IBOutlet UIButton *erasebtn;
@property (nonatomic,retain)IBOutlet UIButton *drawbtn;
@property (nonatomic,retain)IBOutlet UIButton *colorbtn;

@property (nonatomic,retain) IBOutlet UIView *MainToolbarView;
@property (nonatomic,retain) IBOutlet UIButton *textkbdbtn;
@property (nonatomic,retain) IBOutlet UIButton *textcolorbtn;
@property (nonatomic,retain) IBOutlet UIButton *textfontbtn;
@property (nonatomic,retain) IBOutlet UIButton *textdonebtn;

@property (nonatomic,retain) IBOutlet UIView *MainTextUIView;
@property (nonatomic,retain) IBOutlet UIView *MainTextColorPicker;
@property (nonatomic,retain) IBOutlet UIView *MainTextPickerView;
@property (nonatomic,retain) IBOutlet UICollectionView *pickerview;
@property (nonatomic,retain) NSArray *fontArray;

@property (nonatomic,retain)IBOutlet UIView *colorview;
@property (nonatomic,retain)IBOutlet UILabel *prevlbl;
@property (nonatomic,retain)IBOutlet UIImageView *drawcolorimgview;

@end
