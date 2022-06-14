//
//  ViewController.m
//  Photo Collage Maker
//
//  Created by Vaishu on 8/27/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSInteger btnindex;
    BOOL purchase;
    NSNumberFormatter * _priceFormatter;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainAdView.hidden = YES;
    _AdsView.alpha = 0.0;
    
    _photobtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _treebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _d3btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _morebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _adsbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _adsclosebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _purchasebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _restorebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (IPAD) {
        _toplbl.hidden = YES;
        _btmView.frame = CGRectMake(150, HEIGHT-(WIDTH-300), WIDTH-300, WIDTH-300);
        _mainAdView.frame = CGRectMake(200, 0, WIDTH-400, _btmView.frame.origin.y-10);
    }
    else if (IS_IPHONE_6_PLUS || IS_IPHONE_6 || IS_IPHONE_5 || IS_IPHONE_4){
        _toplbl.hidden = YES;
        _btmView.frame = CGRectMake(0, HEIGHT-WIDTH+30, WIDTH, WIDTH-30);
        _mainAdView.frame = CGRectMake(0, 0, WIDTH, _btmView.frame.origin.y-10);
    }
    else{
        _toplbl.hidden = NO;
        _btmView.frame = CGRectMake(0, HEIGHT-WIDTH, WIDTH, WIDTH);
        _mainAdView.frame = CGRectMake(0, 30, WIDTH, _btmView.frame.origin.y-10-30);
    }
    
    [self settingAnimation];
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    purchase = [[NSUserDefaults standardUserDefaults]boolForKey:@"purchase"];
    [self loadPurchaseView];
    
    if (purchase == NO) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"UnifiedNativeAdView" owner:nil options:nil];
        [self setAdView:[nibObjects firstObject]];
        [self refreshAd:nil];
        [self LoadFBAds];
    }
//    [self LoadNativeAd];
    // Do any additional setup after loading the view.
}
-(void)settingAnimation
{
    [UIView animateWithDuration:1.0 animations:^{
        self.adsbtn.transform = CGAffineTransformMakeScale(1.5,1.5);
        
    }completion:^(BOOL finished){
        [UIView animateWithDuration:1.0 animations:^{
            self.adsbtn.transform = CGAffineTransformMakeScale(1.0,1.0);
        }completion:^(BOOL finished) {
            [self settingAnimation];
        }];
    }];
}
-(void)didReceiveDelegateWith:(NSArray *)myArray
{
//    NSLog(@"receive delegate");
    TreeMainViewController *tree= [[TreeMainViewController alloc]initWithNibName:@"TreeMainViewController" bundle:nil];
    tree.mainArray = [myArray mutableCopy];//[DEFAULT objectForKey:@"treeArray"];//[photoAssets mutableCopy];
    tree.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:tree animated:YES completion:nil];
//    [DEFAULT setBool:NO forKey:@"dismiss"];
}
- (IBAction)refreshAd:(id)sender {
    // Loads an ad for unified native ad.
//    self.refreshButton.enabled = NO;
    
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:native
                                       rootViewController:self
                                                  adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
                                                  options:@[ videoOptions ]];
    self.adLoader.delegate = self;
    [self.adLoader loadRequest:[GADRequest request]];
}
- (void)setAdView:(GADUnifiedNativeAdView *)view {
    // Remove previous ad view.
    [self.nativeAdView removeFromSuperview];
    self.nativeAdView = view;
    view.frame = CGRectMake(0, 0, _mainAdView.frame.size.width, _mainAdView.frame.size.height);
    // Add new ad view and set constraints to fill its container.
    [self.mainAdView addSubview:view];
    
    NSLog(@"set ad view");
}
-(void)LoadFBAds
{
    self.interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:@"746848915786274_746850892452743"];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAd];
    
}
- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd
{
  NSLog(@"Ad is loaded and ready to be displayed");

  
}
- (void)interstitialAdWillLogImpression:(FBInterstitialAd *)interstitialAd
{
  NSLog(@"The user sees the add");
  // Use this function as indication for a user's impression on the ad.
}

- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd
{
  NSLog(@"The user clicked on the ad and will be taken to its destination");
  // Use this function as indication for a user's click on the ad.
}

- (void)interstitialAdWillClose:(FBInterstitialAd *)interstitialAd
{
  NSLog(@"The user clicked on the close button, the ad is just about to close");
  // Consider to add code here to resume your app's flow
}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd
{
  NSLog(@"Interstitial had been closed");
    if (btnindex == 1) {
        [self openphotoGallery];
    }
    else if (btnindex == 2){
        CollectionViewController *collection = [[CollectionViewController alloc]initWithNibName:@"CollectionViewController" bundle:nil];
        collection.delegate = self;
        collection.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:collection animated:YES completion:nil];
    }
    else if (btnindex == 3){
        [self openimagepicker];
    }
    btnindex = 0;
    [self LoadFBAds];
  // Consider to add code here to resume your app's flow
}
- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
  NSLog(@"Ad failed to load");
}

#pragma mark GADAdLoaderDelegate implementation
- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@ failed with error: %@", adLoader, error);
//    self.refreshButton.enabled = YES;
}

#pragma mark GADUnifiedNativeAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
//    self.refreshButton.enabled = YES;
    
    GADUnifiedNativeAdView *nativeAdView = self.nativeAdView;
    
    // Deactivate the height constraint that was set when the previous video ad loaded.
//    self.heightConstraint.active = NO;
    
    nativeAdView.nativeAd = nativeAd;
    
    // Set ourselves as the ad delegate to be notified of native ad events.
    nativeAd.delegate = self;
    
    // Populate the native ad view with the native ad assets.
    // The headline and mediaContent are guaranteed to be present in every native ad.
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;
    nativeAdView.mediaView.mediaContent = nativeAd.mediaContent;
    
    // This app uses a fixed width for the GADMediaView and changes its height
    // to match the aspect ratio of the media content it displays.
    if (nativeAd.mediaContent.aspectRatio > 0) {

    }
    
    if (nativeAd.videoController.hasVideoContent) {
        // By acting as the delegate to the GADVideoController, this ViewController
        // receives messages about events in the video lifecycle.
        nativeAd.videoController.delegate = self;
        
//        self.videoStatusLabel.text = @"Ad contains a video asset.";
    } else {
//        self.videoStatusLabel.text = @"Ad does not contain a video.";
    }
    
    // These assets are not guaranteed to be present. Check that they are before
    // showing or hiding them.
    ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
    nativeAdView.bodyView.hidden = nativeAd.body ? NO : YES;
    
    [((UIButton *)nativeAdView.callToActionView) setTitle:nativeAd.callToAction
                                                 forState:UIControlStateNormal];
    nativeAdView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;
    
    ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
    nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;
    
    ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
    nativeAdView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;
    
    // In order for the SDK to process touch events properly, user interaction
    // should be disabled.
    nativeAdView.callToActionView.userInteractionEnabled = NO;
    _mainAdView.hidden = NO;
    _bgimgview.hidden = YES;
    NSLog(@"ad loader");
}

#pragma mark GADVideoControllerDelegate implementation

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
//    self.videoStatusLabel.text = @"Video playback has ended.";
}

#pragma mark GADUnifiedNativeAdDelegate

- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(IBAction)photobtnpress:(id)sender
{
    btnindex = 1;
    if (purchase == YES) {
        [self openphotoGallery];
    }
    else{
        if (AppDelObj.inter_View.isReady)
        {
            AppDelObj.inter_View.delegate = self;
            [AppDelObj.inter_View presentFromRootViewController:self];
        }
        else{
            [self openphotoGallery];
        }
    }
}
-(void)openphotoGallery {
    YMSPhotoPickerViewController *pickerViewController = [[YMSPhotoPickerViewController alloc] init];
    pickerViewController.numberOfPhotoToSelect = 6;
    pickerViewController.selectIndex = 0;
    
    UIColor *customColor = TopColor;//[UIColor greenColor];//[UIColor colorWithRed:248.0/255.0 green:217.0/255.0 blue:44.0/255.0 alpha:1.0];
    
    pickerViewController.theme.titleLabelTextColor = [UIColor whiteColor];
    pickerViewController.theme.titleLabelFont = [UIFont fontWithName:@"AvenirLTStd-Heavy" size:18.0];
    pickerViewController.theme.albumNameLabelFont = [UIFont fontWithName:@"AvenirLTStd-Medium" size:18.0];
    pickerViewController.theme.photosCountLabelFont = [UIFont fontWithName:@"AvenirLTStd-Medium" size:18.0];
    pickerViewController.theme.navigationBarBackgroundColor = customColor;
    pickerViewController.theme.tintColor = [UIColor whiteColor];
    pickerViewController.theme.orderTintColor = customColor;
    pickerViewController.theme.orderLabelTextColor = [UIColor whiteColor];
    pickerViewController.theme.cameraVeilColor = customColor;
    pickerViewController.theme.cameraIconColor = [UIColor whiteColor];
    pickerViewController.theme.statusBarStyle = UIStatusBarStyleDefault;
    
    pickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self yms_presentCustomAlbumPhotoView:pickerViewController delegate:self];
}
-(IBAction)treebtnpress:(id)sender
{
    btnindex = 2;
    if (purchase == YES) {
        CollectionViewController *collection = [[CollectionViewController alloc]initWithNibName:@"CollectionViewController" bundle:nil];
        collection.delegate = self;
        collection.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:collection animated:YES completion:nil];
    }
    else{
        
        if (AppDelObj.inter_View.isReady)
        {
            AppDelObj.inter_View.delegate = self;
            [AppDelObj.inter_View presentFromRootViewController:self];
        }
        else{
            CollectionViewController *collection = [[CollectionViewController alloc]initWithNibName:@"CollectionViewController" bundle:nil];
            collection.delegate = self;
            collection.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:collection animated:YES completion:nil];
        }
    }
}
-(IBAction)d3btnpress:(id)sender
{
    btnindex = 3;
    if (purchase == YES) {
        [self openimagepicker];
    }
    else{
        if (AppDelObj.inter_View.isReady)
        {
            AppDelObj.inter_View.delegate = self;
            [AppDelObj.inter_View presentFromRootViewController:self];
        }
        else{
            [self openimagepicker];
        }
    }
}
-(IBAction)adsbtnpress:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.AdsView.alpha = 1.0;
    }];
}
-(IBAction)adsclosebtnpress:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.AdsView.alpha = 0.0;
    }];
}
-(IBAction)restorebtnpress:(id)sender
{
    [SVProgressHUD showWithStatus:@"Please Wait"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];

    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions) {
        self->purchase = YES;
        [SVProgressHUD dismiss];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"purchase"];
        self.mainAdView.hidden = YES;
        self.bgimgview.hidden = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Restore Transactions Success", @"")
                                                        message:@"Restore is Success"
                                                        delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                      otherButtonTitles:nil];
        [alertView show];
    //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.AdsView.alpha = 0.0;
        }];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
    //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Restore Transactions Failed", @"")
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                      otherButtonTitles:nil];
            [alertView show];
    }];
}
-(IBAction)purchasebtnpress:(id)sender
{
    [SVProgressHUD showWithStatus:@"Please Wait"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            
        [[RMStore defaultStore] addPayment:ProductID success:^(SKPaymentTransaction *transaction) {
            NSLog(@"Purchased!");
            [SVProgressHUD dismiss];

            self->purchase = YES;
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"purchase"];
            self.mainAdView.hidden = YES;
            self.bgimgview.hidden = NO;
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                      @"Purchase is completed succesfully" message:nil delegate:
                                      self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            [UIView animateWithDuration:0.3 animations:^{
                self.AdsView.alpha = 0.0;
            }];
            
            } failure:^(SKPaymentTransaction *transaction, NSError *error) {
                    NSLog(@"Something went wrong");
                    NSLog(@"error : %@",error);
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"purchase"];
                [SVProgressHUD dismiss];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Something went wrong" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];

                    // Update the UI on the main thread.
                });
                
        }];
}
-(void)loadPurchaseView
{
//    NSString *str = @"mehul.ielts.writing.removeads";
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:ProductID,nil];
    
    [[RMStore defaultStore] requestProducts:productIdentifiers success:^(NSArray *product, NSArray *invalidProductIdentifiers) {
//        self->_products = product;
//        [self.settingtblView reloadData];
        if (self->purchase == YES) {
            self.pricelbl.text = @"Purchsed";
            self.purchasebtn.enabled = NO;
//            [cell.buybtn setTitle:@"Purchased" forState:UIControlStateNormal];
//            cell.moneylbl.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"price"];
//            [cell.buybtn removeTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            if (product.count != 0) {
                NSLog(@"product available");
                SKProduct * product1 = (SKProduct *) [product objectAtIndex:0];
                [self->_priceFormatter setLocale:product1.priceLocale];
                
                NSString *price = [self->_priceFormatter stringFromNumber:product1.price];
                self.pricelbl.text = [NSString stringWithFormat:@"Price : %@",price];
                [[NSUserDefaults standardUserDefaults]setObject:price forKey:@"price"];
//                [cell.buybtn setTitle:@"Buy" forState:UIControlStateNormal];
//                [cell.buybtn addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                NSLog(@"somethong went wrong");
                dispatch_async(dispatch_get_main_queue(), ^{
                self.purchasebtn.enabled = NO;
//                    [self.purchasebtn.enabled = NO];
                });
//                cell.buybtn.enabled = NO;
            }
        }
        
    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Something went wrong" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }];
}
-(void)openimagepicker {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark Custom Gallery Delegates
-(void)photoPickerViewControllerDidReceivePhotoAlbumAccessDenied:(YMSPhotoPickerViewController *)picker{
    NSLog(@"library denied");
}
-(void)photoPickerViewControllerDidReceiveCameraAccessDenied:(YMSPhotoPickerViewController *)picker{
    NSLog(@"camera denied");
}
- (void)photoPickerViewController:(YMSPhotoPickerViewController *)picker didFinishPickingImages:(NSArray *)photoAssets
{
    [picker dismissViewControllerAnimated:YES completion:^() {

    }];
}

#pragma mark ImagePicker Methods
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^
     {
         D3MainViewController *main = [[D3MainViewController alloc]initWithNibName:@"D3MainViewController" bundle:nil];
         main.mainImage = chosenImage;
         main.modalPresentationStyle = UIModalPresentationFullScreen;
         [self presentViewController:main animated:YES completion:nil];
     }];
}
-(IBAction)morebtnpress:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REVIEWURL] options:@{} completionHandler:nil];
}

-(void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    [AppDelObj createInterView];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    if (btnindex == 1) {
        [self openphotoGallery];
    }
    else if (btnindex == 2){
        CollectionViewController *collection = [[CollectionViewController alloc]initWithNibName:@"CollectionViewController" bundle:nil];
        collection.delegate = self;
        collection.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:collection animated:YES completion:nil];
    }
    else if (btnindex == 3){
        [self openimagepicker];
    }
    btnindex = 0;
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    [AppDelObj createInterView];
}

@end
