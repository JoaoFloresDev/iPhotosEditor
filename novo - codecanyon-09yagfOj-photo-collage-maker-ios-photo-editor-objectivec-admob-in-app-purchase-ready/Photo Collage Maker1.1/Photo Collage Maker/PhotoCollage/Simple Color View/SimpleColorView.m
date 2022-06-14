//
//  SimpleColorView.m
//  Image_EditorAll
//
//  Created by Did on 23/01/15.
//  Copyright (c) 2015 Escrow. All rights reserved.
//

#import "SimpleColorView.h"
#import "AppDelegate.h"

@implementation SimpleColorView
@synthesize newcolor,oldcolor;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
     //   UIImage *imagecolor=[self imageFromColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgr.png"]]];
        mainview=[[UIView alloc]initWithFrame:CGRectMake(0, 30, WIDTH, HEIGHT-30)];
//        mainview.backgroundColor=[UIColor blackColor];
    
//        mainview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgr.png"]];
        [self addSubview:mainview];
        
        NSData* oldimageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"OldColor"];
        oldcolor = [UIImage imageWithData:oldimageData]; 
        
        NSData* newimageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewColor"];
        newcolor = [UIImage imageWithData:newimageData];
        
         CGRect colorRect=CGRectMake(0, 0, WIDTH, HEIGHT-150);
        _colorpickerview=[[NKOColorPickerView alloc]initWithFrame:colorRect color:[UIColor redColor] andDidChangeColorBlock:^(UIColor *color) {
            previewview.backgroundColor=color;
            
        }];
        [mainview addSubview:_colorpickerview];

        originalview=[[UIView alloc]initWithFrame:CGRectMake(WIDTH/2-70-20, HEIGHT-140, 70, 35)];
        originalview.backgroundColor=[UIColor  colorWithPatternImage:oldcolor];
        [mainview addSubview:originalview];
        
        
        previewview=[[UIView alloc]initWithFrame:CGRectMake((WIDTH-70)/2, HEIGHT-140, 70, 35)];
        previewview.backgroundColor=[UIColor colorWithPatternImage:newcolor];
        [mainview addSubview:previewview];
        
        
        UIButton *okbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        okbtn.frame=CGRectMake(WIDTH/2-120-20,HEIGHT-90 , 120, 45) ;
        [okbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [okbtn setTitle:@"OK" forState:UIControlStateNormal];
       // [okbtn setImage:[UIImage imageNamed:@"back_unpresed.png"] forState:UIControlStateNormal];
        //[okbtn setImage:[UIImage imageNamed:@"back_presed.png"] forState:UIControlStateHighlighted];
        [okbtn setBackgroundColor:[UIColor grayColor]];
        [okbtn addTarget:self action:@selector(okbtnaction) forControlEvents:UIControlEventTouchUpInside];
        
        [mainview addSubview:okbtn];
        
        
        UIButton *cancelbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelbtn.frame=CGRectMake(WIDTH/2+20,HEIGHT-90 , 120, 45) ;
        [cancelbtn setTitle:@"Cancel" forState:UIControlStateNormal];
     //   [cancelbtn setImage:[UIImage imageNamed:@"back_unpresed.png"] forState:UIControlStateNormal];
      //  [cancelbtn setImage:[UIImage imageNamed:@"back_presed.png"] forState:UIControlStateHighlighted];
        [cancelbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelbtn setBackgroundColor:[UIColor grayColor]];
        [cancelbtn addTarget:self action:@selector(cancelbtnaction) forControlEvents:UIControlEventTouchUpInside];
        
        [mainview addSubview:cancelbtn];


    
    }
    return self;
}
-(void)okbtnaction
{
    
    newcolor=[self imageFromColor:previewview.backgroundColor];
    oldcolor=[self imageFromColor:previewview.backgroundColor];
    
    if([_delegate respondsToSelector:@selector(simplecolrViewReciveColor:andOldcolor:)])
        [_delegate simplecolrViewReciveColor:newcolor andOldcolor:oldcolor];

    self.hidden=YES;

   // [self removeFromSuperview];
   // self.hidden=YES;
}
-(void)cancelbtnaction
{
   // [self removeFromSuperview];
    self.hidden=YES;
}
- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, WIDTH, HEIGHT-100);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
