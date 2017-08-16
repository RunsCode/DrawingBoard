//
//  GKDrawingBoardView.m
//  GuoKao
//
//  Created by wang on 16/6/10.
//  Copyright © 2016年 ShangHai HongYiTong. All rights reserved.
//

#import "GKDrawingBoardView.h"
#import "RunsShapeProtocol.h"
#import "RunsBrushModel.h"
#import "RunsBrushCharacterModel.h"

#import "RunsBeeline.h"
#import "RunsPolyline.h"
#import "RunsSquare.h"
#import "RunsRound.h"
#import "RunsEllipse.h"
#import "RunsCharacter.h"


#define SuperViewTransparent(arg1,arg2) ([arg1 colorWithAlphaComponent:arg2])

@implementation GKDrawingBoardView {
    NSMutableArray<NSValue *> * mCoordinateArray;//坐标集合
    NSMutableArray<NSMutableArray *> * mLineArray;//线集合
    NSMutableArray<UIColor *> * mLineColorArray;//线颜色集合
    NSMutableArray<NSNumber *> * mLineWidthArray;//线宽集合
    
    //用于撤销返回的最后一组数据
    NSMutableArray<NSMutableArray *> * mLastLineArray;//线集合
    NSMutableArray<UIColor *> * mLastLineColorArray;//线颜色集合
    NSMutableArray<NSNumber *> * mLastLineWidthArray;//线宽集合
    
    //
    id<RunsShapeProtocol> mShape;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initMember];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initMember];
    }
    return self;
}

- (void)initMember {
    self.lineWidth = 2.f;
    self.lineColor = [UIColor redColor];
    self.backgroundColor = SuperViewTransparent(UIColor.grayColor, 0.6);// [[UIColor grayColor] colorWithAlphaComponent:0.6];
    if (mLastLineArray.count <= 0) {
        mLastLineArray = [[NSMutableArray alloc] initWithCapacity:10];
        mLastLineColorArray = [[NSMutableArray alloc] initWithCapacity:10];
        mLastLineWidthArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
}

- (void)initCoordinateAarray {
    //初始化
    mCoordinateArray = [[NSMutableArray alloc] initWithCapacity:10];
    [self insertsSgementLineWidth:self.lineWidth];
    [self insertsSgementLineColor:self.lineColor];
}

- (void)insertLineToArray {
    //把画过的当前线放入　存放线的数组
    if (!mLineArray && mLineArray.count <= 0) {
        mLineArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [mLineArray addObject:mCoordinateArray];
}

- (void)insertCoordinate:(CGPoint)sender {
    NSValue* pointvalue = [NSValue valueWithCGPoint:sender];
    [mCoordinateArray addObject:pointvalue];
}

- (void)insertsSgementLineColor:(UIColor *)color {
    if (!mLineColorArray && mLineColorArray.count <= 0) {
        mLineColorArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [mLineColorArray addObject:color];
}

- (void)insertsSgementLineWidth:(CGFloat)sender {
    if (!mLineWidthArray && mLineWidthArray.count <= 0) {
        mLineWidthArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [mLineWidthArray addObject:@(sender)];
}

- (void)clearLine {
    //清屏按钮
   if (mLineArray.count > 0) {
       
       [mLastLineArray addObjectsFromArray:[[mLineArray reverseObjectEnumerator]allObjects]];
       [mLastLineColorArray addObjectsFromArray:[[mLineColorArray reverseObjectEnumerator]allObjects]];
       [mLastLineWidthArray addObjectsFromArray:[[mLineWidthArray reverseObjectEnumerator]allObjects]];
       
       [mLineArray removeAllObjects];
       [mLineColorArray removeAllObjects];
       [mLineWidthArray removeAllObjects];
       [mCoordinateArray removeAllObjects];
       mLineArray = [[NSMutableArray alloc] initWithCapacity:10];
       mLineColorArray = [[NSMutableArray alloc] initWithCapacity:10];
       mLineWidthArray = [[NSMutableArray alloc] initWithCapacity:10];
        [self setNeedsDisplay];
    }
}

- (void)undo {
    //撤销
    if (mLineArray.count > 0) {
        NSMutableArray * array = [NSMutableArray array];
        [array addObjectsFromArray:mLineArray.lastObject];
        [mLastLineArray addObject:array];
        [mLastLineColorArray addObject:mLineColorArray.lastObject];
        [mLastLineWidthArray addObject:mLineWidthArray.lastObject];
        
        [mLineArray  removeLastObject];
        [mLineColorArray removeLastObject];
        [mLineWidthArray removeLastObject];
        [mCoordinateArray removeAllObjects];
        [self setNeedsDisplay];
    }
}

- (void)redo {
    //撤销返回
    if (mLastLineColorArray.count > 0) {
        [mLineColorArray addObject:mLastLineColorArray.lastObject];
        [mLastLineColorArray removeLastObject];
    }
    
    if (mLastLineWidthArray.count > 0) {
        [mLineWidthArray addObject:mLastLineWidthArray.lastObject];
        [mLastLineWidthArray removeLastObject];
    }
    
    if (mLastLineArray.count > 0) {
        [mLineArray addObject:mLastLineArray.lastObject];
        [mLastLineArray removeLastObject];
        [self setNeedsDisplay];
    }
}

#pragma mark -- Private Method

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self initCoordinateAarray];
    [self insertCoordinate:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray * movePointArray = [touches allObjects];
    CGPoint point = [movePointArray.firstObject locationInView:self];
    [self insertCoordinate:point];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self insertLineToArray];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)drawRect:(CGRect)rect {
    
    if (!mShape) {
        mShape = (id<RunsShapeProtocol>)[[RunsRound alloc] init];
    }
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGPoint originPoint = mCoordinateArray.firstObject.CGPointValue;
//    CGRect originRect = CGRectMake(originPoint.x, originPoint.y, 0, 0);
//    NSValue *origin = [NSValue valueWithCGRect:originRect];
//
//    CGPoint nextPoint = mCoordinateArray.lastObject.CGPointValue;
//    CGRect nextRect = CGRectMake(nextPoint.x, nextPoint.y, 0, 0);
//    NSValue *next = [NSValue valueWithCGRect:nextRect];
//    
///*    NSMutableArray<NSValue *> *array = [NSMutableArray arrayWithCapacity:mCoordinateArray.count];
//    [mCoordinateArray enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGPoint point = obj.CGPointValue;
//        CGRect rect = CGRectMake(point.x, point.y, 0, 0);
//        NSValue *value = [NSValue valueWithCGRect:rect];
//        [array addObject:value];
//    }];
////*/
////    NSString *text = @"NSMutableArray<NSValue *> *array = [NSMutableArray arrayWithCapacity:mCoordinateArray.count];[mCoordinateArray enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {CGPoint point = obj.CGPointValue; CGRect rect = CGRectMake(point.x, point.y, 0, 0); NSValue *value = [NSValue valueWithCGRect:rect]; [array addObject:value]; \n}];";
//    
//    RunsBrushModel *model = [RunsBrushModel defaultWithShape:ShapeType_Beeline lineColor:self.lineColor lineWidth:self.lineWidth frames:@[origin,next]];
////    CGRect textRect = CGRectMake(100, 100, 700
////                                 , 0);
////    RunsBrushCharacterModel *model = [RunsBrushCharacterModel defaultWithShape:ShapeType_Text text:text color:self.lineColor font:28.f frame:textRect];
//    [mShape drawContext:context brush:model];
//    return;
    
    //设置笔冒
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置画线的连接处　拐点圆滑
    CGContextSetLineJoin(context, kCGLineJoinRound);
    //画之前线
    if (mLineArray.count > 0) {
        for (int i = 0; i < mLineArray.count; i++) {
            NSArray<NSValue *> * tempArray = mLineArray[i];
            UIColor * color = nil;
            CGFloat width = 2.f;
            if (mLineColorArray.count > 0) {
                color = mLineColorArray[i];
                width = mLineWidthArray[i].floatValue;
            }
            if (tempArray.count > 1) {
                CGContextBeginPath(context);
                CGPoint myStartPoint = tempArray.firstObject.CGPointValue;
                CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
                
                for (int j = 1; j < tempArray.count; j++) {
                    CGPoint endPoint = tempArray[j].CGPointValue;
                    CGContextAddLineToPoint(context, endPoint.x,endPoint.y);
                }
                CGContextSetStrokeColorWithColor(context, color.CGColor);
                CGContextSetLineWidth(context, width);
                CGContextStrokePath(context);
            }
        }
    }
    //画当前的线
    if (mCoordinateArray.count > 1) {
        CGContextBeginPath(context);
        //起点
        CGPoint startPoint = mCoordinateArray.firstObject.CGPointValue;
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        //把move的点全部加入　数组
        for (int i = 1; i < mCoordinateArray.count; i++) {
            CGPoint endPoint = mCoordinateArray[i].CGPointValue;
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        }
        //绘制画笔颜色
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetFillColorWithColor (context,  self.lineColor.CGColor);
        //绘制画笔宽度
        CGContextSetLineWidth(context, self.lineWidth);
        //把数组里面的点全部画出来
        CGContextStrokePath(context);
    }
}


@end
