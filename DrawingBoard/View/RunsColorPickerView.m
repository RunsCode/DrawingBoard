//
//  RunsColorPickerView.m
//  DrawingBoard
//
//  Created by runs on 2017/8/14.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsColorPickerView.h"
#import "RunsControlProtocol.h"

@interface RunsColorPickerView ()<RunsControlProtocol>

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) RunsControlCallback callback;
@property (nonatomic, strong) HRColorPickerView *colorPickerView;
@end

@implementation RunsColorPickerView

- (instancetype)init {
    CGRect rect = CGRectMake(0, 0, 480, 588);
    self = [super initWithFrame:rect];
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

- (void)initMember {
    self.color = [UIColor greenColor];
    self.hidden = YES;
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
    self.alpha = 0.0f;
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged];
}

- (void)action:(HRColorPickerView *)picker {
    NSLog(@"%@", picker.color);
    if (self.callback) {
        self.callback(_type, picker.color);
    }
}

- (void)setType:(NSInteger)type {
    _type = type;
}


- (void)setCallback:(RunsControlCallback)callback {
    _callback = callback;
}

- (void)run {
    
    self.hidden = NO;
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
    }];
}

- (void)stop {
    [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
 
}

- (void)callback:(RunsControlCallback)callback {
    
}


@end
