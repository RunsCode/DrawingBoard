//
//  RunsDrawingBoardView.m
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsDrawingBoardView.h"

//protocol
#import "RunsBrushProtocol.h"
#import "RunsShapeProtocol.h"
#import "RunsDrawingBoardProxyProtocol.h"

//model
#import "RunsBrushCharacterModel.h"
#import "RunsBrushModel.h"

//proxy
#import "RunsDrawingBoardProxy.h"

//API
#import "NSObject+RuntimeLog.h"
#import "UIImage+Category.h"
#import "GKSimpleAPI.h"



@interface RunsDrawingBoardView ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipTap;
@property (nonatomic, strong) UIPanGestureRecognizer *panTap;
@end


@implementation RunsDrawingBoardView

- (void)dealloc {
    RunsReleaseLog()
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initMember];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initMember];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initMember];
}

- (void)initMember {
    self.backgroundColor = [UIColor clearColor];
    self.swipTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    self.swipTap.direction = UISwipeGestureRecognizerDirectionDown;
    self.swipTap.enabled = NO;
    self.panTap = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    self.panTap.enabled = NO;
    [self addGestureRecognizer:self.swipTap];
    [self addGestureRecognizer:self.panTap];
    [self.panTap requireGestureRecognizerToFail:self.swipTap];
    
    id<RunsBrushProtocol> brush = [RunsBrushModel brushWithShape:ShapeType_Polyline color:UIColor.redColor thickness:1.5];
    self.brushModel = brush;
    self.proxy = (id<RunsDrawingBoardProxyProtocol>)[RunsDrawingBoardProxy new];
    //
    _drawEnable = NO;
}

#pragma mark -- RunsDrawingBoardViewProtocol

- (void)setDrawEnable:(BOOL)drawEnable {
    _drawEnable = drawEnable;
}

- (void)restore {

}

- (void)clear:(BOOL)canUndo {
    [self.proxy clear:canUndo];
    [self setNeedsDisplay];
}

- (void)clear {
    [self.proxy clear:YES];
    [self setNeedsDisplay];
}

- (void)undo:(BOOL)canRedo {
    [self.proxy undo:canRedo];
    [self setNeedsDisplay];
}

- (void)redo {
    [self.proxy redo];
    [self setNeedsDisplay];
}

- (void)setBrushModel:(id<RunsBrushProtocol>)brushModel {
    _brushModel = brushModel;
    self.textField.hidden = brushModel.shape != ShapeType_Text;
    self.swipTap.enabled = brushModel.shape == ShapeType_Text;
    self.panTap.enabled = brushModel.shape == ShapeType_Text;
    [self endEditing:brushModel.shape != ShapeType_Text];
}

- (void)drawPartWithBrush:(id<RunsBrushProtocol>)brush {
    if (!brush) return;
    [self.proxy drawPartWithBrush:brush];
    [self setNeedsDisplay];
}

- (void)eraseBrushIds:(NSArray <NSString *> *)brushIds {
    [self.proxy eraseBrushIds:brushIds];
    [self refresh];
}

- (void)updateBrushes:(NSArray <id <RunsBrushProtocol>> *)brushes {
    [self.proxy updateBrushes:brushes];
    [self refresh];
}

- (void)refresh {
    [self setNeedsDisplay];
}

- (NSArray<id<RunsBrushProtocol>> *)brushes {
    return self.proxy.brushes;
}
#pragma mark -- UITouch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    RunsLog(@"RunsDrawingBoardView touchesBegan")
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self.delegate respondsToSelector:@selector(drawingBoardView:didBeganPoint:)]) {
        [self.delegate drawingBoardView:self didBeganPoint:point];
    }
    if (!_drawEnable) return;
    //
    if (self.brushModel.shape == ShapeType_Text && !self.textField.isFirstResponder) {//文字特殊绘制
        CGRect rect = CGRectMake(point.x, point.y, 0, 0);
        NSValue *value = [NSValue valueWithCGRect:rect];
        [self.brushModel.frames removeAllObjects];
        [self.brushModel.frames addObject:value];
        UITextField *field = [self textField:point];
        [field becomeFirstResponder];
        return;
    }
    if (self.brushModel.shape != ShapeType_Text) {
        NSObject *object = (NSObject *)self.brushModel;
        [self.proxy drawBeganWithPoint:point brush:(id<RunsBrushProtocol>)[object rs_deepCopy]];
        return;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSArray * movePointArray = [touches allObjects];
    CGPoint point = [movePointArray.firstObject locationInView:self];
    if ([self.delegate respondsToSelector:@selector(drawingBoardView:didMovedPoint:)]) {
        [self.delegate drawingBoardView:self didMovedPoint:point];
    }
    if (!_drawEnable) return;
    //
    if (self.textField.isFirstResponder) return;
    [self.proxy drawMovedWithPoint:point];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self.delegate respondsToSelector:@selector(drawingBoardView:didEndedPoint:brush:)]) {
        [self.delegate drawingBoardView:self didEndedPoint:point brush:self.proxy.currentBrush];
    }
    if (!_drawEnable) return;
    //
   
    if (self.textField.isFirstResponder) return;
    
    [self.proxy drawEndedWithPoint:point];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self.delegate respondsToSelector:@selector(drawingBoardView:didEndedPoint:brush:)]) {
        [self.delegate drawingBoardView:self didEndedPoint:point brush:self.proxy.currentBrush];
    }
    if (!_drawEnable) return;
    //
    if (self.textField.isFirstResponder) return;
    [self.proxy drawEndedWithPoint:point];
    [self setNeedsDisplay];
}
#pragma mark -- UITextFieldDelegate

- (void)handleSwipeDown:(UISwipeGestureRecognizer*)sender {
    [self endEditing:YES];
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)sender {
    
    CGPoint point = [sender locationInView:self];
    CGFloat offsetX = (CGFloat) (self.textField.frame.size.width * 0.5);
    CGFloat offsetY = (CGFloat) (self.textField.frame.size.height * 0.5);
    CGRect frame = CGRectMake(point.x - offsetX, point.y - offsetY, self.textField.frame.size.width, self.textField.frame.size.height);
    [self updateTextFieldWithFrame:frame];
    [self.proxy drawTextChangedWithFrame:frame text:self.textField.text];
    [self setNeedsDisplay];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return _drawEnable;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!_drawEnable) return;
    //
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(((NSObject *)self.brushModel).rs_deepCopy);
    if (!model) return;
    [textField setHidden:NO];
    model.character = textField.text;
    [self.proxy drawTextBeganWithFrame:textField.frame brush:model];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (!_drawEnable) return;
    //
    CGRect frame = [self calculateFrameWithText:textField.text];
    [self updateTextFieldWithFrame:frame];
    [self.proxy drawTextChangedWithFrame:frame text:textField.text];
    [self setNeedsDisplay];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (!_drawEnable) return;
    //
    CGRect frame = [self calculateFrameWithText:textField.text];
    [self updateTextFieldWithFrame:frame];
    [self.proxy drawTextEndedWithFrame:frame text:textField.text];
    //
    [self restoreTextField];
    //
    [self setNeedsDisplay];
    //
    if ([self.delegate respondsToSelector:@selector(drawingBoardView:didEndedPoint:brush:)]) {
        [self.delegate drawingBoardView:self didEndedPoint:frame.origin brush:self.proxy.currentBrush];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.proxy drawWithContext:context];
}

#pragma mark -- Private

- (void)updateTextFieldWithFrame:(CGRect)frame {
    [self.textField setFrame:frame];
    UIImage *background = [UIImage rs_imageWithSize:(CGSize){frame.size.width, frame.size.height} borderColor:UIColor.grayColor borderWidth:1];
    self.textField.background = background;
}

- (void)restoreTextField {
    CGRect frame = [self calculateFrameWithText:self.textField.placeholder];
    UIImage *background = [UIImage rs_imageWithSize:CGSizeMake(frame.size.width, frame.size.height) borderColor:UIColor.grayColor borderWidth:1];
    self.textField.background = background;
    [self.textField setFrame:frame];
    self.textField.text = @"";
    [self.textField setHidden:YES];
}

- (UITextField *)textField:(CGPoint)point {
    if (_textField) {
        CGSize originSise = _textField.frame.size;
        _textField.frame = CGRectMake(point.x, point.y, originSise.width, originSise.height);
        return _textField;
    }
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(self.brushModel);
    if (!model || model.shape != ShapeType_Text) return nil;
    CGRect frame = CGRectMake(point.x, point.y, model.fontSize + 2, model.fontSize + 2);
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = [UIColor clearColor];
    textField.tintColor =[UIColor clearColor];
    textField.backgroundColor = [UIColor clearColor];
    textField.returnKeyType = UIReturnKeyDone;
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.borderWidth = 0;
    textField.placeholder = @"点此输入文字";
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [textField setTag:ShapeType_Text];
    textField.delegate = self;
    _textField = textField;
    [self addSubview:textField];
    [self restoreTextField];
    return textField;
}

- (CGRect)calculateFrameWithText:(NSString *)text {
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(((NSObject *)self.brushModel).rs_deepCopy);
    if (!model || model.shape != ShapeType_Text) return CGRectZero;
    CGPoint point = model.frames.firstObject.CGRectValue.origin;
    if (!CGRectEqualToRect(self.textField.frame, CGRectZero)) {
        point = self.textField.frame.origin;
    }
    
    UIFont *font = [UIFont systemFontOfSize:model.fontSize];
    CGFloat width = self.frame.size.width - point.x - 10;
    CGFloat height = self.frame.size.height - point.y - 10;
    
    CGSize size = [GKSimpleAPI getContentSizeWithText:text font:font size:(CGSize){width, height}];
    CGRect frame = (CGRect){point.x, point.y, size.width + 2, size.height + 2};
    RunsLogEX(@"calculateFrameWithText x = %f, y = %f",point.x, point.y);
    return frame;
}

@end






