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

NS_ASSUME_NONNULL_BEGIN

@interface SAYExampleBaseClass : NSObject<SAYExampleProtocol>
@property (nonatomic, copy) void(^drawCycle)(void);
@property (nonatomic, copy) void(^resourcesClean)(void);
@property (nonatomic, strong) SAYShader *shader1;
@property (nonatomic, strong) SAYShader *shader2;
@end

NS_ASSUME_NONNULL_END
