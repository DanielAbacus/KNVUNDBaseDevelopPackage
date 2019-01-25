//
//  KNVUNDInvocation.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 25/1/19.
//

#import "KNVUNDInvocation.h"

/// Lib
#import <objc/runtime.h>

@implementation KNVUNDInvocation

#pragma mark - Factory Method
+ (instancetype)invocationWithTarget:(NSObject*)targetObject
                            selector:(SEL)selector {
    NSMethodSignature* sig = [targetObject
                              methodSignatureForSelector:selector];
    NSInvocation* inv = [NSInvocation
                         invocationWithMethodSignature:sig];
    [inv setTarget:targetObject];
    [inv setSelector:selector];
    return inv;
}

+ (instancetype)invocationWithClass:(Class)targetClass
                           selector:(SEL)selector {
    Method method =
    class_getInstanceMethod(targetClass, selector);
    struct objc_method_description* desc =
    method_getDescription(method);
    if (desc == NULL || desc->name == NULL)
        return nil;
    
    NSMethodSignature* sig = [NSMethodSignature
                              signatureWithObjCTypes:desc->types];
    NSInvocation* inv = [NSInvocation
                         invocationWithMethodSignature:sig];
    [inv setSelector:selector];
    return inv;
}

+ (instancetype)invocationWithProtocol:(Protocol*)targetProtocol
                              selector:(SEL)selector {
    struct objc_method_description desc;
    BOOL required = YES;
    desc = protocol_getMethodDescription(targetProtocol,
                                         selector,
                                         required,
                                         YES);
    if (desc.name == NULL) {
        required = NO;
        desc = protocol_getMethodDescription(targetProtocol,
                                             selector,
                                             required,
                                             YES);
    }
    if (desc.name == NULL)
        return nil;
    
    NSMethodSignature* sig = [NSMethodSignature
                              signatureWithObjCTypes:desc.types];
    NSInvocation* inv = [NSInvocation
                         invocationWithMethodSignature:sig];
    [inv setSelector:selector];
    return inv;
}

@end
