//
//  RunsDrawingBoardViewProtocol.h
//  DrawingBoard
//
//  Created by runs on 2017/8/16.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RunsDrawingBoardViewDelegate,RunsDrawingBoardOperatingProtocol,RunsBrushProtocol;

@protocol RunsDrawingBoardViewProtocol <RunsDrawingBoardOperatingProtocol>
@property (nonatomic, assign) BOOL drawEnable;
@property (nonatomic, strong) id<RunsBrushProtocol> brushModel;
@property (nonatomic, strong, readonly) NSArray<id<RunsBrushProtocol>> *brushes;
@property (nonatomic, weak) id<RunsDrawingBoardViewDelegate> delegate;

- (void)restore;
- (void)drawPartWithBrush:(id<RunsBrushProtocol>)brush;
//擦除 更新
- (void)eraseBrushIds:(NSArray <NSString *> *)brushIds;
- (void)updateBrushes:(NSArray <id<RunsBrushProtocol>>*)brushes;
- (void)refresh;

@end
