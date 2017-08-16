//
//  RunsDrawingBoardView.h
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunsDrawingBoardOperatingProtocol.h"
#import "RunsDrawingBoardViewProtocol.h"

@protocol RunsBrushProtocol;
@interface RunsDrawingBoardView : UIView<RunsDrawingBoardViewProtocol>

@property (nonatomic, strong) id<RunsBrushProtocol> brushModel;
@property (nonatomic, weak) id<RunsDrawingBoardViewDelegate> delegate;

@end
