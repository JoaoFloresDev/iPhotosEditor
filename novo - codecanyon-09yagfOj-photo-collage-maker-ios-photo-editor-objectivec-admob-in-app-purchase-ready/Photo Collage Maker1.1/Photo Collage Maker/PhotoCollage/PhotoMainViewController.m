//
//  PhotoMainViewController.m
//  Photo Collage Maker
//
//  Created by Vaishu on 8/29/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import "PhotoMainViewController.h"
#define BETWEEN(value, min, max) (value < max && value > min)

@interface PhotoMainViewController () {
    NSMutableArray *menuArray;
    NSMutableArray *selectmenuArray;
    
    NSMutableArray *nameArray;
    
    NSDictionary *myMainDic;
    NSInteger PhotosCounter;
    NSInteger selectedLayout;
    
    int selectedTag;
    int oldTag;
    
    UIColor *bgcolor;
    
    ZDStickerView *edit_Sticker;
    
    IQLabelView *currentlyEditingLabel;
    NSMutableArray *labels;
    IQLabelView *labelView;
    
    float tempcornerRadiusFloat;
    float tempborderFloat;
    float cornerRadius;

    NSInteger btnIndex;
    NSInteger cellindex;
}

@end

@implementation PhotoMainViewController

-(void)addImageintoArray
{
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeNone;
    options.synchronous = YES;
    
    for (PHAsset *asset in _MainimagesArray) {
        [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *image, NSDictionary *info) {
            
            NSLog(@"imafo : %@",image);

            [self.imagesArray addObject:image];
            [self.originalArray addObject:image];
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topView.backgroundColor = TopColor;
    _toplbl.backgroundColor = TopColor;
    _btmlbl.backgroundColor = BottomBGColor;
    _FilterView.backgroundColor = BottomBGColor;
    _layoutView.backgroundColor = BottomBGColor;
    _MainToolbarView.backgroundColor = BottomBGColor;
    _borderView.backgroundColor = BottomBGColor;
    _bguiView.backgroundColor = BottomBGColor;
    
    labels = [[NSMutableArray alloc]init];
    _imagesArray = [[NSMutableArray alloc]init];
    _originalArray=[[NSMutableArray alloc]init];
    [self addImageintoArray];
    
    if (IPAD) {
        _topView.frame = CGRectMake(0, 0, WIDTH, 80);
        _saveView.frame = CGRectMake(0, 85, WIDTH, WIDTH);
        _adBanner.frame = CGRectMake(0, WIDTH+85, WIDTH, 90);
        _bottomView.frame = CGRectMake(0, HEIGHT-80, WIDTH, 80);
        _FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, IPADHeight);
        _layoutView.frame = CGRectMake(0, HEIGHT, WIDTH, IPADHeight);
        _borderView.frame = CGRectMake(0, HEIGHT, WIDTH, IPADHeight);
        _bguiView.frame = CGRectMake(0, HEIGHT, WIDTH, IPADHeight);
        _btmlbl.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
    }
    else if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        _topView.frame = CGRectMake(0, 0, WIDTH, 45);
        _saveView.frame = CGRectMake(0, 50, WIDTH, WIDTH);
        _adBanner.frame = CGRectMake(0, WIDTH+50, WIDTH, 50);
        _bottomView.frame = CGRectMake(0, HEIGHT-60, WIDTH, 60);
        _FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, IPhoneHeight);
        _layoutView.frame = CGRectMake(0, HEIGHT, WIDTH, IPhoneHeight);
        _borderView.frame = CGRectMake(0, HEIGHT, WIDTH, IPhoneHeight);
        _bguiView.frame = CGRectMake(0, HEIGHT, WIDTH, IPhoneHeight);
        _btmlbl.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
    }
    else{
        _topView.frame = CGRectMake(0, 30, WIDTH, 45);
        _saveView.frame = CGRectMake(0, 80, WIDTH, WIDTH);
        _adBanner.frame = CGRectMake(0, WIDTH+80, WIDTH, 50);
        _bottomView.frame = CGRectMake(0, HEIGHT-90, WIDTH, 70);
        _FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, XHeight);
        _layoutView.frame = CGRectMake(0, HEIGHT, WIDTH, XHeight);
        _borderView.frame = CGRectMake(0, HEIGHT, WIDTH, XHeight);
        _bguiView.frame = CGRectMake(0, HEIGHT, WIDTH, XHeight);
        _btmlbl.frame = CGRectMake(0, HEIGHT-20, WIDTH, 20);
    }
    
    _btmlbl.hidden = YES;
    
    menuArray = [[NSMutableArray alloc]initWithObjects:@"layout_unpresed.png",@"background.png",@"border_unpresed.png",@"filter_unpresed.png",@"tex_unpresed.png",@"cut_unpresed.png",@"add_unpresed.png",@"sticker_unpresed.png", nil];
    selectmenuArray = [[NSMutableArray alloc]initWithObjects:@"layout_presed.png",@"background_preesd.png",@"border_presed.png",@"filter_presed.png",@"tex_presed.png",@"cut_presed.png",@"add_presed.png",@"sticker_presed.png", nil];
    
    [AppDelObj loadBannerAds:_adBanner];
    _adBanner.delegate = self;
    
    bgcolor=[UIColor whiteColor];
    _mainbgimgview.image=[self imageFromColor:bgcolor];
    
    
    _viewArray=[[NSMutableArray alloc]init];
    _imgviewArray=[[NSMutableArray alloc]init];
    _scrollviewArray=[[NSMutableArray alloc]init];
    _frameArray=[[NSMutableArray alloc]init];
    _zoomscaleArray=[[NSMutableArray alloc]init];
    _maskingLayerArray=[[NSMutableArray alloc]init];
    _imgviewFrameArray=[[NSMutableArray alloc]init];
    _bgArray = [[NSMutableArray alloc]init];
    
    _layoutArray=[[NSMutableArray alloc]init];
    PhotosCounter = _imagesArray.count;
    selectedLayout=0;
    cornerRadius=0.0;
    _gridoutsideSlider.value=0.0;
    
    NSString *layout=[NSString stringWithFormat:@"grid_%ld",(long)PhotosCounter];
    NSString *path = [[NSBundle mainBundle] pathForResource:layout ofType:@"plist"];
    NSDictionary *dictionary =[NSDictionary dictionaryWithContentsOfFile:path];
    myMainDic=[dictionary objectForKey:@"grid"];
    NSString *countstr=[myMainDic valueForKey:@"count"];
    int gridcount=(int)[countstr integerValue];
    
//    _originalArray = _imagesArray;
    
    [_bgArray addObject:@"collage_color_thumb"];
    for (int i= 1; i<=20; i++) {
        NSString *str=[NSString stringWithFormat:@"thumb_bg_%d.jpg",i];
        [_bgArray addObject:str];
        str =  nil;
    }
    
    for (int i=0; i<gridcount; i++){
        NSString *str=[NSString stringWithFormat:@"grid_layout_%ld_%d.png",(long)PhotosCounter,i];
        [_layoutArray addObject:str];
        str =  nil;
    }
    
    for (int i=0; i<PhotosCounter; i++)
    {
        NSString *strpath=[NSString stringWithFormat:@"grid_%ld.%d",(long)selectedLayout,i];
        
        float loadx=(WIDTH*[[[myMainDic valueForKeyPath:strpath] valueForKey:@"x"] floatValue])/720;
        float loady=(WIDTH*[[[myMainDic valueForKeyPath:strpath] valueForKey:@"y"] floatValue])/720;
        
        NSString *mask=[[myMainDic valueForKeyPath:strpath] valueForKey:@"mask"];
        UIImage *myimgmask=[UIImage imageNamed:mask];
        
        float loadw=(WIDTH*myimgmask.size.width)/720;
        float loadh=(WIDTH*myimgmask.size.height)/720;
        
        UIView *myview=[[UIView alloc]initWithFrame:CGRectMake(loadx, loady,loadw,loadh)];
        myview.backgroundColor=[UIColor clearColor];
        myview.tag=i+1;
        
        _scrollview = [[UIScrollView alloc]initWithFrame:myview.bounds];
        _scrollview.delegate=self;
        _scrollview.bounces=NO;
        _scrollview.tag=i+1;
        _scrollview.showsVerticalScrollIndicator=NO;
        _scrollview.showsHorizontalScrollIndicator=NO;
        UIImage *myimg=[_imagesArray objectAtIndex:i];
        _imageview=[[UIImageView alloc]initWithImage:myimg];
        [_scrollview addSubview:_imageview];
        
        [myview addSubview:_scrollview];
        [self.saveInsideview addSubview:myview];
        
        [_scrollview setContentSize:CGSizeMake(_imageview.bounds.size.width,_imageview.bounds.size.height)];
        
        float zoomScaling;
        float zoomx=_scrollview.frame.size.width/_imageview.bounds.size.width;
        float zoomy=_scrollview.frame.size.height/_imageview.bounds.size.height;
        
        zoomScaling = (zoomx >= zoomy) ? zoomx : zoomy;
        
        _scrollview.minimumZoomScale=zoomScaling;
        _scrollview.maximumZoomScale=5.0;
        _scrollview.zoomScale=zoomScaling;
        _scrollview.clipsToBounds = YES;
        [_zoomscaleArray addObject:[NSString stringWithFormat:@"%f",zoomScaling]];
        [_frameArray addObject:[NSValue valueWithCGRect:myview.frame]];
        [_scrollviewArray addObject:_scrollview];
        [_imgviewArray addObject:_imageview];
        [_imgviewFrameArray addObject:[NSValue valueWithCGRect:myview.frame]];
        [_viewArray addObject:myview];
        
        CGFloat newContentOffsetX = (_scrollview.contentSize.width/2) - (_scrollview.bounds.size.width/2);
        CGFloat newContentOffsetY = (_scrollview.contentSize.height/2) - (_scrollview.bounds.size.height/2);
        _scrollview.contentOffset = CGPointMake(newContentOffsetX, newContentOffsetY);
        
        UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressonUIView:)];
        [myview addGestureRecognizer:longpress];
        
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
        [myview addGestureRecognizer:letterTapRecognizer];
        
        if (mask!=nil) {
            UIImage *maskImage=[UIImage imageNamed:mask];
            CALayer  *_maskingLayer = [CALayer layer];
            _maskingLayer.frame =myview.bounds;
            [_maskingLayer setContents:(id)[maskImage CGImage]];
            [myview.layer setMask:_maskingLayer];
            [_maskingLayerArray addObject:_maskingLayer];
        }
    }
    
    oldTag=100;
    _selectedViewlayer.layer.borderColor=bgcolor.CGColor;
    _selectedViewlayer.layer.masksToBounds=YES;
    
    _btmColView.delegate = self;
    _btmColView.dataSource = self;
    [self.btmColView registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    _layoutColView.delegate = self;
    _layoutColView.dataSource = self;
    [self.layoutColView registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    _bgcolView.delegate = self;
    _bgcolView.dataSource = self;
    [self.bgcolView registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    self.filterColView.delegate=self;
    self.filterColView.dataSource=self;
    [self.filterColView registerNib:[UINib nibWithNibName:@"FontCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    _filterArray=[[NSMutableArray alloc]init];
    [_filterArray addObject:@"original.png"];
    
    nameArray = [[NSMutableArray alloc]initWithObjects:@"original",@"B/W",@"Ivory",@"Milky",@"Baby",@"Angel",@"Mono",@"Sweet",@"Grace",@"Yellow",@"Jasmine",@"Lucky",@"Green",@"Sketch",@"Miracle",@"Dollish",@"Swan",@"Emma",@"Paopose",@"Coral",@"Poster",@"Hera",@"Bella",@"Vignet",@"swag",@"Coy",@"Stellar",@"Crush",@"Lady",@"Desire",@"Spice",@"Detect",@"Wine",@"Fantasy",@"Twist",@"Timber",@"Yuki",@"Glow",@"Ruby",@"Olive",@"Soft",@"Gleam",@"Mild",@"Chill",@"Maple",@"Scent", nil];
    
    _fontArray = @[@"AmericanTypewriter",@"AmericanTypewriter-CondensedLight",@"AppleSDGothicNeo-Bold",@"Avenir",@"AvenirNext",@"Baskerville",@"BradleyHandITCTT-Bold",@"Cochin",@"Chalkduster",@"DINCondensed-Bold",@"DiwanMishafi",@"Futura-CondensedExtraBold",@"GillSans",@"Menlo",@"MarkerFelt-Thin",@"Noteworthy-Bold",@"Optima",@"Palatino",@"Papyrus",@"PartyLetPlain",@"SavoyeLetPlain",@"Thonburi",@"TimesNewRomanPS"];
    
    self.pickerview.delegate=self;
    self.pickerview.dataSource=self;
    [self.pickerview registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    for (int i=1; i<=45; i++){
        NSString *str=[NSString stringWithFormat:@"filter_%d.png",i];
        [_filterArray addObject:str];
    }
    
    _scrollview.delegate = self;
    
    _textkbdbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _textdonebtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _textfontbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _textcolorbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    _filterdonebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _layoutdonebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _borderdonebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _bgdonebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardSize:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    UIImage *maxImage = [[UIImage imageNamed:@"empty_bg.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    UIImage *thumbImage = [UIImage imageNamed:@"slider_base.png"];
    
    [_gridcornerSlider setMaximumTrackTintColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [_gridcornerSlider  setMinimumTrackImage:maxImage forState:UIControlStateNormal];
    [_gridcornerSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [_gridoutsideSlider setMaximumTrackTintColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [_gridoutsideSlider  setMinimumTrackImage:maxImage forState:UIControlStateNormal];
    [_gridoutsideSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    simplecolorview=[[SimpleColorView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    simplecolorview.delegate=self;
    [self.view addSubview:simplecolorview];
    simplecolorview.hidden=YES;
    
    NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [_layoutColView selectItemAtIndexPath:indexPathForFirstRow animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:_layoutColView didSelectItemAtIndexPath:indexPathForFirstRow];
    
    [_filterColView selectItemAtIndexPath:indexPathForFirstRow animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:_filterColView didSelectItemAtIndexPath:indexPathForFirstRow];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    int counter=0;
    for (UIScrollView *scr in _scrollviewArray) {
//        NSLog(@"Zoomscale : %f",[[_zoomscaleArray objectAtIndex:counter] floatValue]);
        scr.zoomScale=[[_zoomscaleArray objectAtIndex:counter] floatValue];
        counter++;
    }
}
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
//    NSLog(@"scroll view delegate");
    UIImageView *imview;
    int count=0;
    for (UIScrollView *myscrollView in _scrollviewArray) {
        
        if (myscrollView==scrollView) {
            imview=[_imgviewArray objectAtIndex:count];
        }
        count++;
    }
    return imview;
}
- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, WIDTH*2,WIDTH*2);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark TapDetectingImageViewDelegate methods
-(void)LongPressonUIView:(UIGestureRecognizer *)sender
{
    UIView *view = sender.view;
    CGPoint touchPoint = [sender locationInView:view.superview];
    _selectedViewlayer.hidden=NO;
    
    if (sender.state == UIGestureRecognizerStateBegan){
        for (UIView *subview in [_saveInsideview subviews])
        {
            if ([subview isKindOfClass:[UIView class]])
            {
                if (subview.tag != 0 && oldTag!=subview.tag && BETWEEN(touchPoint.y, subview.frame.origin.y, subview.frame.origin.y + subview.frame.size.height)  && BETWEEN(touchPoint.x, subview.frame.origin.x, subview.frame.origin.x + subview.frame.size.width)){
                    _selectedViewlayer.layer.borderWidth=2.0;
                    _selectedViewlayer.layer.borderColor=TopColor.CGColor;
                    
                    oldTag=(int)subview.tag;
                    _selectedViewlayer.image=[_imagesArray objectAtIndex:oldTag-1];
                    _selectedViewlayer.alpha=0.8;
                    self.selectedViewlayer.frame = subview.frame;
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        self.selectedViewlayer.frame = CGRectMake(subview.frame.origin.x+subview.frame.size.width/8, subview.frame.origin.y+subview.frame.size.height/8, subview.frame.size.width-((subview.frame.size.width/8)*2), subview.frame.size.height-((subview.frame.size.height/8)*2));
                    }
                                     completion:^(BOOL finished){}];
                }
            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        for (UIView *subview in [_saveInsideview subviews])
        {
            if ([subview isKindOfClass:[UIView class]])
            {
                if (subview.tag != 0  && BETWEEN(touchPoint.y, subview.frame.origin.y, subview.frame.origin.y + subview.frame.size.height)  && BETWEEN(touchPoint.x, subview.frame.origin.x, subview.frame.origin.x + subview.frame.size.width)){
                    selectedTag=(int)subview.tag;
                    [UIView animateWithDuration:0.50 animations:^{
                        self.selectedViewlayer.frame = CGRectMake(subview.frame.origin.x+subview.frame.size.width/8, subview.frame.origin.y+subview.frame.size.height/8, subview.frame.size.width-((subview.frame.size.width/8)*2), subview.frame.size.height-((subview.frame.size.height/8)*2));
                    }];
                }
            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [_imagesArray exchangeObjectAtIndex:selectedTag-1 withObjectAtIndex:oldTag-1];
        [_originalArray exchangeObjectAtIndex:selectedTag-1 withObjectAtIndex:oldTag-1];
//        [_assetImagesArray exchangeObjectAtIndex:selectedTag-1 withObjectAtIndex:oldTag-1];
        
        _selectedViewlayer.hidden=YES;
        
        [self LoadNewLayout];
    }
}
-(void)LoadNewLayout
{
    for (UIView *myview in _viewArray) {
        [myview removeFromSuperview];
    }
    [_viewArray removeAllObjects];
    [_imgviewArray removeAllObjects];
    [_scrollviewArray removeAllObjects];
    [_frameArray removeAllObjects];
    [_zoomscaleArray removeAllObjects];
    [_maskingLayerArray removeAllObjects];
    [_imgviewFrameArray removeAllObjects];
    
    for (int i=0; i<_imagesArray.count; i++)
    {
        NSString *strpath=[NSString stringWithFormat:@"grid_%ld.%d",(long)selectedLayout,i];
        float loadx=(WIDTH*[[[myMainDic valueForKeyPath:strpath] valueForKey:@"x"] floatValue])/720;
        float loady=(WIDTH*[[[myMainDic valueForKeyPath:strpath] valueForKey:@"y"] floatValue])/720;
        NSString *mask=[[myMainDic valueForKeyPath:strpath] valueForKey:@"mask"];
        UIImage *myimgmask=[UIImage imageNamed:mask];
        
        float loadw=(WIDTH*myimgmask.size.width)/720;
        float loadh=(WIDTH*myimgmask.size.height)/720;
        UIView *myview=[[UIView alloc]initWithFrame:CGRectMake(loadx,loady,loadw,loadh)];
        myview.backgroundColor=[UIColor clearColor];
        myview.tag=i+1;
        
        _scrollview=[[UIScrollView alloc]initWithFrame:myview.bounds];
        _scrollview.delegate=self;
        _scrollview.bounces=NO;
        _scrollview.tag=i+1;
        _scrollview.showsVerticalScrollIndicator=NO;
        _scrollview.showsHorizontalScrollIndicator=NO;
        UIImage *myimg=[_imagesArray objectAtIndex:i];
        _imageview=[[UIImageView alloc]initWithImage:myimg];
        _imageview.tag=i+1;
        _imageview.userInteractionEnabled=YES;
        [_scrollview addSubview:_imageview];
        
        [myview addSubview:_scrollview];
        [self.saveInsideview addSubview:myview];
        [_scrollview setContentSize:CGSizeMake(_imageview.bounds.size.width, _imageview.bounds.size.height)];
        float zoomScaling;
        float zoomx=_scrollview.frame.size.width/_imageview.bounds.size.width;
        float zoomy=_scrollview.frame.size.height/_imageview.bounds.size.height;
        zoomScaling = (zoomx >= zoomy) ? zoomx : zoomy;
        _scrollview.minimumZoomScale=zoomScaling;
        _scrollview.maximumZoomScale=5.0;
        _scrollview.zoomScale=zoomScaling;
        _scrollview.clipsToBounds = YES;
        [_zoomscaleArray addObject:[NSString stringWithFormat:@"%f",zoomScaling]];
        [_scrollviewArray addObject:_scrollview];
        [_frameArray addObject:[NSValue valueWithCGRect:myview.frame]];
        [_imgviewArray addObject:_imageview];
        [_imgviewFrameArray addObject:[NSValue valueWithCGRect:_imageview.frame]];
        [_viewArray addObject:myview];
        
        CGFloat newContentOffsetX = (_scrollview.contentSize.width/2) - (_scrollview.bounds.size.width/2);
        CGFloat newContentOffsetY = (_scrollview.contentSize.height/2) - (_scrollview.bounds.size.height/2);
        _scrollview.contentOffset = CGPointMake(newContentOffsetX, newContentOffsetY);
        
        UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressonUIView:)];
        [myview addGestureRecognizer:longpress];
        
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
        [myview addGestureRecognizer:letterTapRecognizer];
        
        if (mask!=nil) {
            UIImage *maskImage=[UIImage imageNamed:mask];
            CALayer  *_maskingLayer = [CALayer layer];
            _maskingLayer.frame =myview.bounds;
            [_maskingLayer setContents:(id)[maskImage CGImage]];
            [myview.layer setMask:_maskingLayer];
            [_maskingLayerArray addObject:_maskingLayer];
        }
    }
    oldTag=100;
    _selectedViewlayer.layer.borderColor=bgcolor.CGColor;
    _selectedViewlayer.layer.masksToBounds=YES;
    [self Afterscrollviewmethod];
}
-(void)Afterscrollviewmethod
{
    int counter=0;
    for (UIScrollView *scr in _scrollviewArray)
    {
        scr.zoomScale=[[_zoomscaleArray objectAtIndex:counter] floatValue];
        counter++;
    }
}
- (void)highlightLetter:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    selView=view;
    selView.tag=view.tag;
    
    _btnAddM.hidden=NO;
    _btnDelete.hidden=NO;
    if (IPAD) {
        _btnAddM.frame=CGRectMake(view.frame.origin.x + 10,view.frame.origin.y + 10, 40, 40);
        _btnDelete.frame=CGRectMake(view.frame.origin.x+40 ,view.frame.origin.y + 10, 40, 40);
    }
    else{
        _btnAddM.frame=CGRectMake(view.frame.origin.x + 10,view.frame.origin.y + 10, 25, 25);
        _btnDelete.frame=CGRectMake(view.frame.origin.x+40 ,view.frame.origin.y + 10, 25, 25);
    }
    
    [self.saveView addSubview:_btnAddM];
    [self.saveView addSubview:_btnDelete];
    
    [self.view bringSubviewToFront:_btnDelete];
    [self.view bringSubviewToFront:_btnAddM];
    [self.view bringSubviewToFront:view];
}

#pragma mark CollectionView Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _btmColView) {
        return menuArray.count;
    }
    else if (collectionView == _filterColView){
        return _filterArray.count;
    }
    else if (collectionView == _layoutColView){
        return _layoutArray.count;
    }
    else if (collectionView == _bgcolView){
        return _bgArray.count;
    }
    else if (collectionView == _pickerview){
        return _fontArray.count;
    }
    else{
        return 0;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _btmColView ){
        MenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
        
        UIImage *img = [UIImage imageNamed:[menuArray objectAtIndex:indexPath.row]];
        UIImage *select = [UIImage imageNamed:[selectmenuArray objectAtIndex:indexPath.row]];
        
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
        cell.cellImage.layer.borderWidth = 1.0;
        cell.cellImage.layer.borderColor = [UIColor blackColor].CGColor;
        return cell;
    }
    else if (collectionView == _layoutColView){
        MenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
        cell.imgiew.backgroundColor = [UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0];
        cell.imgiew.image=[UIImage imageNamed:[_layoutArray objectAtIndex:indexPath.row]];
        cell.imgiew.layer.borderWidth = 1.0;
        cell.imgiew.layer.borderColor = [UIColor blackColor].CGColor;
        return cell;
    }
    else if (collectionView == _bgcolView){
        MenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
//        cell.imgiew.backgroundColor = [UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0];
        cell.imgiew.image=[UIImage imageNamed:[_bgArray objectAtIndex:indexPath.row]];
        cell.imgiew.layer.borderWidth = 1.0;
        cell.imgiew.layer.borderColor = [UIColor blackColor].CGColor;
        return cell;
    }
    else if (collectionView == _pickerview){
        MenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
        cell.txtlbl.hidden=false;
        cell.txtlbl.text=@"Text";
        [cell.txtlbl setFont:[UIFont fontWithName:[_fontArray objectAtIndex:indexPath.row] size:18.0]];
        cell.imgiew.hidden = YES;
        return cell;
    }
    else{
        FontCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
        
        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(collectionView == _btmColView){
        size=CGSizeMake(WIDTH/4.5, _btmColView.frame.size.height);
    }
    else if (collectionView == _filterColView){
        float wid = IPAD?(IPADHeight*54)/120 : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? (IPhoneHeight*54)/120 : (XHeight*54)/120 ;
        if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS) {
            size = CGSizeMake(wid, _filterColView.frame.size.height);
        }
        else{
            size = CGSizeMake(wid, _filterColView.frame.size.height-10);
        }
        
//        NSLog(@"size : %f",wid);
    }
    else if (collectionView == _layoutColView){
        size = CGSizeMake(_layoutColView.frame.size.height-10, _layoutColView.frame.size.height-10);
    }
    else if (collectionView == _bgcolView){
        size = CGSizeMake(_bgcolView.frame.size.height-10, _bgcolView.frame.size.height-10);
    }
    else if (collectionView == _pickerview){
        if (IPAD) {
            size = CGSizeMake(WIDTH/6, WIDTH/6);
        }
        else{
            size = CGSizeMake(WIDTH/4, WIDTH/4);
        }
    }
    else{
        size = CGSizeMake(50, 50);
    }
    
    return size;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _btmColView) {
    }
    else if (collectionView == _filterColView){
        int count=0;
        for (UIImageView *imgview in _imgviewArray)
        {
            UIImage *myimage1=[_originalArray objectAtIndex:count];
            imgview.image=[AppDelObj LoadAllEffectWithImage:myimage1 WithIndex:(int)indexPath.row];
            [_imagesArray replaceObjectAtIndex:count withObject:imgview.image];
            count++;
        }
    }
    else if (collectionView == _layoutColView){
        selectedLayout=(int)indexPath.row;
        [self LoadNewLayout];
    }
    else if (collectionView == _bgcolView){
        if (indexPath.row==0){
//            isborder=YES;
//            simplecolorview.hidden=NO;
            [self openColorPickerView];
        }else{
            bgcolor=[UIColor colorWithPatternImage:[UIImage imageNamed:[_bgArray objectAtIndex:indexPath.row]]];
            _mainbgimgview.image=[self imageFromColor:bgcolor];
        }
    }
    else if (collectionView == _pickerview){
        currentlyEditingLabel.fontName = [_fontArray objectAtIndex:indexPath.row];
    }
}
-(void)openColorPickerView
{
    [[NSUserDefaults standardUserDefaults]setInteger:03 forKey:@"add"];
    DRColorPickerBackgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    DRColorPickerBorderColor = [UIColor blackColor];
    DRColorPickerFont = [UIFont fontWithName:@"AvenirLTStd-Medium" size:16.0];
    DRColorPickerLabelColor = [UIColor blackColor];
    DRColorPickerStoreMaxColors = 200;
    DRColorPickerShowSaturationBar = YES;
    DRColorPickerHighlightLastHue = YES;
    DRColorPickerUsePNG = NO;
    DRColorPickerJPEG2000Quality = 0.9f;
    DRColorPickerSharedAppGroup = nil;
   
    DRColorPickerViewController* vc = [DRColorPickerViewController newColorPickerWithColor:self.color];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.rootViewController.showAlphaSlider = YES; // default is YES, set to NO to hide the alpha slider
    
    NSInteger theme = 2; // 0 = default, 1 = dark, 2 = light
    
    // in addition to the default images, you can set the images for a light or dark navigation bar / toolbar theme, these are built-in to the color picker bundle
    if (theme == 0)
    {
        // setting these to nil (the default) tells it to use the built-in default images
        vc.rootViewController.addToFavoritesImage = nil;
        vc.rootViewController.favoritesImage = nil;
        vc.rootViewController.hueImage = nil;
        vc.rootViewController.wheelImage = nil;
        vc.rootViewController.importImage = nil;
    }
    else if (theme == 1)
    {
        vc.rootViewController.addToFavoritesImage = DRColorPickerImage(@"images/dark/drcolorpicker-addtofavorites-dark.png");
        vc.rootViewController.favoritesImage = DRColorPickerImage(@"images/dark/drcolorpicker-favorites-dark.png");
        vc.rootViewController.hueImage = DRColorPickerImage(@"images/dark/drcolorpicker-hue-v3-dark.png");
        vc.rootViewController.wheelImage = DRColorPickerImage(@"images/dark/drcolorpicker-wheel-dark.png");
        vc.rootViewController.importImage = DRColorPickerImage(@"images/dark/drcolorpicker-import-dark.png");
    }
    else if (theme == 2)
    {
        vc.rootViewController.addToFavoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-addtofavorites-light.png");
        vc.rootViewController.favoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-favorites-light.png");
        vc.rootViewController.hueImage = DRColorPickerImage(@"images/light/drcolorpicker-hue-v3-light.png");
        vc.rootViewController.wheelImage = DRColorPickerImage(@"images/light/drcolorpicker-wheel-light.png");
        vc.rootViewController.importImage = DRColorPickerImage(@"images/light/drcolorpicker-import-light.png");
    }
    
    // assign a weak reference to the color picker, need this for UIImagePickerController delegate
    self.colorPickerVC = vc;
    
    // make an import block, this allows using images as colors, this import block uses the UIImagePickerController,
    // but in You Doodle for iOS, I have a more complex import that allows importing from many different sources
    // *** Leave this as nil to not allowing import of textures ***
    vc.rootViewController.importBlock = ^(UINavigationController* navVC, DRColorPickerHomeViewController* rootVC, NSString* title)
    {
        UIImagePickerController* p = [[UIImagePickerController alloc] init];
        p.delegate = self;
        p.modalPresentationStyle = UIModalPresentationCurrentContext;
        p.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.colorPickerVC presentViewController:p animated:YES completion:nil];
    };
    
    // dismiss the color picker
    vc.rootViewController.dismissBlock = ^(BOOL cancel)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    // a color was selected, do something with it, but do NOT dismiss the color picker, that happens in the dismissBlock
    vc.rootViewController.colorSelectedBlock = ^(DRColorPickerColor* color, DRColorPickerBaseViewController* vc)
    {
        self.color = color;
        if (color.rgbColor == nil)
        {
//            self.view.backgroundColor = [UIColor colorWithPatternImage:color.image];
            self.mainbgimgview.image=color.image;//newcolor;
            self->bgcolor=[UIColor colorWithPatternImage:color.image];
        }
        else
        {
            self.mainbgimgview.image=[self imageFromColor:color.rgbColor];//color.image;//newcolor;
            self->bgcolor=color.rgbColor;//[UIColor colorWithPatternImage:color.image];
//            self.view.backgroundColor = color.rgbColor;
        }
    };
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    // finally, present the color picker
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)openAllViewWithIndex : (NSInteger )index
{
    if (index == 0) {
        //        Layout
        _btmlbl.hidden = NO;
        [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.layoutView.frame = CGRectMake(0, IPAD ? HEIGHT-IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? HEIGHT-IPhoneHeight : HEIGHT-XHeight-20, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
        }completion:^(BOOL finished) {
            
        }];
    }
    else if (index == 1){
        //        Background
        _btmlbl.hidden = NO;
        [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.bguiView.frame = CGRectMake(0, IPAD ? HEIGHT-IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? HEIGHT-IPhoneHeight : HEIGHT-XHeight-20, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
        }completion:^(BOOL finished) {
            
        }];
    }
    else if (index == 2){
        //        Border
        _btmlbl.hidden = NO;
        [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.borderView.frame = CGRectMake(0, IPAD ? HEIGHT-IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? HEIGHT-IPhoneHeight : HEIGHT-XHeight-20, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
        }completion:^(BOOL finished) {
            self->tempcornerRadiusFloat=self.gridcornerSlider.value;
            self->tempborderFloat=self.gridoutsideSlider.value;
        }];
    }
    else if (index == 3){
        //        Filter
        _btmlbl.hidden = NO;
        [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.FilterView.frame = CGRectMake(0, IPAD ? HEIGHT-IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? HEIGHT-IPhoneHeight : HEIGHT-XHeight-20, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
        }completion:^(BOOL finished) {
            
        }];
    }
    else if (index == 4){
        //        Text
        currentlyEditingLabel.labelTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self performSelectorOnMainThread:@selector(btnTextPressed) withObject:self waitUntilDone:YES];
    }
    else if (index == 5){
        //        Cut
        [[NSUserDefaults standardUserDefaults]setInteger:04 forKey:@"add"];
        [self GalleryOpen];
    }
    else if (index == 6){
        //        Add
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"addImage"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (index == 7){
        //        Sticker
        StickerViewController *stickerv=[[StickerViewController alloc]initWithNibName:@"StickerViewController" bundle:nil];
        stickerv.stickerindex = 1;
        stickerv.photodelegate = self;
        stickerv.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:stickerv animated:YES completion:nil];
    }
}
-(IBAction)cellbuttonPress:(UIButton *)sender
{
    btnIndex = 1;
    cellindex = sender.tag;
    if (![self showInterAdWithCount:3]){
        [self openAllViewWithIndex:sender.tag];
    }
}

#pragma mark border slider methods
-(IBAction)GridLayerRadiurValuChanged:(UISlider *)sender
{
    cornerRadius=sender.value;
    _gridcornerSlider.value=sender.value;
    for (UIView *view in _viewArray) {
        view.layer.cornerRadius= cornerRadius;
        view.layer.masksToBounds=YES;
    }
}
-(IBAction)OutsideframeValueChanged:(UISlider *)sender
{
    _gridoutsideSlider.value=sender.value;
    int count=0;
    for (UIView *view in _viewArray) {
        view.layer.cornerRadius=_gridcornerSlider.value;
        view.layer.masksToBounds=YES;
        CGRect someRect = [[_frameArray objectAtIndex:count] CGRectValue];
        CALayer *maskinlayer=[_maskingLayerArray objectAtIndex:count];
        UIScrollView *myscrollview=[_scrollviewArray objectAtIndex:count];
        UIImageView *imgview=[_imgviewArray objectAtIndex:count];
        CGRect imgRect=[[_imgviewFrameArray objectAtIndex:count] CGRectValue];
        
        view.frame=CGRectMake(someRect.origin.x+_gridoutsideSlider.value, someRect.origin.y+_gridoutsideSlider.value, someRect.size.width-(_gridoutsideSlider.value*2), someRect.size.height-(_gridoutsideSlider.value*2));
        count++;
        myscrollview.frame=view.bounds;
        maskinlayer.frame=view.bounds;
        myscrollview.contentSize=CGSizeMake(imgRect.size.width-(_gridoutsideSlider.value*2), imgRect.size.height-(_gridoutsideSlider.value*2));
        
        float zoomScaling;
        
        float zoomx=myscrollview.frame.size.width/imgview.bounds.size.width;
        float zoomy=myscrollview.frame.size.height/imgview.bounds.size.height;
        
        zoomScaling = (zoomx >= zoomy) ? zoomx : zoomy;
        
        myscrollview.minimumZoomScale=zoomScaling;
        myscrollview.maximumZoomScale=5.0;
        myscrollview.zoomScale=zoomScaling;
        
        CGFloat newContentOffsetX = (myscrollview.contentSize.width/2) - (myscrollview.bounds.size.width/2);
        CGFloat newContentOffsetY = (myscrollview.contentSize.height/2) - (myscrollview.bounds.size.height/2);
        myscrollview.contentOffset = CGPointMake(newContentOffsetX, newContentOffsetY);
    }
}

-(void)btnTextPressed
{
    if (currentlyEditingLabel!=nil)
    {
        [currentlyEditingLabel hideEditingHandles];
    }
    labelView = [[IQLabelView alloc] initWithFrame:CGRectMake((_saveView.frame.size.width/2)-30, 50, 60, 50)];
    [labelView setDelegate:self];
    [labelView setShowsContentShadow:NO];
    [labelView setEnableMoveRestriction:NO];
    [labelView setFontName:@"Baskerville-BoldItalic"];
    [labelView setFontSize:21.0];
    
    [self.saveView addSubview:labelView];
    [self.saveView setUserInteractionEnabled:YES];
    
    currentlyEditingLabel = labelView;
    [labels addObject:labelView];
}
#pragma mark - IQLabelDelegate
- (void)labelViewDidClose:(IQLabelView *)label
{
    // some actions after delete label
    [labels removeObject:label];
    _MainToolbarView.hidden=YES;
    _MainTextUIView.hidden=YES;
}
- (void)labelViewDidBeginEditing:(IQLabelView *)label
{
}
- (void)labelViewDidShowEditingHandles:(IQLabelView *)label
{
    currentlyEditingLabel = label;
}
- (void)labelViewDidHideEditingHandles:(IQLabelView *)label
{
    currentlyEditingLabel = nil;
}
- (void)labelViewDidStartEditing:(IQLabelView *)label
{
    currentlyEditingLabel = label;
}

#pragma mark KeyboardSize and Show
-(void)keyboardSize :(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _MainTextUIView.frame=CGRectMake(0, keyboardFrame.origin.y, WIDTH, keyboardFrame.size.height);
    [_MainToolbarView setFrame:CGRectMake(0.0f, self.view.frame.size.height - keyboardFrame.size.height - _MainToolbarView.frame.size.height, WIDTH, _MainToolbarView.frame.size.height)];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    _MainToolbarView.hidden=NO;
}

#pragma mark Text Editing Button Method
-(IBAction)KBDbtnPressed:(UIButton *)sender
{
    if(sender.tag==11)
    {
        _textkbdbtn.selected=YES;
        _textcolorbtn.selected=NO;
        _textfontbtn.selected=NO;
        
        [currentlyEditingLabel.labelTextField becomeFirstResponder];
        
        _MainTextUIView.hidden=YES;
        _MainTextColorPicker.hidden=YES;
        _MainTextPickerView.hidden=YES;
        
    }
    else if (sender.tag==13)
    {
        _textkbdbtn.selected=NO;
        _textcolorbtn.selected=NO;
        _textfontbtn.selected=YES;
        
        [self.view endEditing:YES];
        
        _MainTextUIView.hidden=NO;
        _MainTextColorPicker.hidden=YES;
        _MainTextPickerView.hidden=NO;
    }
    else if (sender.tag==12)
    {
        _textkbdbtn.selected=NO;
        _textcolorbtn.selected=YES;
        _textfontbtn.selected=NO;
        
        [self.view endEditing:YES];
        
        _MainTextUIView.hidden=NO;
        _MainTextColorPicker.hidden=NO;
        _MainTextPickerView.hidden=YES;
    }
    else if(sender.tag==14)
    {
        _MainToolbarView.hidden=YES;
        _MainTextUIView.hidden=YES;
        [self.view endEditing:YES];
    }
}
- (void)imageView:(DTColorPickerImageView *)imageView didPickColorWithColor:(UIColor *)color
{
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    currentlyEditingLabel.textColor=[UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //    NSLog(@"Picked Color Components: %.0f, %.0f, %.0f", red * 255.0f, green * 255.0f, blue * 255.0f);
}
-(IBAction)filterdonebtnpress:(id)sender
{
    [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
    }completion:^(BOOL finished) {
        self.btmlbl.hidden = YES;
    }];
}
-(IBAction)layoutdonebtnpress:(id)sender
{
    [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.layoutView.frame = CGRectMake(0, HEIGHT, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
    }completion:^(BOOL finished) {
        self.btmlbl.hidden = YES;
    }];
}
-(IBAction)borderdonebtnpress:(id)sender
{
    [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.borderView.frame = CGRectMake(0, HEIGHT, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
    }completion:^(BOOL finished) {
        self.btmlbl.hidden = YES;
    }];
}
-(IBAction)bgdonebtnpress:(id)sender
{
    [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.bguiView.frame = CGRectMake(0, HEIGHT, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
    }completion:^(BOOL finished) {
        self.btmlbl.hidden = YES;
    }];
}
-(void)GalleryOpen
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:NO completion:^{
//        _indicatorView.hidden=true;
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    int add=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"add"];
    if (add == 03) {
        [self.colorPickerVC dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self dismissViewControllerAnimated:picker completion:^{
            //        _CutButton.selected=NO;
        }];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    int add=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"add"];
    
    if (add==01)
    {
        [_imagesArray replaceObjectAtIndex:selView.tag-1 withObject:image];
        
        [self dismissViewControllerAnimated:YES completion:^
         {
             [self btnDeletePressed:nil];
         }];
    }
    else if (add == 03){
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        if(!img) img = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.colorPickerVC.rootViewController finishImport:img];
        [self.colorPickerVC dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^
        {
             CropViewController *crop=[[CropViewController alloc]initWithNibName:@"CropViewController" bundle:nil];
             crop.delegate=self;
             crop.imageA=image;
             crop.modalPresentationStyle = UIModalPresentationFullScreen;
             [self presentViewController:crop animated:YES completion:nil];
        }];
    }
}
-(IBAction)btnAddPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setInteger:01 forKey:@"add"];
    [self GalleryOpen];
}
-(IBAction)btnDeletePressed:(UIButton *)sender
{
    int add=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"add"];
    if (add == 01){
        
    }
    else{
        if (_imagesArray.count==2) {
            NSLog(@"you can't remove image");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Photo Collage" message:@"You Can't Remove image because Photo Collage Contains minimum two Images" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    //    else{
    NSLog(@"remove");
    
    [[NSUserDefaults standardUserDefaults]setInteger:02 forKey:@"add"];
    
    if([_viewArray containsObject:selView])
    {
        [selView removeFromSuperview];
        
        _btnAddM.hidden=YES;
        _btnDelete.hidden=YES;
        
        if(add==01)
        {
        }
        else
        {
            selectedLayout = 0;
            if (_imagesArray.count==2) {
                
            }
            else{
                [_imagesArray removeObjectAtIndex:selView.tag-1];
                [_originalArray removeObjectAtIndex:selView.tag-1];
            }
        }
        PhotosCounter = _imagesArray.count;
        _selectedViewlayer.image=nil;
        
        for (UIView *myview in _viewArray)
        {
            [myview removeFromSuperview];
        }
        
        [_viewArray removeAllObjects];
        [_imgviewArray removeAllObjects];
        [_scrollviewArray removeAllObjects];
        [_frameArray removeAllObjects];
        [_zoomscaleArray removeAllObjects];
        [_maskingLayerArray removeAllObjects];
        [_imgviewFrameArray removeAllObjects];
        [_layoutArray removeAllObjects];
        
        NSString *layout=[NSString stringWithFormat:@"grid_%ld",(long)PhotosCounter];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:layout ofType:@"plist"];
        NSDictionary *dictionary =[NSDictionary dictionaryWithContentsOfFile:path];
        myMainDic=[dictionary objectForKey:@"grid"];
        NSString *countstr=[myMainDic valueForKey:@"count"];
        int gridcount=(int)[countstr integerValue];
        
//        selectedLayout = 0;
        cornerRadius=0.0;
        _gridoutsideSlider.value=0.0;
        
        for (int i=0; i<PhotosCounter; i++)
        {
            NSString *strpath=[NSString stringWithFormat:@"grid_%ld.%d",(long)selectedLayout,i];
            
            float loadx=(WIDTH*[[[myMainDic valueForKeyPath:strpath] valueForKey:@"x"] floatValue])/720;
            float loady=(WIDTH*[[[myMainDic valueForKeyPath:strpath] valueForKey:@"y"] floatValue])/720;
            
            NSString *mask=[[myMainDic valueForKeyPath:strpath] valueForKey:@"mask"];
            UIImage *myimgmask=[UIImage imageNamed:mask];
            
            float loadw=(WIDTH*myimgmask.size.width)/720;
            float loadh=(WIDTH*myimgmask.size.height)/720;
            
            UIView *myview=[[UIView alloc]initWithFrame:CGRectMake(loadx, loady,loadw,loadh)];
            myview.backgroundColor=[UIColor clearColor];
            myview.tag=i+1;
            
            _scrollview=[[UIScrollView alloc]initWithFrame:myview.bounds];
            _scrollview.delegate=self;
            _scrollview.bounces=NO;
            _scrollview.tag=i+1;
            _scrollview.showsVerticalScrollIndicator=NO;
            _scrollview.showsHorizontalScrollIndicator=NO;
            
            UIImage *myimg=[_imagesArray objectAtIndex:i];
            _imageview=[[UIImageView alloc]initWithImage:myimg];
            [_scrollview addSubview:_imageview];
            
            [myview addSubview:_scrollview];
            [self.saveInsideview addSubview:myview];
            
            [_scrollview setContentSize:CGSizeMake(_imageview.bounds.size.width,_imageview.bounds.size.height)];
            
            float zoomScaling;
            float zoomx=_scrollview.frame.size.width/_imageview.bounds.size.width;
            float zoomy=_scrollview.frame.size.height/_imageview.bounds.size.height;
            
            zoomScaling = (zoomx >= zoomy) ? zoomx : zoomy;
            
            _scrollview.minimumZoomScale=zoomScaling;
            _scrollview.maximumZoomScale=5.0;
            _scrollview.zoomScale=zoomScaling;
            _scrollview.clipsToBounds = YES;
            [_zoomscaleArray addObject:[NSString stringWithFormat:@"%f",zoomScaling]];
            [_frameArray addObject:[NSValue valueWithCGRect:myview.frame]];
            [_scrollviewArray addObject:_scrollview];
            [_imgviewArray addObject:_imageview];
            [_imgviewFrameArray addObject:[NSValue valueWithCGRect:myview.frame]];
            [_viewArray addObject:myview];
            
            CGFloat newContentOffsetX = (_scrollview.contentSize.width/2) - (_scrollview.bounds.size.width/2);
            CGFloat newContentOffsetY = (_scrollview.contentSize.height/2) - (_scrollview.bounds.size.height/2);
            _scrollview.contentOffset = CGPointMake(newContentOffsetX, newContentOffsetY);
            
            UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressonUIView:)];
            [myview addGestureRecognizer:longpress];
            
            UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
            [myview addGestureRecognizer:letterTapRecognizer];
            
            if (mask!=nil) {
                UIImage *maskImage=[UIImage imageNamed:mask];
                CALayer  *_maskingLayer = [CALayer layer];
                _maskingLayer.frame = myview.bounds;
                [_maskingLayer setContents:(id)[maskImage CGImage]];
                [myview.layer setMask:_maskingLayer];
                [_maskingLayerArray addObject:_maskingLayer];
            }
        }

        oldTag=100;
        _selectedViewlayer.layer.borderColor=TopColor.CGColor;
        _selectedViewlayer.layer.masksToBounds=YES;
        
        for (int i=0; i<gridcount; i++){
            NSString *str=[NSString stringWithFormat:@"grid_layout_%ld_%d.png",(long)PhotosCounter,i];
            [_layoutArray addObject:str];
            str =  nil;
        }
       
        [_layoutColView reloadData];
        
        int counter=0;
        for (UIScrollView *scr in _scrollviewArray) {
            NSLog(@"Zoomscale : %f",[[_zoomscaleArray objectAtIndex:counter] floatValue]);
            scr.zoomScale=[[_zoomscaleArray objectAtIndex:counter] floatValue];
            counter++;
        }
    }
}

-(void)addItemViewControllerdidFinishEnteringItem:(UIImage *)item
{
    if(item != nil)
    {
        [self hideAllCurrentEditingSticker];
        UIImageView *imageView1 = [[UIImageView alloc] initWithImage:item];
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
        [_saveView addSubview:userResizableView];
    }
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
        [_saveView addSubview:userResizableView];
    }
}
#pragma mark ZDStickerView delegate functions
-(void)hideAllCurrentEditingSticker
{
    for (ZDStickerView *sticker in _saveView.subviews)
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
#pragma mark Simple color Delegate Method
- (void)simplecolrViewReciveColor:(UIImage *)newcolor andOldcolor:(UIImage *)oldcolor
{
    UIColor *color=[UIColor colorWithPatternImage:newcolor];
    _mainbgimgview.image=newcolor;
    bgcolor=color;
    
    int count=0;
    for (UIView *view in _viewArray) {
        view.layer.cornerRadius=cornerRadius;
        view.layer.masksToBounds=YES;
        CGRect someRect = [[_frameArray objectAtIndex:count] CGRectValue];
        view.frame=CGRectMake(someRect.origin.x+_gridoutsideSlider.value, someRect.origin.y+_gridoutsideSlider.value, someRect.size.width-(_gridoutsideSlider.value*2), someRect.size.height-(_gridoutsideSlider.value*2));
        count++;
    }
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
        //        if (![DEFAULT boolForKey:IS_ACTIVE_SUB])
        //        {
        if (AppDelObj.inter_View.isReady)
        {
            AppDelObj.inter_View.delegate = self;
            [AppDelObj.inter_View presentFromRootViewController:self];
            return  YES;
        }
        else
        {
            [AppDelObj createInterView];
            return  NO;
        }
        //        }
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
        [self openAllViewWithIndex:cellindex];
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
    [currentlyEditingLabel hideEditingHandles];
    [self hideAllCurrentEditingSticker];
    ShareViewController *share = [[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    share.saveimage = [AppDelObj screenshotimageWithView:_saveView];
    share.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:share animated:YES completion:nil];
}
-(IBAction)backbtnpress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
