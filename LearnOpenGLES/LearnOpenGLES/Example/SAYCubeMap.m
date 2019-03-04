//
//  SAYCubeMap.m
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/3/4.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import "SAYCubeMap.h"
#import "SAYUtil.h"

@interface SAYCubeMap ()
@property (nonatomic, copy) void(^drawCycle)(void);
@property (nonatomic, copy) void(^resourceClean)(void);
@end

@implementation SAYCubeMap

- (GLubyte *)createImageDataWithName:(NSString *) name format:(GLenum *) format width:(size_t *) width height:(size_t *) height {
    UIImage *image = [UIImage imageNamed:name];
    CGImageRef newImageSource = image.CGImage;
    *width = CGImageGetWidth(newImageSource);
    *height = CGImageGetHeight(newImageSource);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(newImageSource);
    size_t bytesPerPixel = bytesPerRow / *width;
    *format = GL_RGBA;
    GLubyte * imageData;
    if (bytesPerPixel != 4) {
        imageData = (GLubyte *) calloc(1, (*width) * (*height) * 4);
        CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef imageContext = CGBitmapContextCreate(imageData, (size_t)width, (size_t)height, 8, (*width) * 4, genericRGBColorspace,  kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        CGContextDrawImage(imageContext, CGRectMake(0.0, 0.0, *width, *height), newImageSource);
        CGContextRelease(imageContext);
        CGColorSpaceRelease(genericRGBColorspace);
    } else {
        CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(newImageSource));
        imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    }
    return imageData;
}

- (GLuint)loadCubeMap:(NSArray *) mapNames {
    GLuint textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_CUBE_MAP, textureID);
    
    NSArray *textureName = mapNames;
    for (int i = 0; i < textureName.count; i++) {
        GLenum format;
        size_t width, height;
        GLubyte *data = [self createImageDataWithName:textureName[i] format:&format width:&width height:&height];
        if (data) {
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, format, (GLsizei)width, (GLsizei)height, 0, format, GL_UNSIGNED_BYTE, data);
        } else {
            NSLog(@"cube map data not exist %d", i);
        }
        
        free(data);
    }
    
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE);
    return textureID;
}

- (BOOL)useCamera {
    return YES;
}

- (void)parpareDrawWithCamera:(SAYCamera *)camera inView:(GLKView *)view {

    glEnable(GL_DEPTH_TEST);
    
    // set up vertex data (and buffer(s)) and configure vertex attributes
    // ------------------------------------------------------------------
    float cubeVertices[] = {
        // positions          // texture Coords
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
        0.5f, -0.5f, -0.5f,  1.0f, 0.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
        
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f,  0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        
        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  1.0f, 1.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f
    };
    float skyboxVertices[] = {
        // positions
        -1.0f,  1.0f, -1.0f,
        -1.0f, -1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,
        1.0f,  1.0f, -1.0f,
        -1.0f,  1.0f, -1.0f,
        
        -1.0f, -1.0f,  1.0f,
        -1.0f, -1.0f, -1.0f,
        -1.0f,  1.0f, -1.0f,
        -1.0f,  1.0f, -1.0f,
        -1.0f,  1.0f,  1.0f,
        -1.0f, -1.0f,  1.0f,
        
        1.0f, -1.0f, -1.0f,
        1.0f, -1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,
        
        -1.0f, -1.0f,  1.0f,
        -1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f, -1.0f,  1.0f,
        -1.0f, -1.0f,  1.0f,
        
        -1.0f,  1.0f, -1.0f,
        1.0f,  1.0f, -1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        -1.0f,  1.0f,  1.0f,
        -1.0f,  1.0f, -1.0f,
        
        -1.0f, -1.0f, -1.0f,
        -1.0f, -1.0f,  1.0f,
        1.0f, -1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,
        -1.0f, -1.0f,  1.0f,
        1.0f, -1.0f,  1.0f
    };
    
    // cube VAO
    GLuint cubeVAO, cubeVBO;
    glGenVertexArrays(1, &cubeVAO);
    glGenBuffers(1, &cubeVBO);
    glBindVertexArray(cubeVAO);
    glBindBuffer(GL_ARRAY_BUFFER, cubeVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cubeVertices), &cubeVertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
    // skybox VAO
    GLuint skyboxVAO, skyboxVBO;
    glGenVertexArrays(1, &skyboxVAO);
    glGenBuffers(1, &skyboxVBO);
    glBindVertexArray(skyboxVAO);
    glBindBuffer(GL_ARRAY_BUFFER, skyboxVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(skyboxVertices), &skyboxVertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    
    GLuint cubeTexture = [SAYUtil uploadImageWithName:@"marble"];
    
    
    NSArray *faces = @[
                       @"right",
                       @"left",
                       @"top",
                       @"bottom",
                       @"front",
                       @"back"
                       ];
    GLuint cubemapTexture = [self loadCubeMap:faces];
    
    
    SAYShader *cubemapShader = [[SAYShader alloc] initWithVertexShaderFileName:@"cubemap"
                                                        fragmentShaderFileName:@"cubemap"];
    SAYShader *skyboxShader = [[SAYShader alloc] initWithVertexShaderFileName:@"skybox"
                                                       fragmentShaderFileName:@"skybox"];
    
    [cubemapShader use];
    [cubemapShader uniform1i:@"texture1" value:0];
    
    [skyboxShader use];
    [skyboxShader uniform1i:@"skybox" value:0];
    
    camera->Position = GLKVector3Make(0, 0, 5);
    self.drawCycle = ^{
        // render
        // ------
        glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        // draw scene as normal
        [cubemapShader use];
        GLKMatrix4 model = GLKMatrix4Identity;
        GLKMatrix4 view = [camera viewMatrix];
        GLKMatrix4 projection = GLKMatrix4MakePerspective(camera.fovyRadians, (float)SCR_WIDTH / (float)SCR_HEIGHT, 0.1, 100.0f);
        
        [cubemapShader uniformMat4:@"model" mat:model];
        [cubemapShader uniformMat4:@"view" mat:view];
        [cubemapShader uniformMat4:@"projection" mat:projection];
        
        // cubes
        glBindVertexArray(cubeVAO);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, cubeTexture);
        glDrawArrays(GL_TRIANGLES, 0, 36);
        glBindVertexArray(0);
        
        // draw skybox as last
        glDepthFunc(GL_LEQUAL);  // change depth function so depth test passes when values are equal to depth buffer's content
        [skyboxShader use];
        
        GLKMatrix3 view3 = GLKMatrix4GetMatrix3([camera viewMatrix]);
        view = GLKMatrix4Make(view3.m00, view3.m01, view3.m02, 0,
                              view3.m10, view3.m11, view3.m12, 0,
                              view3.m20, view3.m21, view3.m22, 0,
                              0,         0,         0,         0);
        [skyboxShader uniformMat4:@"view" mat:view];
        [skyboxShader uniformMat4:@"projection" mat:projection];
        // skybox cube
        glBindVertexArray(skyboxVAO);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_CUBE_MAP, cubemapTexture);
        glDrawArrays(GL_TRIANGLES, 0, 36);
        glBindVertexArray(0);
        glDepthFunc(GL_LESS); // set depth function back to default
    };
    
    self.resourceClean = ^{
        glDeleteVertexArrays(1, &cubeVAO);
        glDeleteBuffers(1, &cubeVBO);
        
        glDeleteVertexArrays(1, &skyboxVAO);
        glDeleteBuffers(1, &skyboxVBO);
        
        glDeleteTextures(1, &cubeTexture);
        glDeleteTextures(1, &cubemapTexture);
    };
}

- (void)drawWithCamera:(SAYCamera *)camera inView:(GLKView *)view {
    if (self.drawCycle) {
        self.drawCycle();
    }
}

- (void)drawFinished {
    if (self.drawCycle) {
        self.drawCycle = NULL;
    }
    if (self.resourceClean) {
        self.resourceClean();
        self.resourceClean = NULL;
    }
}

@end
