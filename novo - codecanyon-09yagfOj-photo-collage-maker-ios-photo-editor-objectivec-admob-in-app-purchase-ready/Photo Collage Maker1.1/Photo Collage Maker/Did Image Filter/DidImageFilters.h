//
//  DidImageFilters.h
//  DidImageFilters
//
//  Created by Escrow on 12/30/15.
//  Copyright © 2015 Escrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DidImageFilters : NSObject

-(UIImage *)SepiaWithImage:(UIImage *)image;
-(UIImage *)GaussianBlurWithImage:(UIImage *)image AndRadius:(float)radius;
-(UIImage *)BoxBlurWithImage:(UIImage *)image AndRadius:(float)radius;
-(UIImage *)iOSBlurWithImage:(UIImage *)image AndRadius:(float)radius;
-(UIImage *)PixellateWithImage:(UIImage *)image AndRadius:(float)radius;
-(UIImage *)PolkaDotWithImage:(UIImage *)image;
-(UIImage *)SketchWithImage:(UIImage *)image;
-(UIImage *)ToonWithImage:(UIImage *)image;
-(UIImage *)EmbossWithImage:(UIImage *)image;
-(UIImage *)PosterizeWithImage:(UIImage *)image;
-(UIImage *)KuwaharaWithImage:(UIImage *)image;
-(UIImage *)VigneteWithImage:(UIImage *)image;

- (UIImage *)BlackAndWhiteImage:(UIImage *)img;
- (UIImage *)MonoBlackAndWhiteImage:(UIImage *)img;
- (UIImage *)LaveMonoBlackAndWhiteImage:(UIImage *)img;
-(UIImage *)LookupFilter:(UIImage *)img AndLookupImageName:(NSString *)lookupimgname;
-(UIImage *)ApplyBlendFilterWithImage:(UIImage *)mainImage BlendImage:(UIImage *)blendimg;


-(UIImage *)GauusianDoubleBlur:(UIImage *)image AndRadius:(float)radius;

-(UIImage *)BrightnessWithImage:(UIImage *)image Radius:(float)radius;
-(UIImage *)ContrastWithImage:(UIImage *)image Radius:(float)radius;
-(UIImage *)SaturationWithImage:(UIImage *)image Radius:(float)radius;
-(UIImage *)HueWithImage:(UIImage *)image Radius:(float)radius;

@end
