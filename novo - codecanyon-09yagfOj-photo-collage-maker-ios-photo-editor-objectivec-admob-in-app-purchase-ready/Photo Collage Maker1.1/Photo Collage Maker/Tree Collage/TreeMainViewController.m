//
//  TreeMainViewController.m
//  Photo Collage Maker
//
//  Created by Vaishu on 8/30/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import "TreeMainViewController.h"

@interface TreeMainViewController ()
{
    NSMutableArray *btmArray;
    NSMutableArray *selectbtmArray;
    
    NSMutableArray *nameArray;
    
    NSMutableArray *imgviewArray;
    NSMutableArray *scrollimgview;
    NSString *frameName;
    UIImage *editedImage;
    NSInteger num;
    BOOL isfilter;
    
    UIImageView *moveimgview;

    ZDStickerView *edit_Sticker;
    
    NSInteger btnIndex;
    NSInteger cellindex;
}

@end

@implementation TreeMainViewController

-(void)addImageintoArray
{
//    PHImageManager *imageManager = [[PHImageManager alloc] init];
//
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//    options.networkAccessAllowed = YES;
//    options.resizeMode = PHImageRequestOptionsResizeModeNone;
//    options.synchronous = YES;
//
//    //    NSMutableArray *mutableImages = [NSMutableArray array];
//
//    for (PHAsset *asset in _mainArray) {
//
//        [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *image, NSDictionary *info) {
//
//            NSLog(@"imafo : %@",image);
//            //            NSLog(@"info url  :%@",[info valueForKey:@"PHImageFileURLKey"]);
//            //            NSString *path = [NSString strin]
//            NSData *data = [NSData dataWithContentsOfURL:[info valueForKey:@"PHImageFileURLKey"]];
//            UIImage *final = [UIImage imageWithData:data];
//            NSLog(@"image : %@",final);
//            [self.imageArray addObject:final];
//        }];
//    }
    
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeNone;
    options.synchronous = YES;
    
    for (PHAsset *asset in _mainArray) {
        [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *image, NSDictionary *info) {
            
            NSLog(@"imafo : %@",image);

            [self.imageArray addObject:image];
//            [self.originalArray addObject:image];
        }];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissview"
//                                                        object:nil];
    
    _toplbl.backgroundColor = TopColor;
    _topView.backgroundColor = TopColor;
    
    _btmlbl.backgroundColor = BottomBGColor;
    _FilterView.backgroundColor = BottomBGColor;
    
    _imageArray = [[NSMutableArray alloc]init];
    [self addImageintoArray];
    
    if (IPAD) {
        _topView.frame = CGRectMake(0, 0, WIDTH, 80);
        _saveview.frame = CGRectMake(50, 85, WIDTH-100, WIDTH-100);
        _bannerView.frame = CGRectMake(0, 85+(WIDTH-100), WIDTH, 90);
        _btmView.frame = CGRectMake(0, HEIGHT-80, WIDTH, 80);
        _FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, IPADHeight);
        _btmlbl.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
    }
    else if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        _topView.frame = CGRectMake(0, 0, WIDTH, 45);
        _saveview.frame = CGRectMake(0, 50, WIDTH, WIDTH);
        _bannerView.frame = CGRectMake(0, 50+WIDTH, WIDTH, 50);
        _btmView.frame = CGRectMake(0, HEIGHT-60, WIDTH, 60);
        _FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, IPhoneHeight);
        _btmlbl.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
    }
    else{
        _topView.frame = CGRectMake(0, 30, WIDTH, 45);
        _saveview.frame = CGRectMake(0, 80, WIDTH, WIDTH);
        _bannerView.frame = CGRectMake(0, 80+WIDTH, WIDTH, 50);
        _btmView.frame = CGRectMake(0, HEIGHT-90, WIDTH, 70);
        _btmlbl.frame = CGRectMake(0, HEIGHT-20, WIDTH, 20);
        _FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, XHeight);
    }
    
    _btmlbl.hidden = YES;
    
    [AppDelObj loadBannerAds:_bannerView];
    _bannerView.delegate = self;
    
    btmArray = [[NSMutableArray alloc]initWithObjects:@"filter_unpresed.png",@"tree_unpresed.png",@"edit_unpresed.png",@"sticker_unpresed.png", nil];
    selectbtmArray = [[NSMutableArray alloc]initWithObjects:@"filter_presed.png",@"treepresed.png",@"edit_presed.png",@"sticker_presed.png", nil];
    
    nameArray = [[NSMutableArray alloc]initWithObjects:@"original",@"B/W",@"Ivory",@"Milky",@"Baby",@"Angel",@"Mono",@"Sweet",@"Grace",@"Yellow",@"Jasmine",@"Lucky",@"Green",@"Sketch",@"Miracle",@"Dollish",@"Swan",@"Emma",@"Paopose",@"Coral",@"Poster",@"Hera",@"Bella",@"Vignet",@"swag",@"Coy",@"Stellar",@"Crush",@"Lady",@"Desire",@"Spice",@"Detect",@"Wine",@"Fantasy",@"Twist",@"Timber",@"Yuki",@"Glow",@"Ruby",@"Olive",@"Soft",@"Gleam",@"Mild",@"Chill",@"Maple",@"Scent", nil];
    
    _filterArray=[[NSMutableArray alloc]init];
    [_filterArray addObject:@"original.png"];
    for (int i=1; i<=45; i++){
        NSString *str=[NSString stringWithFormat:@"filter_%d.png",i];
        [_filterArray addObject:str];
    }
    
    _btmcolView.delegate = self;
    _btmcolView.dataSource = self;
    [self.btmcolView registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    self.filterColView.delegate=self;
    self.filterColView.dataSource=self;
    [self.filterColView registerNib:[UINib nibWithNibName:@"FontCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    num = 0;
    
    NSInteger framenum=[[NSUserDefaults standardUserDefaults]integerForKey:@"frameName"];
    frameName=[NSString stringWithFormat:@"moby3d_%ld.png",framenum+1];
    _imageview.image=[UIImage imageNamed:frameName];
    
    imgviewArray=[[NSMutableArray alloc]init];
    scrollimgview=[[NSMutableArray alloc]init];
    
    _filterdonebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage *maxImage = [[UIImage imageNamed:@"empty_bg.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    UIImage *thumbImage = [UIImage imageNamed:@"slider_base.png"];
    
    [_pinchslider setMaximumTrackTintColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [_pinchslider  setMinimumTrackImage:maxImage forState:UIControlStateNormal];
    [_pinchslider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [self makeView];
    
    NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [_filterColView selectItemAtIndexPath:indexPathForFirstRow animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:_filterColView didSelectItemAtIndexPath:indexPathForFirstRow];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)makeView{
    {
        NSInteger framenum=[[NSUserDefaults standardUserDefaults]integerForKey:@"frameName"];
        NSString *jsonName=[NSString stringWithFormat:@"mask3d_%ld",framenum+1];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        for (int i=0; i<_imageArray.count; i++) {
            NSArray *countx=[[parsedObject valueForKey:@"frame_0"]valueForKey:[NSString stringWithFormat:@"frame_%d_x",i+1]];
            float x=[[countx objectAtIndex:0]floatValue];
            NSArray *county=[[parsedObject valueForKey:@"frame_0"]valueForKey:[NSString stringWithFormat:@"frame_%d_y",i+1]];
            float y=[[county objectAtIndex:0]floatValue];
            NSArray *countw=[[parsedObject valueForKey:@"frame_0"]valueForKey:[NSString stringWithFormat:@"frame_%d_w",i+1]];
            float w=[[countw objectAtIndex:0]floatValue];
            NSArray *counth=[[parsedObject valueForKey:@"frame_0"]valueForKey:[NSString stringWithFormat:@"frame_%d_h",i+1]];
            float h=[[counth objectAtIndex:0]floatValue];
            
            float wid = IPAD ? WIDTH-100 : WIDTH;
            //        NSLog(@"wid : %f",wid);
            float newx=(x*wid)/612;
            float newy=(y*wid)/612;
            float neww=(w*wid)/612;
            float newh=(h*wid)/612;
            
            if (i==0) {
                _borderlbl.frame=CGRectMake(newx,newy,neww,newh);
                _borderlbl.layer.borderColor=[UIColor redColor].CGColor;
                _borderlbl.layer.borderWidth=3.0f;
                _borderlbl.layer.masksToBounds=YES;
            }
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(newx, newy, neww, newh)];
            view.backgroundColor=[UIColor clearColor];
            view.clipsToBounds=YES;
            view.tag=i;
            view.userInteractionEnabled=YES;
            [self.allView addSubview:view];
            
            UIImageView *imageview = [[UIImageView alloc]init];
            imageview.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);//view.bounds;
            imageview.contentMode=UIViewContentModeScaleAspectFill;
            imageview.image=[_imageArray objectAtIndex:i];
            if (i == 0) {
                imageview.userInteractionEnabled=YES;
            }
            else{
                imageview.userInteractionEnabled=NO;
            }
            
            imageview.tag=i;
            
            UIScrollView *imageScrollView = [[UIScrollView alloc] init];
            imageScrollView.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);//view.bounds;
            imageScrollView.clipsToBounds = YES;
            //        imageScrollView.userInteractionEnabled = NO;
            
            [imageScrollView addSubview:imageview];
            [scrollimgview addObject:imageScrollView];
            [imgviewArray addObject:imageview];
            
            imageScrollView.delegate=self;
            imageScrollView.zoomScale=4.0;
            imageScrollView.maximumZoomScale=10.0;
            [view addSubview:imageScrollView];
            
            UITapGestureRecognizer *onetapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onetapgesture:)];
            onetapgesture.delegate=self;
            onetapgesture.numberOfTapsRequired=1;
            [view addGestureRecognizer:onetapgesture];
            
            UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didtapgesture:)];
            tapgesture.delegate=self;
            tapgesture.numberOfTapsRequired=2;
            [imageview addGestureRecognizer:tapgesture];
            
            UIPanGestureRecognizer *pangesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didpangesture:)];
            pangesture.delegate=self;
            [imageview addGestureRecognizer:pangesture];
            
            UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongpress:)];
            longpress.delegate=self;
            longpress.minimumPressDuration=0.5;
            [imageview addGestureRecognizer:longpress];
        }
    }
}
-(void)viewDidAppear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissview"
//                                                        object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    _borderlbl.hidden=NO;
}

#pragma mark Sldier Method
-(IBAction)slidervaluechanged:(UISlider *)slider
{
    UIScrollView *imageview=[scrollimgview objectAtIndex:num];
    [imageview setZoomScale:slider.value];
}
- (CGRect)zoomRectForScrollView:(UIScrollView *)ImgscrollView withScale:(float)scale withCenter:(CGPoint)center
{
    NSLog(@"rect");
    CGRect zoomRect;
    zoomRect.size.height = ImgscrollView.frame.size.height / scale;
    zoomRect.size.width  = ImgscrollView.frame.size.width  / scale;
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imgview = [imgviewArray objectAtIndex:num];
    return imgview;
}
#pragma mark Gesture Methods
-(void)onetapgesture:(UITapGestureRecognizer *)recognizer
{
    UIImageView *imgview = [imgviewArray objectAtIndex:num];
    imgview.userInteractionEnabled = NO;
    _borderlbl.frame=CGRectMake(recognizer.view.frame.origin.x, recognizer.view.frame.origin.y, recognizer.view.frame.size.width, recognizer.view.frame.size.height);
    _borderlbl.layer.borderColor=[UIColor redColor].CGColor;
    _borderlbl.layer.borderWidth=3.0f;
    _borderlbl.layer.masksToBounds=YES;
    num=recognizer.view.tag;
    UIImageView *newimgview = [imgviewArray objectAtIndex:num];
    newimgview.userInteractionEnabled = YES;
}
-(void)didtapgesture:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"double tap");
    [self openLibrary];
}
-(void)openLibrary
{
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = NO;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //    NSInteger num=[[NSUserDefaults standardUserDefaults]integerForKey:@"editimage"];
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [_imageArray replaceObjectAtIndex:num withObject:chosenImage];
    
    UIImageView *image=[imgviewArray objectAtIndex:num];
    image.image=chosenImage;
    //    [self makeView];
    [_picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(void)didpangesture:(UIPanGestureRecognizer *)gesture
{
    UIImageView *imgview = [imgviewArray objectAtIndex:num];
    UIGestureRecognizerState state = [gesture state];
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gesture translationInView:gesture.view];
        if (imgview.frame.origin.x+imgview.frame.size.width-5<0){
            NSLog(@"x");
            imgview.frame = CGRectMake(0, imgview.frame.origin.y, imgview.frame.size.width, imgview.frame.size.height);
        }
        else if (imgview.frame.size.width-5 < imgview.frame.origin.x){
            NSLog(@"width");
            imgview.frame = CGRectMake(0, imgview.frame.origin.y, imgview.frame.size.width, imgview.frame.size.height);
        }
        else if (imgview.frame.size.height-5 < imgview.frame.origin.y){
            NSLog(@"height");
            imgview.frame = CGRectMake(imgview.frame.origin.x, 0, imgview.frame.size.width, imgview.frame.size.height);
        }
        else if (imgview.frame.origin.y+imgview.frame.size.height-5<0){
            NSLog(@"y");
            imgview.frame = CGRectMake(imgview.frame.origin.x, 0, imgview.frame.size.width, imgview.frame.size.height);
        }
        else{
//            NSLog(@"else");
            [gesture.view setTransform:CGAffineTransformTranslate(gesture.view.transform, translation.x, translation.y)];
            [gesture setTranslation:CGPointZero inView:gesture.view];
        }
    }
    else if (state == UIGestureRecognizerStateEnded){
        if (imgview.frame.origin.x < 0-(imgview.frame.size.width-5) && imgview.frame.origin.y > imgview.frame.size.height-5) {
            NSLog(@"xy");
            imgview.frame = CGRectMake(0, 0, imgview.frame.size.width, imgview.frame.size.height);
        }
        else if (imgview.frame.origin.x > imgview.frame.size.width-5 && imgview.frame.origin.y > imgview.frame.size.height-5){
            NSLog(@"width");
            imgview.frame = CGRectMake(0, 0, imgview.frame.size.width, imgview.frame.size.height);
        }
        else if (imgview.frame.origin.x < 0-(imgview.frame.size.width-5) && imgview.frame.origin.y < 0-(imgview.frame.size.height-5)){
            NSLog(@"up xy");
            imgview.frame = CGRectMake(0, 0, imgview.frame.size.width, imgview.frame.size.height);
        }
        else if (imgview.frame.origin.x > imgview.frame.size.width-5 && imgview.frame.origin.y < 0-(imgview.frame.size.height-5)){
            NSLog(@"up last xy");
            imgview.frame = CGRectMake(0, 0, imgview.frame.size.width, imgview.frame.size.height);
        }
        else if (imgview.frame.origin.y < 0-(imgview.frame.size.height-5)){
            NSLog(@"up y");
            imgview.frame = CGRectMake(imgview.frame.origin.x, 0, imgview.frame.size.width, imgview.frame.size.height);
        }
        else if (imgview.frame.origin.x > imgview.frame.size.width-5){
            NSLog(@"last x");
            imgview.frame = CGRectMake(0, imgview.frame.origin.y, imgview.frame.size.width, imgview.frame.size.height);
        }
        else if (imgview.frame.origin.y > imgview.frame.size.height-5){
            NSLog(@"last y");
            imgview.frame = CGRectMake(imgview.frame.origin.x, 0, imgview.frame.size.width, imgview.frame.size.height);
        }
        else if (imgview.frame.origin.x < 0-(imgview.frame.size.width-5)) {
            imgview.frame = CGRectMake(0, imgview.frame.origin.y, imgview.frame.size.width, imgview.frame.size.height);
            NSLog(@"resize x");
        }
        else{
            NSLog(@"else");
        }
    }
}
-(void)didLongpress:(UILongPressGestureRecognizer *)recognizer
{
    //    CGPoint locationPointInCollection = [recognizer locationInView:_saveview];
    CGPoint locationPointInView = [recognizer locationInView:self.allView];
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        UIImage *image=[_imageArray objectAtIndex:num];
        CGRect frame = CGRectMake(locationPointInView.x, locationPointInView.y, 80, 80);
        moveimgview = [[UIImageView alloc] initWithFrame:frame];
        //        moveimgview=recognizer.view;
        [moveimgview clipsToBounds];
        //        moveimgview.contentMode=UIViewContentModeScaleAspectFill;
        moveimgview.image = image;
        [moveimgview setCenter:locationPointInView];
        moveimgview.layer.borderWidth = 3.0f;
        moveimgview.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.saveview addSubview:moveimgview];
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [moveimgview setCenter:locationPointInView];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        for (id i in imgviewArray){
            if( [i isKindOfClass:[UIImageView class]]){
                UIImageView *tmpScroll = (UIImageView *)i;
                CGRect frameRelativeToParent= [tmpScroll convertRect: tmpScroll.bounds
                                                              toView:_allView];
                if (CGRectContainsPoint(frameRelativeToParent, moveimgview.center)){
                    
                    UIImageView *toview=[imgviewArray objectAtIndex:num];
                    toview.image=[_imageArray objectAtIndex:tmpScroll.tag];
                    
                    UIImageView *fromview=[imgviewArray objectAtIndex:tmpScroll.tag];
                    fromview.image=[_imageArray objectAtIndex:num];
                    
                    [_imageArray replaceObjectAtIndex:tmpScroll.tag withObject:moveimgview.image];
                    [_imageArray replaceObjectAtIndex:num withObject:toview.image];
                }
            }
            [moveimgview removeFromSuperview];
        }
    }
}

#pragma mark CollectionView Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _btmcolView){
        return btmArray.count;
    }
    else if(collectionView==_filterColView){
        return _filterArray.count;
    }
    
    return true;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _btmcolView ){
        MenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
        
        UIImage *img = [UIImage imageNamed:[btmArray objectAtIndex:indexPath.row]];
        UIImage *select = [UIImage imageNamed:[selectbtmArray objectAtIndex:indexPath.row]];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:cell.bounds];
        btn.tag = indexPath.row;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn addTarget:self action:@selector(cellbuttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:img forState:UIControlStateNormal];
        [btn setImage:select forState:UIControlStateHighlighted];
        [cell addSubview:btn];
        
        cell.imgiew.hidden = YES;
        return cell;
    }
    else if (collectionView == _filterColView){
        FontCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
        cell.cellFilterLabel.text=[nameArray objectAtIndex:indexPath.row];
        cell.cellImage.image=[UIImage imageNamed:[_filterArray objectAtIndex:indexPath.row]];
        cell.cellImage.layer.borderWidth = 1.5;
        cell.cellImage.layer.borderColor = [UIColor blackColor].CGColor;
        return cell;
    }
    else{
        MenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
        
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _filterColView){
        UIImageView *imageview=[imgviewArray objectAtIndex:num];
        
        UIImage *img = [_imageArray objectAtIndex:num];
        //    UIImage *image=[self scaleImage:img toSize:CGSizeMake(img.size.width, img.size.height)];
        UIImage *main = [AppDelObj LoadAllEffectWithImage:img WithIndex:indexPath.row];
        editedImage=main;
        imageview.image=main;
        isfilter=YES;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(collectionView == _btmcolView){
        size=CGSizeMake(WIDTH/4, _btmcolView.frame.size.height);
    }
    else if (collectionView == _filterColView){
        float wid = IPAD?(IPADHeight*54)/120 : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? (IPhoneHeight*54)/120 : (XHeight*54)/120 ;
        if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ) {
            size = CGSizeMake(wid, _filterColView.frame.size.height);
        }
        else{
            size = CGSizeMake(wid, _filterColView.frame.size.height-10);
        }
    }
    else{
        size = CGSizeMake(50, 50);
    }
    
    return size;
}
-(void)openallViewWithIndex : (NSInteger)index{
    if (index == 0) {
        _pinchslider.hidden = YES;
        _btmlbl.hidden = NO;
        [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.FilterView.frame = CGRectMake(0, IPAD ? HEIGHT-IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? HEIGHT-IPhoneHeight : HEIGHT-XHeight-20, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
        }completion:^(BOOL finished) {
            
        }];
    }
    else if (index == 1){
        CollectionViewController *collection=[[CollectionViewController alloc]initWithNibName:@"CollectionViewController" bundle:nil];
        collection.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:collection animated:YES completion:nil];
    }
    else if (index == 2){
        EditViewController *edit = [[EditViewController alloc]initWithNibName:@"EditViewController" bundle:nil];
        edit.delegate=self;
        edit.mainImage=[_imageArray objectAtIndex:num];
        edit.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:edit animated:YES completion:nil];
    }
    else{
        StickerViewController *stickerv=[[StickerViewController alloc]initWithNibName:@"StickerViewController" bundle:nil];
        stickerv.stickerindex = 2;
        stickerv.tstickerdelegate = self;
        stickerv.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:stickerv animated:YES completion:nil];
    }
}
-(IBAction)cellbuttonPress:(UIButton *)sender
{
    btnIndex = 1;
    cellindex = sender.tag;
    if (![self showInterAdWithCount:2]){
        [self openallViewWithIndex:sender.tag];
    }
}
-(IBAction)filterdonebtnpress:(id)sender
{
    _pinchslider.hidden = NO;
    _btmlbl.hidden = YES;
    [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
    }completion:^(BOOL finished) {
        if (self->isfilter==YES) {
            [self.imageArray replaceObjectAtIndex:self->num withObject:self->editedImage];
        }
        else{
            NSLog(@"no filter ");
        }
    }];
}
#pragma mark Sticker Delegate
-(void)didReceiveDelegateWith:(UIImage *)stickerimg
{
    if(stickerimg != nil)
    {
        [self hideAllCurrentEditingSticker];
        UIImageView *imageView1 = [[UIImageView alloc] initWithImage:stickerimg];
        imageView1.contentMode = UIViewContentModeScaleToFill;
        imageView1.backgroundColor = [UIColor clearColor];
        CGRect gripFrame1 = CGRectMake(WIDTH/2-50, WIDTH/2-50, 100, 100);
        
        UIView* contentView = [[UIView alloc] initWithFrame:gripFrame1];
        contentView.contentMode = UIViewContentModeScaleToFill;
        [contentView setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:imageView1];
        
        ZDStickerView *userResizableView = [[ZDStickerView alloc] initWithFrame:gripFrame1];
        userResizableView.tag = 0;
        edit_Sticker = userResizableView;
        userResizableView.stickerViewDelegate = self;
        userResizableView.contentView = contentView;//contentView;
        userResizableView.preventsPositionOutsideSuperview = NO;
        userResizableView.translucencySticker = NO;
        [userResizableView showEditingHandles];
        [_saveview addSubview:userResizableView];
    }
}
#pragma mark ZDStickerView delegate functions
-(void)hideAllCurrentEditingSticker
{
    for (ZDStickerView *sticker in _saveview.subviews)
    {
        if ([sticker isKindOfClass:[ZDStickerView class]])
        {
            [sticker hideAllEditingHandles];
        }
    }
}
- (void)stickerViewDidBeginEditing:(ZDStickerView *)sticker
{
    NSLog(@"%s [%ld]",__func__, (long)sticker.tag);
}

- (void)stickerViewDidEndEditing:(ZDStickerView *)sticker
{
    NSLog(@"%s [%ld]",__func__, (long)sticker.tag);
}

- (void)stickerViewDidCancelEditing:(ZDStickerView *)sticker
{
    if (sticker.isEditingHandlesHidden)
    {
        //        _color_Lbl.backgroundColor = [UIColor whiteColor];
        edit_Sticker = sticker;
        [self hideAllCurrentEditingSticker];
        [sticker showEditingHandles];
    }
    else
    {
        [self hideAllCurrentEditingSticker];
    }
    
    NSLog(@"%s [%ld]",__func__, (long)sticker.tag);
}

- (void)stickerViewDidClose:(ZDStickerView *)sticker
{
    NSLog(@"%s [%ld]",__func__, (long)sticker.tag);
}

- (void)stickerViewDidCustomButtonTap:(ZDStickerView *)sticker
{
    NSLog(@"%s [%ld]",__func__, (long)sticker.tag);
    [((UITextView*)sticker.contentView) becomeFirstResponder];
}

-(void)didReceiveDelegateWithImage:(UIImage *)myimg
{
    UIImageView *image=[imgviewArray objectAtIndex:num];
    image.image=myimg;
    [_imageArray replaceObjectAtIndex:num withObject:myimg];
}
-(IBAction)donebtnpress:(id)sender
{
    btnIndex = 2;
    if (AppDelObj.inter_View.isReady)
    {
        AppDelObj.inter_View.delegate = self;
        [AppDelObj.inter_View presentFromRootViewController:self];
    }
    else{
        [self openshareView];
    }
}
-(void)openshareView
{
    _borderlbl.hidden=YES;
    [self hideAllCurrentEditingSticker];
    ShareViewController *share = [[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    share.saveimage = [AppDelObj screenshotimageWithView:_saveview];
    share.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:share animated:YES completion:nil];
}

#pragma mark Interstial Methods
-(BOOL)showInterAdWithCount : (int)count
{
    int adCount = (int)[DEFAULT integerForKey:AD_COUNT];
    adCount++;
    [DEFAULT setInteger:adCount forKey:AD_COUNT];
    [DEFAULT synchronize];
    if (adCount % count == 0)
    {
        if (AppDelObj.inter_View.isReady)
        {
            AppDelObj.inter_View.delegate = self;
            [AppDelObj.inter_View presentFromRootViewController:self];
            return  YES;
        }
        else {
            [AppDelObj createInterView];
            return  NO;
        }
        return  NO;
    }
    return  NO;
}

-(void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    [AppDelObj createInterView];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    if (btnIndex == 1) {
        [self openallViewWithIndex:cellindex];
    }
    else if (btnIndex == 2){
        [self openshareView];
    }
    btnIndex = 0;
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    [AppDelObj createInterView];
}

-(IBAction)backbtnpress:(id)sender
{
    UIAlertController  *alert = [UIAlertController alertControllerWithTitle:APPLICATION_NAME
                                                                    message:@"Are you sure you want to remove all work ??"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              ViewController *view = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
                                                              view.modalPresentationStyle = UIModalPresentationFullScreen;
                                                              [self presentViewController:view animated:NO completion:nil];
                                                              
                                                          }];
    
    [alert addAction:defaultAction];
    
    UIAlertAction *NOAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                     }];
    
    [alert addAction:NOAction];
    [self presentViewController:alert animated:YES completion:nil];
    
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
