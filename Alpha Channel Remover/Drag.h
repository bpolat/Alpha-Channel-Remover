
#import <AppKit/AppKit.h>

@interface Drag : NSImageView <NSDraggingSource, NSDraggingDestination, NSPasteboardItemDataProvider> {
    
    BOOL highlight;
}


@property (nonatomic,strong) NSMutableArray *fileNames;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
