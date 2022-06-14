//
//  FrameViewController.m
//  WaterfallPhotoFrame
//
//  Created by Tejas vaghasiya on 11/06/16.
//  Copyright © 2016 Tejas vaghasiya. All rights reserved.
//

#import "FrameViewController.h"

@interface FrameViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation FrameViewController
{
    int index;
    BOOL count;
    float y;
    
    NSMutableArray *thumbArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    _toplbl.backgroundColor = TopColor;
    _topView.backgroundColor = TopColor;
    
    if (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        _topView.frame = CGRectMake(0, 0, WIDTH, 45);
        _bannerView.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
        _collectionFrame.frame = CGRectMake(0, 50, WIDTH, HEIGHT-50-50);
    }
    else if (IPAD){
        _topView.frame = CGRectMake(0, 0, WIDTH, 80);
        _bannerView.frame = CGRectMake(0, HEIGHT-90, WIDTH, 90);
        _collectionFrame.frame = CGRectMake(0, 85, WIDTH, HEIGHT-85-90);
    }
    else{
        _topView.frame = CGRectMake(0, 30, WIDTH, 45);
        _bannerView.frame = CGRectMake(0, HEIGHT-60, WIDTH, 50);
        _collectionFrame.frame = CGRectMake(0, 80, WIDTH, HEIGHT-80-60);
    }
    
    self.collectionFrame.delegate=self;
    self.collectionFrame.dataSource=self;
    [self.collectionFrame registerNib:[UINib nibWithNibName:@"FrameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [AppDelObj loadBannerAds:_bannerView];
    _bannerView.delegate = self;
    
    thumbArray = [[NSMutableArray alloc]init];
    
    for (int i=1; i<=44; i++)
    {
        NSString *thumb = [NSString stringWithFormat:@"frame_thumb_%d.png",i];
        [thumbArray addObject:thumb];
    }

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mysize;
    if (IS_IPHONE_4 || IS_IPHONE_5)
    {
        mysize=CGSizeMake(93, 93);
    }
    else if (IS_IPHONE_6 || IS_IPHONE_X)
    {
        mysize=CGSizeMake(111, 111);
    }
    else if (IS_IPHONE_6_PLUS || IS_IPHONE_XS_MAX)
    {
        mysize=CGSizeMake(124,124);
    }
    else if (IPAD)
    {
        mysize = CGSizeMake(141,141);
    }
    else
    {
        mysize = CGSizeMake(70, 70);
    }
    return mysize;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return thumbArray.count;
}
-(FrameCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FrameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    cell.cellImage.image = [UIImage imageNamed:[thumbArray objectAtIndex:indexPath.row]];
    cell.cellImage.layer.borderColor = [UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1.0].CGColor;
    cell.cellImage.layer.borderWidth = 1.0;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    index = (int)indexPath.row;
    [self present];
}
-(void)present
{
    [_delegate didReceiveDelegateWithINT:index];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnBAckPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
