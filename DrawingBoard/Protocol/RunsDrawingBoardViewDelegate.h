//
//  RunsDrawingBoardViewDelegate.h
//  DrawingBoard
//
//  Created by runs on 2017/8/16.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RunsDrawingBoardViewProtocol;
@protocol RunsDrawingBoardViewDelegate <NSObject>
- (void)drawingBoardView:(id<RunsDrawingBoardViewProtocol>)boardView didBeganPoint:(CGPoint)point;
- (void)drawingBoardView:(id<RunsDrawingBoardViewProtocol>)boardView didMovedPoint:(CGPoint)point;
- (void)drawingBoardView:(id<RunsDrawingBoardViewProtocol>)boardView didEndedPoint:(CGPoint)point;
@end
