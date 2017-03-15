# Method-Swizzle-Pitfall
如果UIViewController和一个继承自UIViewController的子类的viewWillAppear:方法都被swizzle，
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(sub_swizzleviewWillAppear:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        IMP originIMP = method_getImplementation(originalMethod);
        IMP swizzleIMP = method_getImplementation(swizzledMethod);

        BOOL didAddMethod = class_addMethod(class, originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector,
                                originIMP,
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
     });
}
 子类如果没有实现viewWillAppear方法的话在swizzle时会被添加UIViewController的原始方法（注意UIViewController中的viewWillAppear方法并没有call super）,
 这时会导致被swizzle之后的父类方法不会被调到。
