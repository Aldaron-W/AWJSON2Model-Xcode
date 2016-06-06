//
//  AWJ2PController.m
//  AWJSON2Model
//
//  Created by Work on 16/6/5.
//  Copyright © 2016年 Aldaron. All rights reserved.
//

#import "AWJ2PController.h"
#import "NSString+JSON.h"
#import "ParsePropertyManager.h"

@interface AWJ2PController ()<NSOutlineViewDelegate, NSOutlineViewDataSource>
@property (unsafe_unretained) IBOutlet NSTextView *resultView;
@property (unsafe_unretained) IBOutlet NSTextView *jsonInputView;
@property (weak) IBOutlet NSClipView *jsonOutlineView;

@property (weak) IBOutlet NSButton *biuBtn;
@property (weak) IBOutlet NSButton *cancelBtn;

@end

@implementation AWJ2PController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)touchBiuBtn:(id)sender {
    NSString *jsonText = _jsonInputView.string;
    
    NSError *error = nil;
    id jsonObject = [jsonText jsonObjectWithError:&error];
    if (!error) {
        NSLog(@"%@", jsonObject);
    }
    
}

-(void)textDidChange:(NSNotification *)notification{
    NSTextView *textView = notification.object;
    
    NSString *jsonText = textView.string;
    NSError *error = nil;
    NSDictionary *jsonObject = [jsonText jsonObjectWithError:&error];
    if (!error) {
        NSMutableString *resultStr = [NSMutableString string];
        [jsonObject enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [resultStr appendFormat:@"\n%@\n",[ParsePropertyManager formatObjcWithKey:key value:obj]];
        }];
        
        [_resultView setString:resultStr];
        NSLog(@"%@", resultStr);
    }
    else{
        [_resultView setString:[error description]];
        NSLog(@"%@", error);
    }
}

#pragma mark - Outline View
//- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
//    
//}

@end
