//
//  RunsDrawingBoardViewDelegate.h
//  DrawingBoard
//
//  Created by runs on 2017/8/16.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// RunsDrawingBoardViewProtocol 这里不知道为什么又不需要导入任何头文件或者引用就能编译通过 FUCK Xcode

@protocol RunsDrawingBoardViewDelegate <NSObject>
- (void)drawingBoardView:(id<RunsDrawingBoardViewProtocol>)boardView didBeganPoint:(CGPoint)point;
- (void)drawingBoardView:(id<RunsDrawingBoardViewProtocol>)boardView didMovedPoint:(CGPoint)point;
- (void)drawingBoardView:(id<RunsDrawingBoardViewProtocol>)boardView didEndedPoint:(CGPoint)point brush:(id<RunsBrushProtocol>)brush;
@end
