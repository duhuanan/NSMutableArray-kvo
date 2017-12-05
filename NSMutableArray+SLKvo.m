//
//  NSMutableArray+SLKvo.m
//  SLQuestion
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NSMutableArray+SLKvo.h"
#import <objc/runtime.h>

@interface KvoArray() {
}

@property (nonatomic, assign) int targetIdentity;
@end
@implementation KvoArray

@end

#define KVOLock(...) int value = 0;\
\
if(self.kvo.targetIdentity == 0) {\
    value = 1;\
    self.kvo.targetIdentity = 1;\
}\
__VA_ARGS__; \
\
if(value) {\
self.kvo.kvoNotify = @([self.kvo.kvoNotify integerValue] + 1);\
self.kvo.targetIdentity = 0;\
}\

@implementation NSMutableArray (SLKvo)
@dynamic kvo;

+ (void)load {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSArrayM");
        
        NSArray *sels = @[@"insertObject:atIndex:", @"removeLastObject", @"replaceObjectAtIndex:withObject:", @"addObjectsFromArray:",
                          @"exchangeObjectAtIndex:withObjectAtIndex:", @"removeAllObjects", @"removeObject:inRange:", @"removeObject:", @"removeObjectIdenticalTo:inRange:",
                          @"removeObjectIdenticalTo:", @"removeObjectsFromIndices:numIndices:", @"removeObjectsInArray:", @"removeObjectsInRange:", @"replaceObjectsInRange:withObjectsFromArray:range:",
                          @"replaceObjectsInRange:withObjectsFromArray:", @"setArray:", @"sortUsingFunction:context:", @"sortUsingSelector:", @"insertObjects:atIndexes:",
                          @"removeObjectsAtIndexes:", @"replaceObjectsAtIndexes:withObjects:", @"setObject:atIndexedSubscript:", @"sortUsingComparator:", @"sortWithOptions:usingComparator:"];
        
        for(NSString *selStr in sels) {
            SEL safeSel = sel_registerName([[NSString stringWithFormat:@"safe%@", selStr] UTF8String]);
            SEL unsafeSel = sel_registerName([selStr UTF8String]);
            
            Method safeMethod = class_getInstanceMethod(class, safeSel);
            Method unsafeMethod = class_getInstanceMethod(class, unsafeSel);
            
            method_exchangeImplementations(unsafeMethod, safeMethod);
        }
    });
}

- (void)setKvoNotify:(KvoArray *)kvoNotify {
    objc_setAssociatedObject(self, "kvoNotify", kvoNotify, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KvoArray *)kvo {
    KvoArray *kvoData = objc_getAssociatedObject(self, "kvoNotify");
    
    if(kvoData == nil) {
        kvoData = [KvoArray new];
        objc_setAssociatedObject(self, "kvoNotify", kvoData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return kvoData;
}

- (void)safeinsertObject:(id)anObject atIndex:(NSUInteger)index {
    KVOLock([self safeinsertObject:anObject atIndex:index]);
}

- (void)saferemoveLastObject {
    KVOLock([self saferemoveLastObject]);
}

- (void)saferemoveObjectAtIndex:(NSUInteger)index {
    KVOLock([self saferemoveObjectAtIndex:index]);
}

- (void)safereplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    KVOLock([self safereplaceObjectAtIndex:index withObject:anObject]);
}

- (void)safeaddObjectsFromArray:(NSArray<id> *)otherArray {
    KVOLock([self safeaddObjectsFromArray:otherArray]);
}

- (void)safeexchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    KVOLock([self safeexchangeObjectAtIndex:idx1 withObjectAtIndex:idx2]);
}

- (void)saferemoveAllObjects {
    KVOLock([self saferemoveAllObjects]);
}

- (void)saferemoveObject:(id)anObject inRange:(NSRange)range {
    KVOLock([self saferemoveObject:anObject inRange:range]);
}

- (void)saferemoveObject:(id)anObject {
    KVOLock([self saferemoveObject:anObject]);
}

- (void)saferemoveObjectIdenticalTo:(id)anObject inRange:(NSRange)range {
    KVOLock([self saferemoveObjectIdenticalTo:anObject inRange:range]);
}

- (void)saferemoveObjectIdenticalTo:(id)anObject {
    KVOLock([self saferemoveObjectIdenticalTo:anObject]);
}

- (void)saferemoveObjectsFromIndices:(NSUInteger *)indices numIndices:(NSUInteger)cnt  {
    KVOLock([self saferemoveObjectsFromIndices:indices numIndices:cnt]);
}

- (void)saferemoveObjectsInArray:(NSArray<id> *)otherArray {
    KVOLock([self saferemoveObjectsInArray:otherArray]);
}

- (void)saferemoveObjectsInRange:(NSRange)range {
    KVOLock([self saferemoveObjectsInRange:range]);
}

- (void)safereplaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray range:(NSRange)otherRange {
    KVOLock([self safereplaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange]);
}

- (void)safereplaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray {
    KVOLock([self safereplaceObjectsInRange:range withObjectsFromArray:otherArray]);
}

- (void)safesetArray:(NSArray<id> *)otherArray {
    KVOLock([self safesetArray:otherArray]);
}

- (void)safesortUsingFunction:(NSInteger (NS_NOESCAPE *)(id,  id, void * _Nullable))compare context:(nullable void *)context {
    KVOLock([self safesortUsingFunction:compare context:context]);
}

- (void)safesortUsingSelector:(SEL)comparator {
    KVOLock([self safesortUsingSelector:comparator]);
}

- (void)safeinsertObjects:(NSArray<id> *)objects atIndexes:(NSIndexSet *)indexes {
    KVOLock([self safeinsertObjects:objects atIndexes:indexes]);
}

- (void)saferemoveObjectsAtIndexes:(NSIndexSet *)indexes {
    KVOLock([self saferemoveObjectsAtIndexes:indexes]);
}

- (void)safereplaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<id> *)objects {
    KVOLock([self safereplaceObjectsAtIndexes:indexes withObjects:objects]);
}

- (void)safesetObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    KVOLock([self safesetObject:obj atIndexedSubscript:idx]);
}

- (void)safesortUsingComparator:(NSComparator NS_NOESCAPE)cmptr {
    KVOLock([self safesortUsingComparator:cmptr]);
}

- (void)safesortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator NS_NOESCAPE)cmptr {
    KVOLock([self safesortWithOptions:opts usingComparator:cmptr]);
}

@end
