//
//  D3MainViewController.m
//  Photo Collage Maker
//
//  Created by Vaishu on 8/27/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

#import "D3MainViewController.h"

@interface D3MainViewController (){
    IQLabelView *currentlyEditingLabel;
    NSMutableArray *labels;
    IQLabelView *labelView;

    NSMutableArray *nameArray;
    NSMutableArray *menuArray;
    NSMutableArray *menuSelectArray;
    
    NSInteger menuindex;
    
    ZDStickerView *edit_Sticker;
    
    NSInteger btnindex;
    NSInteger cellindex;
}

@end

@implementation D3MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topUIView.backgroundColor = TopColor;
    _headerLabel.backgroundColor = TopColor;
    
    if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        _topUIView.frame = CGRectMake(0, 0, WIDTH, 45);
        _saveView.frame = CGRectMake(0, 50, WIDTH, WIDTH);
        _bannerView.frame = CGRectMake(0, 50+WIDTH, WIDTH, 50);
        _menubtmView.frame = CGRectMake(0, HEIGHT-60, WIDTH, 60);
        _FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, IPhoneHeight);
        _btmlbl.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
    }
    else if (IPAD){
        _topUIView.frame = CGRectMake(0, 0, WIDTH, 80);
        _saveView.frame = CGRectMake((WIDTH-(WIDTH-100))/2, 85, WIDTH-100, WIDTH-100);
        _bannerView.frame = CGRectMake(0, 85+(WIDTH-100), WIDTH, 90);
        _menubtmView.frame = CGRectMake(0, HEIGHT-80, WIDTH, 80);
        _FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, IPADHeight);
        _btmlbl.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
    }
    else{
        _topUIView.frame = CGRectMake(0, 30, WIDTH, 45);
        _saveView.frame = CGRectMake(0, 80, WIDTH, WIDTH);
        _bannerView.frame = CGRectMake(0, 80+WIDTH, WIDTH, 50);
        _menubtmView.frame = CGRectMake(0, HEIGHT-90, WIDTH, 70);
        _FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, XHeight);
        _btmlbl.frame = CGRectMake(0, HEIGHT-20, WIDTH, 20);
    }
    
    _btmlbl.hidden = YES;
    
    [AppDelObj loadBannerAds:_bannerView];
    _bannerView.delegate = self;
    
    _FilterView.backgroundColor = BottomBGColor;
    _btmlbl.backgroundColor = BottomBGColor;
    _MainToolbarView.backgroundColor = BottomBGColor;
    
    labels = [[NSMutableArray alloc]init];
    
    _backImageView.image = _mainImage;
    _frameImageView.image = [UIImage imageNamed:@"frame_1.png"];
    
    _textkbdbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _textdonebtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _textfontbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _textcolorbtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    _filterdonebtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
     _fontArray = @[@"AmericanTypewriter",@"AmericanTypewriter-CondensedLight",@"AppleSDGothicNeo-Bold",@"Avenir",@"AvenirNext",@"Baskerville",@"BradleyHandITCTT-Bold",@"Cochin",@"Chalkduster",@"DINCondensed-Bold",@"DiwanMishafi",@"Futura-CondensedExtraBold",@"GillSans",@"Menlo",@"MarkerFelt-Thin",@"Noteworthy-Bold",@"Optima",@"Palatino",@"Papyrus",@"PartyLetPlain",@"SavoyeLetPlain",@"Thonburi",@"TimesNewRomanPS"];
    
    _menuColView.delegate = self;
    _menuColView.dataSource = self;
    [self.menuColView registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    self.pickerview.delegate=self;
    self.pickerview.dataSource=self;
    [self.pickerview registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    self.filterColView.delegate=self;
    self.filterColView.dataSource=self;
    [self.filterColView registerNib:[UINib nibWithNibName:@"FontCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    _filterArray=[[NSMutableArray alloc]init];
    [_filterArray addObject:@"original.png"];
    
    nameArray = [[NSMutableArray alloc]initWithObjects:@"original",@"B/W",@"Ivory",@"Milky",@"Baby",@"Angel",@"Mono",@"Sweet",@"Grace",@"Yellow",@"Jasmine",@"Lucky",@"Green",@"Sketch",@"Miracle",@"Dollish",@"Swan",@"Emma",@"Paopose",@"Coral",@"Poster",@"Hera",@"Bella",@"Vignet",@"swag",@"Coy",@"Stellar",@"Crush",@"Lady",@"Desire",@"Spice",@"Detect",@"Wine",@"Fantasy",@"Twist",@"Timber",@"Yuki",@"Glow",@"Ruby",@"Olive",@"Soft",@"Gleam",@"Mild",@"Chill",@"Maple",@"Scent", nil];
    
    for (int i=1; i<=45; i++){
        NSString *str=[NSString stringWithFormat:@"filter_%d.png",i];
        [_filterArray addObject:str];
    }
    
    menuArray = [[NSMutableArray alloc]initWithObjects:@"frame_unpresed.png",@"filter_unpresed.png",@"tex_unpresed.png",@"sticker_unpresed.png", nil];
    menuSelectArray = [[NSMutableArray alloc]initWithObjects:@"frame_presed.png",@"filter_presed.png",@"tex_presed.png",@"sticker_presed.png", nil];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
    [pinchGestureRecognizer setDelegate:self];
    [self.backImageView addGestureRecognizer:pinchGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [panGestureRecognizer setDelegate:self];
    [self.backImageView addGestureRecognizer:panGestureRecognizer];
    
    UIRotationGestureRecognizer *rotateGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(RotationGestureDetected:)];
    [rotateGestureRecognizer setDelegate:self];
    [self.backImageView addGestureRecognizer:rotateGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardSize:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    // Do any additional setup after loading the view from its nib.
}

#pragma mark GestureMethods
-(void)pinchGestureDetected:(UIPinchGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, scale,scale)];
        [recognizer setScale:1.0];
    }
}
-(void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:_insideSaveView];
        [recognizer.view setTransform:CGAffineTransformTranslate(recognizer.view.transform, translation.x, translation.y)];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
}
-(void)RotationGestureDetected:(UIRotationGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
        recognizer.rotation = 0;
    }
}
- (void)touchOutside:(UITapGestureRecognizer *)touchGesture
{
    [currentlyEditingLabel hideEditingHandles];
}

#pragma mark CollectionView Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView==_pickerview)
    {
        return [_fontArray count];
    }
    else if (collectionView == _menuColView){
        return menuArray.count;
    }
    else if(collectionView==_filterColView){
        return _filterArray.count;
    }
    
    return true;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _menuColView ){
        MenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];

        UIImage *img = [UIImage imageNamed:[menuArray objectAtIndex:indexPath.row]];
        UIImage *select = [UIImage imageNamed:[menuSelectArray objectAtIndex:indexPath.row]];
        
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
    if(collectionView == _menuColView){
        size=CGSizeMake(WIDTH/4, _menuColView.frame.size.height);
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
    if (collectionView == _menuColView) {
//        if (indexPath.row == 0) {
//            FrameViewController *frame=[[FrameViewController alloc]initWithNibName:@"FrameViewController" bundle:nil];
//            frame.delegate = self;
//            [self presentViewController:frame animated:YES completion:nil];
//        }
//        else if (indexPath.row == 1){
//        }
//        else if (indexPath.row == 2){
//        }
//        else if (indexPath.row == 3){
//        }
//        else if (indexPath.row == 4){
//        }
//        NSLog(@"menu select");
    }
    else if (collectionView == _filterColView){
        UIImage *main = [AppDelObj LoadAllEffectWithImage:_mainImage WithIndex:indexPath.row];//[self LoadAllEffectWithImage:_mainImage WithIndex:indexPath.row];
        _backImageView.image = main;
    }
    else if (collectionView == _pickerview){
        currentlyEditingLabel.fontName = [_fontArray objectAtIndex:indexPath.row];
    }
    
}
-(void)openallViewWithIndex : (NSInteger )index
{
    if (index == 0) {
        FrameViewController *frame=[[FrameViewController alloc]initWithNibName:@"FrameViewController" bundle:nil];
        frame.delegate=self;
        frame.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:frame animated:YES completion:nil];
    }
    else if (index == 1){
        _btmlbl.hidden = NO;
        [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.FilterView.frame = CGRectMake(0, IPAD ? HEIGHT-IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? HEIGHT-IPhoneHeight : HEIGHT-XHeight-20, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
        }completion:^(BOOL finished) {
            
        }];
    }
    else if (index == 2){
        currentlyEditingLabel.labelTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self performSelectorOnMainThread:@selector(btnTextPressed) withObject:self waitUntilDone:YES];
    }
    else if (index == 3){
        StickerViewController *stickerv=[[StickerViewController alloc]initWithNibName:@"StickerViewController" bundle:nil];
        stickerv.stickerindex = 0;
        stickerv.delegate=self;
        stickerv.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:stickerv animated:YES completion:nil];
    }
}
-(IBAction)cellbuttonPress:(UIButton *)sender
{
    btnindex = 1;
    cellindex = sender.tag;
    if (![self showInterAdWithCount:2]){
        [self openallViewWithIndex:sender.tag];
    }
}
-(IBAction)filterdonebtnpress:(id)sender
{
    [UIView animateWithDuration:Duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.FilterView.frame = CGRectMake(0, HEIGHT, WIDTH, IPAD ? IPADHeight : IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ? IPhoneHeight : XHeight);
    }completion:^(BOOL finished) {
        self.btmlbl.hidden = YES;
    }];
}
-(void)btnTextPressed
{
    if (currentlyEditingLabel!=nil)
    {
        [currentlyEditingLabel hideEditingHandles];
    }
    labelView = [[IQLabelView alloc] initWithFrame:CGRectMake((_insideSaveView.frame.size.width/2)-30, 50, 60, 50)];
    [labelView setDelegate:self];
    [labelView setShowsContentShadow:NO];
    [labelView setEnableMoveRestriction:NO];
    [labelView setFontName:@"Baskerville-BoldItalic"];
    [labelView setFontSize:21.0];
    
    [self.insideSaveView addSubview:labelView];
    [self.insideSaveView setUserInteractionEnabled:YES];
    
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
        [_insideSaveView addSubview:userResizableView];
    }
}
#pragma mark ZDStickerView delegate functions
-(void)hideAllCurrentEditingSticker
{
    for (ZDStickerView *sticker in _insideSaveView.subviews)
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

#pragma mark Frame Delegate
-(void)didReceiveDelegateWithINT:(int)myint
{
    int integ=myint+1;
    NSString *str;
    str=[NSString stringWithFormat:@"frame_%d.png",integ];
    _frameImageView.image = [UIImage imageNamed:str];
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
        [self openallViewWithIndex:cellindex];
    }
    else if (btnindex == 2){
        [self doneMethod];
    }
    btnindex = 0;
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    [AppDelObj createInterView];
}

#pragma mark Done Methods
-(void)doneMethod
{
    [currentlyEditingLabel hideEditingHandles];
    [self hideAllCurrentEditingSticker];
    ShareViewController *share=[[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    share.saveimage=[AppDelObj screenshotimageWithView:_saveView];
    share.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:share animated:YES completion:nil];
}
-(IBAction)donebtnpress:(id)sender
{
    btnindex = 2;
    if (AppDelObj.inter_View.isReady)
    {
        AppDelObj.inter_View.delegate = self;
        [AppDelObj.inter_View presentFromRootViewController:self];
    }
    else{
        [self doneMethod];
    }
}
-(IBAction)backbtnpress:(id)sender
{
    UIAlertController  *alert = [UIAlertController alertControllerWithTitle:APPLICATION_NAME
                                                                    message:@"Are you sure you want to remove all work ??"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
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
