//
//  AWJ2PController.m
//  AWJSON2Model
//
//  Created by Work on 16/6/5.
//  Copyright © 2016年 Aldaron. All rights reserved.
//

#import "AWJ2PController.h"
#import "NSString+JSON.h"

@interface AWJ2PController ()
@property (unsafe_unretained) IBOutlet NSTextView *jsonInputView;
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
    id jsonObject = [jsonText jsonObjectWithError:&error];
    if (!error) {
        NSLog(@"%@", jsonObject);
    }
    else{
        NSLog(@"%@", error);
    }
}

@end
