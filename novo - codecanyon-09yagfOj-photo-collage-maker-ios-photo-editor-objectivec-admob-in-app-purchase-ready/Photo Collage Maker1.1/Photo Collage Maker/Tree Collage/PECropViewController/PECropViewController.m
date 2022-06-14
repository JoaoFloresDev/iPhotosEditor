//
//  PECropViewController.m
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "PECropViewController.h"
#import "PECropView.h"

@interface PECropViewController () <UIActionSheetDelegate>

@property (nonatomic) PECropView *cropView;
@property (nonatomic) UIActionSheet *actionSheet;

- (void)commonInit;

@end

@implementation PECropViewController
@synthesize rotationEnabled = _rotationEnabled;

+ (NSBundle *)bundle
{
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"PEPhotoCropEditor" withExtension:@"bundle"];
        bundle = [[NSBundle alloc] initWithURL:bundleURL];
    });
    
    return bundle;
}

static inline NSString *PELocalizedString(NSString *key, NSString *comment)
{
    return [[PECropViewController bundle] localizedStringForKey:key value:nil table:@"Localizable"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.rotationEnabled = YES;
}

#pragma mark -

- (void)loadView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
    
    self.cropView = [[PECropView alloc] initWithFrame:contentView.bounds];
    [contentView addSubview:self.cropView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *headerlbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 45)];
    headerlbl.backgroundColor = TopColor;
    headerlbl.text = @"";
    [self.view addSubview:headerlbl];
    
    UIView *topView = [[UIView alloc]init];
    if (IPAD) {
        topView.frame = CGRectMake(0, 0, WIDTH, 80);
    }
    else if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        topView.frame = CGRectMake(0, 0, WIDTH, 45);
    }
    else{
        topView.frame = CGRectMake(0, 30, WIDTH, 45);
    }
    topView.backgroundColor = TopColor;
    [self.view addSubview:topView];
    
    
    UILabel *toplabel=[[UILabel alloc]init];
    if (IPAD) {
        toplabel.frame = CGRectMake(0, 0, WIDTH, 80);
    }
//    else if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
//        toplabel.frame = CGRectMake(0, 0, Width, 45);
//    }
    else{
        toplabel.frame = CGRectMake(0, 0, WIDTH, 45);
    }
    toplabel.backgroundColor=TopColor;
    
    toplabel.text=@"Crop";
    toplabel.textColor=[UIColor whiteColor];
    toplabel.font=[UIFont fontWithName:@"AvenirLTStd-Heavy" size:20.0];
    toplabel.textAlignment=NSTextAlignmentCenter;
    [topView addSubview:toplabel];
    
    _backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if (IPAD) {
        _backbtn.frame=CGRectMake(5, 7, 30,30);
    }
    else{
        _backbtn.frame=CGRectMake(5, 7, 30,30);
    }
    
    [_backbtn setImage:[UIImage imageNamed:@"back_unpresed.png"] forState:UIControlStateNormal];
    [_backbtn setImage:[UIImage imageNamed:@"back_presed.png"] forState:UIControlStateHighlighted];
    [_backbtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_backbtn];
    
    _donebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if (IPAD) {
        _donebtn.frame=CGRectMake(WIDTH-70,17, 70,45);
    }
    else{
        _donebtn.frame=CGRectMake(WIDTH-70,0, 70,45);
    }
    
    _donebtn.titleLabel.textColor=[UIColor whiteColor];
    _donebtn.titleLabel.font=[UIFont fontWithName:@"AvenirLTStd-Heavy" size:17.0];
    //    [_donebtn setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    [_donebtn setTitle:@"Done" forState:UIControlStateNormal];
    [_donebtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_donebtn];
    
    
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.toolbar.translucent = NO;
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                          target:self
//                                                                                          action:@selector(cancel:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                                                                           target:self
//                                                                                           action:@selector(done:)];
//
//    if (!self.toolbarItems) {
//        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                                       target:nil
//                                                                                       action:nil];
//        UIBarButtonItem *constrainButton = [[UIBarButtonItem alloc] initWithTitle:PELocalizedString(@"Constrain", nil)
//                                                                            style:UIBarButtonItemStyleBordered
//                                                                           target:self
//                                                                           action:@selector(constrain:)];
//        self.toolbarItems = @[flexibleSpace, constrainButton, flexibleSpace];
//    }
//    self.navigationController.toolbarHidden = self.toolbarHidden;
    
    
    
    self.cropView.cropAspectRatio = 1.0f;
    self.cropView.image = self.image;
    
//    self.cropView.rotationGestureRecognizer.enabled = _rotationEnabled;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.cropAspectRatio != 0) {
        self.cropAspectRatio = self.cropAspectRatio;
    }
    if (!CGRectEqualToRect(self.cropRect, CGRectZero)) {
        self.cropRect = self.cropRect;
    }
    if (!CGRectEqualToRect(self.imageCropRect, CGRectZero)) {
        self.imageCropRect = self.imageCropRect;
    }
    
    self.keepingCropAspectRatio = self.keepingCropAspectRatio;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark -

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.cropView.image = image;
}

- (void)setKeepingCropAspectRatio:(BOOL)keepingCropAspectRatio
{
    _keepingCropAspectRatio = keepingCropAspectRatio;
    self.cropView.keepingCropAspectRatio = self.keepingCropAspectRatio;
}

- (void)setCropAspectRatio:(CGFloat)cropAspectRatio
{
    _cropAspectRatio = cropAspectRatio;
    self.cropView.cropAspectRatio = self.cropAspectRatio;
}

- (void)setCropRect:(CGRect)cropRect
{
    _cropRect = cropRect;
    _imageCropRect = CGRectZero;
    
    CGRect cropViewCropRect = self.cropView.cropRect;
    cropViewCropRect.origin.x += cropRect.origin.x;
    cropViewCropRect.origin.y += cropRect.origin.y;
    
    CGSize size = CGSizeMake(fminf(CGRectGetMaxX(cropViewCropRect) - CGRectGetMinX(cropViewCropRect), CGRectGetWidth(cropRect)),
                             fminf(CGRectGetMaxY(cropViewCropRect) - CGRectGetMinY(cropViewCropRect), CGRectGetHeight(cropRect)));
    cropViewCropRect.size = size;
    self.cropView.cropRect = cropViewCropRect;
}

- (void)setImageCropRect:(CGRect)imageCropRect
{
    _imageCropRect = imageCropRect;
    _cropRect = CGRectZero;
    
    self.cropView.imageCropRect = imageCropRect;
}

- (BOOL)isRotationEnabled
{
    return _rotationEnabled;
}

- (void)setRotationEnabled:(BOOL)rotationEnabled
{
    _rotationEnabled = rotationEnabled;
    self.cropView.rotationGestureRecognizer.enabled = _rotationEnabled;
}

- (CGAffineTransform)rotationTransform
{
    return self.cropView.rotation;
}

- (CGRect)zoomedCropRect
{
    return self.cropView.zoomedCropRect;
}

- (void)resetCropRect
{
    [self.cropView resetCropRect];
}

- (void)resetCropRectAnimated:(BOOL)animated
{
    [self.cropView resetCropRectAnimated:animated];
}

#pragma mark -

- (void)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewControllerDidCancel:)]) {
        [self.delegate cropViewControllerDidCancel:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:transform:cropRect:)])
    {
        [self.delegate cropViewController:self didFinishCroppingImage:self.cropView.croppedImage transform: self.cropView.rotation cropRect: self.cropView.zoomedCropRect];
    } else if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:)])
    {
        [self.delegate cropViewController:self didFinishCroppingImage:self.cropView.croppedImage];
    }
}

- (void)constrain:(id)sender
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:PELocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:
                        PELocalizedString(@"Original", nil),
                        PELocalizedString(@"Square", nil),
                        PELocalizedString(@"3 x 2", nil),
                        PELocalizedString(@"3 x 5", nil),
                        PELocalizedString(@"4 x 3", nil),
                        PELocalizedString(@"4 x 6", nil),
                        PELocalizedString(@"5 x 7", nil),
                        PELocalizedString(@"8 x 10", nil),
                        PELocalizedString(@"16 x 9", nil), nil];
    [self.actionSheet showFromToolbar:self.navigationController.toolbar];
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CGRect cropRect = self.cropView.cropRect;
        CGSize size = self.cropView.image.size;
        CGFloat width = size.width;
        CGFloat height = size.height;
        CGFloat ratio;
        if (width < height) {
            ratio = width / height;
            cropRect.size = CGSizeMake(CGRectGetHeight(cropRect) * ratio, CGRectGetHeight(cropRect));
        } else {
            ratio = height / width;
            cropRect.size = CGSizeMake(CGRectGetWidth(cropRect), CGRectGetWidth(cropRect) * ratio);
        }
        self.cropView.cropRect = cropRect;
    } else if (buttonIndex == 1) {
        self.cropView.cropAspectRatio = 1.0f;
    } else if (buttonIndex == 2) {
        self.cropView.cropAspectRatio = 2.0f / 3.0f;
    } else if (buttonIndex == 3) {
        self.cropView.cropAspectRatio = 3.0f / 5.0f;
    } else if (buttonIndex == 4) {
        CGFloat ratio = 3.0f / 4.0f;
        CGRect cropRect = self.cropView.cropRect;
        CGFloat width = CGRectGetWidth(cropRect);
        cropRect.size = CGSizeMake(width, width * ratio);
        self.cropView.cropRect = cropRect;
    } else if (buttonIndex == 5) {
        self.cropView.cropAspectRatio = 4.0f / 6.0f;
    } else if (buttonIndex == 6) {
        self.cropView.cropAspectRatio = 5.0f / 7.0f;
    } else if (buttonIndex == 7) {
        self.cropView.cropAspectRatio = 8.0f / 10.0f;
    } else if (buttonIndex == 8) {
        CGFloat ratio = 9.0f / 16.0f;
        CGRect cropRect = self.cropView.cropRect;
        CGFloat width = CGRectGetWidth(cropRect);
        cropRect.size = CGSizeMake(width, width * ratio);
        self.cropView.cropRect = cropRect;
    }
}

@end
