//
//  SAYExampleProtocol.h
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import <GLKit/GLKit.h>
#import "SAYShader.h"
#import "SAYCamera.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SAYExampleProtocol <NSObject>

@optional
- (BOOL)useCamera;

@required
- (void)parpareDrawWithCamera:(SAYCamera *) camera inView:(GLKView *) view;
- (void)drawWithCamera:(SAYCamera *) camera inView:(GLKView *) view;
- (void)drawFinished;

@end

NS_ASSUME_NONNULL_END
