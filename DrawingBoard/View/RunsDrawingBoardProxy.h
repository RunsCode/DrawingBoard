//
//  RunsDrawingBoardProxy.h
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RunsBrushProtocol;

@interface RunsDrawingBoardProxy : NSObject
@property (nonatomic, strong, readonly) id<RunsBrushProtocol> currentBrush;
@property (nonatomic, strong, readonly) NSMutableArray<id<RunsBrushProtocol>> *brushes;
@end
