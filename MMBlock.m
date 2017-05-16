//
//  MMBlock.m
//  test
//
//  Created by 杜蒙 on 2017/5/16.
//  Copyright © 2017年 杜蒙. All rights reserved.
//

#import "MMBlock.h" 
// Block internals.
typedef NS_OPTIONS(int, AspectBlockFlags) {
    AspectBlockFlagsHasCopyDisposeHelpers = (1 << 25),
    AspectBlockFlagsHasSignature          = (1 << 30)
};
typedef struct _AspectBlock {
    __unused Class isa;
    AspectBlockFlags flags;
    __unused int reserved;
    void (__unused *invoke)(struct _AspectBlock *block, ...);
    struct {
        unsigned long int reserved;
        unsigned long int size;
        // requires AspectBlockFlagsHasCopyDisposeHelpers
        void (*copy)(void *dst, const void *src);
        void (*dispose)(const void *);
        // requires AspectBlockFlagsHasSignature
        const char *signature;
        const char *layout;
    } *descriptor;
    // imported variables
} *AspectBlockRef;


NSMethodSignature * block_blockSignature(id block){
    if (!block) return nil;
    AspectBlockRef layout = (__bridge void *)block;
    void *desc = layout->descriptor;
    desc += 2 * sizeof(unsigned long int);
    if (layout->flags & AspectBlockFlagsHasCopyDisposeHelpers) {
        desc += 2 * sizeof(void *);
    };
    const char *_signature = (*(const char **)desc);
    NSMethodSignature *signature  = [NSMethodSignature signatureWithObjCTypes:_signature];
    return signature;
}

int block_dynamicPerformBlock(id block ,NSArray *arguments){
    NSMethodSignature *singature = block_blockSignature(block);
    if (!singature)return  -1;
    NSInvocation *invocation  = [NSInvocation invocationWithMethodSignature:singature];
    NSUInteger numberOfArguments = singature.numberOfArguments;
    NSUInteger argumnetsCount    = arguments.count;
    if (numberOfArguments > 1 && argumnetsCount) {
            for (int i = 0 ; i  < argumnetsCount; i++) {
                id value = arguments[i];
                int index =  i + 1;
                if (index >= numberOfArguments)break;
                [invocation setArgument:&value atIndex:index];
            }
            [invocation invokeWithTarget:block];
    } else {
        [invocation invokeWithTarget:block];
    }
    return 0;
}
