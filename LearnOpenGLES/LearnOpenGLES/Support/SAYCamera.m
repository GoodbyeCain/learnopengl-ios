//
//  SAYCamera.m
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import "SAYCamera.h"

// Defines several possible options for camera movement. Used as abstraction to stay away from window-system specific input methods


// Default camera values
const float YAW         = -90.0f;
const float PITCH       =  0.0f;
const float SPEED       =  2.5f;
const float SENSITIVITY =  0.1f;
const float ZOOM        =  45.0f;

@implementation SAYCamera

- (void)updateCameraVectors {
    // Calculate the new Front vector
    GLKVector3 front;
    
    front.x = cos(GLKMathDegreesToRadians(Yaw)) * cos(GLKMathDegreesToRadians(Pitch));
    front.y = sin(GLKMathDegreesToRadians(Pitch));
    front.z = sin(GLKMathDegreesToRadians(Yaw)) * cos(GLKMathDegreesToRadians(Pitch));
    Front = GLKVector3Normalize(front);
    // Also re-calculate the Right and Up vector
    
    Right = GLKVector3Normalize(GLKVector3CrossProduct(Front, WorldUp));
    Up    = GLKVector3Normalize(GLKVector3CrossProduct(Right, Front));
    
}


+ (SAYCamera *)defaultCamera {
    SAYCamera *camera = [[SAYCamera alloc] init];
    camera->Position = GLKVector3Make(0.0, 0.0, 0.0);
    camera->WorldUp = GLKVector3Make(0.0, 1.0, 0.0);
    camera->Yaw = YAW;
    camera->Pitch = PITCH;
    camera->Front = GLKVector3Make(0.0, 0.0, -1.0);
    camera->MovementSpeed = SPEED;
    camera->MouseSensitivity = SENSITIVITY;
    camera->Zoom = ZOOM;
    [camera updateCameraVectors];
    return camera;
}

- (GLKMatrix4)viewMatrix {
    GLKVector3 center = GLKVector3Add(Position, Front);
    return GLKMatrix4MakeLookAt(Position.x, Position.y, Position.z, center.x, center.y, center.z, Up.x, Up.y, Up.z);
}

- (float)fovyRadians {
    return GLKMathDegreesToRadians(self->Zoom);
}

- (void)processKeyboard:(Camera_Movement) direction withTime:(float) deltaTime
{
    float velocity = MovementSpeed * deltaTime;
    if (direction == FORWARD)
        Position = GLKVector3Add(Position, GLKVector3MultiplyScalar(Front, velocity));
    if (direction == BACKWARD)
        Position = GLKVector3Subtract(Position, GLKVector3MultiplyScalar(Front, velocity));
    if (direction == LEFT)
        Position = GLKVector3Subtract(Position, GLKVector3MultiplyScalar(Right, velocity));
    if (direction == RIGHT)
        Position = GLKVector3Add(Position, GLKVector3MultiplyScalar(Right, velocity));
}

- (void)processRotate:(float) xoffset yoffset:(float) yoffset {
    xoffset *= MouseSensitivity;
    yoffset *= MouseSensitivity;
    
    Yaw   += xoffset;
    Pitch += yoffset;
    
    // Make sure that when pitch is out of bounds, screen doesn't get flipped
    //    if (constrainPitch)
    //    {
    //        if (Pitch > 89.0f)
    //            Pitch = 89.0f;
    //        if (Pitch < -89.0f)
    //            Pitch = -89.0f;
    //    }
    
    // Update Front, Right and Up Vectors using the updated Euler angles
    [self updateCameraVectors];
}

@end
