//
//  RunsDrawingBoardOperatingProtocol.h
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RunsBrushProtocol,RunsDrawingBoardViewDelegate;
@protocol RunsDrawingBoardOperatingProtocol <NSObject>

/**
 撤销 cmd + z

 @param canRedo Yes : 可以撤销 ，No : 就是直接删除了
 */
- (void)undo:(BOOL)canRedo;

/**
 返回 重做 取消撤销 cmd + shift + z
 */
- (void)redo;

/**
 清屏
 */
- (void)clear;

@end
