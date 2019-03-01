//
//  SAYShader.m
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import "SAYShader.h"

@interface SAYShader ()
@property (nonatomic, assign) GLuint program;
@end

@implementation SAYShader

- (void)dealloc {
    if (_program) {
        glDeleteProgram(_program);
    }
}

- (instancetype)initWithVertexShaderString:(NSString *) vShaderString
                      fragmentShaderString:(NSString *) fShaderString {
    self = [super init];
    if (self) {
        _program = glCreateProgram();
        
        GLuint vertexShader, fragmentShader;
        if (![self compileShader:&vertexShader
                            type:GL_VERTEX_SHADER
                          string:vShaderString]) {
            NSLog(@"compile vertex shader failed");
            return nil;
        }
        
        if (![self compileShader:&fragmentShader
                            type:GL_FRAGMENT_SHADER
                          string:fShaderString]) {
            NSLog(@"compile fragment shader failed");
            return nil;
        }
        
        glAttachShader(_program, vertexShader);
        glAttachShader(_program, fragmentShader);
        
        glLinkProgram(_program);
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
    }
    return self;
}

- (instancetype)initWithVertexShaderFileName:(NSString *) vShaderFileName
                      fragmentShaderFileName:(NSString *) fShaderFileName {
    NSString *vFullPath = [[NSBundle mainBundle] pathForResource:vShaderFileName
                                                          ofType:@"vsh"];
    NSString *vShaderString = [NSString stringWithContentsOfFile:vFullPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
    NSString *fFullPath = [[NSBundle mainBundle] pathForResource:fShaderFileName
                                                          ofType:@"fsh"];
    NSString *fShaderString = [NSString stringWithContentsOfFile:fFullPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
    
    return [self initWithVertexShaderString:vShaderString fragmentShaderString:fShaderString];
}

- (BOOL)compileShader:(GLuint *)shader
                 type:(GLenum)type
               string:(NSString *)shaderString {
    
    const GLchar *source = (GLchar *)[shaderString UTF8String];
    if (!source) {
        NSLog(@"%@ shader string is empty", type == GL_VERTEX_SHADER ? @"vertex" : @"fragment");
        return NO;
    }
    
    GLint status;
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status != GL_TRUE) {
        GLint logLength;
        glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0)  {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetShaderInfoLog(*shader, logLength, &logLength, log);
            NSLog(@"%@", [NSString stringWithFormat:@"%s", log]);
            free(log);
        }
    }
    return YES;
}

- (void)use {
    glUseProgram(_program);
}

- (GLuint)uniformIndex:(NSString *)uniformName {
    return glGetUniformLocation(_program, [uniformName UTF8String]);
}

- (void)uniformMat4:(NSString *) identifier mat:(GLKMatrix4) mat {
    GLuint location = [self uniformIndex:identifier];
    glUniformMatrix4fv(location, 1, GL_FALSE, (GLfloat *)&mat);
}

- (void)uniform1i:(NSString *) identifier value:(GLint) value {
    GLuint location = [self uniformIndex:identifier];
    glUniform1i(location, value);
}

- (void)uniform1f:(NSString *) identifier value:(GLfloat) value {
    GLuint location = [self uniformIndex:identifier];
    glUniform1f(location, value);
}

- (void)uniform4f:(NSString *) identifier x:(GLfloat) x y:(GLfloat) y z:(GLfloat) z w:(GLfloat) w {
    GLuint location = [self uniformIndex:identifier];
    glUniform4f(location, x, y, z, w);
}

@end
