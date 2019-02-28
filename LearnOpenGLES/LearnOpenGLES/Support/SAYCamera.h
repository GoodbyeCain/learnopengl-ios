//
//  SAYCamera.h
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FORWARD,
    BACKWARD,
    LEFT,
    RIGHT
} Camera_Movement;

@interface SAYCamera : NSObject {
@public
    GLKVector3 Position;
    GLKVector3 Front;
    GLKVector3 Up;
    GLKVector3 Right;
    GLKVector3 WorldUp;
    // Euler Angles
    float Yaw;
    float Pitch;
    // Camera options
    float MovementSpeed;
    float MouseSensitivity;
    float Zoom;
}

+ (SAYCamera *)defaultCamera;
- (GLKMatrix4)viewMatrix;
- (float)fovyRadians;
- (void)processKeyboard:(Camera_Movement) direction withTime:(float) deltaTime;
- (void)processRotate:(float) xoffset yoffset:(float) yoffset;
@end

NS_ASSUME_NONNULL_END
