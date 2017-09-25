//
//  ViewController.m
//  DrawingBoard
//
//  Created by runs on 2017/8/14.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "ViewController.h"
#import "GKDrawingBoardView.h"
#import "CellDataSource.h"
#import "RunsColorPickerView.h"
#import "RunsControlProtocol.h"
#import "RunsBrushProtocol.h"
#import "RunsDrawingBoardView.h"

#import "RunsBrushModel.h"
#import "RunsBrushCharacterModel.h"
#import "RunsDrawingBoardViewDelegate.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, RunsDrawingBoardViewDelegate>
@property (strong, nonatomic) IBOutlet GKDrawingBoardView *drawingBoardView;
@property (strong, nonatomic) IBOutlet RunsDrawingBoardView *runsDrawingBoardView;
@property (strong, nonatomic) IBOutlet UIView *drawerMenuView;
@property (strong, nonatomic) IBOutlet UITableView *controlPanelTableView;

@property (nonatomic, strong) NSArray<CellDataSource *> *controlList;
@property (nonatomic, strong) RunsColorPickerView<RunsControlProtocol> *colorPickerView;
@property (nonatomic, strong) UIColor *brushColor;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.controlList = [CellDataSource dataSource];;
    [self.controlPanelTableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    [self.controlPanelTableView reloadData];
    self.drawingBoardView.hidden = NO;
    [self.drawingBoardView removeFromSuperview];
    
    self.brushColor = [UIColor redColor];
    id<RunsBrushProtocol> brush = [RunsBrushModel brushWithShape:ShapeType_Polyline color:self.brushColor thickness:3];
    self.runsDrawingBoardView.brushModel = brush;
    self.runsDrawingBoardView.delegate = self;
    self.runsDrawingBoardView.drawEnable = YES;

}

#pragma mark -- RunsDrawingBoardViewDelegate 

- (void)drawingBoardView:(id<RunsDrawingBoardViewProtocol>)boardView didBeganPoint:(CGPoint)point {
    NSLog(@"didBeganPoint x = %f, y = %f",point.x, point.y);
}

- (void)drawingBoardView:(id<RunsDrawingBoardViewProtocol>)boardView didMovedPoint:(CGPoint)point {
    NSLog(@"didMovedPoint x = %f, y = %f",point.x, point.y);
}

- (void)drawingBoardView:(id<RunsDrawingBoardViewProtocol>)boardView didEndedPoint:(CGPoint)point brush:(id<RunsBrushProtocol>)brush { 
    NSLog(@"didEndedPoint x = %f, y = %f",point.x, point.y);
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.controlList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    NSString * actionName = self.controlList[indexPath.row].title;
    cell.textLabel.text = actionName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.controlList[indexPath.row].title;
    NSLog(@"%@", title);
    MenuType type = self.controlList[indexPath.row].type;
    if (MenuType_LineColor == type) {
        [self updateColorPickerView:indexPath];
        return;
    }
    [self operatingWithMenuType:type];
}

- (void)operatingWithMenuType:(MenuType)type {
    if (MenuType_DrawingPolyline <= type && type <= MenuType_Eraser) {
        //gen
        id<RunsBrushProtocol> brush = [self genBrushWithMenuType:type];
        self.runsDrawingBoardView.brushModel = brush;
    }
    
    if (MenuType_Undo <= type && type <= MenuType_Clear ) {
        switch (type) {
            case MenuType_Undo:
                [self.runsDrawingBoardView undo:YES];
                break;
                
            case MenuType_Redo:
                [self.runsDrawingBoardView redo];
                break;
                
            case MenuType_Clear:
                [self.runsDrawingBoardView clear:YES];
                break;
                
            default:
                break;
        }
    }
}

- (id<RunsBrushProtocol>)genBrushWithMenuType:(MenuType)menuType {
    id<RunsBrushProtocol> brush = nil;
    switch (menuType) {
        case MenuType_DrawingPolyline:
            brush = [RunsBrushModel brushWithShape:ShapeType_Polyline color:self.brushColor thickness:6];
            break;
            
        case MenuType_DrawingBeeline:
            brush = [RunsBrushModel brushWithShape:ShapeType_Beeline color:self.brushColor thickness:3];
            break;
            
        case MenuType_DrawingSquare:
            brush = [RunsBrushModel brushWithShape:ShapeType_Square color:self.brushColor thickness:3];
            break;
            
        case MenuType_DrawingElipse:
            brush = [RunsBrushModel brushWithShape:ShapeType_Elipse color:self.brushColor thickness:3];
            break;
            
        case MenuType_DrawingRound:
            brush = [RunsBrushModel brushWithShape:ShapeType_Round color:self.brushColor thickness:3];
            break;
            
        case MenuType_DrawingText: {
            brush = [RunsBrushCharacterModel defaultWithShape:ShapeType_Text text:@"" color:self.brushColor font:18.f frame:self.view.frame];
        }
            break;
            
        case MenuType_Eraser:
            brush = [RunsBrushModel brushWithShape:ShapeType_Polyline color:UIColor.whiteColor thickness:8];
            break;
            
        case MenuType_MagicWand:
            brush = [RunsBrushModel brushWithShape:ShapeType_Polyline color:self.brushColor thickness:3];
            break;
            
        default:
            break;
    }
    self.runsDrawingBoardView.brushModel = brush;
    return brush;
}


- (void)updateColorPickerView:(NSIndexPath *)indexPath {
    NSString *title = @"打开颜色选择器";
    if (self.colorPickerview.hidden) {
        title = @"关闭颜色选择器";
        [self.colorPickerView run];
    }else{
        [self.colorPickerView stop];
    }
    self.controlList[indexPath.row].title = title;
    [self.controlPanelTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    __weak typeof(self) weakSelf = self;
    [self.colorPickerView setCallback:^(NSInteger type, id obj) {
        weakSelf.brushColor = (UIColor *)obj;
        weakSelf.runsDrawingBoardView.brushModel.color = (UIColor *)obj;
    }];
}


- (RunsColorPickerView<RunsControlProtocol> *)colorPickerview {
    if (_colorPickerView) return _colorPickerView;
    RunsColorPickerView *colorPickerView = [[RunsColorPickerView alloc] init];//
    colorPickerView.center = self.view.center;
    [self.view addSubview:colorPickerView];
    _colorPickerView = (RunsColorPickerView<RunsControlProtocol> *)colorPickerView;
    [_colorPickerView setType:MenuType_LineColor];
    return _colorPickerView;
}

@end
