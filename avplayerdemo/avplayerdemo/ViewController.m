//
//  ViewController.m
//  avplayerdemo
//
//  Created by guoqingyang on 16/3/9.
//  Copyright © 2016年 guoqingyang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QYAVPlayer.h"

#define kWidth  [[UIScreen mainScreen] bounds].size.width
#define kHeight  [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()
@property(nonatomic,strong)NSURL *videoUrl;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property(nonatomic,strong)UIView *bigView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
//    
//    self.videoUrl = [NSURL URLWithString:@"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA"];
//    self.playerItem = [[AVPlayerItem alloc]initWithURL:self.videoUrl];
//    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
//    
//    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    self.playerLayer.frame = self.view.bounds;
//    [self.view.layer addSublayer:self.playerLayer];
    
    
    QYAVPlayer *p = [[QYAVPlayer alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) WithUrl:[NSURL URLWithString:@"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA"]];
    [self.view addSubview:p];
    
    

    
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"status"]) {
//        if ([change[@"new"] isEqual:@(AVPlayerItemStatusReadyToPlay)]) {
//            [self.player play];
//        }
//    
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
