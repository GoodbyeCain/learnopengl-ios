//
//  SAYGLKViewController.m
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import "SAYGLKViewController.h"
#import "SAYCamera.h"
#import "SAYMoveView.h"
#import "SAYShader.h"
#import "SAYUtil.h"

@interface SAYGLKViewController ()<SAYMoveViewDelegate>
@end

@implementation SAYGLKViewController {
    SAYCamera *_camera;
    BOOL _rotateStart;
    CGPoint _rotateStartPoint;
    CGPoint _lastPoint;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = NSStringFromClass(self.drawInstance.class);
    
    [self configGLEnvironment];
    if ([self.drawInstance respondsToSelector:@selector(startDrawLogic:inView:)]) {
        [self.drawInstance startDrawLogic:_camera inView:(GLKView *)self.view];
    }
}

- (void)dealloc {
    if (self.drawInstance.resourcesClean) {
        self.drawInstance.resourcesClean();
    }
}

- (void)configGLEnvironment {
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    [EAGLContext setCurrentContext:view.context];
    
    if ([self.drawInstance useCamera]) {
        CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        SAYMoveView *moveView = [[SAYMoveView alloc] initWithFrame:CGRectMake(50, screenHeight - 120, 120, 80)];
        moveView.delegate = self;
        [self.view addSubview:moveView];
        
        _camera = [SAYCamera defaultCamera];
        _camera->Position = GLKVector3Make(0, 0, 3);
    }
}


#pragma mark - draw cycle
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    if (self.drawInstance.drawCycle ) {
        self.drawInstance.drawCycle();
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self.view];
    if (point.x > CGRectGetWidth(self.view.bounds) / 2.0) {
        _rotateStart = YES;
        _rotateStartPoint = point;
        _lastPoint = point;
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    CGPoint curr = [touches.anyObject locationInView:self.view];
    if (_rotateStart) {
        if (!CGPointEqualToPoint(_lastPoint, CGPointZero)) {
            CGFloat offsetX = curr.x - _lastPoint.x;
            CGFloat offsetY = curr.y - _lastPoint.y;
            [_camera processRotate:offsetX yoffset:-offsetY];
            _lastPoint = curr;
        }
    }
    
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    _rotateStart = NO;
    _lastPoint = CGPointZero;
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    _rotateStart = NO;
    _lastPoint = CGPointZero;
}

#pragma mark - SAYMoveViewDelegate
- (void)movePressedWithTag:(NSInteger)tag {
    float time = 0.02;
    if (tag == 0) {
        [_camera processKeyboard:FORWARD withTime:time];
    } else if(tag == 1) {
        [_camera processKeyboard:LEFT withTime:time];
    } else if(tag == 2) {
        [_camera processKeyboard:BACKWARD withTime:time];
    } else {
        [_camera processKeyboard:RIGHT withTime:time];
    }
}
@end
