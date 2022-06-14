//
//  StickerViewController.m
//  YouCamPerfect
//
//  Created by Tejas Vaghasiya on 06/08/16.
//  Copyright © 2016 Tejas Vaghasiya. All rights reserved.
//

#import "StickerViewController.h"
//#import "UIImageView+WebCache.h"


@interface StickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *emojiStickers;
    NSMutableArray *catArray;
//    int index;
//    int count;
//    NSString *catStr;
    
//    float y;
}

@end

@implementation StickerViewController

/*- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    request.testDevices =
    [NSArray arrayWithObjects:
     nil];
    return request;
}

#pragma mark GADBannerViewDelegate callbacks

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
    _adBanner.hidden=NO;
    
}

- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

#pragma mark Smart Banner implementation

//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAll;
//}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInt
                               duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsLandscape(toInt)) {
        self.adBanner.adSize = kGADAdSizeSmartBannerLandscape;
    } else {
        self.adBanner.adSize = kGADAdSizeSmartBannerPortrait;
    }
}
#pragma mark GADRequest implementation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    
    request.testDevices = @[@"3b8e6cc684e409e49e5d7f8c92d1687d"];
    return request;
}
#pragma mark GADInterstitialDelegate implementation

- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    NSLog(@"interstitialDidDismissScreen");
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"Abcd");
    [self.interstitial presentFromRootViewController:self];
}

-(void)loadInterestial
{
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:kSampleAdUnitID];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[self request]];
}

-(void)loadBannerAd
{
    self.adBanner.adUnitID = kSampleAdUnitIDB;
    self.adBanner.delegate = self;
    self.adBanner.adSize=kGADAdSizeSmartBannerPortrait;
    [self.adBanner setRootViewController:self];
    [self.adBanner loadRequest:[self createRequest]];
    _adBanner.hidden=YES;
}
*/


-(void)viewDidLoad
{
    [super viewDidLoad];
    
//    if (IS_IPHONE_X || IS_IPHONE_XS_MAX) {
//        y = STATUSBARHEIGHT;
//    }
//    else{
//        y = 0;
//    }
    
    if (IPAD) {
        _topView.frame = CGRectMake(0, 0, WIDTH, 80);
        _bannerView.frame = CGRectMake(0, HEIGHT-90, WIDTH, 90);
        _CatagoryCollection.frame = CGRectMake(0, 80, WIDTH, 80);
        _StickerCollection.frame = CGRectMake(0, 165, WIDTH, HEIGHT-165-90);
    }
    else if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        _topView.frame = CGRectMake(0, 0, WIDTH, 45);
        _bannerView.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
        _CatagoryCollection.frame = CGRectMake(0, 45, WIDTH, 50);
        _StickerCollection.frame = CGRectMake(0, 95, WIDTH, HEIGHT-95-50);
    }
    else{
        _topView.frame = CGRectMake(0, 30, WIDTH, 45);
        _bannerView.frame = CGRectMake(0, HEIGHT-60, WIDTH, 50);
        _CatagoryCollection.frame = CGRectMake(0, 75, WIDTH, 50);
        _StickerCollection.frame = CGRectMake(0, 125, WIDTH, HEIGHT-125-60);
    }
    
    [AppDelObj loadBannerAds:_bannerView];
    _bannerView.delegate = self;
    
    _topView.backgroundColor = TopColor;
    _toplbl.backgroundColor = TopColor;

    emojiStickers=[[NSMutableArray alloc]init];
    catArray = [[NSMutableArray alloc]initWithObjects:@"Animal",@"Camera",@"Cartoon",@"Emoji",@"Fall",@"Flower",@"Food",@"Friends",@"Love",@"School", nil];
    
//    for (int i = 1; i<=154; i++) {
//        NSString *str = [NSString stringWithFormat:@"sticker_%d.png",i];
//        [emojiStickers addObject:str];
//    }
    
    _CatagoryCollection.delegate=self;
    _CatagoryCollection.dataSource=self;
    [_CatagoryCollection registerNib:[UINib nibWithNibName:@"ColorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [_CatagoryCollection selectItemAtIndexPath:indexPathForFirstRow animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:_CatagoryCollection didSelectItemAtIndexPath:indexPathForFirstRow];
    
    _StickerCollection.delegate=self;
    _StickerCollection.dataSource=self;
    [_StickerCollection registerNib:[UINib nibWithNibName:@"ColorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _CatagoryCollection) {
        return catArray.count;
    }
    else{
         return emojiStickers.count;
    }
}

-(ColorCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColorCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    if (collectionView == _CatagoryCollection) {
        cell.botomLine.hidden = NO;
        cell.cellLabel.hidden = NO;
        cell.cellImage.hidden = YES;
        
//        cell.botomLine.backgroundColor = [UIColor clearColor];
        cell.cellLabel.text = [catArray objectAtIndex:indexPath.row];
    }
    else{
        cell.botomLine.hidden = YES;
        cell.cellLabel.hidden = YES;
        cell.cellImage.hidden = NO;
        
        cell.layer.masksToBounds = YES;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth = 1.0;
        cell.layer.cornerRadius = 5.0;
        
        cell.cellImage.image = [UIImage imageNamed:[emojiStickers objectAtIndex:indexPath.row]];

    }
    
    return  cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _CatagoryCollection) {
        [SVProgressHUD showWithStatus:@"Please Wait"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [emojiStickers removeAllObjects];
        for (int i = 1; i<=20; i++) {
            NSString *str = [NSString stringWithFormat:@"%@_%d.png",[catArray objectAtIndex:indexPath.row],i];
            [emojiStickers addObject:str];
        }
        [_StickerCollection reloadData];
        [SVProgressHUD dismiss];
    }
    else{
        UIImage *image=[UIImage imageNamed:[emojiStickers objectAtIndex:indexPath.row]];
        
        if (_stickerindex == 0) {
            [_delegate didReceiveDelegateWith:image];
        }
        else if (_stickerindex == 1){
            [_photodelegate didReceiveDelegateWith:image];
        }
        else{
            [_tstickerdelegate didReceiveDelegateWith:image];
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size;

    if (collectionView == _CatagoryCollection) {
        if (IPAD) {
            size = CGSizeMake(90, 80);
        }
        else{
            size = CGSizeMake(90, 50);
        }
    }
    else{
        if(IS_IPHONE_4 || IS_IPHONE_5)
        {
            size=CGSizeMake(73, 73);
        }
        else if(IS_IPHONE_6 || IS_IPHONE_X)
        {
            size=CGSizeMake(69,69);
        }
        else if(IS_IPHONE_6_PLUS || IS_IPHONE_XS_MAX)
        {
            size=CGSizeMake(76,76);
        }
        else if (IPAD)
        {
            size=CGSizeMake(79,79);
        }
        else
        {
            size = CGSizeMake(69, 69);
        }
    }
    

    return size;
}

-(IBAction)banClosePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
