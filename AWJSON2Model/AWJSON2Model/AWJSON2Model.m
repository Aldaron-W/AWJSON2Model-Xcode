//
//  AWJSON2Model.m
//  AWJSON2Model
//
//  Created by AldaronWang on 16/6/3.
//  Copyright © 2016年 Aldaron. All rights reserved.
//

#import "AWJSON2Model.h"
#import "AWJ2PController.h"

static AWJSON2Model *sharedPlugin;

@interface AWJSON2Model ()

@property (nonatomic, strong) AWJ2PController *j2pController;

@end

@implementation AWJSON2Model

#pragma mark - Initialization

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSArray *allowedLoaders = [plugin objectForInfoDictionaryKey:@"me.delisa.XcodePluginBase.AllowedLoaders"];
    if ([allowedLoaders containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
        sharedPlugin = [[self alloc] initWithBundle:plugin];
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)bundle
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        _bundle = bundle;
        // NSApp may be nil if the plugin is loaded from the xcodebuild command line tool
        if (NSApp && !NSApp.mainMenu) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationDidFinishLaunching:)
                                                         name:NSApplicationDidFinishLaunchingNotification
                                                       object:nil];
        } else {
            [self initializeAndLog];
        }
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    [self initializeAndLog];
}

- (void)initializeAndLog
{
    NSString *name = [self.bundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *version = [self.bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *status = [self initialize] ? @"loaded successfully" : @"failed to load";
    NSLog(@"🔌 Plugin %@ %@ %@", name, version, status);
}

#pragma mark - Implementation

- (BOOL)initialize
{
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
//    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
//    if (menuItem) {
//        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
//        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@""];
//        //[actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
//        [actionMenuItem setTarget:self];
//        [[menuItem submenu] addItem:actionMenuItem];
//        return YES;
//    } else {
//        return NO;
//    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (menuItem) {
        
        NSMenu *menu = [[NSMenu alloc] init];
        
        //AW JSON to Property window
        //展现JSON转换为Property的界面
        NSMenuItem *inputJsonWindow = [[NSMenuItem alloc] initWithTitle:@"AW JSON to Property window" action:@selector(showJ2PWindow:) keyEquivalent:@"J"];
        [inputJsonWindow setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        inputJsonWindow.target = self;
        [menu addItem:inputJsonWindow];
        
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"AWJSON2Model" action:nil keyEquivalent:@""];
        item.submenu = menu;
        
        [[menuItem submenu] addItem:item];
        return YES;
    }
    return NO;
}

/**
 *  展现JSON转换为Property的界面
 *
 *  @param item 点击目录的按钮Item
 */
- (void)showJ2PWindow:(NSMenuItem *)item{
    self.j2pController = [[AWJ2PController alloc] initWithWindowNibName:@"AWJ2PController"];
    [self.j2pController showWindow:self.j2pController];
}

// Sample Action, for menu item:
- (void)doMenuAction
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Hello, World"];
    [alert runModal];
}

@end
