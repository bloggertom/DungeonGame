//
//  UIImage+Pixel.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  
//

/*
 Code copied from Matej Bukovinski's answer at http://stackoverflow.com/questions/144250/
 */

#import <UIKit/UIKit.h>

typedef struct RGBAPixel{
	Byte red;
	Byte green;
	Byte blue;
	Byte alpha;
}RGBAPixel;

@interface UIImage (Pixel)

- (RGBAPixel)colorAtPosition:(CGPoint)position;

@end
