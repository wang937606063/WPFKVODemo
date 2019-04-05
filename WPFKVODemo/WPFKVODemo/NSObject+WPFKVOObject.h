//
//  NSObject+WPFKVOObject.h
//  WPFKVODemo
//
//  Created by superman on 2019/4/5.
//  Copyright © 2019 王鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WPFKVOObject)
-(void)pf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
-(void)pf_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context;
@end

NS_ASSUME_NONNULL_END
