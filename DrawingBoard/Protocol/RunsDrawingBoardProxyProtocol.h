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

@protocol RunsDrawingBoardOperatingProtocol,RunsBrushProtocol;

@protocol RunsDrawingBoardProxyProtocol <RunsDrawingBoardOperatingProtocol>

@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, strong, readonly) id<RunsBrushProtocol> currentBrush;
@property (nonatomic, strong, readonly) NSMutableArray<id<RunsBrushProtocol>> *brushes;

- (void)drawWithContext:(CGContextRef)context;
//实时绘制
- (void)drawBeganWithPoint:(CGPoint)point brush:(id<RunsBrushProtocol>)brush;
- (void)drawMovedWithPoint:(CGPoint)point;
- (void)drawEndedWithPoint:(CGPoint)point;

//段落绘制
- (void)drawPartWithBrush:(id<RunsBrushProtocol>)brush;

//绘制文字
- (void)drawTextBeganWithFrame:(CGRect)frame brush:(id<RunsBrushProtocol>)brush;
- (void)drawTextChangedWithFrame:(CGRect)frame text:(NSString *)text;
- (void)drawTextEndedWithFrame:(CGRect)frame text:(NSString *)text;

//擦除 更新
- (void)eraseBrushIds:(NSArray <NSString *>*)brushIds;
- (void)updateBrushes:(NSArray <id<RunsBrushProtocol>>*)brushes;

@end
