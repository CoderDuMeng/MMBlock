//
//  MMBlock.h
//  
//
//  Created by 杜蒙 on 2017/5/16.
//  Copyright © 2017年 杜蒙. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 The sample
  获取block的签名   
 
 id block = ^(NSString *value, NSString *value1 , id number, id,number1){
     code........
 }; 
  调用
  block_blockSignature(block); 
 
  传入进去block 返回一个此block的  NSMethodSignature 签名  此block 不能为nil  否则返回 nil
 
 
  @block  需要获取签名的block
  @return 返回签名 
*/
NSMethodSignature * block_blockSignature(id block);
/** 
   The sample 
 
  id block = ^(NSString *value, NSString *value1 , id number, id,number1){
    
        code........
  }; 
  
  调用方式1 可以传一个参数
  block_dynamicPerformBlock(block,@[@"2"]);
  
  调用方式2 可以传两个
  block_dynamicPerformBlock(block,@[@"value",@"value1"]); 
 
  总结:{ 
    
  调用的传入的参数传进去一个数组 根据数组里面的value 来传入参数 
  次数组可以是nil  
 
  }
   @block   传入进去block
   @arguments 参数  
   @return -1 失败  0 成功
 */
int block_dynamicPerformBlock(id block ,NSArray *arguments);








