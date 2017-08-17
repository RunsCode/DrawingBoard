//
//  RunsDrawingBoardProxy.m
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsDrawingBoardProxy.h"
#import "RunsDrawingBoardOperatingProtocol.h"
#import "RunsDrawingBoardProxyProtocol.h"
#import "RunsBrushProtocol.h"

#import "RunsPolyline.h"
#import "RunsBeeline.h"
#import "RunsSquare.h"
#import "RunsRound.h"
#import "RunsEllipse.h"
#import "RunsCharacter.h"

#import "RunsBrushCharacterModel.h"

@implementation RunsDrawingBoardOperate

@end

@interface RunsDrawingBoardProxy ()<RunsDrawingBoardProxyProtocol>
@property (nonatomic, strong) NSMutableArray<id<RunsShapeProtocol>> *shapes;
@property (nonatomic, strong) NSMutableArray<id<RunsBrushProtocol>> *brushes;
@property (nonatomic, strong) NSMutableArray<RunsDrawingBoardOperate *> *brushesCache;//缓存操作记录
@property (nonatomic, strong) id<RunsBrushProtocol> currentBrush;

@end

@implementation RunsDrawingBoardProxy

- (void)dealloc {
    NSLog(@"RunsDrawingBoardProxy Release");
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _brushes = [NSMutableArray array];
        _brushesCache = [NSMutableArray array];
    }
    return self;
}

- (void)undo:(BOOL)canRedo {
    if (self.brushes.count <= 0) return;
    id<RunsBrushProtocol> brush = self.brushes.lastObject;
    [self.brushes removeLastObject];
    if (!canRedo) return;
    [self cacheBrush:brush];
}

- (void)redo {
    NSArray<id<RunsBrushProtocol>> *brushes = self.brushesCache.lastObject.brushes;
    if (brushes.count <= 0) return;
    [self.brushesCache removeLastObject];
    [self.brushes addObjectsFromArray:brushes];
}

- (void)clear {
    [self cacheBrushes:self.brushes.copy];
    [self.brushes removeAllObjects];
}

#pragma mark -- 绘制文字

- (void)drawTextBeganWithFrame:(CGRect)frame brush:(id<RunsBrushProtocol>)brush {
    if (!brush || brush.shape != ShapeType_Text) return;
    [self drawWithBrush:brush];
}

- (void)drawTextChangedWithFrame:(CGRect)frame text:(NSString *)text {
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(self.brushes.lastObject);
    if (!model || model.shape != ShapeType_Text) return;
    model.character = text;
    [model.frames removeAllObjects];
    NSValue *value = [NSValue valueWithCGRect:frame];
    [model.frames addObject:value];
}

- (void)drawTextEndedWithFrame:(CGRect)frame text:(NSString *)text {
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(self.brushes.lastObject);
    if (!model || model.shape != ShapeType_Text) return;
    model.character = text;
    [model.frames removeAllObjects];
    NSValue *value = [NSValue valueWithCGRect:frame];
    [model.frames addObject:value];
}

#pragma mark -- 绘制任何几何图形

- (void)drawBeganWithPoint:(CGPoint)point brush:(id<RunsBrushProtocol>)brush {
    if (!brush || brush.shape == ShapeType_Text) return;
    [self drawWithBrush:brush];

    CGRect rect = CGRectMake(point.x, point.y, 0, 0);
    NSValue *value = [NSValue valueWithCGRect:rect];
    if (!self.brushes.lastObject.frames) {
        self.brushes.lastObject.frames = [NSMutableArray array];
    }
    [self.brushes.lastObject.frames addObject:value];
}

- (void)drawMovedWithPoint:(CGPoint)point {
    if (self.brushes.lastObject.shape == ShapeType_Text) return;
    CGRect rect = CGRectMake(point.x, point.y, 0, 0);
    NSValue *value = [NSValue valueWithCGRect:rect];
    [self.brushes.lastObject.frames addObject:value];
}

- (void)drawEndedWithPoint:(CGPoint)point {
    if (self.brushes.lastObject.shape == ShapeType_Text) return;
    CGRect rect = CGRectMake(point.x, point.y, 0, 0);
    NSValue *value = [NSValue valueWithCGRect:rect];
    [self.brushes.lastObject.frames addObject:value];
}

- (void)drawWithContext:(CGContextRef)context {
    [self.brushes enumerateObjectsUsingBlock:^(id<RunsBrushProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<RunsShapeProtocol> shape = [self shapeRef:obj.shape];
        [shape drawContext:context brush:obj];
    }];
}

#pragma mark -- Private Method

- (void)drawWithBrush:(id<RunsBrushProtocol>)brush {
    [self.brushes addObject:brush];
    //新增操作 清空操作缓存记录
    [self.brushesCache removeAllObjects];
}

- (void)cacheBrush:(id<RunsBrushProtocol>)brush {
    [self cacheBrushes:@[brush]];
}

- (void)cacheBrushes:(NSArray<id<RunsBrushProtocol>>*)brushes {
    RunsDrawingBoardOperate *op = [RunsDrawingBoardOperate new];
    op.brushes = brushes;
    [self.brushesCache addObject:op];
}

- (id<RunsShapeProtocol>)shapeRef:(ShapeType)type {
    if (type >> SHAPE_DISPLACEMENT > self.shapes.count - 1) return nil;
    id<RunsShapeProtocol> shape = self.shapes[type >> SHAPE_DISPLACEMENT];
    return shape;
}

- (NSMutableArray<id<RunsShapeProtocol>> *)shapes {
    if (_shapes) return _shapes;
    NSMutableArray<id<RunsShapeProtocol>> *array = [NSMutableArray array];
    [array addObject:(id<RunsShapeProtocol>)RunsPolyline.new];
    [array addObject:(id<RunsShapeProtocol>)RunsBeeline.new];
    [array addObject:(id<RunsShapeProtocol>)RunsSquare.new];
    [array addObject:(id<RunsShapeProtocol>)RunsEllipse.new];
    [array addObject:(id<RunsShapeProtocol>)RunsRound.new];
    [array addObject:(id<RunsShapeProtocol>)RunsCharacter.new];
    _shapes = array;
    return array;
}

@end
