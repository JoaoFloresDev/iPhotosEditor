//
//  DidImageView.h
//  PIP Effects
//
//  Created by Escrow on 6/17/15.
//  Copyright (c) 2015 Escrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagnifierView.h"




typedef NS_ENUM(NSInteger, DrawingMode) {
    DrawingModeNone = 0,
    DrawingModePaint,
    DrawingModeErase,
};

@interface DidImageView : UIImageView
@property (nonatomic, strong) NSMutableArray *childpathArray;
@property (nonatomic, strong) NSMutableArray *parentArray;
@property (nonatomic, readwrite) DrawingMode drawingMode;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIImage * viewImage;
@property (nonatomic)CGFloat brushsize;
@property (nonatomic,retain) MagnifierView *loop;
-(void)undo;
@end
