//
//  AppDelegate.m
//  Alpha Channel Remover
//
//  Created by polat on 18/09/14.
//  Copyright (c) 2014 polat. All rights reserved.
//

#import "AppDelegate.h"
#import "Drag.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dragNotification:)
                                                 name:@"dragNotification"
                                               object:nil];


}

    
-(void)converter:(NSString*)name{
        NSLog(@"NAME: %@",name);

        NSURL *url = [NSURL fileURLWithPath:name];
        CGImageSourceRef source;
        NSImage *srcImage =[[NSImage alloc] initWithContentsOfURL:url];;
        NSLog(@"URL: %@",url);
        source = CGImageSourceCreateWithData((__bridge CFDataRef)[srcImage TIFFRepresentation], NULL);
        CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
        CGRect rect = CGRectMake(0.f, 0.f, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
        CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                           rect.size.width,
                                                           rect.size.height,
                                                           CGImageGetBitsPerComponent(imageRef),
                                                           CGImageGetBytesPerRow(imageRef),
                                                           CGImageGetColorSpace(imageRef),
                                                           kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Little
                                                           );
        
        CGContextDrawImage(bitmapContext, rect, imageRef);
        
        CGImageRef decompressedImageRef = CGBitmapContextCreateImage(bitmapContext);
        
        NSImage *finalImage = [[NSImage alloc] initWithCGImage:decompressedImageRef size:NSZeroSize];
        NSData *imageData = [finalImage  TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
        imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
        [imageData writeToFile:name atomically:NO];
        
        
        
        CGImageRelease(decompressedImageRef);
        CGContextRelease(bitmapContext);
        

    
    }
    
    
    
    

- (IBAction)start:(id)sender {

 
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *array = [prefs objectForKey:@"fileNames"];
    
    if (array.count==0) {
        return;
    }
    
    NSLog(@"%@",array);
    
    
    for (int i= 0; i<array.count; i++) {
        
        NSString *name =  [array objectAtIndex:i];
        [self converter:name];
    }
    
    
    [prefs setObject:nil forKey:@"fileNames"];
   [_label setStringValue:@"Completed"];
    
}


- (void) dragNotification:(NSNotification *) notification{
    
    _explanationLabel.hidden= YES;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *array = [prefs objectForKey:@"fileNames"];
    
    [_label setStringValue:[NSString stringWithFormat:@"Total Files : %lu",(unsigned long)array.count]];
    NSLog(@"Posted");
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
}



@end
