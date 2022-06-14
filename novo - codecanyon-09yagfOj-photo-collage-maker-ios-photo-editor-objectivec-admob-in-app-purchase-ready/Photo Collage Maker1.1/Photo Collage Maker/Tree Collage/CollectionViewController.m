//
//  CollectionViewController.m
//  Tree Collage Maker
//
//  Created by Tejas Vaghasiya on 10/04/17.
//  Copyright © 2017 Tejas Vaghasiya. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()
{
    NSMutableArray *frameArray;
    NSMutableArray *jsonArray;
    NSMutableArray *imageArray;
}

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IPAD) {
        _topView.frame = CGRectMake(0, 0, WIDTH, 80);
        _framecolview.frame = CGRectMake(5, 85, WIDTH-10, HEIGHT-85-90);
        _bannerView.frame = CGRectMake(0, HEIGHT-90, WIDTH, 90);
    }
    else if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        _topView.frame = CGRectMake(0, 0, WIDTH, 45);
        _framecolview.frame = CGRectMake(5, 50, WIDTH-10, HEIGHT-50-50);
        _bannerView.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
    }
    else{
        _topView.frame = CGRectMake(0, 30, WIDTH, 45);
        _framecolview.frame = CGRectMake(5, 80, WIDTH-10, HEIGHT-80-60);
        _bannerView.frame = CGRectMake(0, HEIGHT-60, WIDTH, 50);
    }
    
    _topView.backgroundColor = TopColor;
    _toplbl.backgroundColor = TopColor;
    
    _framecolview.delegate=self;
    _framecolview.dataSource=self;
    [_framecolview registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"framecell"];
    
    frameArray=[[NSMutableArray alloc]init];
    jsonArray=[[NSMutableArray alloc]init];
    imageArray=[[NSMutableArray alloc]init];

    for (int i=1; i<=24; i++) {
        NSString *str=[NSString stringWithFormat:@"thumb3d_%d.png",i];
        [frameArray addObject:str];
        
        NSString *json=[NSString stringWithFormat:@"mask3d_%d",i];
        [jsonArray addObject:json];
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return frameArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mysize;
    
    if (IS_IPHONE_6_PLUS || IS_IPHONE_XS_MAX){
        mysize=CGSizeMake((WIDTH-10-20)/4, (WIDTH-10-20)/4);
    }
    else if (IPAD)
    {
        mysize=CGSizeMake((WIDTH-10-25)/5, (WIDTH-10-25)/5);
    }
    else{
        mysize=CGSizeMake((WIDTH-10-15)/3, (WIDTH-10-15)/3);
    }
    return mysize;
}
-(MenuCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    MenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"framecell" forIndexPath:indexPath];
    cell.imgiew.image=[UIImage imageNamed:[frameArray objectAtIndex:indexPath.row]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[jsonArray objectAtIndex:indexPath.row] ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    NSArray *count=[[parsedObject valueForKey:@"frame_0"]valueForKey:@"count"];
//    NSLog(@"count : %@",count);
    NSInteger name=indexPath.row;
    [[NSUserDefaults standardUserDefaults]setInteger:name forKey:@"frameName"];
    
    NSString *str=[count objectAtIndex:0];
    NSInteger number=[str intValue];
    YMSPhotoPickerViewController *pickerViewController = [[YMSPhotoPickerViewController alloc] init];
    pickerViewController.numberOfPhotoToSelect = number;
    pickerViewController.selectIndex = 1;
    
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

#pragma mark Custom Gallery Delegates
-(void)photoPickerViewControllerDidReceivePhotoAlbumAccessDenied:(YMSPhotoPickerViewController *)picker{
    NSLog(@"library denied");
}
-(void)photoPickerViewControllerDidReceiveCameraAccessDenied:(YMSPhotoPickerViewController *)picker{
    NSLog(@"camera denied");
}
- (void)photoPickerViewController:(YMSPhotoPickerViewController *)picker didFinishPickingImages:(NSArray *)photoAssets
{
//    [self dismissAllModalAndCoveringViewControllers];
    [picker dismissViewControllerAnimated:YES completion:^() {

        [self dismissViewControllerAnimated:NO completion:^(){
            [self.delegate didReceiveDelegateWith:photoAssets];
        }];
//        TreeMainViewController *tree= [[TreeMainViewController alloc]initWithNibName:@"TreeMainViewController" bundle:nil];
//        tree.mainArray = [photoAssets mutableCopy];
//        [self presentViewController:tree animated:YES completion:^() {
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(receiveendNotification:)
//                                                         name:@"dismissview"
//                                                       object:nil];
//        }];
    }];
}
//+ (UIViewController *)currentViewController
//{
//    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    return [UIViewController findBestViewController:viewController];
//}
//- (NSInteger)findRootViewController:(UIViewController *)viewController
//{
//    if (viewController) {
//        return 1 + [self findRootViewController:viewController.presentingViewController];
//    }
//    return 0;
//}
//
//- (void)dismissAllModalAndCoveringViewControllers
//{
//    UIViewController *currentViewController = [CollectionViewController alloc];//[UIViewController currentViewController];
//
//    NSInteger numVCToDismiss = [self findRootViewController:currentViewController];
//    if (numVCToDismiss > 1) {
//        [currentViewController dismissViewControllerAnimated:YES completion:^{
////            [self dismissAllSignInAndTourViewControllers];
//        }];
//    }
//}
-(IBAction)backbtnpress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
