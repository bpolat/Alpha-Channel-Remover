//
//  AppDelegate.h
//  Alpha Channel Remover
//
//  Created by polat on 18/09/14.
//  Copyright (c) 2014 polat. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet NSTextField *explanationLabel;

@end
