//
//  RunsTextFieldView.m
//  DrawingBoard
//
//  Created by runs on 2017/8/17.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsTextFieldView.h"

@interface RunsTextFieldView ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;

@end

@implementation RunsTextFieldView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark -- UITextFieldDelegate

- (void)handleSwipDown:(UISwipeGestureRecognizer*)sender {
    [self endEditing:YES];
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)sender {
    
    CGPoint netTranslation;//= self.textField.frame.origin;
    CGPoint translation = [(UIPanGestureRecognizer *)sender translationInView:self.textField];
    //平移文字区域
    sender.view.transform = CGAffineTransformMakeTranslation(netTranslation.x + translation.x, netTranslation.y + translation.y);
    if(sender.state == UIGestureRecognizerStateEnded) {
        netTranslation.x += translation.x;
        netTranslation.y += translation.y;
        //        [self updateTextFieldWithFrame:CGRectMake(translation.x, translation.y, self.textField.frame.size.width, self.textField.frame.size.height)];
    }
    NSLog(@"netTranslation x = %f, y = %f", netTranslation.x, netTranslation.y);
    NSLog(@"translation x= %f, y = %f", translation.x, translation.y);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    RunsBrushCharacterModel *model = (RunsBrushCharacterModel *)(self.copyByBrush);
//    if (!model) return;
//    [textField setHidden:NO];
//    model.character = textField.text;
//    [self.proxy drawTextBeganWithFrame:textField.frame brush:model];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
//    CGRect frame = [self calculteFrameWithText:textField.text];
//    [self updateTextFieldWithFrame:frame];
//    [self.proxy drawTextChangedWithFrame:frame text:textField.text];
//    [self setNeedsDisplay];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    CGRect frame = [self calculteFrameWithText:textField.text];
    [self updateTextFieldWithFrame:frame];
//    [self.proxy drawTextEndedWithFrame:frame text:textField.text];
    //
    [self restoreTextField];
    //
//    [self setNeedsDisplay];
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
    CGRect frame = CGRectMake(point.x, point.y, 18, 18);
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = [UIColor clearColor];
    textField.tintColor =[UIColor clearColor];
    textField.backgroundColor = [UIColor clearColor];
    textField.returnKeyType = UIReturnKeyDone;
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.borderWidth = 0;
    textField.placeholder = @"点此输入文字";
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    textField.delegate = self;
    _textField = textField;
    [self addSubview:textField];
    [self restoreTextField];
    return textField;
}

- (CGRect)calculteFrameWithText:(NSString *)text {
//    CGPoint point = model.frames.firstObject.CGRectValue.origin;
//    UIFont *font = [UIFont systemFontOfSize:model.fontSize];
//    CGFloat width = self.frame.size.width - point.x - 10;
//    CGFloat height = self.frame.size.height - point.y - 10;
//    
//    CGSize size = [self getContentSizeWithText:text font:font size:(CGSize){width, height}];
//    CGRect frame = (CGRect){point.x, point.y, size.width + 2, size.height + 2};
//    NSLog(@"calculteFrameWithText x = %f, y = %f",point.x, point.y);
    return CGRectNull;
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
