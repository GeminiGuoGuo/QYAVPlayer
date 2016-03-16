//
//  AVController.m
//  avplayerdemo
//
//  Created by guoqingyang on 16/3/16.
//  Copyright © 2016年 guoqingyang. All rights reserved.
//

#import "AVController.h"
#import "QYAVPlayer.h"
#define kWidth  [[UIScreen mainScreen] bounds].size.width
#define kHeight  [[UIScreen mainScreen] bounds].size.height
@interface AVController ()

@end

@implementation AVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
        QYAVPlayer *p = [[QYAVPlayer alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) WithUrl:[NSURL URLWithString:@"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA"]];
        [self.view addSubview:p];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
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
