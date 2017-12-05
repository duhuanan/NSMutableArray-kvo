//
//  NSMutableArray+SLKvo.h
//  SLQuestion
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KvoArray:NSObject {
    
}

@property (nonatomic, strong) NSNumber *kvoNotify;
@end;

@interface NSMutableArray (SLKvo)

@property (nonatomic, strong) KvoArray *kvo;

@end
