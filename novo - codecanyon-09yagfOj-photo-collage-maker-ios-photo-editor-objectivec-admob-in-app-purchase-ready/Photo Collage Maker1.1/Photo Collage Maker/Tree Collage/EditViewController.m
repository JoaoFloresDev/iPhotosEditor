//
//  EditViewController.m
//  Tree Collage Maker
//
//  Created by Tejas Vaghasiya on 11/04/17.
//  Copyright © 2017 Tejas Vaghasiya. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()<PECropViewControllerDelegate>
{
    NSMutableArray *effectArray;
    NSMutableArray *effectthumbArray;
    UIImage *editedimage;
    
    NSInteger selectIndex;
    
    NSInteger btnindex;
}

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IPAD) {
        _topView.frame = CGRectMake(0, 0, WIDTH, 80);
        _saveview.frame = CGRectMake((WIDTH-(WIDTH-100))/2, 85, WIDTH-100, WIDTH-100);
        _btmmainview.frame = CGRectMake(0, HEIGHT-80, WIDTH, 80);
        _bannerView.frame = CGRectMake(0, 85+(WIDTH-100), WIDTH, 90);
        _btmlbl.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
        _effectview.frame=CGRectMake(0, HEIGHT, WIDTH, IPADHeight);
        _drawview.frame=CGRectMake(0, HEIGHT, WIDTH, IPADHeight);
    }
    else if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS) {
        _topView.frame = CGRectMake(0, 0, WIDTH, 45);
        _saveview.frame = CGRectMake(0, 50, WIDTH, WIDTH);
        _bannerView.frame = CGRectMake(0, 50+WIDTH, WIDTH, 50);
        _btmlbl.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
        _effectview.frame=CGRectMake(0, HEIGHT, WIDTH, IPhoneHeight);
        _drawview.frame=CGRectMake(0, HEIGHT, WIDTH, IPhoneHeight);
        _btmmainview.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
    }
    else {
        _topView.frame = CGRectMake(0, 30, WIDTH, 45);
        _saveview.frame = CGRectMake(0, 80, WIDTH, WIDTH);
        _bannerView.frame = CGRectMake(0, 80+WIDTH, WIDTH, 50);
        _btmmainview.frame = CGRectMake(0, HEIGHT-_btmmainview.frame.size.height-20, WIDTH, _btmmainview.frame.size.height);
        _btmlbl.frame = CGRectMake(0, HEIGHT-20, WIDTH, 20);
        _effectview.frame=CGRectMake(0, HEIGHT, WIDTH, XHeight);
        _drawview.frame=CGRectMake(0, HEIGHT, WIDTH, XHeight);
    }
    
    _btmlbl.hidden = YES;
    
    [AppDelObj loadBannerAds:_bannerView];
    _bannerView.delegate = self;
    
    _topView.backgroundColor = TopColor;
    _toplbl.backgroundColor = TopColor;
    _effectview.backgroundColor = BottomBGColor;
    _drawview.backgroundColor = BottomBGColor;
    _colorview.backgroundColor = BottomBGColor;
    _btmlbl.backgroundColor = BottomBGColor;
    _MainToolbarView.backgroundColor = BottomBGColor;
    
    UIImage *maxImage = [[UIImage imageNamed:@"empty_bg.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    UIImage *thumbImage = [UIImage imageNamed:@"slider_base.png"];
    
    [_sizeslider setMaximumTrackTintColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [_sizeslider  setMinimumTrackImage:maxImage forState:UIControlStateNormal];
    [_sizeslider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [_opacityslider setMaximumTrackTintColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [_opacityslider  setMinimumTrackImage:maxImage forState:UIControlStateNormal];
    [_opacityslider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [_effectslider setMaximumTrackTintColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [_effectslider  setMinimumTrackImage:maxImage forState:UIControlStateNormal];
    [_effectslider setThumbImage:thumbImage forState:UIControlStateNormal];
    
     _MainTextUIView.hidden=YES;
    
    effectArray=[[NSMutableArray alloc]init];
    effectthumbArray=[[NSMutableArray alloc]init];
    didImageFilter=[[DidImageFilters alloc]init];
    labels = [[NSMutableArray alloc]init];

    selectIndex = 0;

    [effectthumbArray addObject:[NSString stringWithFormat:@"original.png"]];
    [effectArray addObject:[NSString stringWithFormat:@"original.png"]];

    for (int i=1; i<=50; i++) {
        NSString *str=[NSString stringWithFormat:@"bokeh_thumb_%d.jpg",i];
        [effectthumbArray addObject:str];
        
        NSString *strmoby=[NSString stringWithFormat:@"bokeh_%d.jpg",i];
        [effectArray addObject:strmoby];
    }
    
    _colorview.frame=CGRectMake(0, HEIGHT, WIDTH, 300);

    _mainImage=[self scaleImage:_mainImage toSize:CGSizeMake(WIDTH, WIDTH)];
    _mainimgview.image=_mainImage;
    editedimage=_mainImage;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardSize:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"touchesEnded"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTouchesMoved:)
                                                 name:@"touchesMoved"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTouchesBegan:)
                                                 name:@"touchesBegan"
                                               object:nil];
    
    _fontArray=[[NSMutableArray alloc]init];
    
    _effectcolview.delegate=self;
    _effectcolview.dataSource=self;
    [_effectcolview registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"effectcell"];
    
    self.pickerview.delegate=self;
    self.pickerview.dataSource=self;
    [self.pickerview registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"effectcell"];
    
    _textfontbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _textcolorbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _textkbdbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _textdonebtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    _effectdonebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    _opacityslider.thumbTintColor=TopColor;
//    _sizeslider.thumbTintColor=TopColor;
//    _effectslider.thumbTintColor=TopColor;
    
    _prevlbl.layer.cornerRadius=(_prevlbl.frame.size.width)/2;
    _prevlbl.layer.borderWidth=3.0f;
    _prevlbl.layer.borderColor=[UIColor whiteColor].CGColor;
    _prevlbl.layer.masksToBounds=YES;
    
    _frontImageView.userInteractionEnabled=NO;
    [_frontImageView setDrawingMode:DrawingModeNone];
    
    _fontArray = @[@"AmericanTypewriter",@"AmericanTypewriter-CondensedLight",@"AppleSDGothicNeo-Bold",@"Avenir",@"AvenirNext",@"Baskerville",@"BradleyHandITCTT-Bold",@"Cochin",@"Chalkduster",@"DINCondensed-Bold",@"DiwanMishafi",@"Futura-CondensedExtraBold",@"GillSans",@"Menlo",@"MarkerFelt-Thin",@"Noteworthy-Bold",@"Optima",@"Palatino",@"Papyrus",@"PartyLetPlain",@"SavoyeLetPlain",@"Thonburi",@"TimesNewRomanPS"];

    _cropbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _effectbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _maindrawbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _textbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    _erasebtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _drawbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _colorbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
}
-(void)viewDidAppear:(BOOL)animated
{
//    [_effectcolview reloadData];
}
- (UIImage *)scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView==_pickerview)
    {
        return _fontArray.count;
    }
    else{
        return effectthumbArray.count;
    }
}
-(MenuCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    MenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"effectcell" forIndexPath:indexPath];
    
    if(collectionView==_pickerview)
    {
        cell.txtlbl.hidden=NO;
        cell.imgiew.hidden=YES;
        cell.txtlbl.text=@"Text";
        [cell.txtlbl setFont:[UIFont fontWithName:[_fontArray objectAtIndex:indexPath.row] size:17.0]];
        cell.txtlbl.textColor = [UIColor blackColor];
        cell.imgiew.hidden = YES;
    }
    else{
        cell.imgiew.hidden=NO;
        cell.imgiew.image=[UIImage imageNamed:[effectthumbArray objectAtIndex:indexPath.row]];
        
        if (selectIndex == indexPath.row) {
            cell.imgiew.layer.borderWidth = 1.5;
            cell.imgiew.layer.borderColor = TopColor.CGColor;
        }
        else{
            cell.imgiew.layer.borderWidth = 1.0;
            cell.imgiew.layer.borderColor = [UIColor blackColor].CGColor;
        }
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==_pickerview)
    {
        currentlyEditingLabel.fontName=[_fontArray objectAtIndex:indexPath.row];
        currentlyEditingLabel.labelTextField.font=[UIFont fontWithName:[_fontArray objectAtIndex:indexPath.row] size:currentlyEditingLabel.fontSize];
    }
    else{
        selectIndex = indexPath.row;
        NSLog(@"select");
        UIImage *image;
        if (indexPath.row==0) {
            image=_mainImage;
        }
        else{
            image=[didImageFilter ApplyBlendFilterWithImage:_mainImage BlendImage:[UIImage imageNamed:[effectArray objectAtIndex:indexPath.row]]];
        }
       
        [_effectimgview setAlpha:_effectslider.value];
        editedimage=image;
        [_effectimgview setImage:image];
        [_effectcolview reloadData];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(collectionView == _pickerview){
        if (IPAD) {
            size = CGSizeMake(WIDTH/6, WIDTH/6);
        }
        else{
            size = CGSizeMake(WIDTH/4, WIDTH/4);
        }
    }
    else if (collectionView == _effectcolview){
        size = CGSizeMake(_effectcolview.frame.size.height-10, _effectcolview.frame.size.height-10);
    }
    else{
        size = CGSizeMake(50, 50);
    }
    
    return size;
}
- (UIImage *) screenshotimageWithView:(UIView *)view
{
    [currentlyEditingLabel hideEditingHandles];
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
-(IBAction)cropbtnpress:(id)sender
{
    btnindex = 1;
    if (![self showInterAdWithCount:2]){
        [self opencropView];
    }
}
-(void)opencropView
{
    UIImage *image=[self screenshotimageWithView:_saveview];
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = image;
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    controller.keepingCropAspectRatio=NO;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:NULL];
}
-(void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [self dismissViewControllerAnimated:YES completion:^
    {
         [self->currentlyEditingLabel hideEditingHandles];
         [self->currentlyEditingLabel.labelTextField removeFromSuperview];
         self.mainimgview.image=croppedImage;
         self.effectimgview.image=croppedImage;
         self.mainImage=croppedImage;
//         MainViewController *view=[[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
//         view.mainimage=croppedImage;
//         [self presentViewController:view animated:YES completion:nil];
    }];
}
-(IBAction)effectdonebtnpress:(id)sender
{
    _btmlbl.hidden = YES;
    [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.effectview.frame = CGRectMake(0, HEIGHT, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
    }completion:^(BOOL finished) {
        
    }];
}
-(IBAction)effectsliderchanged:(UISlider *)sender
{
    _effectimgview.alpha=sender.value;
}
-(IBAction)effectbtnpress:(id)sender
{
    btnindex = 2;
    _btmlbl.hidden = NO;
    if (![self showInterAdWithCount:2]){
        [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.effectview.frame = CGRectMake(0, IPAD ? HEIGHT-IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? HEIGHT-IPhoneHeight : HEIGHT-XHeight-20, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
        }completion:^(BOOL finished) {
            
        }];
    }
}
-(IBAction)drawbtnpress:(id)sender
{
    btnindex = 3;
    _btmlbl.hidden = NO;
    if (![self showInterAdWithCount:2]){
        [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.drawview.frame = CGRectMake(0, IPAD ? HEIGHT-IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? HEIGHT-IPhoneHeight : HEIGHT-XHeight-20, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
        }completion:^(BOOL finished) {
            
        }];
    }
}
-(IBAction)drawdonebtnpress:(id)sender
{
    _btmlbl.hidden = YES;
    _frontImageView.userInteractionEnabled=NO;
    [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.drawview.frame = CGRectMake(0, HEIGHT, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
    }completion:^(BOOL finished) {
        
    }];
}
-(IBAction)brushbtnpress:(id)sender
{
    _frontImageView.userInteractionEnabled=YES;
    [_frontImageView setDrawingMode:DrawingModePaint];
    [_frontImageView setSelectedColor:_prevlbl.backgroundColor];
//    [_frontImageView setSelectedColor:[UIColor blackColor]];
}
-(IBAction)colorbtnpress:(id)sender
{
    _frontImageView.userInteractionEnabled=NO;
    [_frontImageView setDrawingMode:DrawingModeNone];
    [UIView animateWithDuration:Duration animations:^{
        self.colorview.frame=CGRectMake(0, IS_IPHONE_XS_MAX || IS_IPHONE_X ? HEIGHT-300-20 : HEIGHT-300, WIDTH, 300);
    }];
}
-(IBAction)colordonepress:(id)sender
{
    [UIView animateWithDuration:Duration animations:^{
        self.colorview.frame=CGRectMake(0, HEIGHT, WIDTH, 300);
    }];
}
-(IBAction)erasebtnpress:(id)sender
{
    _frontImageView.userInteractionEnabled=YES;
    [_frontImageView setDrawingMode:DrawingModeErase];
}
-(void)receiveTouchesBegan:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"touchesBegan"])
    {

    }
}
- (void) receiveTestNotification:(NSNotification *) notification
{
//    NSLog (@"Successfully received the test notification!");
    
    if ([[notification name] isEqualToString:@"touchesEnded"])
    {
        
    }
    
}

-(void)receiveTouchesMoved:(NSNotification *) notification
{
//    NSLog(@"touch moved");
    if ([[notification name] isEqualToString:@"touchesMoved"])
    {
        
    }
}
-(IBAction)sizesliderchanged:(UISlider *)sender
{
    _frontImageView.brushsize=sender.value;
}
-(IBAction)opacitysliderchanged:(UISlider *)sender
{
    _frontImageView.alpha=sender.value;
}
-(IBAction)textbtnpress:(id)sender
{
    btnindex = 4;
    if (![self showInterAdWithCount:2]){
        [self btnTextPressed];
    }
}
-(void)donemethod
{
    [currentlyEditingLabel hideEditingHandles];
    UIImage *image=[self screenshotimageWithView:_saveview];
    [_delegate didReceiveDelegateWithImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)donebtnpress:(id)sender
{
    btnindex = 5;
    if (AppDelObj.inter_View.isReady)
    {
        AppDelObj.inter_View.delegate = self;
        [AppDelObj.inter_View presentFromRootViewController:self];
    }
    else{
        [self donemethod];
    }
}
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
    else
    {
        
    }
}
-(void)btnTextPressed
{
    _MainToolbarView.hidden=NO;
    if (currentlyEditingLabel!=nil)
    {
        [currentlyEditingLabel hideEditingHandles];
    }
    labelView = [[IQLabelView alloc] initWithFrame:CGRectMake((_saveview.frame.size.width/2)-30, 50, 60, 50)];
    [labelView setDelegate:self];
    [labelView setShowsContentShadow:NO];
    [labelView setEnableMoveRestriction:NO];
    [labelView setFontName:@"Baskerville-BoldItalic"];
    [labelView setFontSize:21.0];
    
    [self.saveview addSubview:labelView];
    [self.saveview setUserInteractionEnabled:YES];
    
    currentlyEditingLabel = labelView;
    [labels addObject:labelView];
}
-(void)keyboardSize :(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    //    NSLog(@"size height: %f",keyboardFrame.size.height);
    _MainTextUIView.frame=CGRectMake(0, keyboardFrame.origin.y, WIDTH, keyboardFrame.size.height);
    [_MainToolbarView setFrame:CGRectMake(0.0f, self.view.frame.size.height - keyboardFrame.size.height - _MainToolbarView.frame.size.height, WIDTH, _MainToolbarView.frame.size.height)];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    _MainToolbarView.hidden=NO;
//    CGRect keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    NSLog(@"Keyboard Height : %f",keyboardBounds.size.height);
//    NSLog(@"Y :%f",Height - keyboardBounds.size.height);
//    [_MainToolbarView setFrame:CGRectMake(0.0f, self.view.frame.size.height - keyboardBounds.size.height - _MainToolbarView.frame.size.height, Width, _MainToolbarView.frame.size.height)];
}
- (void)imageView:(DTColorPickerImageView *)imageView didPickColorWithColor:(UIColor *)color
{
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    
    
    if (imageView == _drawcolorimgview) {
        _prevlbl.backgroundColor=[UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    }
    else{
        currentlyEditingLabel.textColor=[UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    }
    
    //    NSLog(@"Picked Color Components: %.0f, %.0f, %.0f", red * 255.0f, green * 255.0f, blue * 255.0f);
}
- (void)touchOutside:(UITapGestureRecognizer *)touchGesture
{
    NSLog(@"outside");
    [currentlyEditingLabel hideEditingHandles];
    [self.view endEditing:YES];
}

#pragma mark - IQLabelDelegate

- (void)labelViewDidClose:(IQLabelView *)label
{
    _MainToolbarView.hidden=YES;
    // some actions after delete label
    [labels removeObject:label];
}

- (void)labelViewDidBeginEditing:(IQLabelView *)label
{
    // move or rotate begin
}

- (void)labelViewDidShowEditingHandles:(IQLabelView *)label
{
    // showing border and control buttons
    currentlyEditingLabel = label;
//    _MainToolbarView.hidden=YES;

}

- (void)labelViewDidHideEditingHandles:(IQLabelView *)label
{
    // hiding border and control buttons
    currentlyEditingLabel = nil;
}

- (void)labelViewDidStartEditing:(IQLabelView *)label
{
    // tap in text field and keyboard showing
    currentlyEditingLabel = label;
}

#pragma mark interstial Method
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

- (void) interstitialDidDismissScreen:(GADInterstitial *)ad
{
    if (btnindex == 1) {
        [self opencropView];
    }
    else if (btnindex == 2){
        [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.effectview.frame = CGRectMake(0, IPAD ? HEIGHT-IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? HEIGHT-IPhoneHeight : HEIGHT-XHeight-20, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
        }completion:^(BOOL finished) {
            
        }];
    }
    else if (btnindex == 3){
        [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.drawview.frame = CGRectMake(0, IPAD ? HEIGHT-IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? HEIGHT-IPhoneHeight : HEIGHT-XHeight-20, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
        }completion:^(BOOL finished) {
            
        }];
    }
    else if (btnindex == 4){
        [self btnTextPressed];
    }
    else if (btnindex == 5){
        [self donemethod];
    }
    btnindex = 0;
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    [AppDelObj createInterView];
}


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
