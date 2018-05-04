//
//  RunsDrawingBoardProxy.m
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsDrawingBoardProxy.h"

//model
#import "RunsBrushCharacterModel.h"

//shape
#import "RunsPolyline.h"
#import "RunsBeeline.h"
#import "RunsSquare.h"
#import "RunsRound.h"
#import "RunsEllipse.h"
#import "RunsCharacter.h"
#import "RunsEraser.h"

//protocol
#import "RunsBrushProtocol.h"

#import "RunsDrawingBoardOperate.h"

@interface RunsDrawingBoardProxy ()
@property (nonatomic, strong) NSMutableArray<id<RunsShapeProtocol>> *shapes;
@property (nonatomic, strong) id<RunsBrushProtocol> currentBrush;
@property (nonatomic, strong) RunsDrawingBoardOperate *operate;
@end

@implementation RunsDrawingBoardProxy

- (void)dealloc {
    RunsReleaseLog()
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _brushes = [NSMutableArray array];
        _operate = [RunsDrawingBoardOperate new];
    }
    return self;
}

#pragma mark -- RunsDrawingBoardOperatingProtocol

- (void)undo:(BOOL)canRedo {
    _brushes = _operate.undo.brushes;
}

- (void)redo {
    _brushes = _operate.redo.brushes;
}

- (void)clear:(BOOL)canUndo {
    if (!canUndo) {
        [_brushes removeAllObjects];
        return;
    }
    _brushes = _operate.clear.brushes;
}

#pragma mark -- 绘制任何几何图形 RunsDrawingBoardProxyProtocol

- (id<RunsBrushProtocol>)currentBrush {
    return _brushes.lastObject;
}

- (void)drawWithContext:(CGContextRef)context {
    [_brushes enumerateObjectsUsingBlock:^(id<RunsBrushProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<RunsShapeProtocol> shape = [self shapeRef:obj.shape];
        [shape drawContext:context brush:obj];
    }];
}

- (void)drawBeganWithPoint:(CGPoint)point brush:(id<RunsBrushProtocol>)brush {
    if (!brush || brush.shape == ShapeType_Text) return;
    [self drawWithBrush:brush];

    CGRect rect = CGRectMake(point.x, point.y, 0, 0);
    NSValue *value = [NSValue valueWithCGRect:rect];
    if (!_brushes.lastObject.frames) {
        _brushes.lastObject.frames = [NSMutableArray array];
    }
    [_brushes.lastObject.frames addObject:value];
}

- (void)drawMovedWithPoint:(CGPoint)point {
    if (_brushes.lastObject.shape == ShapeType_Text) return;
    CGRect rect = CGRectMake(point.x, point.y, 0, 0);
    NSValue *value = [NSValue valueWithCGRect:rect];
    [_brushes.lastObject.frames addObject:value];
}

- (void)drawEndedWithPoint:(CGPoint)point {
    if (_brushes.lastObject.shape == ShapeType_Text) return;
    CGRect rect = CGRectMake(point.x, point.y, 0, 0);
    NSValue *value = [NSValue valueWithCGRect:rect];
    [_brushes.lastObject.frames addObject:value];
}

#pragma mark -- 分段直接绘制 一般来源于网络 一段一段的按坐标绘制 包含文字和图片

- (void)drawPartWithBrush:(id<RunsBrushProtocol>)brush {
    if (!brush) return;
    [self drawWithBrush:brush];
}

#pragma mark -- 绘制文字

- (void)drawTextBeganWithFrame:(CGRect)frame brush:(id<RunsBrushProtocol>)brush {
    if (!brush || brush.shape != ShapeType_Text) return;
    [self drawWithBrush:brush];
}

- (void)drawTextChangedWithFrame:(CGRect)frame text:(NSString *)text {
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(_brushes.lastObject);
    if (!model || model.shape != ShapeType_Text) return;
    model.character = text;
    [model.frames removeAllObjects];
    NSValue *value = [NSValue valueWithCGRect:frame];
    [model.frames addObject:value];
}

- (void)drawTextEndedWithFrame:(CGRect)frame text:(NSString *)text {
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(_brushes.lastObject);
    if (!model || model.shape != ShapeType_Text) return;
    model.character = text;
    [model.frames removeAllObjects];
    NSValue *value = [NSValue valueWithCGRect:frame];
    [model.frames addObject:value];
}

- (void)eraseBrushIds:(NSArray <NSString *> *)brushIds {
    if (brushIds.isEmpty)
        return;
    [_brushes enumerateObjectsUsingBlock:^(id <RunsBrushProtocol> obj, NSUInteger idx, BOOL *stop) {
        [brushIds enumerateObjectsUsingBlock:^(NSString * brushId, NSUInteger idx, BOOL *stop) {
            if ([obj.brushId isEqualToString:brushId]) {
                [_brushes removeObject:obj];
                [_operate pop:obj];
            }
        }];
    }];
}

- (void)updateBrushes:(NSArray <id <RunsBrushProtocol>> *)brushes {
    if (brushes.isEmpty)
        return;
    [_brushes enumerateObjectsUsingBlock:^(id <RunsBrushProtocol> obj, NSUInteger idx, BOOL *stop) {
        [brushes enumerateObjectsUsingBlock:^(id <RunsBrushProtocol> obj1, NSUInteger idx1, BOOL *stop) {
            if ([obj.brushId isEqualToString:obj1.brushId]) {
                _brushes[idx] = obj1;
            }
        }];
    }];
}

#pragma mark -- Private Method

- (void)drawWithBrush:(id<RunsBrushProtocol>)brush {
    [_brushes addObject:brush];
    [_operate push:brush];
}

- (id<RunsShapeProtocol>)shapeRef:(ShapeType)type {
    if (type >> SHAPE_DISPLACEMENT > self.shapes.count - 1) return nil;
    id<RunsShapeProtocol> shape = self.shapes[type >> SHAPE_DISPLACEMENT];
    return shape;
}

- (NSMutableArray<id<RunsShapeProtocol>> *)shapes {
    if (_shapes) return _shapes;
    NSMutableArray<id<RunsShapeProtocol>> *array = [NSMutableArray array];
    [array addObject:[RunsPolyline shapeWithBounds:_bounds]];
    [array addObject:[RunsBeeline shapeWithBounds:_bounds]];
    [array addObject:[RunsSquare shapeWithBounds:_bounds]];
    [array addObject:[RunsEllipse shapeWithBounds:_bounds]];
    [array addObject:[RunsRound shapeWithBounds:_bounds]];
    [array addObject:[RunsCharacter shapeWithBounds:_bounds]];
    [array addObject:[RunsEraser shapeWithBounds:_bounds]];
    _shapes = array;
    return array;
}

@end
