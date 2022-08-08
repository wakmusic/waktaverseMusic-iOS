//
//  UINavigationBar+wbColor.m
//  Hello
//
//  Created by nana on 2019/11/6.
//  Copyright © 2019 nana. All rights reserved.
//

#import "UINavigationBar+wbColor.h"
#import <objc/runtime.h>


@implementation UINavigationBar (wbColor)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method Method1 = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method Method2 = class_getInstanceMethod(self, @selector(wb_layoutSubviews));
        method_exchangeImplementations(Method1, Method2);

        Method Method3 = class_getInstanceMethod(self, @selector(setBarTintColor:));
        Method Method4 = class_getInstanceMethod(self, @selector(wb_setBarTintColor:));
        method_exchangeImplementations(Method3, Method4);

        Method Method5 = class_getInstanceMethod(self, @selector(barTintColor));
        Method Method6 = class_getInstanceMethod(self, @selector(wb_barTintColor));
        method_exchangeImplementations(Method5, Method6);
    });
}

- (void)wb_layoutSubviews {
    [self wb_layoutSubviews];
    UINavigationController *navvc = (UINavigationController *)[self wb_viewController];
    UIViewController *lastVc = navvc.viewControllers.lastObject;
    NSMutableDictionary *p = self.barTintParmDict[NSStringFromClass([lastVc class])];

    [self setParm:p vcClass:[lastVc class]];
}

- (void)wb_setBarTintColor:(UIColor *)barTintColor {
    objc_setAssociatedObject(self, "wb_barTintColor1", barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self wb_setBarTintColor:barTintColor];
    });
    [self layoutIfNeeded];
}

- (UIColor *)wb_barTintColor {
   UIColor *rgb = objc_getAssociatedObject(self, "wb_barTintColor1");
    return rgb;
}

- (void)setWb_defaultHidden:(BOOL)wb_defaultHidden {
    objc_setAssociatedObject(self, @selector(wb_defaultHidden), @(wb_defaultHidden), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)wb_defaultHidden{
    NSNumber *value = objc_getAssociatedObject(self, _cmd);
    return value.boolValue;
}


- (void)setBarTintParmDict:(NSMutableDictionary *)barTintColorsDict {
    objc_setAssociatedObject(self, @selector(barTintParmDict), barTintColorsDict, OBJC_ASSOCIATION_RETAIN);
}
- (NSMutableDictionary *)barTintParmDict {
    NSMutableDictionary *constraints = objc_getAssociatedObject(self, _cmd);
    if (!constraints) {
        constraints = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, _cmd, constraints, OBJC_ASSOCIATION_RETAIN);
    }
    return constraints;
}


- (UIView *)wb_barTintView {
    UIView *barView = nil;
    for (UIView *oneview in self.subviews) {
       if ([NSStringFromClass([oneview class]) isEqualToString:@"_UIBarBackground"]) {
           for (UIView *twoView in oneview.subviews) {
               if ([NSStringFromClass([twoView class]) isEqualToString:@"UIVisualEffectView"]) {
                    barView =  twoView.subviews.lastObject;
                     break;
                 }
           }
           break;
       }
    }
    return barView;
}
- (UIViewController *)wb_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)setParm:(NSDictionary *)parm vcClass:(Class)vcClass {
    
    if (!parm) {
        [self wb_barTintView].backgroundColor = self.barTintColor;
        self.hidden = self.wb_defaultHidden;
        return;
    }
    
    UINavigationController *navvc = (UINavigationController *)[self wb_viewController];
    NSString *lastClassString = NSStringFromClass([navvc.viewControllers.lastObject class]);
    NSString *currentClassString = NSStringFromClass(vcClass);

    if ([lastClassString isEqualToString:currentClassString]) {
        UIColor * color = parm[@"color"];
        if (!color) {
            color = self.barTintColor;
        }
        [self wb_barTintView].backgroundColor = color;
         
        NSNumber *hiddenNumber = parm[@"hidden"];
        if (hiddenNumber) {
            self.hidden = hiddenNumber.boolValue;
        }else {
            self.hidden = self.wb_defaultHidden;
        }
    }
}



-(void)wb_setHidden:(BOOL)hidden vcClass:(Class)vcClass
{
    NSMutableDictionary *pDict = self.barTintParmDict[NSStringFromClass(vcClass)];
    if (!pDict) {
        pDict = [[NSMutableDictionary alloc] init];
        self.barTintParmDict[NSStringFromClass(vcClass)] = pDict;
    }
    pDict[@"hidden"] = @(hidden);
    [self setParm:pDict vcClass:vcClass];
}

-(BOOL)wb_hiddenWithvcClass:(Class)vcClass
{
    NSMutableDictionary *pDict = self.barTintParmDict[NSStringFromClass(vcClass)];
    return [pDict[@"hidden"] boolValue];
}
-(void)wb_setBarTintColor:(UIColor*)color vcClass:(Class)vcClass
{
    NSMutableDictionary *pDict = self.barTintParmDict[NSStringFromClass(vcClass)];
    if (!pDict) {
        pDict = [[NSMutableDictionary alloc] init];
        self.barTintParmDict[NSStringFromClass(vcClass)] = pDict;
    }
    pDict[@"color"] = color;
    [self setParm:pDict vcClass:vcClass];
}
-(UIColor *)wb_barTintColorWithvcClass:(Class)vcClass {
    NSMutableDictionary *pDict = self.barTintParmDict[NSStringFromClass(vcClass)];
    return pDict[@"color"];
}

@end

//
//@implementation UINavigationBar (wbColor)
//
//+(void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Method Method1 = class_getInstanceMethod(self, @selector(layoutSubviews));
//        Method Method2 = class_getInstanceMethod(self, @selector(wb_layoutSubviews));
//        method_exchangeImplementations(Method1, Method2);
//
//        Method Method3 = class_getInstanceMethod(self, @selector(setBarTintColor:));
//        Method Method4 = class_getInstanceMethod(self, @selector(wb_setBarTintColor:));
//        method_exchangeImplementations(Method3, Method4);
//
//        Method Method5 = class_getInstanceMethod(self, @selector(barTintColor));
//        Method Method6 = class_getInstanceMethod(self, @selector(wb_barTintColor));
//        method_exchangeImplementations(Method5, Method6);
//    });
//}
//
//- (void)setBarTintColorsDict:(NSMutableDictionary *)barTintColorsDict {
//    objc_setAssociatedObject(self, @selector(barTintColorsDict), barTintColorsDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (NSMutableDictionary *)barTintColorsDict {
//    NSMutableDictionary *constraints = objc_getAssociatedObject(self, _cmd);
//    if (!constraints) {
//        constraints = [[NSMutableDictionary alloc] init];
//        objc_setAssociatedObject(self, _cmd, constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    return constraints;
//}
//
//- (void)setBarHidenDict:(NSMutableDictionary *)barHidenDict {
//    objc_setAssociatedObject(self, @selector(barHidenDict), barHidenDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (NSMutableDictionary *)barHidenDict {
//    NSMutableDictionary *constraints = objc_getAssociatedObject(self, _cmd);
//    if (!constraints) {
//        constraints = [[NSMutableDictionary alloc] init];
//        objc_setAssociatedObject(self, _cmd, constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    return constraints;
//}
//
//
//- (void)wb_setBarTintColor:(UIColor *)barTintColor {
//    objc_setAssociatedObject(self, "wb_barTintColor1", barTintColor, OBJC_ASSOCIATION_ASSIGN);
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self wb_setBarTintColor:barTintColor];
//    });
//    [self layoutIfNeeded];
//}
//
//- (UIColor *)wb_barTintColor {
//   return objc_getAssociatedObject(self, "wb_barTintColor1");
//
//}
//
//- (UIView *)wb_barTintView {
//    UIView *barView = nil;
//    for (UIView *oneview in self.subviews) {
//       if ([NSStringFromClass([oneview class]) isEqualToString:@"_UIBarBackground"]) {
//           for (UIView *twoView in oneview.subviews) {
//               if ([NSStringFromClass([twoView class]) isEqualToString:@"UIVisualEffectView"]) {
//                    barView =  twoView.subviews.lastObject;
//                     break;
//                 }
//           }
//           break;
//       }
//    }
//    return barView;
//}
//
//
//
//- (void)wb_layoutSubviews {
//    [self wb_layoutSubviews];
//    UINavigationController *navvc = (UINavigationController *)[self wb_viewController];
//    UIViewController *vc = navvc.viewControllers.lastObject;
//    [self setupValueCurrentVc:vc];
//}
//
//- (void)setupValueCurrentVc:(UIViewController *)currentVc {
//
//    UINavigationController *navvc = (UINavigationController *)[self wb_viewController];
//    UIViewController *lastVc = navvc.viewControllers.lastObject;
//
//    if ([lastVc isEqual:currentVc]) {
//          NSString *classKey = [self keyWithClass:[currentVc class]];
//          UIColor * color = self.barTintColorsDict[classKey];
//          if (!color) {
//              color = self.barTintColor;
//          }
//          self.wb_barTintView.backgroundColor = color;
//          NSString *hidenString = self.barHidenDict[classKey];
//          self.hidden = hidenString.boolValue;
//    }
//}
//
//- (UIViewController *)wb_viewController {
//    for (UIView *view = self; view; view = view.superview) {
//        UIResponder *nextResponder = [view nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)nextResponder;
//        }
//    }
//    return nil;
//}
//
//- (NSString *)keyWithClass:(Class)vcClass {
//    return NSStringFromClass(vcClass);
//}
//
//#pragma 颜色
//- (void)registerControllerClass:(Class)vcClass color:(UIColor *)color {
//    NSString *key = [self keyWithClass:vcClass];
//    [self registerKey:key color:color];
//}
//- (void)registerController:(UIViewController *)vc color:(UIColor *)color {
//    NSString *key = [self keyWithClass:[vc class]];
//    [self registerKey:key color:color];
//    [self setupValueCurrentVc:vc];
//}
//
//- (void)registerKey:(NSString *)key color:(UIColor *)color {
//     self.barTintColorsDict[key] = color;
//}
//
//- (void)unregisterColorWithControllerClass:(Class)vcClass{
//    [self.barTintColorsDict removeObjectForKey:[self keyWithClass:vcClass]];
//}
//
//- (void)unregisterColorWithController:(UIViewController *)vc{
//    [self.barTintColorsDict removeObjectForKey:[self keyWithClass:[vc class]]];
//    [self setupValueCurrentVc:vc];
//}
//
//#pragma 隐藏
//- (void)registerControllerClass:(Class)vcClass hiden:(BOOL)hiden {
//    NSString *key =[self keyWithClass:vcClass];
//    [self registerKey:key hiden:hiden];
//}
//
//- (void)registerController:(UIViewController *)vc hiden:(BOOL)hiden {
//    NSString *key = [self keyWithClass:[vc class]];
//    [self registerKey:key hiden:hiden];
//    [self setupValueCurrentVc:vc];
//
//}
//
//- (void)registerKey:(NSString *)key hiden:(BOOL)hiden {
//    self.barHidenDict[key] = [NSString stringWithFormat:@"%d",hiden];
//}
//
//
//- (void)unregisterHidenWithControllerClass:(Class)vcClass {
//    [self.barTintColorsDict removeObjectForKey:[self keyWithClass:vcClass]];
//}
//
//- (void)unregisterHidenWithController:(UIViewController *)vc {
//    [self.barTintColorsDict removeObjectForKey:[self keyWithClass:[vc class]]];
//    [self setupValueCurrentVc:vc];
//}
//@end

//@interface UINavigationBar (wbColor)


/////注册 控制器  是否隐藏
//- (void)registerControllerClass:(Class)vcClass hiden:(BOOL)hiden;
/////注册 控制器  是否隐藏 调用后马上隐藏
//- (void)registerController:(UIViewController *)vc hiden:(BOOL)hiden;
/////注册 控制器  是否隐藏
//- (void)unregisterHidenWithControllerClass:(Class)vcClass;
/////删除 注册 控制器  是否隐藏 调用后马上隐藏
//- (void)unregisterHidenWithController:(UIViewController *)vc;
//
/////注册 控制器的 名字 的颜色
//- (void)registerControllerClass:(Class)vcClass color:(UIColor *)color;
/////注册 控制器的 对象 的颜色 实时改变控制器颜色
//- (void)registerController:(UIViewController *)vc color:(UIColor *)color;
/////删除 控制器的 名字 的颜色
//- (void)unregisterColorWithControllerClass:(Class)vcClass;
/////删除 控制器的 对象 的颜色 实时改变控制器颜色
//- (void)unregisterColorWithController:(UIViewController *)vc;
//@end
