//
//  RunsBrushCharacterModel.m
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsBrushCharacterModel.h"
#import <objc/runtime.h>
#import "NSObject+RuntimeLog.h"

@implementation RunsBrushCharacterModel

- (id)copyWithZone:(NSZone *)zone {
    RunsBrushCharacterModel *model = [[[self class] allocWithZone:zone] init];
    model.shape = self.shape;
    model.color = self.color;
    model.character = self.character;
    model.fontSize = self.fontSize;
    model.frames = self.frames;
    return model;
}

- (instancetype)deepCopy {
    return [self rs_deepCopy];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivarLists = class_copyIvarList([RunsBrushCharacterModel class], &count);
    for (int i = 0; i < count; i++) {
        const char* name = ivar_getName(ivarLists[i]);
        NSString* strName = [NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:strName] forKey:strName];
    }
    free(ivarLists);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivarLists = class_copyIvarList([RunsBrushCharacterModel class], &count);
        for (int i = 0; i < count; i++) {
            const char* name = ivar_getName(ivarLists[i]);
            NSString* strName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [aDecoder decodeObjectForKey:strName];
            [self setValue:value forKey:strName];
        }
        free(ivarLists);
    }
    return self;
}

- (instancetype)initWithShape:(ShapeType)shape text:(NSString *)text color:(UIColor *)color font:(CGFloat)fontSize frame:(CGRect)frame {
    self = [super init];
    if (self) {
        _shape = shape;
        _character = text;
        _color = color;
        _fontSize = fontSize;
        _frames = [NSMutableArray arrayWithObject:[NSValue valueWithCGRect:frame]];
    }
    return self;
}

+ (instancetype)brushWithShape:(ShapeType)shape color:(UIColor *)color thickness:(CGFloat)width {
    RunsBrushCharacterModel *model = [[RunsBrushCharacterModel alloc] initWithShape:shape text:@"" color:color font:DEFAULT_WHITEBOARD_FONT_SIZE(14.f) frame:CGRectZero];
    return model;
}

+ (instancetype)defaultWithShape:(ShapeType)shape text:(NSString *)text color:(UIColor *)color font:(CGFloat)fontSize frame:(CGRect)frame {
    RunsBrushCharacterModel *model = [[RunsBrushCharacterModel alloc] initWithShape:shape text:text color:color font:fontSize frame:frame];
    return model;
}

- (NSString *)debugDescription {
    
    NSString *shape = nil;
    switch (self.shape) {
        case ShapeType_Polyline:
            shape = @"折线";
            break;
        case ShapeType_Beeline:
            shape = @"直线";
            break;
        case ShapeType_Square:
            shape = @"矩形";
            break;
        case ShapeType_Ellipse:
            shape = @"椭圆";
            break;
        case ShapeType_Round:
            shape = @"正圆";
            break;
        case ShapeType_Text:
            shape = @"文字";
            break;
        case ShapeType_Eraser:
            shape = @"橡皮擦";
            break;
            
        default:
            break;
    }
    
    NSString *debug = [NSString stringWithFormat:@"shape : %@, fontsize : %f, text: %@ \n", shape, self.fontSize, self.character];
    NSMutableString *point = [NSMutableString string];
    [self.frames enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = obj.CGRectValue;
        NSString *str = [NSString stringWithFormat:@"x : %f,  y : %f,  w : %f,  h : %f \n",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height];
        [point appendString:str];
    }];
    
    return [NSString stringWithFormat:@"%@%@",debug,point];
}

@end
