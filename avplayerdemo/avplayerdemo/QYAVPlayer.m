//
//  QYAVPlayer.m
//  avplayerdemo
//
//  Created by guoqingyang on 16/3/10.
//  Copyright © 2016年 guoqingyang. All rights reserved.
//

#import "QYAVPlayer.h"
#import <AVFoundation/AVFoundation.h>
@interface QYAVPlayer ()
{
    NSURL *videlUrl;
    BOOL isHave;
    BOOL isPlay;
    UIView *controllView;
    UIProgressView *_progressView;
    UIButton *change;
}
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property(nonatomic,strong) UIButton *playBtn;
@property (nonatomic, assign) id periodicTimeObserver;
@property(nonatomic,strong)UISlider *slider;
@property(nonatomic,strong)UILabel *time;
@end

@implementation QYAVPlayer

-(instancetype)initWithFrame:(CGRect)frame WithUrl:(NSURL*)url{
    if (self = [super initWithFrame:frame]) {
        isHave = NO;
        videlUrl = url;
        [self drawPlayer];
        [self drawControllView];
        [self notifications];
        [self ViewTap];
    }
    return self;
}
-(void)ViewTap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenControllView)];
    [self addGestureRecognizer:tap];
}
-(void)hiddenControllView{
    if (controllView.isHidden==YES) {
        controllView.hidden = NO;
    }else{
        controllView.hidden = YES;
    }
}

-(void)drawControllView{
    UIView *bigview = [UIView new];
    bigview.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bigview];
    NSLayoutConstraint *topConstraint1 = [NSLayoutConstraint constraintWithItem:bigview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *leftConstraint1 = [NSLayoutConstraint constraintWithItem:bigview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *rightConstraint1 = [NSLayoutConstraint constraintWithItem:bigview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0.f];
    NSLayoutConstraint *bottomConstraint1 = [NSLayoutConstraint constraintWithItem:bigview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:-30];
    [self addConstraints:@[topConstraint1, leftConstraint1, rightConstraint1, bottomConstraint1]];

    controllView  = [UIView new];
    UITapGestureRecognizer *contap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap4conView)];
    [controllView addGestureRecognizer:contap];
    controllView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topToolConstraint = [NSLayoutConstraint constraintWithItem:controllView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bigview attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *leftToolConstraint = [NSLayoutConstraint constraintWithItem:controllView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:bigview attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *rightToolConstraint = [NSLayoutConstraint constraintWithItem:controllView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:bigview attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0.f];
    NSLayoutConstraint *bottomToolConstraint = [NSLayoutConstraint constraintWithItem:controllView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f];
    [self addConstraints:@[topToolConstraint, leftToolConstraint, rightToolConstraint, bottomToolConstraint]];
    controllView.hidden = YES;
    controllView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:controllView];
    [self playbtn];
}
//conviewTap
-(void)tap4conView{
    controllView.hidden = NO;
}

-(void)drawSlider{
    isHave = YES;
    self.slider = [[UISlider alloc]init];
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    self.slider.maximumTrackTintColor= [UIColor clearColor];
    self.slider.minimumTrackTintColor = [UIColor clearColor];
    CGFloat totalSecond = self.playerItem.duration.value / self.playerItem.duration.timescale;
    self.slider.maximumValue = totalSecond;
    _progressView = [[UIProgressView alloc]init];
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [controllView addSubview:_progressView];
    [controllView addSubview:_slider];
    [_slider setThumbImage:[UIImage imageNamed:@"player_slider"] forState:UIControlStateNormal];
    NSLayoutConstraint *topToolConstraint = [NSLayoutConstraint constraintWithItem:_slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeTop multiplier:1.0f constant:10];
    NSLayoutConstraint *leftToolConstraint = [NSLayoutConstraint constraintWithItem:_slider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.playBtn attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
    NSLayoutConstraint *rightToolConstraint = [NSLayoutConstraint constraintWithItem:_slider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeWidth multiplier:1 constant:-140];
    NSLayoutConstraint *bottomToolConstraint = [NSLayoutConstraint constraintWithItem:_slider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-10];
    [controllView addConstraints:@[topToolConstraint, leftToolConstraint, rightToolConstraint, bottomToolConstraint]];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self timelabel];
    __weak typeof(self) myself = self;
    _periodicTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time1) {
        CGFloat currentSecond = myself.playerItem.currentTime.value/myself.playerItem.currentTime.timescale;
        [myself.slider setValue:currentSecond animated:YES];
        //CGFloat currentSecond = _playerItem.currentTime.value/_playerItem.currentTime.timescale;// 计算当前在第几秒
        CGFloat totalSecond = _playerItem.duration.value / _playerItem.duration.timescale;// 转换成秒
        myself.time.text = [NSString stringWithFormat:@"%.@/%@",[myself transform:currentSecond],[myself transform:totalSecond]];
    }];
    NSLayoutConstraint *topToolConstraint1 = [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeTop multiplier:1.0f constant:14];
    NSLayoutConstraint *leftToolConstraint1 = [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.playBtn attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
    NSLayoutConstraint *rightToolConstraint1 = [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeWidth multiplier:1 constant:-140];
    NSLayoutConstraint *bottomToolConstraint1 = [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-14];
    [controllView addConstraints:@[topToolConstraint1, leftToolConstraint1, rightToolConstraint1, bottomToolConstraint1]];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}
-(NSString *)transform:(CGFloat)floatValue{
    NSString *result = @"--:--";
    NSInteger tmpM = (NSInteger)floatValue /60;
    NSInteger tmpS = (NSInteger)floatValue %60;
    result = [NSString stringWithFormat:@"%.2zd:%.2zd", tmpM, tmpS];
    return result;
}
-(void)sliderValueChanged:(UISlider *)sender{
    [self.player pause];
    self.time.text = [NSString stringWithFormat:@"%@/%@", [self transform:sender.value], [self transform:_playerItem.duration.value / _playerItem.duration.timescale]];
       __weak typeof(self) myself = self;
    if(sender.value == 0.000000) {
        [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [myself.player play];
        }];
    }else{
        CMTime changedTime = CMTimeMakeWithSeconds(sender.value, 1);
        [_player seekToTime:changedTime completionHandler:^(BOOL finished) {
                //[myself.player play];
        }];
        [self play];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    }
    
}

-(void)timelabel{
    self.time = [UILabel new];
    [controllView addSubview:self.time];
    self.time.text = @"--:--/--:--";
    self.time.font = [UIFont systemFontOfSize:10];
    self.time.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topToolConstraint = [NSLayoutConstraint constraintWithItem:self.time attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeTop multiplier:1.0f constant:10];
    NSLayoutConstraint *leftToolConstraint = [NSLayoutConstraint constraintWithItem:self.time attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_slider attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:10];
    NSLayoutConstraint *rightToolConstraint = [NSLayoutConstraint constraintWithItem:self.time attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-30];
    NSLayoutConstraint *bottomToolConstraint = [NSLayoutConstraint constraintWithItem:self.time attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-10];
    [controllView addConstraints:@[topToolConstraint, leftToolConstraint, rightToolConstraint, bottomToolConstraint]];
   // [self changebtn];//全屏按钮,暂没实现

}
-(void)changebtn{
    change = [UIButton buttonWithType:UIButtonTypeCustom];
    change.translatesAutoresizingMaskIntoConstraints = NO;
    [controllView addSubview:change];
    [change setBackgroundImage:[UIImage imageNamed:@"big"] forState:UIControlStateNormal];
    NSLayoutConstraint *topToolConstraint = [NSLayoutConstraint constraintWithItem:change attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeTop multiplier:1.0f constant:8];
    NSLayoutConstraint *leftToolConstraint = [NSLayoutConstraint constraintWithItem:change attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.time attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:8];
    NSLayoutConstraint *rightToolConstraint = [NSLayoutConstraint constraintWithItem:change attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-8];
    NSLayoutConstraint *bottomToolConstraint = [NSLayoutConstraint constraintWithItem:change attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-8];
    [controllView addConstraints:@[topToolConstraint, leftToolConstraint, rightToolConstraint, bottomToolConstraint]];

}
-(void)playbtn{
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [controllView addSubview:self.playBtn];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    NSLayoutConstraint *topToolConstraint = [NSLayoutConstraint constraintWithItem:self.playBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeTop multiplier:1.0f constant:5];
    NSLayoutConstraint *leftToolConstraint = [NSLayoutConstraint constraintWithItem:self.playBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:5];
    NSLayoutConstraint *rightToolConstraint = [NSLayoutConstraint constraintWithItem:self.playBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeWidth multiplier:0 constant:20];
    NSLayoutConstraint *bottomToolConstraint = [NSLayoutConstraint constraintWithItem:self.playBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:controllView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-5];
    [controllView addConstraints:@[topToolConstraint, leftToolConstraint, rightToolConstraint, bottomToolConstraint]];
    [self.playBtn addTarget:self action:@selector(playOrStop) forControlEvents:UIControlEventTouchDown];
}

-(void)drawPlayer{
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.bounds;
    [self.layer addSublayer:self.playerLayer];
}
//懒加载
-(AVPlayer*)player{
    if (_player==nil) {
        self.playerItem = [[AVPlayerItem alloc]initWithURL:videlUrl];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviewEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        _player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    }
    return _player;
}
//视频结束
-(void)moviewEnd:(NSNotification *)notification {
    __weak typeof(self) myself = self;
    [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [_slider setValue:0.0 animated:YES];
        [myself.playBtn setBackgroundImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        isPlay = NO;
    }];
}

#pragma mark-KVO-
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        /**
         *     AVPlayerItemStatusUnknown,播放源未知
         *     AVPlayerItemStatusReadyToPlay,播放源准备好
         *     AVPlayerItemStatusFailed播放源失败
         */
        if ([change[@"new"] isEqual:@(AVPlayerItemStatusReadyToPlay)]) {
            //播放源可用
            [UIView animateWithDuration:0.3 animations:^{
                controllView.hidden = NO;
            }];
            if (!isHave) {
                [self drawSlider];
            }
            [self play];
        } else {
            //播放源不可用
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *loadedTimeRanges = _player.currentItem.loadedTimeRanges;
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval timeInterval = startSeconds + durationSeconds;
        CMTime duration = _playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        _progressView.progress = (CGFloat)(timeInterval /totalDuration) > _progressView.progress?(CGFloat)(timeInterval /totalDuration):_progressView.progress;
    }

}
//播放
-(void)play{
    if (_player) {
        [self.player play];
        isPlay = YES;
    }
}
//播放按钮
-(void)playOrStop{
    if (isPlay == YES) {
        [self.player pause];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        isPlay = NO;
    }else{
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
        [self play];
    }
}
#pragma mark-转屏-
-(void)notifications{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)deviceOrientationDidChange:(NSNotification *)sender{
    //    UIDeviceOrientationUnknown,
    //    UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
    //    UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
    //    UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
    //    UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
    //    UIDeviceOrientationFaceUp,              // Device oriented flat, face up
    //    UIDeviceOrientationFaceDown
    UIDevice *device = sender.object;
    if (device.orientation == (UIDeviceOrientationPortraitUpsideDown)) {
        
    } else {
        [self removeFromSuperview];
        self.frame = (CGRect){0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height};
        UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
        [mainWindow addSubview:self];
        [mainWindow bringSubviewToFront:self];
        _playerLayer.frame = self.bounds;
    }
}
//获取当前控制器
- (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}
#pragma mark - dealloc
-(void)dealloc{
    [_playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    [_player removeTimeObserver:_periodicTimeObserver];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
