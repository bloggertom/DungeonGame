//
//  UIImage+Pixel.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  
//
/*
 Code copied from Matej Bukovinski's answer at http://stackoverflow.com/questions/144250/
 */
#import "UIImage+Pixel.h"

@implementation UIImage (Pixel)

- (RGBAPixel)colorAtPosition:(CGPoint)position {
	
    CGRect sourceRect = CGRectMake(position.x, position.y, 1.f, 1.f);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, sourceRect);
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *buffer = malloc(4);
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    CGContextRef context = CGBitmapContextCreate(buffer, 1, 1, 8, 4, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0.f, 0.f, 1.f, 1.f), imageRef);
    CGImageRelease(imageRef);
    CGContextRelease(context);
	
	RGBAPixel pixel;
	
    pixel.red = buffer[0];
    pixel.green = buffer[1];
    pixel.blue = buffer[2];
    pixel.alpha= buffer[3];
	
    free(buffer);
	
    return pixel;
}

@end
