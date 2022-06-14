//
//  ShareViewController.m
//  Tree Collage Maker
//
//  Created by Tejas Vaghasiya on 13/04/17.
//  Copyright © 2017 Tejas Vaghasiya. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
//{
////    BOOL isshare;
//}

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btmscrollview.hidden = YES;
    
    if (IPAD) {
        _topView.frame = CGRectMake(0, 0, WIDTH, 80);
        _saveImgView.frame = CGRectMake((WIDTH-(WIDTH-100))/2, 85, WIDTH-100, WIDTH-100);
        _bannerView.frame = CGRectMake(0, 85+(WIDTH-100), WIDTH, 90);
        _btmView.frame = CGRectMake(0, 85+(WIDTH-100)+90, WIDTH, HEIGHT-(85+(WIDTH-100)+90));
    }
    else if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        _topView.frame = CGRectMake(0, 0, WIDTH, 45);
        _saveImgView.frame = CGRectMake(0, 50, WIDTH, WIDTH);
        _bannerView.frame = CGRectMake(0, WIDTH+50, WIDTH, 50);
        _btmView.frame = CGRectMake(0, WIDTH+50+50, WIDTH, HEIGHT-(WIDTH+50+50));
    }
    else{
        _topView.frame = CGRectMake(0, 30, WIDTH, 45);
        _saveImgView.frame = CGRectMake(0, 80, WIDTH, WIDTH);
        _bannerView.frame = CGRectMake(0, 80+WIDTH, WIDTH, 50);
        _btmView.frame = CGRectMake(0, WIDTH+80+50, WIDTH, HEIGHT-(WIDTH+80+50));
    }
    
    [AppDelObj loadBannerAds:_bannerView];
    _bannerView.delegate = self;
    
    _toplbl.backgroundColor = TopColor;
    _topView.backgroundColor = TopColor;
    
    _saveImgView.image = _saveimage;
    
//    isshare = [[NSUserDefaults standardUserDefaults]boolForKey:@"isShare"];
    
    _instabtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _morebtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _videotomp3btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
//    NSLog(@"view did load");
    
    
}
-(void)viewDidAppear:(BOOL)animated{
//    NSLog(@"view did appear");
    [self performSelector:@selector(animatebutton) withObject:self afterDelay:0.1];
//    [self animatebutton];
}
-(void)animatebutton
{
    float btnwid = (WIDTH*180)/320;
    float btnhei = (btnwid*43)/180;
    float btnx = (WIDTH - btnwid)/2;
    
    _btmscrollview.frame = CGRectMake(0, 0, WIDTH, _btmView.frame.size.height);
    _btmscrollview.contentSize = CGSizeMake(WIDTH, btnhei*3+80);
    
    _instabtn.frame = CGRectMake(btnx, _btmscrollview.frame.size.height, btnwid, btnhei);
    _morebtn.frame = CGRectMake(btnx, _btmscrollview.frame.size.height+btnhei+40, btnwid, btnhei);
    _videotomp3btn.frame = CGRectMake(btnx, _btmscrollview.frame.size.height+btnhei*2+60, btnwid, btnhei);
    
    _btmscrollview.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.instabtn.frame = CGRectMake(btnx, 20, btnwid, btnhei);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.morebtn.frame = CGRectMake(btnx, btnhei+40, btnwid, btnhei);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                
            } completion:^(BOOL finished) {
                self.videotomp3btn.frame = CGRectMake(btnx, btnhei*2+60, btnwid, btnhei);
            }];
        }];
    }];
}
- (void)showAlertViewWithMessage:(NSString*)message
{
    void (^showBlock)() = ^(){
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [view show];
    };
    if ([NSThread isMainThread]) {
        showBlock();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            showBlock();
        });
    }
}
-(void)savemethod{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imagesPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    if (![fileManager fileExistsAtPath:imagesPath]) {
        [fileManager createDirectoryAtPath:imagesPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *FileName = [NSString stringWithFormat:@"image-%lu.png", (unsigned long)([[NSDate date] timeIntervalSince1970]*10.0)];
    NSString *images=[documentsDirectory stringByAppendingPathComponent:@"/images"];
    NSString *imagepath=[images stringByAppendingPathComponent:FileName];
    NSLog(@"path : %@",imagepath);
    NSData *imageData = UIImagePNGRepresentation(_saveimage);
    [imageData writeToFile:imagepath atomically:YES];
    
    [[ZCPhotoLibrary sharedInstance]saveImageDatas:_saveimage toAlbum:APPLICATION_NAME withCompletionBlock:^(NSError* error){
        if (error) {
            NSLog(@"Error");
        }
        else {
            [self showAlertViewWithMessage:@"Saved Successfully into Photo Collage Album and Camera Roll !!"];
        }
    }];
}
-(IBAction)instabtnpress:(id)sender
{
    if (AppDelObj.inter_View.isReady)
    {
        AppDelObj.inter_View.delegate = self;
        [AppDelObj.inter_View presentFromRootViewController:self];
    }
    else{
        [self savemethod];
    }
}
-(IBAction)morebtnpress:(id)sender
{
    UIImage *savedImage=_saveimage;
    
    NSArray *objectsToShare = @[savedImage];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    if (IPAD) {
        
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        
        
        [popoverController presentPopoverFromRect:[(UIButton *)sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
    }else{
        [self presentViewController:activityVC animated:YES completion:nil];
    }

}
-(IBAction)backbtnpress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)homebtnpress:(id)sender
{
    ViewController *view=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    view.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:view animated:YES completion:nil];
}
-(void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    [AppDelObj createInterView];
}

- (void) interstitialDidDismissScreen:(GADInterstitial *)ad
{
    [self savemethod];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    [AppDelObj createInterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
