//
//  ParsePropertyManager.h
//  AWJSON2Model
//
//  Created by AldaronWang on 16/6/6.
//  Copyright © 2016年 Aldaron. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Test Content
 
 {
	"number": 0.0,
 "int": 0,
	"string": "string",
	"array": [
 {
 "key1" : "value1",
 "key2" : "value2",
 "key3" : "value3",
 },
 {
 "key1" : "value1",
 "key2" : "value2",
 "key3" : "value3",
 },
 "ArraySubString",
 0.0,
 ],
	"dictionary": {
 "key1" : "value1",
 "key2" : "value2",
 "key3" : "value3",
	},
 "NULL" : null,
 "BOOL" : true,
 }
 */

@interface ParsePropertyManager : NSObject

/**
 *  格式化OC属性字符串
 *
 *  @param key       JSON里面key字段
 *  @param value     JSON里面key对应的NSDiction或者NSArray
 *  @param classInfo 类信息
 *
 *  @return
 */
+ (NSString *)formatObjcWithKey:(NSString *)key value:(NSObject *)value;

@end
