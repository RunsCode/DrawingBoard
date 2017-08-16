//
//  RunsDrawingBoardViewProtocol.h
//  DrawingBoard
//
//  Created by runs on 2017/8/16.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RunsDrawingBoardViewDelegate,RunsDrawingBoardOperatingProtocol,RunsBrushProtocol;

@protocol RunsDrawingBoardViewProtocol <RunsDrawingBoardOperatingProtocol>

@property (nonatomic, strong) id<RunsBrushProtocol> brushModel;
@property (nonatomic, weak) id<RunsDrawingBoardViewDelegate> delegate;

@end
