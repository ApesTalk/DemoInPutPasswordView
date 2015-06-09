//
//  ViewController.m
//  DemoInPutPasswordView
//
//  Created by lqcjdx on 15/6/9.
//  Copyright (c) 2015年 YL. All rights reserved.
//

#import "ViewController.h"
#import "LMPopInputPasswordView.h"

@interface ViewController ()<LMPopInputPassViewDelegate>
{
    LMPopInputPasswordView *popView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    
}

-(void)dealloc{
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInputView:(UIButton *)sender {
    _resultLabel.text = nil;
    popView = [[LMPopInputPasswordView alloc]init];
    popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, 50, 250, 150);
    popView.delegate = self;
    [popView pop];
}

#pragma mark ---LMPopInputPassViewDelegate
-(void)buttonClickedAtIndex:(NSUInteger)index withText:(NSString *)text
{
    NSLog(@"buttonIndex = %li password=%@",(long)index,text);
    if(index==1){
        if(text.length==0){
            NSLog(@"密码长度不正确");
        }else if(text.length<6){
            NSLog(@"密码长度不正确");
        }else{
            _resultLabel.text = text;
        }
    }
}

-(void)deviceOrientationDidChange:(NSObject*)sender{
    UIDevice* device = [sender valueForKey:@"object"];
    if(device.orientation==UIInterfaceOrientationLandscapeLeft||device.orientation==UIInterfaceOrientationLandscapeRight)
    {
        popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, 50, 250, 150);
    }
    else if(device.orientation==UIInterfaceOrientationPortrait||device.orientation==UIInterfaceOrientationPortraitUpsideDown)
    {
        popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, 50, 250, 150);
    }
}
@end
