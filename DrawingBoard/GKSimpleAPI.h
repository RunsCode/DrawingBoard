//
//  GKSimpleAPI.h
//  GuoKao
//
//  Created by wang on 16/4/11.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class OUPoint;

NS_ASSUME_NONNULL_BEGIN

@interface GKSimpleAPI : NSObject

/**
 获取UUID 每次都不同


 @return UUID
 */
+ (NSString* _Nonnull)UUID;

/**
 *  对象转json字符串
 *
 *  @param obj json object (NSArray / NSDictionary)
 *
 *  @return json string
 */
+ ( NSString* _Nonnull )objectConvertJson:(_Nonnull id)obj;
/**
 *  json字符串转对象
 *
 *  @param szValue json串
 *
 *  @return 目标对象
 */
+ (nonnull id)jsonConvertObject:(nonnull NSString*)szValue;

/**
 汉子转拼音返回大写
 
 @param chinese 汉字
 
 @return 大写无音标首字母
 */
+ (nullable NSString *)transform:(nonnull NSString *)chinese;
/**
 md5加密
 
 @param input 输入加密前字符串
 
 @return 返回加密后字符串
 */
+ (nullable NSString *)md5:(nonnull NSString *)input;
/**
 *  给不同文字上色
 *
 *  @param szOriginalString 所有文字
 *  @param szRegionString   着色文字
 *  @param color            着色字体颜色
 *
 *  @return 返回对应着色文本
 */
+ (nonnull NSMutableAttributedString *)makeAttributedString:(nonnull NSString *)szOriginalString regionString:(nonnull NSString*)szRegionString regionStringColor:(nonnull UIColor*)color;
/**
 *  根据label.text计算大小
 *
 *  @param _label 当前需要适配的label
 *  @param _size  指定范围CGSize
 *
 *  @return 返回计算后的size
 */
+ (CGSize)getContentSize:(nonnull UILabel *)_label andSize:(CGSize)_size;
/**
 *  根据字符串计算大小
 *
 *  @param text    需要计算的字符串
 *  @param font    字符串字体格式
 *  @param maxSize 期望最大值
 *
 *  @return 返回计算后的size
 */
+ (CGSize)getContentSizeWithText:(nonnull NSString *)text font:(nonnull UIFont *)font size:(CGSize)maxSize;
/**
 *  手机号码正则表达式检测
 *
 *  @param mobile 接受输入的手机号码
 *
 *  @return YES OR NO
 */
+ (BOOL)checkMobileNumber:(nonnull NSString *)mobile;

/**
 验证码正则表达式检测

 @param code 验证码
 @param bits 极为 的验证码
 @return YES OR NO
 */
+ (BOOL)checkVerifyCode:(nonnull NSString *)code withBits:(NSUInteger)bits;
/**
 *  邮箱正则表达式检查
 *
 *  @param address 接受输入的邮箱
 *
 *  @return YES OR NO
 */
+ (BOOL)chackEmailAddress:(nonnull NSString *)address;
/**
 *  移除沙盒文件
 *
 *  @param dataFilePath 文件路径
 *
 *  @return 返回是否移除成功
 */
+ (BOOL)deleteFileWithPath:(nonnull NSString *)dataFilePath;
/**
 *  获取SD图片缓存
 *
 *  @param url                  链接
 *  @param placeHolderImageName 替代图名字
 *
 *  @return 返回图片
 */
+ (nonnull UIImage *)fetchCacheImageWithUrl:(nonnull NSURL *)url placeholderImage:(nullable NSString *)placeHolderImageName;
/**
 *  获取视频第一帧图片
 *
 *  @param videoUrl 链接
 *
 *  @return 返回图片
 */
+ (nullable UIImage *)fetchVideoPreViewImageWithUrl:(nonnull NSURL *)videoUrl;
/**
 *  获取视频任意一帧图片
 *
 *  @param videoURL 链接
 *  @param time 时间帧
 *
 *  @return 返回图片
 */
+ (nonnull UIImage *) thumbnailImageForVideo:(nonnull NSURL *)videoURL atTime:(NSTimeInterval)time;
/**
 *  视频压缩
 *
 *  @param videoUrl 链接
 *  @param callback 压缩结果回调
 *
 */
+ (void)compressVideoWithUrl:( nonnull NSURL * )videoUrl completed:( void (^ _Nonnull ) ( NSData * _Nullable  data))callback;
/**
 *  把自身layer画成一张图片（截屏）
 *
 *  @param layer 截图层
 *
 */
+ (nullable UIImage *)imageByRenderingLayer:(nonnull CALayer *)layer;
/**
 *  获取音视频文件的Metadata信息(可以获取到mp3以及m4a的相关信息)
 *  AVMetadataCommonKeyArtwork这个参数是可以换的,换不同的参数可以取得不同的值
 *  [注意]此方法中用到了信号量将异步操作转换成了同步操作,尽量在主线程中使用
 *  @param fileURL 文件的URL地址
 *
 *  @return 一个包含了相关内容的字典
 */
+ (nullable NSDictionary *)dataInfoFromFileURL:(nonnull NSURL *)fileURL;
/**
 *  http数据返回适配转换
 *
 *  @param response 服务器返回数据
 *
 */
+ (nullable NSDictionary *)dataConversionAdaption:(id _Nullable )response;
/**
 *  日志重定向
 *
 */
+ (void)switchStderrToFile;

/**
 随机生成目标位汉字

 @param bits 多少位
 @return 随机汉字
 */
+ (NSString *_Nullable)randomGenerateChineseCharacter:(NSUInteger)bits;

/**
 计算点到线（两点确定一条直线）的垂直距离

 @param start 线的起始点
 @param end 线的尾端
 @param point 点
 @return 距离
 */
+ (CGFloat)calculateTheVerticalDistanceFromPointToLineStart:(CGPoint)start endPoint:(CGPoint)end point:(CGPoint)point;

/**
 道格拉斯-普克算法(D-P)  根据最大距离限制，采用DP方法递归的对原始轨迹进行采样，得到压缩后的轨迹

 @param points 原始坐标组
 @param epsilon 点到直线最大距离阈值
 @return 目标数组
 */
+ (NSArray<NSValue *> *)douglasPeucker:(NSArray<NSValue *> *)points epsilon:(float)epsilon;
@end
NS_ASSUME_NONNULL_END
