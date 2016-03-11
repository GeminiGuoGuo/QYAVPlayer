//
//  QYAVPlayer.h
//  avplayerdemo
//
//  Created by guoqingyang on 16/3/10.
//  Copyright © 2016年 guoqingyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYAVPlayer : UIView
-(instancetype)initWithFrame:(CGRect)frame WithUrl:(NSURL*)url;

-(void)play;
@end
