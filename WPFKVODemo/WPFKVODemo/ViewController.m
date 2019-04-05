//
//  ViewController.m
//  WPFKVODemo
//
//  Created by superman on 2019/4/5.
//  Copyright © 2019 王鹏飞. All rights reserved.
//

#import "ViewController.h"
#import "WPFPerson.h"
#import "NSObject+WPFKVOObject.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WPFPerson * personA = [[WPFPerson alloc]init];
    WPFPerson * personB = [[WPFPerson alloc]init];
    personA.age = 9;
    personA.name = @"张三";
    NSObject * object = [NSObject new];
    [personA pf_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [personA pf_addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    [personA setAge:-10.6];;
    personA.name = @"李四";

}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@",change);
}
-(void)pf_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@",change);
}
@end
