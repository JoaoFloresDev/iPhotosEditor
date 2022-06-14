//
//  DidImageFilters.m
//  DidImageFilters
//
//  Created by Escrow on 12/30/15.
//  Copyright © 2015 Escrow. All rights reserved.
//

#import "DidImageFilters.h"
#import "GPUImage.h"

@implementation DidImageFilters

-(UIImage *)BrightnessWithImage:(UIImage *)image Radius:(float)radius
{
    GPUImageBrightnessFilter *filter=[[GPUImageBrightnessFilter alloc]init];
    filter.brightness=radius;
    return [filter imageByFilteringImage:image];;
}
-(UIImage *)ContrastWithImage:(UIImage *)image Radius:(float)radius
{
    GPUImageContrastFilter *filter=[[GPUImageContrastFilter alloc]init];
    filter.contrast=radius;
    return [filter imageByFilteringImage:image];;
}
-(UIImage *)SaturationWithImage:(UIImage *)image Radius:(float)radius
{
    GPUImageSaturationFilter *filter=[[GPUImageSaturationFilter alloc]init];
    filter.saturation=radius;
    return [filter imageByFilteringImage:image];;
}
-(UIImage *)HueWithImage:(UIImage *)image Radius:(float)radius
{
    GPUImageExposureFilter *filter=[[GPUImageExposureFilter alloc]init];
    filter.exposure=radius;
    return [filter imageByFilteringImage:image];;
}

-(UIImage *)SepiaWithImage:(UIImage *)image
{
    GPUImageSepiaFilter *filter =[[GPUImageSepiaFilter alloc]init];
    return [filter imageByFilteringImage:image];;
}
-(UIImage *)GaussianBlurWithImage:(UIImage *)image AndRadius:(float)radius
{
    GPUImageGaussianBlurFilter *filter =[[GPUImageGaussianBlurFilter alloc]init];
    filter.blurRadiusInPixels=radius;
    
    return [filter imageByFilteringImage:image];;
}
-(UIImage *)GauusianDoubleBlur:(UIImage *)image AndRadius:(float)radius
{
    GPUImageGaussianBlurFilter *filter =[[GPUImageGaussianBlurFilter alloc]init];
    filter.blurRadiusInPixels=radius;
    
    GPUImageGaussianBlurFilter *afilter =[[GPUImageGaussianBlurFilter alloc]init];
    afilter.blurRadiusInPixels=radius;
     UIImage *img = [afilter imageByFilteringImage:[filter imageByFilteringImage:image]];
    
    return img;

}
-(UIImage *)BoxBlurWithImage:(UIImage *)image AndRadius:(float)radius
{
    GPUImageBoxBlurFilter *filter =[[GPUImageBoxBlurFilter alloc]init];
    filter.blurRadiusInPixels=radius;
    return [filter imageByFilteringImage:image];;
}
-(UIImage *)iOSBlurWithImage:(UIImage *)image AndRadius:(float)radius
{
    GPUImageiOSBlurFilter *filter =[[GPUImageiOSBlurFilter alloc]init];
    [filter setBlurRadiusInPixels:radius];
    UIImage *img=[filter imageByFilteringImage:image];
    return img;
}
-(UIImage *)PixellateWithImage:(UIImage *)image AndRadius:(float)radius
{
    GPUImagePixellateFilter *filter =[[GPUImagePixellateFilter alloc]init];
    filter.fractionalWidthOfAPixel=0.03;
    UIImage *img=[filter imageByFilteringImage:image];
    return img;
}
-(UIImage *)PolkaDotWithImage:(UIImage *)image
{
    GPUImagePolkaDotFilter *filter =[[GPUImagePolkaDotFilter alloc]init];
    UIImage *img=[filter imageByFilteringImage:image];
    return img;
}
-(UIImage *)SketchWithImage:(UIImage *)image
{
    GPUImageSketchFilter *filter =[[GPUImageSketchFilter alloc]init];
    UIImage *img=[filter imageByFilteringImage:image];
    return img;
}
-(UIImage *)ToonWithImage:(UIImage *)image
{
    GPUImageToonFilter *filter =[[GPUImageToonFilter alloc]init];
    filter.quantizationLevels=5;
    UIImage *img=[filter imageByFilteringImage:image];
    return img;
}
-(UIImage *)EmbossWithImage:(UIImage *)image
{
    GPUImageEmbossFilter *filter =[[GPUImageEmbossFilter alloc]init];
    UIImage *img=[filter imageByFilteringImage:image];
    return img;
}
-(UIImage *)PosterizeWithImage:(UIImage *)image
{
    GPUImageEmbossFilter *filter =[[GPUImageEmbossFilter alloc]init];
    UIImage *img=[filter imageByFilteringImage:image];
    return img;
}
-(UIImage *)KuwaharaWithImage:(UIImage *)image
{
    GPUImageKuwaharaFilter *filter =[[GPUImageKuwaharaFilter alloc]init];
    UIImage *img=[filter imageByFilteringImage:image];
    return img;
}
-(UIImage *)VigneteWithImage:(UIImage *)image
{
    GPUImageVignetteFilter *filter =[[GPUImageVignetteFilter alloc]init];
    UIImage *img=[filter imageByFilteringImage:image];
    return img;
}
- (UIImage *)BlackAndWhiteImage:(UIImage *)img
{
    CIImage *beginImage = [CIImage imageWithCGImage:img.CGImage];
    
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:img.scale orientation:img.imageOrientation];
    CGImageRelease(cgiimage);
    
    return newImage;
}
- (UIImage *)MonoBlackAndWhiteImage:(UIImage *)img
{
    CIImage *beginImage = [CIImage imageWithCGImage:img.CGImage];
    
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.6], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:img.scale orientation:img.imageOrientation];
    CGImageRelease(cgiimage);
    
    return newImage;
}
- (UIImage *)LaveMonoBlackAndWhiteImage:(UIImage *)img
{
    CIImage *beginImage = [CIImage imageWithCGImage:img.CGImage];
    
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.0], @"inputSaturation", [NSNumber numberWithFloat:1.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:1.0], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:img.scale orientation:img.imageOrientation];
    CGImageRelease(cgiimage);
    
    return newImage;
}
-(UIImage *)SepiaToneWithImage:(UIImage *)img
{
    CIImage *beginImage =[[CIImage alloc]initWithImage:img];
    
    CIContext * context=[CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", @0.8, nil];
    CIImage *outImage = [filter outputImage];
    
    CGImageRef cgimg=[context createCGImage:outImage fromRect:[outImage extent]];
    
    return [UIImage imageWithCGImage:cgimg];
    
}
-(UIImage *)LookupFilter:(UIImage *)img AndLookupImageName:(NSString *)lookupimgname
{
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:img];
    
    GPUImagePicture *lookupImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:lookupimgname]];
    
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
    [stillImageSource addTarget:lookupFilter];
    [lookupImageSource addTarget:lookupFilter];
    
    [lookupFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    [lookupImageSource processImage];
    
    UIImage *filteredimage = [lookupFilter imageFromCurrentFramebuffer];
    
    return filteredimage;
}
-(UIImage *)ApplyBlendFilterWithImage:(UIImage *)mainImage BlendImage:(UIImage *)blendimg
{
    GPUImagePicture *mainPicture = [[GPUImagePicture alloc] initWithImage:mainImage];
    GPUImagePicture *topPicture = [[GPUImagePicture alloc] initWithImage:blendimg];
    
    GPUImageOverlayBlendFilter *blendFilter = [[GPUImageOverlayBlendFilter alloc] init];
    
    
    [mainPicture addTarget:blendFilter];
    [topPicture addTarget:blendFilter];
    
    [blendFilter useNextFrameForImageCapture];
    [mainPicture processImage];
    [topPicture processImage];
    
    UIImage * mergedImage = [blendFilter imageFromCurrentFramebuffer];
    return mergedImage;
    
}

@end
