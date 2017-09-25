//
//  RunsDrawingBoardOperate.h
//  OU_iPad
//
//  Created by runs on 2017/8/29.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RunsBrushProtocol;

typedef NS_ENUM(NSUInteger, OperationalType) {
    Operate_Undo    = 0,
    Operate_Redo    = 1,
    Operate_Clear   = 2,
    OperateDefault  = Operate_Undo,
};

@interface RunsDrawingBoardOperateEntity : NSObject
@property (nonatomic, assign) BOOL shouldDisplay;
@property (nonatomic, strong) NSMutableArray<id<RunsBrushProtocol>> *brushes;
@end

@interface RunsDrawingBoardOperate : NSObject
- (void)push:(id<RunsBrushProtocol>)brush;
- (RunsDrawingBoardOperateEntity *)undo;
- (RunsDrawingBoardOperateEntity *)redo;
- (RunsDrawingBoardOperateEntity *)clear;
@end
