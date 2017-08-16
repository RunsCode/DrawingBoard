//
//  CellDataSource.m
//  DrawingBoard
//
//  Created by runs on 2017/8/14.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "CellDataSource.h"

@implementation CellDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (NSArray<NSString *> *)titles {
    return @[@"自由绘制（默认）",@"直线",@"矩形",@"椭圆",
             @"正圆",@"文字",@"橡皮",@"魔棒",
             @"Undo",@"Redo",@"Clear",@"打开颜色选择器",@"线条宽度"];
}

+ (NSArray<NSNumber *> *)enums {
    return @[@(MenuType_DrawingPolyline),@(MenuType_DrawingBeeline),@(MenuType_DrawingSquare),@(MenuType_DrawingElipse),
             @(MenuType_DrawingRound),@(MenuType_DrawingText),@(MenuType_Eraser),@(MenuType_MagicWand),
             @(MenuType_Undo),@(MenuType_Redo),@(MenuType_Clear),@(MenuType_LineColor),@(MenuType_LineWidth)];
}

+ (NSArray<CellDataSource *> *)dataSource {
    
    NSMutableArray<CellDataSource *> *array = [NSMutableArray arrayWithCapacity:CellDataSource.titles.count];
    [CellDataSource.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CellDataSource *data = [CellDataSource new];
        data.type = CellDataSource.enums[idx].integerValue;
        data.title = obj;
        [array addObject:data];
    }];
    
    return array;
}
@end
