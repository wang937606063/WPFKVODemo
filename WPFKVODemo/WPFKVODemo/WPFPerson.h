//
//  WPFPerson.h
//  WPFKVODemo
//
//  Created by superman on 2019/4/5.
//  Copyright © 2019 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+WPFKVOObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface WPFPerson : NSObject{
    @public
//    NSInteger _age;
}
@property(nonatomic , assign)NSInteger index;
@property(nonatomic , assign)NSInteger age;
@property (nonatomic, copy) NSString * name;
@end

NS_ASSUME_NONNULL_END
