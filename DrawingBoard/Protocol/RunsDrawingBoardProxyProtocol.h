//
//  RunsDrawingBoardProxyProtocol.h
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@protocol RunsDrawingBoardOperatingProtocol;
@protocol RunsDrawingBoardProxyProtocol <RunsDrawingBoardOperatingProtocol>

- (void)drawWithContext:(CGContextRef)context;

- (void)drawBeganWithPoint:(CGPoint)point brush:(id<RunsBrushProtocol>)brush;
- (void)drawMovedWithPoint:(CGPoint)point;
- (void)drawEndedWithPoint:(CGPoint)point;

- (void)drawTextBeganWithFrame:(CGRect)frame brush:(id<RunsBrushProtocol>)brush;
- (void)drawTextChangedWithFrame:(CGRect)frame text:(NSString *)text;
- (void)drawTextEndedWithFrame:(CGRect)frame text:(NSString *)text;

@end
