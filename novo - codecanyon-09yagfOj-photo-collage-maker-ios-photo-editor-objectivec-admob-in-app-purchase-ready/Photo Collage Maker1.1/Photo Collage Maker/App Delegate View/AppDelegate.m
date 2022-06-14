//
//  AppDelegate.m
//  Photo Collage Maker
//
//  Created by Vaishu on 8/27/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import "AppDelegate.h"
#import "DidImageFilters.h"

@interface AppDelegate (){
    DidImageFilters *imagefilters;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewcntr = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewcntr;
    [self.window makeKeyAndVisible];
    
    imagefilters = [[DidImageFilters alloc]init];
    
    [self createInterView];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        NSLog(@"Already Launched");
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"purchase"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"purchase"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"$ 1.99" forKey:@"price"];
    }
    
    return YES;
}
- (UIImage *) screenshotimageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
-(UIImage *)LoadAllEffectWithImage:(UIImage *)thumbImg WithIndex:(NSInteger)index
{
    UIImage *effectedImage;
    
    if (index==0) {
        effectedImage=thumbImg;
    }else if (index==1)
    {
        effectedImage= [imagefilters BlackAndWhiteImage:thumbImg];
        
    }else if (index==2){
        effectedImage=  [imagefilters LookupFilter:thumbImg AndLookupImageName:@"A13.png"];
        
    }else if (index==3){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A14.png"];
        
    }else if (index==4){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A15.png"];
        
    }else if (index==5){
        effectedImage= [imagefilters LookupFilter:thumbImg AndLookupImageName:@"A16.png"];
        
    }else if (index==6){
        effectedImage= [imagefilters MonoBlackAndWhiteImage:thumbImg];
        
    }else if (index==7){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A17.png"];
        
    }else if (index==8){
        effectedImage= [imagefilters LookupFilter:thumbImg AndLookupImageName:@"A18.png"];
        
    }else if (index==9){
        effectedImage=[imagefilters SepiaWithImage:thumbImg ];
        
    }else if (index==10){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A34.png"];
        
    }else if (index==11){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A19.png"];
        
    }else if (index==12){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A20.png"];
        
    }else if (index==13){
        effectedImage=[imagefilters SketchWithImage:thumbImg];
        
    }else if (index==14){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A21.png"];
        
    }else if (index==15){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A22.png"];
        
    }else if (index==16){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A23.png"];
        
    }else if (index==17){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A24.png"];
        
    }else if (index==18){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A25.png"];
        
    }else if (index==19){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A26.png"];
        
    }else if (index==20){
        effectedImage=[imagefilters PosterizeWithImage:thumbImg];
        
    }else if (index==21){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A27.png"];
        
    }else if (index==22){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A28.png"];
        
    }else if (index==23){
        effectedImage=[imagefilters VigneteWithImage:thumbImg];
        
    }else if (index==24){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A29.png"];
        
    }else if (index==25){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A30.png"];
        
    }else if (index==26){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A31.png"];
        
    }else if (index==27){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A32.png"];
        
    }else if (index==28){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A33.png"];
        
    }else if (index==29){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A34.png"];
        
    }else if (index==30){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A35.png"];
        
    }else if (index==31){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A36.png"];
        
    }else if (index==32){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A37.png"];
        
    }else if (index==33){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A38.png"];
        
    }else if (index==34){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A39.png"];
        
    }else if (index==35){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A40.png"];
        
    }else if (index==36){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A41.png"];
        
    }else if (index==37){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A42.png"];
        
    }else if (index==38){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A43.png"];
        
    }else if (index==39){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A44.png"];
        
    }else if (index==40){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A45.png"];
        
    }else if (index==41){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A46.png"];
        
    }else if (index==42){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A47.png"];
        
    }else if (index==43){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A48.png"];
        
    }else if (index==44){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A49.png"];
        
    }else if (index==45){
        effectedImage=[imagefilters LookupFilter:thumbImg AndLookupImageName:@"A50.png"];
        
    }
    return effectedImage;
    
}

#pragma mark Banner Methods
-(void)loadBannerAds : (GADBannerView *)bannerView
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"purchase"] == YES){
        NSLog(@"app purchased");
    }
    else{
        bannerView.adUnitID = Banner_ID;
        bannerView.rootViewController = self.window.rootViewController;
        GADRequest *request = [GADRequest request];
        [bannerView loadRequest:request];
        bannerView.delegate = self;
    }
}

#pragma mark interestial Methods
-(void)createInterView
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"purchase"] == YES){
        NSLog(@"app purchased");
    }
    else{
        _inter_View = [[GADInterstitial alloc] initWithAdUnitID:Inter_ID];
        _inter_View.delegate = self;
        GADRequest *request = [GADRequest request];
        [_inter_View loadRequest:request];
    }
}
- (void) interstitialDidDismissScreen:(GADInterstitial *)ad
{
    [self createInterView];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    [self createInterView];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
