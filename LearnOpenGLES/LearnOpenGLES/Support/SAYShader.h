//
//  SAYShader.h
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAYShader : NSObject
- (instancetype)initWithVertexShaderFileName:(NSString *) vShaderFileName
                      fragmentShaderFileName:(NSString *) fShaderFileName;
@property (nonatomic, readonly) GLuint program;
- (void)use;
- (void)uniformMat4:(NSString *) identifier mat:(GLKMatrix4) mat;
- (void)uniform1i:(NSString *) identifier value:(GLint) value;
- (void)uniform1f:(NSString *) identifier value:(GLfloat) value;
- (void)uniform4f:(NSString *) identifier x:(GLfloat) x y:(GLfloat) y z:(GLfloat) z w:(GLfloat) w;
@end

NS_ASSUME_NONNULL_END
