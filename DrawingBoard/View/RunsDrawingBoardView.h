//
//  RunsDrawingBoardView.h
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <UIKit/UIKit.h>

//这里存在一个问题 定义协议引用 @protocol 时候报错,无法编译通过，必须import导入切实的头文件名才会编译通过
#import "RunsDrawingBoardOperatingProtocol.h"
#import "RunsDrawingBoardViewProtocol.h"
#import "RunsDrawingBoardViewDelegate.h"
#import "RunsDrawingBoardProxyProtocol.h"

@interface RunsDrawingBoardView : UIView<RunsDrawingBoardViewProtocol>
@property (nonatomic, assign) BOOL drawEnable;
@property (nonatomic, strong) id<RunsBrushProtocol> brushModel;
@property (nonatomic, strong, readonly) NSArray<id<RunsBrushProtocol>> *brushes;
@property (nonatomic, weak) id<RunsDrawingBoardViewDelegate> delegate;
@property (nonatomic, strong) id<RunsDrawingBoardProxyProtocol> proxy;

@end
