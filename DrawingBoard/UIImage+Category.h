//
//  UIImage+Category.h
//  OU_iPad
//
//  Created by runs on 2017/8/24.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
+ (instancetype)rs_imageWithColor:(UIColor *)color;
+ (instancetype)rs_imageWithColor:(UIColor *)color size:(CGSize)size;
+ (instancetype)rs_imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
- (UIImage *)rs_round;
- (UIImage *)rs_corner:(CGFloat)radius;
- (UIImage *)rs_scaledWithSize:(CGSize)size;
- (UIImage *)rs_merge:(UIImage *)image;
@end
