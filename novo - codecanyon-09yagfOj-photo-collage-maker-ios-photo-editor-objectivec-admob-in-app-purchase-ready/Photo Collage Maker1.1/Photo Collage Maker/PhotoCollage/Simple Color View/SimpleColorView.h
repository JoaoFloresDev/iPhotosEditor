//
//  SimpleColorView.h
//  Image_EditorAll
//
//  Created by Did on 23/01/15.
//  Copyright (c) 2015 Escrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKOColorPickerView.h"

@protocol SimpleColorViewDelegate;


@interface SimpleColorView : UIView
{
    UIView *mainview;
    UIView *originalview;
    UIView *previewview;
//    UIColor *oldcolor;
//    UIColor *newcolor;
}

@property (nonatomic,retain)NKOColorPickerView *colorpickerview;
@property (unsafe_unretained) id <SimpleColorViewDelegate> delegate;

@property (nonatomic,retain)UIImage *newcolor;
@property (nonatomic,retain)UIImage *oldcolor;

@end
@protocol SimpleColorViewDelegate <NSObject>
@optional
- (void)simplecolrViewReciveColor:(UIImage *)newcolor andOldcolor:(UIImage *)oldcolor;

@end
