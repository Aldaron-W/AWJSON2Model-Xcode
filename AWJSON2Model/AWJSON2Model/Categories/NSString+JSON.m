//
//  NSString+JSON.m
//  AWJSON2Model
//
//  Created by AldaronWang on 16/6/6.
//  Copyright © 2016年 Aldaron. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

/**
 *	parse sender to json object
 *
 *	@return	NSArray or NSDictionary
 */
- (id)jsonObjectWithError:(NSError **)error{
    return [NSString parseJsonString:self error:error];
}

/**
 *	parse sender to mutable json object
 *
 *	@return	NSMutableArray or NSMutableDictionary
 */
- (id)jsonMutableObjectWithError:(NSError **)error{
    return [NSString mutableParseJsonString:self error:error];
}

+ (id)mutableParseJsonData:(NSData*)data error:(NSError **)error{
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
}

+ (id)mutableParseJsonString:(NSString*)jsonStr error:(NSError **)error{
    return [self mutableParseJsonData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] error:error];
}

+ (id)parseJsonData:(NSData*)data error:(NSError **)error{
    if (data)
    {
        return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
    }
    
    return nil;
}

+ (id)parseJsonString:(NSString *)jsonStr error:(NSError **)error{
    return [self parseJsonData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] error:error];
}

+ (NSData*)dataEncodingJsonObject:(id)obj{
    return [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:nil];
}

+ (NSString*)stringEncodingJsonObject:(id)obj{
    if (!obj)
    {
        return nil;
    }
    NSData *jsonRawData = [self dataEncodingJsonObject:obj];
    return [[NSString alloc] initWithData:jsonRawData encoding:NSUTF8StringEncoding];
}
@end
