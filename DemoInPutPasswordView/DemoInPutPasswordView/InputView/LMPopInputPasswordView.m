//
//  YLPopInputPasswordView.m
//  YouLanAgents
//
//  Created by lqcjdx on 15/5/27.
//  Copyright (c) 2015年 YL. All rights reserved.
//

#define kLineTag 1000
#define kDotTag 3000

#import "LMPopInputPasswordView.h"
#import <QuartzCore/QuartzCore.h>

#define kPasswordLength  6

@interface LMPopInputPasswordView()<UITextFieldDelegate>
{
    
}
@property(nonatomic,strong)UIControl *overlayView;//背景
@property(nonatomic,strong)UILabel *titleLabel;//标题
@property(nonatomic,strong)UILabel *lineLabel;//线条
@property(nonatomic,strong)YLPasswordTextFiled *textFiled;//输入文本框
@property(nonatomic,strong)UIButton *cancelButton;//取消按钮
@property(nonatomic,strong)UIButton *ensureButton;//确定按钮
@end

@implementation LMPopInputPasswordView

-(instancetype)init{
    if(self = [super init]){
        [self customInit];
    }
    return self;
}

-(void)customInit
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"请输入密码";
    [self addSubview:_titleLabel];
    
    _lineLabel = [[UILabel alloc]init];
    _lineLabel.backgroundColor = [UIColor grayColor];
    [self addSubview:_lineLabel];
    
    _textFiled = [[YLPasswordTextFiled alloc]init];
    _textFiled.backgroundColor = [UIColor whiteColor];
    _textFiled.layer.masksToBounds = YES;
    _textFiled.layer.borderColor = [UIColor grayColor].CGColor;
    _textFiled.layer.borderWidth = 1;
    _textFiled.layer.cornerRadius = 5;
    _textFiled.secureTextEntry = YES;
    _textFiled.delegate = self;
    _textFiled.tintColor = [UIColor clearColor];//看不到光标
    _textFiled.textColor = [UIColor clearColor];//看不到输入内容
    _textFiled.font = [UIFont systemFontOfSize:30];
    _textFiled.keyboardType = UIKeyboardTypeNumberPad;
    _textFiled.pattern = [NSString stringWithFormat:@"^\\d{%li}$",(long)kPasswordLength];
    [_textFiled addTarget:self action:@selector(textFiledEdingChanged) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_textFiled];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.backgroundColor = [UIColor whiteColor];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.layer.borderColor = [UIColor grayColor].CGColor;
    _cancelButton.layer.cornerRadius = 5;
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[[UIColor blackColor]colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitle:@"取消" forState:UIControlStateHighlighted];
    _cancelButton.tag = 0;
    [_cancelButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    _ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ensureButton.backgroundColor = [UIColor colorWithRed:48/255.0 green:109/255.0 blue:238/255.0 alpha:1];
    _ensureButton.layer.masksToBounds = YES;
    _ensureButton.layer.cornerRadius = 5;
    _ensureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_ensureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_ensureButton setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    [_ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_ensureButton setTitle:@"确定" forState:UIControlStateHighlighted];
    _ensureButton.tag = 1;
    [_ensureButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_ensureButton];
    
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [_overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _overlayView.frame = [[UIScreen mainScreen] bounds];
    
    //设置子视图位置
    CGFloat offsetX = 10;
    CGFloat offsetY = 10;
    _titleLabel.frame = CGRectMake(offsetX, offsetY, frame.size.width - 2 * offsetX, 21);
    
    offsetY += _titleLabel.frame.size.height + 10;
    _lineLabel.frame = CGRectMake(offsetX, offsetY, frame.size.width - 2 * offsetX, 1);
    
    offsetY += _lineLabel.frame.size.height + 10;
    _textFiled.frame = CGRectMake(offsetX, offsetY, frame.size.width - 2 * offsetX, 35);
    
    offsetY += _textFiled.frame.size.height + 10;
    CGFloat btnWidth = (frame.size.width - offsetX * 3)/2.0;
    _cancelButton.frame = CGRectMake(offsetX, offsetY, btnWidth, 35);
    _ensureButton.frame = CGRectMake(offsetX * 2 + btnWidth, offsetY, btnWidth, 35);
}

#pragma mark ---animation methods
-(void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }completion:^(BOOL finished) {
        [_textFiled becomeFirstResponder];
    }];
}

- (void)fadeOut
{
    [self endEditing:YES];
    
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)pop
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f-100);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

-(void)buttonClickedAction:(UIButton *)sender
{
    //传值给委托对象
    if([_delegate respondsToSelector:@selector(buttonClickedAtIndex:withText:)]){
        [_delegate buttonClickedAtIndex:sender.tag withText:_textFiled.text];
    }
    
    [self dismiss];
}

-(void)textFiledEdingChanged
{
    NSInteger length = _textFiled.text.length;
    NSLog(@"lenght=%li",(long)length);
    if(length==kPasswordLength){
        [self buttonClickedAction:_ensureButton];
    }
    for(NSInteger i=0;i<kPasswordLength;i++){
        UILabel *dotLabel = (UILabel *)[_textFiled viewWithTag:kDotTag + i];
        if(dotLabel){
            dotLabel.hidden = length <= i;
        }
    }
    [_textFiled sendActionsForControlEvents:UIControlEventValueChanged];
}

#define mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc
{
    [_textFiled removeTarget:self action:@selector(textFiledEdingChanged) forControlEvents:UIControlEventEditingChanged];
}
@end



@implementation YLPasswordTextFiled
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat perWidth = (frame.size.width - kPasswordLength + 1)*1.0/kPasswordLength;
    for(NSInteger i=0;i<kPasswordLength;i++){
        if(i < kPasswordLength - 1){
            UILabel *vLine = (UILabel *)[self viewWithTag:kLineTag + i];
            if(!vLine){
                vLine = [[UILabel alloc]init];
                vLine.tag = kLineTag + i;
                [self addSubview:vLine];
            }
            vLine.frame = CGRectMake(perWidth + (perWidth + 1)*i, 0, 1, frame.size.height);
            vLine.backgroundColor = [UIColor grayColor];
        }
        UILabel *dotLabel = (UILabel *)[self viewWithTag:kDotTag + i];
        if(!dotLabel){
            dotLabel = [[UILabel alloc]init];
            dotLabel.tag = kDotTag + i;
            [self addSubview:dotLabel];
        }
        dotLabel.frame = CGRectMake((perWidth + 1)*i + (perWidth - 10)*0.5, (frame.size.height - 10)*0.5, 10, 10);
        dotLabel.layer.masksToBounds = YES;
        dotLabel.layer.cornerRadius = 5;
        dotLabel.backgroundColor = [UIColor blackColor];
        dotLabel.hidden = YES;
    }
}

//禁止复制粘帖
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if(menuController){
        menuController.menuVisible = NO;
    }
    return NO;
}

@end
