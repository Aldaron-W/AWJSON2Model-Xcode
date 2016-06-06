//
//  NSString+JSON.h
//  AWJSON2Model
//
//  Created by AldaronWang on 16/6/6.
//  Copyright © 2016年 Aldaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

/**
 *	parse sender to json object
 *
 *	@return	NSArray or NSDictionary
 */
- (id)jsonObjectWithError:(NSError **)error;

/**
 *	parse sender to mutable json object
 *
 *	@return	NSMutableArray or NSMutableDictionary
 */
- (id)jsonMutableObjectWithError:(NSError **)error;

@end
