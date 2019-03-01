//
//  SAYGLKViewController.h
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "SAYExampleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SAYGLKViewController : GLKViewController
@property (nonatomic, strong) id<SAYExampleProtocol> drawInstance;
@end

NS_ASSUME_NONNULL_END
