//
//  SLQLRunloop.h
//  textKit
//
//  Created by duha on 2017/12/7.
//  Copyright © 2017年 monph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLQLRunloop : NSObject

+ (SLQLRunloop *)runloop;

- (void)asyncRun:(void (^)())block;     //runloop 能让线程在空闲时不占用cpu，并保证只有一条线程在处理block函数

@end
