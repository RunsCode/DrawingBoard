//
//  RunsDrawingBoardView.m
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsDrawingBoardView.h"

#import "RunsBrushProtocol.h"
#import "RunsShapeProtocol.h"
#import "RunsDrawingBoardProxyProtocol.h"
#import "RunsDrawingBoardOperatingProtocol.h"
#import "RunsDrawingBoardViewDelegate.h"

#import "RunsDrawingBoardProxy.h"
#import "RunsBrushCharacterModel.h"

@interface RunsDrawingBoardView ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipTap;
@property (nonatomic, strong) id<RunsDrawingBoardProxyProtocol> proxy;
@end


@implementation RunsDrawingBoardView

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
    self.swipTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipDown:)];
    self.swipTap.direction = UISwipeGestureRecognizerDirectionDown;
    self.swipTap.enabled = NO;
    [self addGestureRecognizer:self.swipTap];
}

- (void)initMember {
    self.proxy = (id<RunsDrawingBoardProxyProtocol>)[RunsDrawingBoardProxy new];
}

- (void)clear {
    [self.proxy clear];
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
}

#pragma mark -- UITextFieldDelegate

- (void)onSwipDown:(UISwipeGestureRecognizer*)sender {
    [self endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(self.copyByBrush);
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
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(self.brushModel);
    if (!model) return;
    CGRect frame = [self calculteFrameWithText:textField.text];
    [self updateTextFieldWithFrame:frame];
    [self.proxy drawTextChangedWithFrame:frame text:textField.text];
    [self setNeedsDisplay];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(self.copyByBrush);
    if (!model) return;
    CGRect frame = [self calculteFrameWithText:textField.text];
    [self updateTextFieldWithFrame:frame];
    [self.proxy drawTextEndedWithFrame:frame text:textField.text];
    //
    [self restoreTextField];
    //
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (self.brushModel.shape == ShapeType_Text && !self.textField.isFirstResponder) {//文字特殊绘制
        CGRect rect = CGRectMake(point.x, point.y, 0, 0);
        NSValue *value = [NSValue valueWithCGRect:rect];
        [self.brushModel.frames removeAllObjects];
        [self.brushModel.frames addObject:value];
        UITextField *field = [self textField:point];
        [field becomeFirstResponder];
        
        
        return;
    }
    
    [self.proxy drawBeganWithPoint:point brush:self.copyByBrush];
    
    if ([self.delegate respondsToSelector:@selector(drawingBoardView:didBeganPoint:)]) {
        [self.delegate drawingBoardView:self didBeganPoint:point];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray * movePointArray = [touches allObjects];
    CGPoint point = [movePointArray.firstObject locationInView:self];
    [self.proxy drawMovedWithPoint:point];
    [self setNeedsDisplay];
    
    if ([self.delegate respondsToSelector:@selector(drawingBoardView:didMovedPoint:)]) {
        [self.delegate drawingBoardView:self didMovedPoint:point];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.proxy drawEndedWithPoint:point];
    [self setNeedsDisplay];
    
    if ([self.delegate respondsToSelector:@selector(drawingBoardView:didEndedPoint:)]) {
        [self.delegate drawingBoardView:self didEndedPoint:point];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.proxy drawEndedWithPoint:point];
    [self setNeedsDisplay];                             

    if ([self.delegate respondsToSelector:@selector(drawingBoardView:didEndedPoint:)]) {
        [self.delegate drawingBoardView:self didEndedPoint:point];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.proxy drawWithContext:context];
}

#pragma mark -- Private

- (id<RunsBrushProtocol>)copyByBrush {
    if (!_brushModel) return nil;
    NSData *archiveForCopy = [NSKeyedArchiver archivedDataWithRootObject:self.brushModel];
    NSObject *deepCoy = [NSKeyedUnarchiver unarchiveObjectWithData:archiveForCopy];
    return (id<RunsBrushProtocol>)deepCoy;
}

- (void)updateTextFieldWithFrame:(CGRect)frame {
    [self.textField setFrame:frame];
    UIImage *background = [self imageWithSize:(CGSize){frame.size.width, frame.size.height} borderColor:UIColor.grayColor borderWidth:1];
    self.textField.background = background;
}

- (void)restoreTextField {
    CGRect frame = [self calculteFrameWithText:self.textField.placeholder];
    UIImage *background = [self imageWithSize:CGSizeMake(frame.size.width, frame.size.height) borderColor:UIColor.grayColor borderWidth:1];
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
    if (!model) return nil;
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

- (CGRect)calculteFrameWithText:(NSString *)text {
    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(self.copyByBrush);
    if (!model) return CGRectZero;
    CGPoint point = model.frames.firstObject.CGRectValue.origin;
    UIFont *font = [UIFont systemFontOfSize:model.fontSize];
    CGFloat width = self.frame.size.width - point.x - 10;
    CGFloat height = self.frame.size.height - point.y - 10;
    
    CGSize size = [self getContentSizeWithText:text font:font size:(CGSize){width, height}];
    CGRect frame = (CGRect){point.x, point.y, size.width + 2, size.height + 2};
    NSLog(@"calculteFrameWithText x = %f, y = %f",point.x, point.y);
    return frame;
}

- (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGSize)getContentSizeWithText:(nonnull NSString *)text font:(nonnull UIFont *)font size:(CGSize)maxSize {
    CGSize size;
    NSDictionary * tdic  = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    size.height += 2;//加两个像素,防止emoji被切掉.
    size.width = size.width >= maxSize.width ? maxSize.width : size.width;
    return size;
}

@end






