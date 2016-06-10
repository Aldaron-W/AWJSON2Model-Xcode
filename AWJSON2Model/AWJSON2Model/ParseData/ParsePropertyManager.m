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
    AWNSTypeBOOL,
    AWNSTypeNSNull,
};

@implementation ParsePropertyManager

+ (AWNSType)getPropertyNSType:(Class)class{
    
    if (!class) return AWNSTypeNSUnknown;
    if ([class isSubclassOfClass:[@(YES) class]]) return AWNSTypeBOOL;
    if ([class isSubclassOfClass:[NSNull class]]) return AWNSTypeNSNull;
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
    if ([class isSubclassOfClass:[@(YES) class]]) return AWNSTypeBOOL;
    if ([class isSubclassOfClass:[NSNull class]]) return AWNSTypeNSNull;
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
            typeStr = @"NSString *";
        }
            break;
        case AWNSTypeNSNumber:
        case AWNSTypeNSDecimalNumber:{
            qualifierStr = @"assign";
            
            NSNumber *valueNumber = (NSNumber *)value;
            if([valueNumber intValue] == [valueNumber doubleValue]){
                if ([valueNumber longLongValue] < NSIntegerMax && [valueNumber longLongValue] > NSIntegerMin) {
                    typeStr = @"NSInteger ";
                }
                else{
                    typeStr = @"long long ";
                }
                
            }else{
                if([valueNumber doubleValue] < CGFLOAT_MAX && [valueNumber doubleValue] > CGFLOAT_MIN) {
                    typeStr = @"CGFloat ";
                }
                else{
                    typeStr = @"double ";
                }
            }
            break;
        }
        case AWNSTypeNSArray:
        case AWNSTypeNSMutableArray:{
            //TODO:支持泛型集合
            qualifierStr = @"strong";
            typeStr = @"NSArray *";
            break;
        }
        case AWNSTypeNSDictionary:
        case AWNSTypeNSMutableDictionary:{
            //TODO:支持泛型集合
            //TODO:支持解析为其他类数据
            qualifierStr = @"strong";
            typeStr = @"NSDictionary *";
            break;
        }
        case AWNSTypeBOOL:{
            qualifierStr = @"assign";
            typeStr = @"BOOL ";
            break;
        }
        case AWNSTypeNSNull:{
            qualifierStr = @"strong";
            typeStr = @"id ";
            break;
        }
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"@property (nonatomic, %@) %@%@;",qualifierStr,typeStr,key];
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
