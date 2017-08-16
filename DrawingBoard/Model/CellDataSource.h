//
//  CellDataSource.h
//  DrawingBoard
//
//  Created by runs on 2017/8/14.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunsBrushModel.h"


typedef NS_ENUM(NSUInteger, MenuType) {
    MenuType_DrawingPolyline    = 0 << 8 | ShapeType_Polyline,
    MenuType_DrawingBeeline     = 1 << 8 | ShapeType_Beeline,
    MenuType_DrawingSquare      = 2 << 8 | ShapeType_Square,
    MenuType_DrawingElipse      = 3 << 8 | ShapeType_Elipse ,
    MenuType_DrawingRound       = 4 << 8 | ShapeType_Round,
    MenuType_DrawingText        = 5 << 8 | ShapeType_Text,
    MenuType_Eraser             = 6 << 8 | ShapeType_Eraser,
    MenuType_MagicWand          = 7 << 8,//魔棒
    //
    MenuType_Undo               = 8 << 8,
    MenuType_Redo               = 9 << 8,
    MenuType_Clear              = 10 << 8,
    //
    MenuType_LineColor          = 11 << 8,
    MenuType_LineWidth          = 12 << 8,
    MenuType_Default            = MenuType_DrawingPolyline,
};


@interface CellDataSource : NSObject
@property (nonatomic, assign) MenuType type;
@property (nonatomic, copy) NSString *title;

+ (NSArray<CellDataSource *> *)dataSource;
@end
