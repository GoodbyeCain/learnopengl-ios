//
//  SAYMoveView.m
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import "SAYMoveView.h"

const float kButtonWidth = 40.0;
const float kButtonHeight = 40.0;

@implementation SAYMoveView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.0 alpha:0.2];
        
        float rect[16] = {
            kButtonWidth, 0, kButtonWidth, kButtonHeight,
            0, kButtonHeight, kButtonWidth, kButtonHeight,
            kButtonWidth, kButtonHeight, kButtonWidth, kButtonHeight,
            kButtonWidth * 2, kButtonHeight, kButtonWidth, kButtonHeight,
        };
        NSArray *titles = @[@"W", @"A", @"S", @"D"];
        for (int i = 0; i < 4; i++) {
            UIButton *wButton = [UIButton buttonWithType:UIButtonTypeCustom];
            wButton.frame = CGRectMake(rect[4 * i],
                                       rect[4 * i + 1],
                                       rect[4 * i + 2],
                                       rect[4 * i + 3]);
            wButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
            [wButton setTitle:titles[i] forState:UIControlStateNormal];
            wButton.tag = i;
            [wButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:wButton];
        }
    }
    return self;
}

- (void)buttonPressed:(UIButton *) button {
    if ([self.delegate respondsToSelector:@selector(movePressedWithTag:)]) {
        [self.delegate movePressedWithTag:button.tag];
    }
}

@end
