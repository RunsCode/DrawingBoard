//
//  RunsDrawingBoardProxy.h
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RunsBrushProtocol;

@interface RunsDrawingBoardOperate : NSObject
@property (nonatomic, strong) NSArray<id<RunsBrushProtocol>> *brushes;
@end

@interface RunsDrawingBoardProxy : NSObject

@end
