//
//  RunsDrawingBoardOperate.m
//  OU_iPad
//
//  Created by runs on 2017/8/29.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsDrawingBoardOperate.h"

//protocol
#import "RunsBrushProtocol.h"

@implementation RunsDrawingBoardOperateEntity

@end


@interface RunsDrawingBoardOperate ()
@property (nonatomic, assign) BOOL canRedo;
@property (nonatomic, assign) OperationalType currentOperate;
@property (nonatomic, strong) NSMutableArray<id<RunsBrushProtocol>> *recordStack;
@property (nonatomic, strong) NSMutableArray<id<RunsBrushProtocol>> *cacheStack;
@property (nonatomic, strong) NSMutableArray<id<RunsBrushProtocol>> *clearTempStack;
@end

@implementation RunsDrawingBoardOperate

- (void)dealloc {
    RunsReleaseLog()
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _recordStack = [NSMutableArray array];
        _cacheStack = [NSMutableArray array];
        _clearTempStack = [NSMutableArray array];
    }
    return self;
}

- (void)push:(id<RunsBrushProtocol>)brush {
    _canRedo = NO;
    [_cacheStack removeAllObjects];
    [_recordStack addObject:brush];
}

- (void)pop:(id<RunsBrushProtocol>)brush {
    _canRedo = YES;
    [_cacheStack addObject:brush];
    [_recordStack removeObject:brush];
}

- (RunsDrawingBoardOperateEntity *)undo {
    _canRedo = YES;
    _currentOperate = Operate_Undo;
    return self.entity;
}

- (RunsDrawingBoardOperateEntity *)redo {
    if (!_canRedo)  {
        RunsDrawingBoardOperateEntity *entity = [RunsDrawingBoardOperateEntity new];
        entity.brushes = [_recordStack mutableCopy];
        entity.shouldDisplay = NO;
        return entity;
    }
    _currentOperate = Operate_Redo;
    return self.entity;
}

- (RunsDrawingBoardOperateEntity *)clear {
    _canRedo = YES;
    _currentOperate = Operate_Clear;
    return self.entity;
}

- (RunsDrawingBoardOperateEntity *)entity {
    RunsDrawingBoardOperateEntity *entity = [RunsDrawingBoardOperateEntity new];
    BOOL shoudlDidplay = NO;
    switch (_currentOperate) {
            
        case Operate_Undo: {
            if (_recordStack.count > 0) {
                [_cacheStack addObject:_recordStack.lastObject];
                [_recordStack removeLastObject];
                //
                shoudlDidplay = YES;
            }
        }
            
            break;
        case Operate_Redo: {
            if (_cacheStack.count > 0) {
                [_recordStack addObject:_cacheStack.lastObject];
                [_cacheStack removeLastObject];
                //
                shoudlDidplay = YES;
            }
        }
            
            break;
        case Operate_Clear: {
            if (_recordStack.count > 0) {
                NSArray *array = _recordStack.reverseObjectEnumerator.allObjects;
                [_cacheStack addObjectsFromArray:array];
                [_recordStack removeAllObjects];
                //
                shoudlDidplay = YES;
            }
        }
            break;
            
        default:
            break;
    }
    entity.shouldDisplay = shoudlDidplay;
    entity.brushes = [_recordStack mutableCopy];
    return entity;
}

@end


//undo
//检测undo上一步是否是清空
//            if (_clearTempStack.count > 0) {
//                [_recordStack addObjectsFromArray:_clearTempStack];
//                [_clearTempStack removeAllObjects];
//                //
//                shoudlDidplay = YES;
//                break;
//            }

//redo
//                [_cacheStack addObjectsFromArray:_recordStack.mutableCopy];
//                _clearTempStack = [_recordStack mutableCopy];






