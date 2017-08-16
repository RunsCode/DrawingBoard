//
//  RunsBrushCharacterModel.h
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunsBrushProtocol.h"

@interface RunsBrushCharacterModel : NSObject<RunsBrushProtocol, NSCopying, NSCoding>

@property (nonatomic, assign) ShapeType shape;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) NSMutableArray<NSValue*> *frames;

@property (nonatomic, assign) NSUInteger fontSize;
@property (nonatomic, copy) NSString *character;

+ (instancetype)defaultWithShape:(ShapeType)shape text:(NSString *)text color:(UIColor *)color font:(CGFloat)fontSize frame:(CGRect)frame;
@end
