//
//  Swizzle.m
//  Swizzle
//
//  Created by lihang on 2017/3/15.
//  Copyright © 2017年 shijiebang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "SwizzleViewController.h"

@import ObjectiveC.runtime;
@implementation ViewController (ViewControllerSwizzle)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL viewDidLoadOriginalSelector = @selector(viewWillAppear:);
        SEL viewDidLoadswizzledSelector = @selector(sub_swizzleviewWillAppear:);
        Method viewDidLoadOriginalMethod = class_getInstanceMethod(class, viewDidLoadOriginalSelector);
        Method viewDidLoadSwizzledMethod = class_getInstanceMethod(class, viewDidLoadswizzledSelector);
        
        IMP originIMP = method_getImplementation(viewDidLoadOriginalMethod);
        IMP swizzleIMP = method_getImplementation(viewDidLoadSwizzledMethod);

#if 1
        BOOL didAddMethod = class_addMethod(class, viewDidLoadOriginalSelector,
                                            method_getImplementation(viewDidLoadSwizzledMethod),
                                            method_getTypeEncoding(viewDidLoadSwizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, viewDidLoadswizzledSelector,
                                originIMP,
                                method_getTypeEncoding(viewDidLoadOriginalMethod));
        } else {
            method_exchangeImplementations(viewDidLoadOriginalMethod, viewDidLoadSwizzledMethod);
        }
#else
        method_exchangeImplementations(viewDidLoadOriginalMethod, viewDidLoadSwizzledMethod);
#endif
    });
}

- (void)sub_swizzleviewWillAppear:(BOOL)animated {
    [self sub_swizzleviewWillAppear:animated];
}


@end

@implementation UIViewController(UIViewControllerSwizzle)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL viewDidLoadOriginalSelector = @selector(viewWillAppear:);
        SEL viewDidLoadswizzledSelector = @selector(super_swizzleviewWillAppear:);
        Method viewDidLoadOriginalMethod = class_getInstanceMethod(class, viewDidLoadOriginalSelector);
        Method viewDidLoadSwizzledMethod = class_getInstanceMethod(class, viewDidLoadswizzledSelector);
        BOOL didAddMethod = class_addMethod(class, viewDidLoadOriginalSelector,
                                            method_getImplementation(viewDidLoadSwizzledMethod),
                                            method_getTypeEncoding(viewDidLoadSwizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, viewDidLoadswizzledSelector,
                                method_getImplementation(viewDidLoadOriginalMethod),
                                method_getTypeEncoding(viewDidLoadOriginalMethod));
        } else {
            method_exchangeImplementations(viewDidLoadOriginalMethod, viewDidLoadSwizzledMethod);
        }
    });
}

- (void)super_swizzleviewWillAppear:(BOOL)animated {
    [self super_swizzleviewWillAppear:animated];
}


@end
