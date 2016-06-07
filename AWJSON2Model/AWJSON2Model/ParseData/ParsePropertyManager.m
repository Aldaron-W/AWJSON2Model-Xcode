//
//  ParsePropertyManager.m
//  AWJSON2Model
//
//  Created by AldaronWang on 16/6/6.
//  Copyright © 2016年 Aldaron. All rights reserved.
//

#import <objc/runtime.h>
#import "ParsePropertyManager.h"

/// Foundation Class Type
typedef NS_ENUM (NSUInteger, AWNSType) {
    AWNSTypeNSUnknown = 0,
    AWNSTypeNSString,
    AWNSTypeNSMutableString,
    AWNSTypeNSValue,
    AWNSTypeNSNumber,
    AWNSTypeNSDecimalNumber,
    AWNSTypeNSData,
    AWNSTypeNSMutableData,
    AWNSTypeNSDate,
    AWNSTypeNSURL,
    AWNSTypeNSArray,
    AWNSTypeNSMutableArray,
    AWNSTypeNSDictionary,
    AWNSTypeNSMutableDictionary,
    AWNSTypeNSSet,
    AWNSTypeNSMutableSet,
};

@implementation ParsePropertyManager

+ (AWNSType)getPropertyNSType:(Class)class{
    
        if (!class) return AWNSTypeNSUnknown;
        if ([class isSubclassOfClass:[NSMutableString class]]) return AWNSTypeNSMutableString;
        if ([class isSubclassOfClass:[NSString class]]) return AWNSTypeNSString;
        if ([class isSubclassOfClass:[NSDecimalNumber class]]) return AWNSTypeNSDecimalNumber;
        if ([class isSubclassOfClass:[NSNumber class]]) return AWNSTypeNSNumber;
        if ([class isSubclassOfClass:[NSValue class]]) return AWNSTypeNSValue;
        if ([class isSubclassOfClass:[NSMutableData class]]) return AWNSTypeNSMutableData;
        if ([class isSubclassOfClass:[NSData class]]) return AWNSTypeNSData;
        if ([class isSubclassOfClass:[NSDate class]]) return AWNSTypeNSDate;
        if ([class isSubclassOfClass:[NSURL class]]) return AWNSTypeNSURL;
        if ([class isSubclassOfClass:[NSMutableArray class]]) return AWNSTypeNSMutableArray;
        if ([class isSubclassOfClass:[NSArray class]]) return AWNSTypeNSArray;
        if ([class isSubclassOfClass:[NSMutableDictionary class]]) return AWNSTypeNSMutableDictionary;
        if ([class isSubclassOfClass:[NSDictionary class]]) return AWNSTypeNSDictionary;
        if ([class isSubclassOfClass:[NSMutableSet class]]) return AWNSTypeNSMutableSet;
        if ([class isSubclassOfClass:[NSSet class]]) return AWNSTypeNSSet;
    return AWNSTypeNSUnknown;
}

+ (AWNSType)getPropertyNSTypeForJSON:(Class)class{
    
    if (!class) return AWNSTypeNSUnknown;
    if ([class isSubclassOfClass:[NSMutableString class]]) return AWNSTypeNSMutableString;
    if ([class isSubclassOfClass:[NSString class]]) return AWNSTypeNSString;
    if ([class isSubclassOfClass:[NSDecimalNumber class]]) return AWNSTypeNSDecimalNumber;
    if ([class isSubclassOfClass:[NSNumber class]]) return AWNSTypeNSNumber;
    if ([class isSubclassOfClass:[NSMutableArray class]]) return AWNSTypeNSMutableArray;
    if ([class isSubclassOfClass:[NSArray class]]) return AWNSTypeNSArray;
    if ([class isSubclassOfClass:[NSMutableDictionary class]]) return AWNSTypeNSMutableDictionary;
    if ([class isSubclassOfClass:[NSDictionary class]]) return AWNSTypeNSDictionary;
    return AWNSTypeNSUnknown;
}

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
    NSString *qualifierStr = @"";
    NSString *typeStr = @"";
    
    switch ([ParsePropertyManager getPropertyNSTypeForJSON:[value class]]) {
        case AWNSTypeNSString:
        case AWNSTypeNSMutableString:{
            qualifierStr = @"copy";
            typeStr = @"NSString";
        }
            break;
        case AWNSTypeNSNumber:
        case AWNSTypeNSDecimalNumber:{
            qualifierStr = @"assign";
            
            NSNumber *valueNumber = (NSNumber *)value;
            if([valueNumber intValue] == [valueNumber longValue]){
                if ([valueNumber longLongValue] < NSIntegerMax && [valueNumber longLongValue] > NSIntegerMin) {
                    typeStr = @"NSInteger";
                }
                else if ([valueNumber longLongValue] < )
                
            }else{
                if([valueNumber doubleValue] < CGFLOAT_MAX && [valueNumber doubleValue] > CGFLOAT_MIN) {
                    typeStr = @"CGFloat";
                }
                else{
                    typeStr = @"double";
                }
            }
                
//            }else{
//                NSNumber *valueNumber = (NSNumber *)value;
//                if ([valueNumber longValue]<NSIntegerMax) {
//                    typeStr = @"NSInteger";
//                }else{
//                    typeStr = @"long long";
//                }
//            }
            
        }
        default:
            break;
    }
    
    //NSString
    if ([value isKindOfClass:[NSString class]]) {
        qualifierStr = @"copy";
        typeStr = @"NSString";
    }else if([value isKindOfClass:[@(YES) class]]){
        //YES or NO
        //the 'NSCFBoolean' is private subclass of 'NSNumber'
        qualifierStr = @"assign";
        typeStr = @"BOOL";
    }else if([value isKindOfClass:[NSNumber class]]){
        //NSNumber
        qualifierStr = @"assign";
        NSString *valueStr = [NSString stringWithFormat:@"%@",value];
        if ([valueStr rangeOfString:@"."].location!=NSNotFound){
            typeStr = @"CGFloat";
        }else{
            NSNumber *valueNumber = (NSNumber *)value;
            if ([valueNumber longValue]<NSIntegerMax) {
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
    else if ([value isKindOfClass:[NSNull class]]){
        
    }
    return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ *%@;",qualifierStr,typeStr,key];
}

- (Class)checkClassWithClassName:(NSString *)className error:(NSError *)error{
    Class class = NSClassFromString(className);
    
    if (class) {
        return class;
    }
    else{
        error = [NSError errorWithDomain:@"AWJSON2Model.error" code:-1 userInfo:@{@"Error":@"Don't have any class with this name."}];
        return nil;
    }
}

@end
