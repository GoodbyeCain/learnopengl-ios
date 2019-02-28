//
//  SAYMoveView.h
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SAYMoveViewDelegate <NSObject>

- (void)movePressedWithTag:(NSInteger) tag;

@end

@interface SAYMoveView : UIView
@property (nonatomic, weak) id<SAYMoveViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
