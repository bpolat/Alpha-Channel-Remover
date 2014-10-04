
#import "Drag.h"

@implementation Drag


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self registerForDraggedTypes:[NSImage imagePasteboardTypes]];
    }
    
        return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSLog(@"draggingEntered");
        highlight = YES;
        [self setNeedsDisplay: YES];
        return NSDragOperationLink;
}


- (void)draggingExited:(id<NSDraggingInfo>)sender {
    
    NSLog(@"draggingExited");
    
    highlight = NO;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    
    if (highlight) {
        [[NSColor grayColor]set];
        [NSBezierPath setDefaultLineWidth:10];
        [NSBezierPath strokeRect:dirtyRect];
    }
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    NSLog(@"prepareForDragOperation");
    highlight = NO;
    [self setNeedsDisplay:YES];
    
    
    return  [NSImage canInitWithPasteboard:[sender draggingPasteboard]];
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSLog(@"performDragOperation");
    NSPasteboard* pboard = [sender draggingPasteboard];
    self.fileNames = [pboard propertyListForType:NSFilenamesPboardType];
    return YES;
}


-(void)concludeDragOperation:(id<NSDraggingInfo>)sender{

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.fileNames forKey:@"fileNames"];
    [prefs synchronize];
    NSLog(@"%@",self.fileNames);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"dragNotification"
     object:self];

}

@end
