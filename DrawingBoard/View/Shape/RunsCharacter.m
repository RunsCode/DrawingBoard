//
//  RunsCharacter.m
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsCharacter.h"
#import "RunsShapeProtocol.h"
#import "RunsBrushProtocol.h"
#import "RunsBrushCharacterModel.h"

#define MARGIN_OFFSET (5.f)

@interface RunsCharacter ()

@end

@implementation RunsCharacter
@synthesize bounds = _bounds;

+ (instancetype)shapeWithBounds:(CGRect)bounds {
    RunsCharacter<RunsShapeProtocol> *shape = [[[self class] alloc] init];
    shape.bounds = bounds;
    return shape;
}

- (void)drawContext:(CGContextRef)context brush:(id<RunsBrushProtocol>)brush {
    
    if (!brush.color)  return;

    
    if (![brush isKindOfClass:RunsBrushCharacterModel.class]) {
        RunsLogEX(@"RunsCharacter drawContext : 绘制文字 参数类型错误");
        return;
    }
    
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)brush;
    if (model.character.length <= 0) {
        RunsLogEX(@"RunsCharacter drawContext : 绘制文字 文字长度小于0");
        return;
    }
    
    if (brush.frames.count <= 0) {
        RunsLogEX(@"RunsCharacter drawContext : 绘制文字 文字起点坐标为空");
        return;
    }
    //靠边自适应边框 自动换行
    CGRect frame = model.frames.firstObject.CGRectValue;
    CGFloat x = frame.origin.x <= 0 ? 0 : frame.origin.x > _bounds.size.width ? _bounds.size.width : frame.origin.x;
    CGFloat y = frame.origin.y <= 0 ? 0 : frame.origin.y > _bounds.size.height ? _bounds.size.height : frame.origin.y;
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        CGFloat maxWidth = _bounds.size.width - fabs(frame.origin.x) - MARGIN_OFFSET;
        CGFloat maxHeight = _bounds.size.height - fabs(frame.origin.y) - MARGIN_OFFSET;
        frame.size.width = maxWidth;
        frame.size.height = maxHeight;
    }
    frame.origin.x = x + MARGIN_OFFSET;
    frame.origin.y = y + MARGIN_OFFSET;
    //移除换行符
    NSString *text = [model.character stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    UIFont *font = [UIFont systemFontOfSize:model.fontSize];
    [text drawWithRect:frame
               options:NSStringDrawingUsesLineFragmentOrigin
            attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:model.color}
               context:nil];
}

@end
