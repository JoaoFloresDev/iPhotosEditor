//
//  DidImageView.m
//  PIP Effects
//
//  Created by Escrow on 6/17/15.
//  Copyright (c) 2015 Escrow. All rights reserved.
//

#import "DidImageView.h"

@interface DidImageView ()
{
    CGPoint previousPoint;
    CGPoint currentPoint;
    CGFloat currentZoomScale;
}
@end

@implementation DidImageView
@synthesize loop;
- (void)awakeFromNib
{
    [self initialize];
}

- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
}

#pragma mark - setter methods
- (void)setDrawingMode:(DrawingMode)drawingMode
{
    _drawingMode = drawingMode;
}

#pragma mark - Private methods
- (void)initialize
{
    currentZoomScale = 1.0;
    _childpathArray = [[NSMutableArray alloc]init];
    _parentArray = [[NSMutableArray alloc]init];
    
    currentPoint = CGPointMake(0, 0);
    previousPoint = currentPoint;
    _brushsize=8;
    _drawingMode = DrawingModeNone;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveZoomscale:)
                                                 name:@"hideMagnifier"
                                               object:nil];
//    _selectedColor = [UIColor blackColor];
}

- (void)eraseLine
{
    
//    dispatch_async(dispatch_get_main_queue(), ^{

    //      CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSoftLight);
    //    CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(0.1, -0.1),_brushsize);
    //    UIColor* shadow = UIColor.redColor;
    //    CGSize shadowOffset = CGSizeMake(0.1, -0.1);
    //    CGFloat shadowBlurRadius = 10;
    //
    //     CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, [shadow CGColor]);

    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:self.bounds];
    
    //above code was here
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _brushsize);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
//    [_childpathArray addObject:self.image];
    [self setNeedsDisplay];
//    });
}


//-(void)drawLineNew
//{
//    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
//    //    UIGraphicsBeginImageContext(self.bounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self.image drawInRect:self.bounds];
//    
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextSetLineWidth(context, _brushsize);
//    
//    
//    CGContextBeginPath(context);
//    
//        CGContextSetStrokeColorWithColor(context, self.selectedColor.CGColor);
//    CGContextSetBlendMode(context, kCGBlendModeColor);
//    
//    
//    CGContextMoveToPoint(context, previousPoint.x, previousPoint.y);
//    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
//    CGContextStrokePath(context);
//    
//    self.image  = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    previousPoint = currentPoint;
//    [self setNeedsDisplay];
//
//}


- (void)drawLineNew
{
//    dispatch_async(dispatch_get_main_queue(), ^{

    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.image drawInRect:self.bounds];
//    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSoftLight);
//    CGSize shadowOffset = CGSizeMake(0.1, -0.1);
//    CGFloat shadowBlurRadius = 10;
//    
//    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), shadowOffset, shadowBlurRadius, self.selectedColor.CGColor);
//    CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(0, 0),_brushsize);

    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _brushsize);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
//    });
}

- (void)drawRecty:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Shadows
    UIColor* shadow = UIColor.redColor;
    CGSize shadowOffset = CGSizeMake(0.1, -0.1);
    CGFloat shadowBlurRadius = 11;
    UIColor* shadow2 = UIColor.whiteColor; // Here you can adjust softness of inner shadow.
    CGSize shadow2Offset = CGSizeMake(0.1, -0.1);
    CGFloat shadow2BlurRadius = 9;
    
    // Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(59, 58, 439, 52) cornerRadius: 21];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, [shadow CGColor]);
    [UIColor.redColor setFill];
    [rectanglePath fill];
    
    // Rectangle Inner Shadow
    CGContextSaveGState(context);
    UIRectClip(rectanglePath.bounds);
    CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
    
    CGContextSetAlpha(context, CGColorGetAlpha([shadow2 CGColor]));
    CGContextBeginTransparencyLayer(context, NULL);
    {
        UIColor* opaqueShadow = [shadow2 colorWithAlphaComponent: 1];
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, [opaqueShadow CGColor]);
        CGContextSetBlendMode(context, kCGBlendModeSourceOut);
        CGContextBeginTransparencyLayer(context, NULL);
        
        [opaqueShadow setFill];
        [rectanglePath fill];
        
        CGContextEndTransparencyLayer(context);
    }
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    CGContextRestoreGState(context);
}


- (void)handleTouches
{
    if (self.drawingMode == DrawingModeNone) {
        // do nothing
    }
    else if (self.drawingMode == DrawingModePaint) {
        [self drawLineNew];
    }
    else
    {
        [self eraseLine];
        
    }
}

-(void)undo
{
    if(_parentArray.count > 0)
    {
        [_parentArray removeLastObject];
        
        [self setNeedsDisplay];
    }
    else{
        NSLog(@"no images to undo");
    }
}

#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint p = [[touches anyObject] locationInView:self];
    previousPoint = p;

    if(currentZoomScale > 1)
    {
        [loop hide];
    }
    else
    {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"touchesBegan"
         object:nil];
        
        if (loop == nil) {
            loop = [[MagnifierView alloc] init];
            loop.viewToMagnify = self;
            loop.followFinger = YES;
        }
        [loop show];
        
        UITouch *touch = [touches anyObject];
        loop.touchPoint = [touch locationInView:self];

    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
    
    [self handleTouches];
    
    NSString *st = NSStringFromCGPoint(currentPoint);
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"touchesMoved"
     object:st];
    
    if(currentZoomScale > 1)
    {
        [loop hide];
    }
    else
    {
        UITouch *touch = [touches anyObject];
        loop.touchPoint = [touch locationInView:self];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
   
    [self handleTouches];
//    [super touchesEnded:touches withEvent:event];
    // Posting notification from another object
    
   NSString *cPoint = NSStringFromCGPoint(currentPoint);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchesEnded"
                                                        object:cPoint];
    [loop hide];
//    [_parentArray addObject:_childpathArray];
 }

-(void)receiveZoomscale:(NSNotification *)notification
{
    currentZoomScale = [notification.object floatValue];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
