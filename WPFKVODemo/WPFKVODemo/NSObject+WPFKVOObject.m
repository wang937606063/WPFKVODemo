//
//  NSObject+WPFKVOObject.m
//  WPFKVODemo
//
//  Created by superman on 2019/4/5.
//  Copyright © 2019 wpf. All rights reserved.
//

#import "NSObject+WPFKVOObject.h"
#import "objc/message.h"
//NSKVONotifying_WPFPerson
//#define PROPERY_KEY @"observer"
static const char * property = "observer";
void getAllPopertyTypeAndName(Class objcClas,NSMutableArray * list){
    unsigned int outCount;
    Ivar * vars = class_copyIvarList(objcClas, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = vars[i];
        NSString * ivarName = [[NSString alloc]initWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        NSString * ivarType = [[NSString alloc]initWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
        [list addObject:@{ivarName:ivarType}];
    }
    Class  superClass = class_getSuperclass(objcClas);
    if (superClass != NULL) {
        getAllPopertyTypeAndName(class_getSuperclass(objcClas), list);
    }else{
        return;
    }
}
void setMethod(id self,SEL _cmd,void * value){
    
    //去调用父类的setter方法
    struct objc_super  superClass= {
        self,
        class_getSuperclass([self class])
    };
    objc_msgSendSuper(&superClass, _cmd,value);
    //拿到keypath
    NSString * methodName = NSStringFromSelector(_cmd);
    NSString * keyPath = [[methodName stringByReplacingOccurrencesOfString:@"set" withString:@""]  stringByReplacingOccurrencesOfString:@":" withString:@""].lowercaseString;
    NSMutableArray * listivar = [NSMutableArray array];
    getAllPopertyTypeAndName([self class], listivar);
    for (NSDictionary * dic in listivar) {
       NSString * ivarName = [dic allKeys].firstObject;
        if ([ivarName.lowercaseString containsString:keyPath]) {
            NSString * type = [dic allValues].firstObject;
            Class  tempClass = NSClassFromString([[type stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"@" withString:@""]);
            
            if(tempClass != nil){
               id address =   (__bridge NSObject*)value;
                //            通知观察者值发生了改变
                NSMutableArray * observers = objc_getAssociatedObject(self, property);
                for (NSObject * object in observers) {
                    objc_msgSend(object, @selector(observeValueForKeyPath:ofObject:change:context:),keyPath,self,@{@"new":address});
                }
            }else{
                NSNumber * number = @((NSInteger)value);
                //            通知观察者值发生了改变
                NSMutableArray * observers = objc_getAssociatedObject(self, property);
                for (NSObject * object in observers) {
                    if ([object respondsToSelector:@selector(pf_observeValueForKeyPath:ofObject:change:context:)]) {
                         objc_msgSend(object, @selector(pf_observeValueForKeyPath:ofObject:change:context:),keyPath,self,@{@"new":number});
                    }

                }
            }

        }
    }
    
 
    
}


@implementation NSObject (WPFKVOObject)
-(void)pf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    NSString * oldClassName = NSStringFromClass([self class]);
    NSString * newClassName = [NSString stringWithFormat:@"WPFKVONotifying_%@",oldClassName];
   //创建新类
    Class newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    
    objc_registerClassPair(newClass);
    //将被观察者对象isa指针指向新类
    object_setClass(self, newClass);
    //给新子类添加setter方法
    NSString * methodName = [NSString stringWithFormat:@"set%@:",keyPath.capitalizedString];
    
    SEL sel = NSSelectorFromString(methodName);
    
    class_addMethod(newClass, sel, (IMP)setMethod, "v@:@");
    
    NSMutableArray * observers = objc_getAssociatedObject(self, property);
    if (observers == nil) {
        //如果为空添加关联对象
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, property, observers, OBJC_ASSOCIATION_RETAIN);

    }
    [observers addObject:observer];
    
}
void message(){
    NSLog(@"message");
}
@end
