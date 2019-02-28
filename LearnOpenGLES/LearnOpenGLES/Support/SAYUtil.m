//
//  SAYUtil.m
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import "SAYUtil.h"

@implementation SAYUtil
+ (GLuint)uploadImageWithName:(NSString *) name{
    UIImage *image = [UIImage imageNamed:name];
    if (!image) {
        NSLog(@"image data not exist:%@", name);
    }
    
    CGImageRef newImageSource = image.CGImage;
    unsigned int width = (unsigned int)CGImageGetWidth(newImageSource);
    unsigned int height = (unsigned int)CGImageGetHeight(newImageSource);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(newImageSource);
    size_t bytesPerPixel = bytesPerRow / width;
    GLenum format = GL_RGBA;
    GLubyte * imageData;
    if (bytesPerPixel == 2) {
        imageData = (GLubyte *) calloc(1, (int)width * (int)height * 4);
        size_t bitsPerCompoent = CGImageGetBitsPerComponent(newImageSource);
        size_t bytesPerRow = CGImageGetBytesPerRow(newImageSource);
        CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef imageContext = CGBitmapContextCreate(imageData, (size_t)width, (size_t)height, 8, width * 4, genericRGBColorspace,  kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        //        CGContextSetBlendMode(imageContext, kCGBlendModeCopy); // From Technical Q&A QA1708: http://developer.apple.com/library/ios/#qa/qa1708/_index.html
        CGContextDrawImage(imageContext, CGRectMake(0.0, 0.0, width, height), newImageSource);
        CGContextRelease(imageContext);
        CGColorSpaceRelease(genericRGBColorspace);
    } else {
        CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(newImageSource));
        imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    }
    
    GLuint texture;
    glGenTextures(1, &texture);
    
    //[image hj_setupTexture:&texture];
    glBindTexture(GL_TEXTURE_2D, texture); // all upcoming GL_TEXTURE_2D operations now have effect on this texture object
    // set the texture wrapping parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);    // set texture wrapping to GL_REPEAT (default wrapping method)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    // set texture filtering parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    // load image, create texture and generate mipmaps
    // The FileSystem::getPath(...) is part of the GitHub repository so we can find files on any IDE/platform; replace it with your own image path.
    
    if (imageData)
    {
        glTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, format, GL_UNSIGNED_BYTE, imageData);
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    else
    {
        NSLog(@"%@", @"Failed to load texture");
    }
    free(imageData);
    
    return texture;
}
@end
