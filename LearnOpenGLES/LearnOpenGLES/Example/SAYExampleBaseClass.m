//
//  SAYExampleBaseClass.m
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import "SAYExampleBaseClass.h"

@implementation SAYExampleBaseClass
- (BOOL)useCamera {
    return NO;
}

- (void)parpareDrawWithCamera:(SAYCamera *) camera inView:(GLKView *) view {
    NSLog(@"%@", @"you should support your draw logic");
}

- (void)drawWithCamera:(SAYCamera *) camera inView:(GLKView *) view {
    NSLog(@"%@", @"you should support your draw cycle");
}

- (void)drawFinished {
    
}


@end
