//
//  CropViewController.m
//  ShapeCrop
//
//  Created by escrow on 8/22/16.
//  Copyright © 2016 escrow. All rights reserved.
//

#import "CropViewController.h"

@interface CropViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGSize size;
    UIImage *finalImage;
    UIImage *tempImage;
    UIImage* _cropImage;
    int index;
    
    int allowed;
    
    CGFloat newwidth;
    CGFloat newheight;
    CGFloat newx;
    CGFloat newy;
    UIImageOrientation orientation;
    
    NSMutableArray *collectionImages;
    NSMutableArray *ShapeImage;
    
    float y;
//    NSMutableArray *borderImage;

}
@end

@implementation CropViewController


- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_IPHONE_XS_MAX || IS_IPHONE_X) {
        y = STATUSBARHEIGHT;
    }
    else{
        y = 0;
    }
    
    if (IPAD) {
        _topView.frame = CGRectMake(0, 0, WIDTH, 80);
        _btmView.frame = CGRectMake(0, HEIGHT-90, WIDTH, 90);
        _btmlbl.hidden = YES;
    }
    else if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        _topView.frame = CGRectMake(0, 0, WIDTH, 45);
        _btmView.frame = CGRectMake(0, HEIGHT-90, WIDTH, 90);
        _btmlbl.hidden = YES;
    }
    else{
        _topView.frame = CGRectMake(0, 30, WIDTH, 45);
        _btmView.frame = CGRectMake(0, HEIGHT-100, WIDTH, 90);
        _btmlbl.frame = CGRectMake(0, HEIGHT-10, WIDTH, 10);
    }
    
    _topView.backgroundColor = TopColor;
    _toplbl.backgroundColor = TopColor;
    _btmlbl.backgroundColor = BottomBGColor;
    _btmView.backgroundColor = BottomBGColor;
   
    index=0;
    allowed=0;
    
    size=CGSizeMake(320,320);
    
    orientation=_imageA.imageOrientation;
    
    _collectionShapes.delegate=self;
    _collectionShapes.dataSource=self;
    [_collectionShapes registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

    collectionImages =[[NSMutableArray alloc]init];
    ShapeImage = [[NSMutableArray alloc]init];
//    borderImage=[[NSMutableArray alloc]init];
    
    for (int i=1; i<=40; i++)
    {
        NSString *str=[NSString stringWithFormat:@"mask%d",i];
        [collectionImages addObject:str];
        
        NSString *str2=[NSString stringWithFormat:@"shape%d",i];
        [ShapeImage addObject:str2];
    }
    
    CGSize vidsize;
    vidsize=_imageA.size;
    
    CGFloat vWidth=vidsize.width+1;
    CGFloat vHeight=vidsize.height;
    CGFloat originalWidth=WIDTH;
    CGFloat originalHeight=HEIGHT-140;
    
    if(vWidth>vHeight)
    {
        newwidth=originalWidth;
        newheight=(int)(vHeight*originalWidth)/vWidth;
        newx=0;
        newy=(originalHeight-newheight)/2;
    }
    else{
        newheight=originalHeight;
        newwidth=(int)(vWidth*originalHeight)/vHeight;
        newy=0;
        newx=(originalWidth-newwidth)/2;
        if(newx<0)
        {
            newwidth=originalWidth;
            newheight=(int)(vHeight*originalWidth)/vWidth;
            newx=(originalWidth-newwidth)/2;
            newy=(originalHeight-newheight)/2;
        }
    }
    
    self.ViewA.frame=CGRectMake(newx, 45+newy+y, newwidth, newheight);
    
    _imageViewA.image = _imageA;
    tempImage=_imageA;
    
    _imgstickerimgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imagestickerview = [[CHTStickerView alloc] initWithContentView:_imgstickerimgview];
    _imagestickerview.frame = CGRectMake(100,100, 100, 100);
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return collectionImages.count;
}

-(MenuCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imgiew.backgroundColor = [UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0];
    cell.imgiew.image = [UIImage imageNamed:[collectionImages objectAtIndex:indexPath.row]];
   
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_imagestickerview removeFromSuperview];

    index=(int)indexPath.row;

    _imageB=[UIImage imageNamed:[ShapeImage objectAtIndex:indexPath.row]];
    _imageB=[self scaleImage:_imageB toSize:size];
    
    _imgstickerimgview.image=_imageB;
    _imgstickerimgview.contentMode=UIViewContentModeScaleAspectFit;
    
    _imagestickerview.delegate = self;
    _imagestickerview.outlineBorderColor = [UIColor blackColor];
    
    [_imagestickerview setImage:[UIImage imageNamed:@"strach"] forHandler:CHTStickerViewHandlerRotate];
    [_imagestickerview setHandlerSize:25];
    [self.ViewA addSubview:_imagestickerview];
    
    _selectedView=_imagestickerview;
    _selectedView.showEditingHandlers=YES;
}

-(void)_actionUse
{
    CGRect recta = _imagestickerview.frame;
    CGSize vidsize=_imageA.size;
    
    CGFloat videoWidth=(vidsize.width*recta.size.width)/newwidth;
    CGFloat videoHeight=(vidsize.height*recta.size.height)/newheight;
    
    CGFloat videox=(vidsize.width*recta.origin.x)/newwidth;
    CGFloat videoy=(vidsize.height*recta.origin.y)/newheight;
    
    _cropImage=[self cropImage:_imageA cropSize:CGRectMake(videox, videoy, videoWidth, videoHeight)];
    
    _cropImage=[self scaleImage:_cropImage toSize:size];
}

-(UIImage *) cropImage:(UIImage *)originalImage cropSize:(CGRect)mycropSize
{
    CGRect cropRect = CGRectMake(mycropSize.origin.x,mycropSize.origin.y, mycropSize.size.width, mycropSize.size.height);
    
    CGAffineTransform rectTransform;
    switch (originalImage.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI_2), 0, -originalImage.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI_2), -originalImage.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI), -originalImage.size.width, -originalImage.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, originalImage.scale, originalImage.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectApplyAffineTransform(cropRect, rectTransform));
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:originalImage.scale orientation:originalImage.imageOrientation];
    CGImageRelease(imageRef);

    UIGraphicsEndImageContext();
    
    return result;    
    result =  nil;
}


-(IBAction)done:(id)sender
{
    if(allowed==1)
    {
        [self _actionUse];
        
        [_imagestickerview removeFromSuperview];
        
        _cropImage =[self maskImage:_cropImage withMask:[UIImage imageNamed:[collectionImages objectAtIndex:index]]];
        _imageViewA.image=tempImage;
        
        _imageB=[self scaleImage:_imageB toSize:size];
        
        CGImageRef imageRef2 = CGImageCreateWithImageInRect([_cropImage CGImage], CGRectMake(0, 0, _cropImage.size.width, _cropImage.size.height));
        CGImageRef imageRef3 = CGImageCreateWithImageInRect([_imageB CGImage], CGRectMake(0, 0, size.width, size.height));
        
        UIImage *i1 =[UIImage imageWithCGImage:imageRef2];
        UIImage *i2=[UIImage imageWithCGImage:imageRef3];
        
        CGImageRelease(imageRef2);
        CGImageRelease(imageRef3);
        
        UIGraphicsBeginImageContextWithOptions(_cropImage.size, NO, 2.0);
        
        [i1 drawInRect: CGRectMake(0, 0, size.width, size.height)];
        [i2 drawInRect:CGRectMake(0, 0, size.width, size.height)];
        
        _cropImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [_delegate addItemViewControllerdidFinishEnteringItem:_cropImage];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Notification" message:@"Set Box on Image Properly" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 2.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize
{
    CGFloat scaleFactor = 1.0;
    if (image.size.width > targetSize.width || image.size.height > targetSize.height || image.size.width == image.size.height)
        if (!((scaleFactor = (targetSize.width / image.size.width)) > (targetSize.height / image.size.height)))            scaleFactor = targetSize.height / image.size.height;
    UIGraphicsBeginImageContext(targetSize);
    CGRect rect = CGRectMake((targetSize.width - image.size.width * scaleFactor) / 2,
                             (targetSize.height -  image.size.height * scaleFactor) / 2,
                             image.size.width * scaleFactor, image.size.height * scaleFactor);
    
    [image drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage)
{
    CGImageRef retVal = NULL;
    
    size_t width = CGImageGetWidth(sourceImage);
    size_t height = CGImageGetHeight(sourceImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,8,0,colorSpace,kCGImageAlphaPremultipliedFirst);
    if(offscreenContext != NULL)
    {
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        retVal = CGBitmapContextCreateImage(offscreenContext);
        CGContextRelease(offscreenContext);
    }
    CGColorSpaceRelease(colorSpace);
    return retVal;
}

-(UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    
    imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    
    CGImageRelease(mask);
    
    if (sourceImage != imageWithAlpha)
    {
        CGImageRelease(imageWithAlpha);
    }
    
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}

- (void)stickerViewDidChangeRotating:(CHTStickerView *)stickerView;
{
    stickerView.showEditingHandlers=YES;
    
    if(_imagestickerview.frame.origin.x < -15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 1");
    }
    else if (_imagestickerview.frame.origin.y < -15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 2");
    }
    else if ((_imagestickerview.frame.size.width + _imagestickerview.frame.origin.x) > _ViewA.frame.size.width+15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 3");
    }
    else if ((_imagestickerview.frame.size.height + _imagestickerview.frame.origin.y) > _ViewA.frame.size.height+15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 4");
    }
    else
    {
        allowed=1;
        _imagestickerview.outlineBorderColor=[UIColor greenColor];
        NSLog(@"Allow");
    }
}

- (void)setSelectedView:(CHTStickerView *)selectedView
{
    if (_selectedView != selectedView) {
        if (_selectedView) {
            _selectedView.showEditingHandlers = NO;
        }
        _selectedView = selectedView;
        if (_selectedView) {
            _selectedView.showEditingHandlers = YES;
            [_selectedView.superview bringSubviewToFront:_selectedView];
        }
    }
}

-(void)stickerViewDidEndMoving:(CHTStickerView *)stickerView
{
    if(_imagestickerview.frame.origin.x < -15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 1");
    }
    else if (_imagestickerview.frame.origin.y < -15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 2");
    }
    else if ((_imagestickerview.frame.size.width + _imagestickerview.frame.origin.x) > _ViewA.frame.size.width+15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 3");
    }
    else if ((_imagestickerview.frame.size.height + _imagestickerview.frame.origin.y) > _ViewA.frame.size.height+15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 4");
    }
    else
    {
        allowed=1;
        _imagestickerview.outlineBorderColor=[UIColor greenColor];
        NSLog(@"Allow");
    }
}

-(void)stickerViewDidEndRotating:(CHTStickerView *)stickerView
{
    if(_imagestickerview.frame.origin.x < -15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 1");
    }
    else if (_imagestickerview.frame.origin.y < -15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 2");
    }
    else if ((_imagestickerview.frame.size.width + _imagestickerview.frame.origin.x) > _ViewA.frame.size.width+15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 3");
    }
    else if ((_imagestickerview.frame.size.height + _imagestickerview.frame.origin.y) > _ViewA.frame.size.height+15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 4");
    }
    else
    {
        allowed=1;
        _imagestickerview.outlineBorderColor=[UIColor greenColor];
        NSLog(@"Allow");
    }
}

-(void)stickerViewDidText:(CHTStickerView *)stickerView
{
    
}

- (void)stickerViewDidBeginMoving:(CHTStickerView *)stickerView
{
    stickerView.showEditingHandlers=YES;
    self.selectedView = stickerView;
    
    if(_imagestickerview.frame.origin.x < -15)
    {
        allowed=0;
       _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 1");
    }
    else if (_imagestickerview.frame.origin.y < -15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 2");
    }
    else if ((_imagestickerview.frame.size.width + _imagestickerview.frame.origin.x) > _ViewA.frame.size.width+15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 3");
    }
    else if ((_imagestickerview.frame.size.height + _imagestickerview.frame.origin.y) > _ViewA.frame.size.height+15)
    {
        allowed=0;
        _imagestickerview.outlineBorderColor=[UIColor redColor];
        NSLog(@"============= 4");
    }
    else
    {
        allowed=1;
       _imagestickerview.outlineBorderColor=[UIColor greenColor];
        NSLog(@"Allow");
    }
}

-(void)stickerViewDidTap:(CHTStickerView *)stickerView
{
    stickerView.showEditingHandlers=YES;
    self.selectedView = stickerView;
}

-(void)stickerViewDidClose:(CHTStickerView *)stickerView
{
    _cropImage=nil;
    _imageA=nil;
    _imageB=nil;
    
    [_imagestickerview removeFromSuperview];
    _imageB=[UIImage imageNamed:@"1.png"];
    _imageViewA.image=tempImage;
    _imageA=tempImage;
    
    _imgstickerimgview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imgstickerimgview.image=_imageB;
    _imgstickerimgview.contentMode=UIViewContentModeScaleAspectFit;
    _imagestickerview = [[CHTStickerView alloc] initWithContentView:_imgstickerimgview];
    _imagestickerview.frame=CGRectMake(100,100, 100, 100);
    _imagestickerview.delegate = self;
    _imagestickerview.outlineBorderColor = [UIColor blackColor];
    
    [_imagestickerview setImage:[UIImage imageNamed:@"stratch_unpresed"] forHandler:CHTStickerViewHandlerRotate];
    [_imagestickerview setHandlerSize:25];
    
    [self.ViewA addSubview:_imagestickerview];
    
    _selectedView=_imagestickerview;
    _selectedView.showEditingHandlers=YES;
}

-(IBAction)btnBAck:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^
    {
         self->_cropImage=nil;
         self->_imageA=nil;
         self->_imageB=nil;
    }];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
