//
//  ParsePropertyManager.m
//  AWJSON2Model
//
//  Created by AldaronWang on 16/6/6.
//  Copyright © 2016年 Aldaron. All rights reserved.
//

#import "ParsePropertyManager.h"

@implementation ParsePropertyManager

/**
 *  格式化OC属性字符串
 *
 *  @param key       JSON里面key字段
 *  @param value     JSON里面key对应的NSDiction或者NSArray
 *  @param classInfo 类信息
 *
 *  @return
 */
+ (NSString *)formatObjcWithKey:(NSString *)key value:(NSObject *)value{
    NSString *qualifierStr = @"copy";
    NSString *typeStr = @"NSString";
    
    //NSString
    if ([value isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ *%@;",qualifierStr,typeStr,key];
        
    }else if([value isKindOfClass:[@(YES) class]]){
        //YES or NO
        //the 'NSCFBoolean' is private subclass of 'NSNumber'
        qualifierStr = @"assign";
        typeStr = @"BOOL";
        return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ %@;",qualifierStr,typeStr,key];
    }else if([value isKindOfClass:[NSNumber class]]){
        //NSNumber
        qualifierStr = @"assign";
        NSString *valueStr = [NSString stringWithFormat:@"%@",value];
        if ([valueStr rangeOfString:@"."].location!=NSNotFound){
            typeStr = @"CGFloat";
        }else{
            NSNumber *valueNumber = (NSNumber *)value;
            if ([valueNumber longValue]<2147483648) {
                typeStr = @"NSInteger";
            }else{
                typeStr = @"long long";
            }
        }
        return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ %@;",qualifierStr,typeStr,key];
    }else if([value isKindOfClass:[NSArray class]]){
        NSArray *array = (NSArray *)value;
        
        //May be 'NSString'，will crash
        NSString *genericTypeStr = @"";
        NSObject *firstObj = [array firstObject];
        if ([firstObj isKindOfClass:[NSDictionary class]]) {
            genericTypeStr = [NSString stringWithFormat:@"<%@ *>",key];
        }else if ([firstObj isKindOfClass:[NSString class]]){
            genericTypeStr = @"<NSString *>";
        }else if ([firstObj isKindOfClass:[NSNumber class]]){
            genericTypeStr = @"<NSNumber *>";
        }
        
        qualifierStr = @"strong";
        typeStr = @"NSArray";
        return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ *%@;",qualifierStr,typeStr,key];
    }else if ([value isKindOfClass:[NSDictionary class]]){
        //NSDictionary
        qualifierStr = @"strong";
        typeStr = @"id";
        return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ *%@;",qualifierStr,typeStr,key];
    }
    return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ *%@;",qualifierStr,typeStr,key];
}


@end
