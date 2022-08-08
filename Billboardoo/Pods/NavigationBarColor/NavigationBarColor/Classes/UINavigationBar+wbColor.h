//
//  UINavigationBar+wbColor.h
//  Hello
//
//  Created by nana on 2019/11/6.
//  Copyright © 2019 nana. All rights reserved.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UINavigationBar (wbColor)
/// 所有控制器 默认 导航栏 隐藏状态, 和系统方法起冲突 
@property(nonatomic, assign)BOOL wb_defaultHidden;
/// 设置某个控制器的导航栏是否隐藏
-(void)wb_setHidden:(BOOL)hidden vcClass:(Class)vcClass;
/// 获取某个控制器的导航栏是否隐藏
-(BOOL)wb_hiddenWithvcClass:(Class)vcClass;

///set the UINavigationBar color of the ViewController
-(void)wb_setBarTintColor:(UIColor*)color vcClass:(Class)vcClass;

///ViewController's UINavigationBar color
-(UIColor *)wb_barTintColorWithvcClass:(Class)vcClass;
@end


NS_ASSUME_NONNULL_END
