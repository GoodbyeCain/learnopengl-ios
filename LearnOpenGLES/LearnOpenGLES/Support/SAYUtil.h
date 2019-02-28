//
//  SAYUtil.h
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import <GLKit/GLKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SAYUtil : NSObject
+ (GLuint)uploadImageWithName:(NSString *) name;
@end

NS_ASSUME_NONNULL_END
