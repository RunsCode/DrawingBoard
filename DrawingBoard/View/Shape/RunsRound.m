//
//  RunsRound.m
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsRound.h"
#import "RunsShapeProtocol.h"
#import "RunsBrushProtocol.h"
//#import <CoreGraphics/CoreGraphics.h>

@interface RunsRound ()

@end


@implementation RunsRound
@synthesize bounds = _bounds;

+ (instancetype)shapeWithBounds:(CGRect)bounds {
    RunsRound<RunsShapeProtocol> *shape = [[[self class] alloc] init];
    shape.bounds = bounds;
    return shape;
}

- (void)drawContext:(CGContextRef)context brush:(id<RunsBrushProtocol>)brush {
    if (brush.frames.count < 2) {
        RunsLogEX(@"RunsRound drawContext : 画正圆 坐标集合长度小于2");
        return;
    }
    CGPoint origin = brush.frames.firstObject.CGRectValue.origin;
    CGPoint next = brush.frames.lastObject.CGRectValue.origin;
    CGFloat width = next.x - origin.x;
    CGFloat height = next.y - origin.y;
    CGFloat radius = MAX(fabs(width), fabs(height));
    
    CGContextSetLineWidth(context, brush.width);
    CGContextSetStrokeColorWithColor(context, brush.color.CGColor);
    
    if (brush.isFill) {
        CGContextSetFillColorWithColor(context, brush.fillColor.CGColor);
    }
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    CGContextAddArc(context, origin.x, origin.y, radius, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, brush.isFill ? kCGPathFillStroke : kCGPathStroke);
}

@end
