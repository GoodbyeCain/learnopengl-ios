//
//  SAYExampleBaseClass.h
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAYExampleProtocol.h"

#define SCR_WIDTH (CGRectGetWidth([UIScreen mainScreen].bounds) * [UIScreen mainScreen].scale)
#define SCR_HEIGHT (CGRectGetHeight([UIScreen mainScreen].bounds) * [UIScreen mainScreen].scale)


//idea in GPUImage https://github.com/BradLarson/GPUImage
#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

NS_ASSUME_NONNULL_BEGIN

@interface SAYExampleBaseClass : NSObject<SAYExampleProtocol>
@end

NS_ASSUME_NONNULL_END
