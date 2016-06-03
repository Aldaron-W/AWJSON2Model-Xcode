//
//  AWJSON2Model.h
//  AWJSON2Model
//
//  Created by AldaronWang on 16/6/3.
//  Copyright © 2016年 Aldaron. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface AWJSON2Model : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end