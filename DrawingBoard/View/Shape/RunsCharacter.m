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

@interface RunsCharacter ()<RunsShapeProtocol>

@end

@implementation RunsCharacter

- (void)drawContext:(CGContextRef)context brush:(id<RunsBrushProtocol>)brush {
    
    if (!brush.color)  return;

    
    if (![brush isKindOfClass:RunsBrushCharacterModel.class]) {
        NSLog(@"RunsCharacter drawContext : 绘制文字 参数类型错误");
        return;
    }
    
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)brush;
    if (model.character.length <= 0) {
        NSLog(@"RunsCharacter drawContext : 绘制文字 文字长度小于0");
        return;
    }
    
    if (brush.frames.count <= 0) {
        NSLog(@"RunsCharacter drawContext : 绘制文字 文字起点坐标为空");
        return;
    }
    CGContextSetBlendMode(context,kCGBlendModeNormal);

    CGRect frame = model.frames.firstObject.CGRectValue;
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        CGFloat width = UIScreen.mainScreen.bounds.size.width - frame.origin.x - 10;
        CGFloat height = UIScreen.mainScreen.bounds.size.height - frame.origin.y - 10;
        frame.size.width = width;
        frame.size.height = height;
    }
    
    UIFont *font = [UIFont systemFontOfSize:model.fontSize];
    [model.character drawWithRect:frame
                          options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:model.color}
                          context:nil];
}

@end
