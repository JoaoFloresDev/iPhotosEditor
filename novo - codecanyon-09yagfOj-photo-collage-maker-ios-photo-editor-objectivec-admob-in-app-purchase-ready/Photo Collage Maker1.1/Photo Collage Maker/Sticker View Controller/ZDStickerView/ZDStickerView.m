//
// ZDStickerView.m
//
// Created by Seonghyun Kim on 5/29/13.
// Copyright (c) 2013 scipi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ZDStickerView.h"
#import "SPGripViewBorderView.h"


#define kSPUserResizableViewGlobalInset 5.0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0
#define kZDStickerViewControlSize 30.0



@interface ZDStickerView ()

@property (nonatomic, strong) SPGripViewBorderView *borderView;

@property (strong, nonatomic) UIImageView *resizingControl;
@property (strong, nonatomic) UIImageView *deleteControl;
@property (strong, nonatomic) UIImageView *rotateControl;
@property (strong, nonatomic) UIImageView *flipControl;

@property (nonatomic) BOOL preventsLayoutWhileResizing;
@property (nonatomic) BOOL IsFlip;

@property (nonatomic) CGFloat deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;

@property (nonatomic) CGPoint touchStart;

@end



@implementation ZDStickerView

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
    // Drawing code
   }
 */

#ifdef ZDSTICKERVIEW_LONGPRESS
- (void)longPress:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidLongPressed:)])
        {
            [self.stickerViewDelegate stickerViewDidLongPressed:self];
        }
    }
}
#endif
- (void)tapForClose:(UIPanGestureRecognizer *)recognizer
{
    [self enableTransluceny:NO];
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCancelEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidCancelEditing:self];
    }
}


- (void)singleTap:(UIPanGestureRecognizer *)recognizer
{
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidClose:)])
    {
        [self.stickerViewDelegate stickerViewDidClose:self];
    }

    if (NO == self.preventsDeleting)
    {
        UIView *close = (UIView *)[recognizer view];
        [close.superview removeFromSuperview];
    }
}

- (void)flipTap:(UIPanGestureRecognizer *)recognizer
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
       {
           self->_IsHide = NO;
           [self showEditingHandles];
           if (!self->_IsFlip)
           {
               self->_IsFlip = YES;
               for (UIImageView *container in self.contentView.subviews)
               {
                   if ([container isKindOfClass:[UIImageView class]])
                   {
//                       NSLog(@"flip img ==> %@",container);
                       [container setImage:[UIImage imageWithCGImage:container.image.CGImage scale:container.image.scale orientation:UIImageOrientationUpMirrored]];
                   }
               }
           }
           else
           {
               self->_IsFlip = NO;
               for (UIImageView *container in self.contentView.subviews)
               {
                   if ([container isKindOfClass:[UIImageView class]])
                   {
//                       NSLog(@"flip img ==> %@",container);
                       [container setImage:[UIImage imageWithCGImage:container.image.CGImage scale:container.image.scale orientation:UIImageOrientationUp]];
                   }
               }
           }
       });
}


- (void)rotatePressed:(UIPanGestureRecognizer *)recognizer
{
    _IsHide = NO;
    [self showEditingHandles];
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        [self enableTransluceny:YES];
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        [self enableTransluceny:YES];
        
        if (self.bounds.size.width < self.minWidth || self.bounds.size.height < self.minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     self.minWidth+1,
                                     self.minHeight+1);
            self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,self.bounds.size.height-(kZDStickerViewControlSize-4),
                   kZDStickerViewControlSize,
               kZDStickerViewControlSize);
            self.deleteControl.frame = CGRectMake(-4, -4,kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.flipControl.frame =CGRectMake(self.bounds.size.width-(kZDStickerViewControlSize-4),-4,
                   kZDStickerViewControlSize,
                   kZDStickerViewControlSize);
            self.rotateControl.frame =CGRectMake(-4,self.bounds.size.height-(kZDStickerViewControlSize-4),
                 kZDStickerViewControlSize,
                 kZDStickerViewControlSize);
            
            self.prevPoint = [recognizer locationInView:self];
        }
        // Resizing
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            
            //        wChange = (point.x - self.prevPoint.x);
            wChange = (self.prevPoint.x - point.x);
            hChange = (self.prevPoint.y - point.y);
            
            hChange = (point.y - self.prevPoint.y);
            
            //        float wRatioChange = (wChange/(float)self.bounds.size.width);
            //
            //        hChange = wRatioChange * self.bounds.size.height;
            
            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
            {
                self.prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,self.bounds.size.width + (wChange),self.bounds.size.height + (hChange));
            self.resizingControl.frame =CGRectMake(self.bounds.size.width-(kZDStickerViewControlSize-4),
                                                   self.bounds.size.height-kZDStickerViewControlSize,
                                                   kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.deleteControl.frame = CGRectMake(-4, -4,
                                                  kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.flipControl.frame =CGRectMake(self.bounds.size.width-(kZDStickerViewControlSize-4),-4,       kZDStickerViewControlSize,     kZDStickerViewControlSize);
            self.rotateControl.frame =CGRectMake(-4,self.bounds.size.height-(kZDStickerViewControlSize-4),
                                                 kZDStickerViewControlSize,
                                                 kZDStickerViewControlSize);
            
            self.prevPoint = [recognizer locationOfTouch:0 inView:self];
            
            self.borderView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset);
            [self.borderView setNeedsDisplay];
            
            [self setNeedsDisplay];
        }
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        [self enableTransluceny:NO];
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}


- (void)pinchTranslate:(UIPinchGestureRecognizer *)recognizer
{
//    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
//    recognizer.scale = 1;
}

- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    _IsHide = NO;
    [self showEditingHandles];
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        [self enableTransluceny:YES];
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        [self enableTransluceny:YES];
        
        // preventing from the picture being shrinked too far by resizing
        if (self.bounds.size.width < self.minWidth || self.bounds.size.height < self.minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     self.minWidth+1,
                                     self.minHeight+1);
            self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
               self.bounds.size.height-(kZDStickerViewControlSize-4),
                   kZDStickerViewControlSize,
                   kZDStickerViewControlSize);
            self.deleteControl.frame = CGRectMake(-4, -4,
                  kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.flipControl.frame =CGRectMake(self.bounds.size.width-(kZDStickerViewControlSize-4),-4,
                 kZDStickerViewControlSize,
                 kZDStickerViewControlSize);
            self.rotateControl.frame =CGRectMake(-4,self.bounds.size.height-(kZDStickerViewControlSize-4),
               kZDStickerViewControlSize,
               kZDStickerViewControlSize);
            
            self.prevPoint = [recognizer locationInView:self];
        }
        // Resizing
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;

            wChange = (point.x - self.prevPoint.x);
            float wRatioChange = (wChange/(float)self.bounds.size.width);

            hChange = wRatioChange * self.bounds.size.height;

            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
            {
                self.prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }

            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,self.bounds.size.width + (wChange),self.bounds.size.height + (hChange));
            self.resizingControl.frame =CGRectMake(self.bounds.size.width-(kZDStickerViewControlSize-4),
               self.bounds.size.height-(kZDStickerViewControlSize-4),
                   kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.deleteControl.frame = CGRectMake(-4, -4,
              kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.flipControl.frame =CGRectMake(self.bounds.size.width-(kZDStickerViewControlSize-4),-4,       kZDStickerViewControlSize,     kZDStickerViewControlSize);
            self.rotateControl.frame =CGRectMake(-4,self.bounds.size.height-(kZDStickerViewControlSize-4),
                 kZDStickerViewControlSize,
                 kZDStickerViewControlSize);

            self.prevPoint = [recognizer locationOfTouch:0 inView:self];
        }

        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x);

        float angleDiff = self.deltaAngle - ang;

        if (NO == self.preventsResizing)
        {
            self.transform = CGAffineTransformMakeRotation(-angleDiff);
        }

        self.borderView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset);
     
        [self.borderView setNeedsDisplay];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        [self enableTransluceny:NO];
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}



- (void)setupDefaultAttributes
{
    self.borderView = [[SPGripViewBorderView alloc] initWithFrame:CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset)];
    [self.borderView setHidden:YES];
    [self addSubview:self.borderView];

    if (kSPUserResizableViewDefaultMinWidth > self.bounds.size.width*0.5)
    {
        self.minWidth = kSPUserResizableViewDefaultMinWidth;
        self.minHeight = self.bounds.size.height * (kSPUserResizableViewDefaultMinWidth/self.bounds.size.width);
    }
    else
    {
        self.minWidth = self.bounds.size.width*0.5;
        self.minHeight = self.bounds.size.height*0.5;
    }

    self.preventsPositionOutsideSuperview = YES;
    self.preventsLayoutWhileResizing = YES;
    self.preventsResizing = NO;
    self.preventsDeleting = NO;
    self.preventsCustomButton = YES;
    self.translucencySticker = YES;

    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(tapForClose:)];
    [self addGestureRecognizer:closeTap];

    
#ifdef ZDSTICKERVIEW_LONGPRESS
    UILongPressGestureRecognizer*longpress = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self
                                                      action:@selector(longPress:)];
    [self addGestureRecognizer:longpress];
#endif

    self.deleteControl = [[UIImageView alloc]initWithFrame:CGRectMake(-4, -4,
      kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.deleteControl.backgroundColor = [UIColor clearColor];
    self.deleteControl.image = [UIImage imageNamed:@"Sticker_Close.png"];
    self.deleteControl.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
         initWithTarget:self
     action:@selector(singleTap:)];
    [self.deleteControl addGestureRecognizer:singleTap];
    [self addSubview:self.deleteControl];

    
    self.flipControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-(kZDStickerViewControlSize-4), -4,
      kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.flipControl.backgroundColor = [UIColor clearColor];
    self.flipControl.image = [UIImage imageNamed:@"Sticker_Flip.png"];
    self.flipControl.userInteractionEnabled = YES;
    UITapGestureRecognizer *flipTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipTap:)];
    [self.flipControl addGestureRecognizer:flipTap];
    [self addSubview:self.flipControl];
    
    
    
    self.resizingControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-(kZDStickerViewControlSize-4),self.frame.size.height-(kZDStickerViewControlSize-4),kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.resizingControl.backgroundColor = [UIColor clearColor];
    self.resizingControl.userInteractionEnabled = YES;
    self.resizingControl.image = [UIImage imageNamed:@"Sticker_Rotate.png"];
    UIPanGestureRecognizer*panResizeGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(resizeTranslate:)];
    [self.resizingControl addGestureRecognizer:panResizeGesture];
    [self addSubview:self.resizingControl];
    
    
    self.rotateControl = [[UIImageView alloc]initWithFrame:CGRectMake(-4,self.frame.size.height-(kZDStickerViewControlSize-4), kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.rotateControl.backgroundColor = [UIColor clearColor];
    self.rotateControl.userInteractionEnabled = YES;
    self.rotateControl.image = [UIImage imageNamed:@"Sticker_Resize.png"];
    UIPanGestureRecognizer *rotateGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(rotatePressed:)];
    [self.rotateControl addGestureRecognizer:rotateGesture];
    [self addSubview:self.rotateControl];

    self.deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,self.frame.origin.x+self.frame.size.width - self.center.x);
    
    
}



- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setupDefaultAttributes];
    }

    return self;
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setupDefaultAttributes];
    }

    return self;
}



- (void)setContentView:(UIView *)newContentView
{
    [self.contentView removeFromSuperview];
    _contentView = newContentView;

    self.contentView.frame = CGRectInset(self.bounds,
     kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2,
     kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self addSubview:self.contentView];

    for (UIView *subview in [self.contentView subviews])
    {
        [subview setFrame:CGRectMake(0, 0,
         self.contentView.frame.size.width,
         self.contentView.frame.size.height)];

        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    [self bringSubviewToFront:self.borderView];
    [self bringSubviewToFront:self.resizingControl];
    [self bringSubviewToFront:self.rotateControl];
    [self bringSubviewToFront:self.deleteControl];
    [self bringSubviewToFront:self.flipControl];
}



- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    self.contentView.frame = CGRectInset(self.bounds,
     kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2,
     kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    for (UIView *subview in [self.contentView subviews])
    {
        [subview setFrame:CGRectMake(0, 0,self.contentView.frame.size.width,
             self.contentView.frame.size.height)];

        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    self.borderView.frame = CGRectInset(self.bounds,
            kSPUserResizableViewGlobalInset,
            kSPUserResizableViewGlobalInset);

    self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,self.bounds.size.height-(kZDStickerViewControlSize-4),kZDStickerViewControlSize,
           kZDStickerViewControlSize);

    self.deleteControl.frame = CGRectMake(-4, -4,kZDStickerViewControlSize, kZDStickerViewControlSize);

    self.flipControl.frame =CGRectMake(self.bounds.size.width-(kZDStickerViewControlSize-4),-4,kZDStickerViewControlSize,kZDStickerViewControlSize);

    self.rotateControl = [[UIImageView alloc]initWithFrame:CGRectMake(-4,self.bounds.size.height-(kZDStickerViewControlSize-4), kZDStickerViewControlSize,kZDStickerViewControlSize)];

    
    [self.borderView setNeedsDisplay];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isEditingHandlesHidden])
    {
        return;
    }

    [self enableTransluceny:YES];

    UITouch *touch = [touches anyObject];
    self.touchStart = [touch locationInView:self.superview];
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidBeginEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidBeginEditing:self];
    }
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self enableTransluceny:NO];

    // Notify the delegate we've ended our editing session.
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidEndEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidEndEditing:self];
    }
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self enableTransluceny:NO];

    // Notify the delegate we've ended our editing session.
//    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCancelEditing:)])
//    {
//        [self.stickerViewDelegate stickerViewDidCancelEditing:self];
//    }
}



- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - self.touchStart.x,
                                    self.center.y + touchPoint.y - self.touchStart.y);

    if (self.preventsPositionOutsideSuperview)
    {
        // Ensure the translation won't cause the view to move offscreen.
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        if (newCenter.x > self.superview.bounds.size.width - midPointX)
        {
            newCenter.x = self.superview.bounds.size.width - midPointX;
        }

        if (newCenter.x < midPointX)
        {
            newCenter.x = midPointX;
        }

        CGFloat midPointY = CGRectGetMidY(self.bounds);
        if (newCenter.y > self.superview.bounds.size.height - midPointY)
        {
            newCenter.y = self.superview.bounds.size.height - midPointY;
        }

        if (newCenter.y < midPointY)
        {
            newCenter.y = midPointY;
        }
    }

    self.center = newCenter;
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isEditingHandlesHidden])
    {
        return;
    }

    [self enableTransluceny:YES];

    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.resizingControl.frame, touchLocation))
    {
        return;
    }

    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch];
    self.touchStart = touch;
}



- (void)hideDelHandle
{
    self.deleteControl.hidden = YES;
}



- (void)showDelHandle
{
    self.deleteControl.hidden = NO;
}


- (void)hideAllEditingHandles
{
    self.resizingControl.hidden = YES;
    self.rotateControl.hidden   = YES;
    self.deleteControl.hidden   = YES;
    self.flipControl.hidden     = YES;
    [self.borderView setHidden:YES];
}

- (void)hideEditingHandles
{
    if (!_IsHide)
    {
        _IsHide = YES;
        self.resizingControl.hidden = YES;
        self.rotateControl.hidden   = YES;
        self.deleteControl.hidden   = YES;
        self.flipControl.hidden     = YES;
        [self.borderView setHidden:YES];
    }
    else
    {
        _IsHide = NO;
        self.resizingControl.hidden = NO;
        self.rotateControl.hidden   = NO;
        self.deleteControl.hidden   = NO;
        self.flipControl.hidden     = NO;
        [self.borderView setHidden:NO];
    }
    
}



- (void)showEditingHandles
{
    self.resizingControl.hidden = NO;
    self.rotateControl.hidden   = NO;
    self.deleteControl.hidden   = NO;
    self.flipControl.hidden     = NO;
    [self.borderView setHidden:NO];
    [self layoutIfNeeded];
}



- (void)setButton:(ZDSTICKERVIEW_BUTTONS)type image:(UIImage*)image
{
    switch (type)
    {
        case ZDSTICKERVIEW_BUTTON_RESIZE:
            self.resizingControl.image = image;
            break;
        case ZDSTICKERVIEW_BUTTON_DEL:
            self.deleteControl.image = image;
            break;
        default:
            break;
    }
}



- (BOOL)isEditingHandlesHidden
{
    return self.borderView.hidden;
}



- (void)enableTransluceny:(BOOL)state
{
    if (self.translucencySticker == YES)
    {
        if (state == YES)
        {
            self.alpha = 0.65;
        }
        else
        {
            self.alpha = 1.0;
        }
    }
}



@end
