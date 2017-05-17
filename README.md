# DemoInPutPasswordView
仿微信支付密码输入框的效果

其中的文本框使用了第三方库[WTReTextField](https://github.com/pieceofsummer/WTReTextField ) （一个可通过正则表达式限制文本框输入内容的文本框。）

## 使用方法：
- 1.将相关类导入到你的项目中
- 2.添加引用#import "LMPopInputPasswordView.h"，实现委托LMPopInputPassViewDelegate
- 3.创建对象并设置委托，弹出视图：
	
```
LMPopInputPasswordView *popView = [[LMPopInputPasswordView alloc]init];
popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, 50, 250, 150);
popView.delegate = self;
[popView pop];	
```

## 效果图：
![](https://github.com/lqcjdx/DemoInPutPasswordView/blob/master/input.gif)


