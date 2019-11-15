//
//  GKSimpleAPI.m
//  GuoKao
//
//  Created by wang on 16/4/11.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "GKSimpleAPI.h"
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreMedia/CoreMedia.h>

@implementation GKSimpleAPI

#pragma mark -- NSString 

+ (NSString *)UUID {
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
    CFRelease(uuidRef);
    return uuid;
}

+ (nonnull NSString*)objectConvertJson:(id)obj {
    if (!obj) {
        return nil;
    }
    NSError * error = nil;
    // Pass 0 if you don't care about the readability of the generated string
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&error];
    if (error) {
        NSLog(@"%@",error);
        return @"{}";
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id)jsonConvertObject:(nonnull NSString*)szValue {
    if (!szValue) {
        return nil;
    }
    NSError * error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:[szValue dataUsingEncoding:NSUTF8StringEncoding]
                                             options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@",error.description);
        return nil;
    }
    return obj;
}

+ (unsigned long long)currentSystemTime {
    return time(NULL);
}

+ (nullable NSString *)transform:(NSString *)chinese {
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [[pinyin uppercaseString] substringToIndex:1];
}

+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (uint32_t)strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

#pragma mark -- NSMutableAttributedString

+ (nonnull NSMutableAttributedString *)makeAttributedString:(nonnull NSString*)szOriginalString regionString:(nonnull NSString*)szRegionString regionStringColor:(nonnull UIColor*)color {
    if (szOriginalString == nil){
        szOriginalString = @"";
    }
    if (!szRegionString) {
        return nil;
    }
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:szOriginalString];
    [strAtt addAttribute:NSForegroundColorAttributeName value:color range:[szOriginalString rangeOfString:szRegionString]];
    return strAtt;
}

#pragma mark -- CGSize

+ (CGSize)getContentSize:(UILabel *)_label andSize:(CGSize)_size {
    return [self getContentSizeWithText:_label.text font:_label.font size:_size];
}

+ (CGSize)getContentSizeWithText:(nonnull NSString *)text font:(nonnull UIFont *)font size:(CGSize)maxSize {
    CGSize size;
    NSDictionary * tdic  = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    size.height += 2;//加两个像素,防止emoji被切掉.
    size.width = size.width >= maxSize.width ? maxSize.width : size.width;
    return size;
}

#pragma mark -- BOOL

+ (BOOL)checkMobileNumber:(nonnull NSString *)numberStr {
    if (numberStr.length <= 0)  return NO;
    NSString * regex = @"^1[34578]\\d{9}";
    NSPredicate  * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:numberStr];
}

+ (BOOL)checkVerifyCode:(nonnull NSString *)code withBits:(NSUInteger)bits {
    if (code.length <= 0) return NO;
    NSString * regex = [NSString stringWithFormat:@"^\\d{%lu}", (unsigned long)bits];
    NSPredicate  * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:code];
}

+ (BOOL)chackEmailAddress:(nonnull NSString *)address {
    if (address.length <= 0)  return NO;
    NSString * regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate  * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:address];
}

+ (BOOL)deleteFileWithPath:(nonnull NSString *)dataFilePath {
    BOOL success = NO;
    NSError *error = nil;
    if (dataFilePath.length <= 0) {
        return success;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:dataFilePath]) {
        success = [fileManager removeItemAtPath:dataFilePath error:&error];
        if (!success) {
#ifdef DEBUG
            NSString * tips = [NSString stringWithFormat:@"Failed to delete data file with message '%@'.", error.localizedDescription];
            NSAssert(!success, tips);
#endif
        }
    }
    return success;
}

#pragma mark -- UIImage

+ (nonnull UIImage *)fetchCacheImageWithUrl:(nonnull NSURL *)url placeholderImage:(nullable NSString *)placeholderImageName {
    return nil;
}

#pragma mark -- Video

+ (UIImage *)fetchVideoPreViewImageWithUrl:(NSURL *)videoUrl {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    NSAssert(asset,@"非法参数");
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetImageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}

+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSAssert(asset,@"非法参数");
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}

+ (void)compressVideoWithUrl:(NSURL *)videoUrl completed:(void (^) (NSData * data))callback {
    NSLog(@"开始压缩,压缩前大小 %f MB",[NSData dataWithContentsOfURL:videoUrl].length/1024.00/1024.00);
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    NSURL * outputUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"outPut.mov"]];
    if ([[NSFileManager defaultManager]fileExistsAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"outPut.mov"]]) {
        [[NSFileManager defaultManager] removeItemAtURL:outputUrl error:nil];
    }
    exportSession.outputURL = outputUrl;
    exportSession.shouldOptimizeForNetworkUse = true;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                NSData * data = [NSData dataWithContentsOfURL:outputUrl];
                NSLog(@"压缩完毕,压缩后大小: %f MB",data.length/1024.00/1024.00);
                if (callback) {
                    callback(data);
                }
            }else{
#ifdef DEBUG
                NSLog(@"当前压缩进度:%f",exportSession.progress);
                NSError *exportError = exportSession.error;
                NSLog(@"AVAssetExportSessionStatusFailed: %@", exportError);
#endif
                if (callback) {
                    callback(nil);
                }
            }
        });
    }];
}

 //把自身layer画成一张图片（截屏）
+ (UIImage *)imageByRenderingLayer:(CALayer *)layer {
    //保存当前页面的alpha值
    CGFloat oldAlpha = layer.opacity;
    //将当前页面的alpha值设为1，保证当前页面处于非透明状态
    layer.opacity = 1.0;
    
    //创建一个基于位图的上下文(context),并把它push到上下文栈顶,将其设置为当前上下文
    UIGraphicsBeginImageContext(layer.bounds.size);
    //把当前的整个画面导入到context中，然后通过context输出UIImage，这样就可以把整个屏幕转化为图片
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    //把当前context的内容输出成一个UIImage图片
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    //上下文栈pop出创建的context
    UIGraphicsEndImageContext();
    
    //把当前页面画成图片之后，就可以把当前页面的alpha值还原了
    layer.opacity = oldAlpha;
    
    //把画出来的图片返回出去
    return resultingImage;
}

+ (NSDictionary *)dataInfoFromFileURL:(NSURL *)fileURL {
    // 创建字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // 创建信号量(将异步变成同步)
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    AVAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    [asset loadValuesAsynchronouslyForKeys:@[@"commonMetadata"]
                         completionHandler:^{
                             // 发送信号量
                             dispatch_semaphore_signal(semaphore);
                         }];
    // 无限等待
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    // 获取数据
    NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                       withKey:AVMetadataCommonKeyArtwork
                                                      keySpace:AVMetadataKeySpaceCommon];
    for (AVMetadataItem *item in artworks) {
        if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
            NSDictionary *dict = [item.value copyWithZone:nil];
            // 获取图片
            UIImage  *image = [UIImage imageWithData:[dict objectForKey:@"data"]];
            [dic setObject:image forKey:@"Artwork"];
        }
        if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
            // 获取图片
            UIImage *image = [UIImage imageWithData:[item.value copyWithZone:nil]];
            [dic setObject:image forKey:@"Artwork"];
        }
    }
    return [NSDictionary dictionaryWithDictionary:dic];
}

+ (NSDictionary *)dataConversionAdaption:(id)response {
    if ([response isKindOfClass:NSData.class]) {
        NSError * error = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
        if (!obj || error) {
            NSString * content = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            return @{@"content":content};
        }
        return obj;
    }
    
    if ([response isKindOfClass:NSDictionary.class]) {
        return response;
    }
    
    if ([response isKindOfClass:NSString.class]) {
        return [GKSimpleAPI jsonConvertObject:response];
    }
    
    return @{@"null":@"null"};
}

+ (void)switchStderrToFile {
#ifdef DEBUG
    NSString *paths =  NSTemporaryDirectory();// NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *logPath = [paths stringByAppendingPathComponent:@"App.log"] ;
    NSString *logbakPath = [paths stringByAppendingPathComponent:@"App_Bak.log"] ;
    
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:logPath]) {
        BOOL needBakLogFile = NO;
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:logPath error:&error];
        if(fileAttributes != nil) {
            NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
            // 大于200KB时切换log文
            needBakLogFile = ([fileSize unsignedLongLongValue] > 1024*1024*2);
        }
        if (needBakLogFile) {
            // 使日志文件控制在200KB * 2左右
            [fileManager removeItemAtPath:logbakPath error:&error];
            // 改名效率会高些
            [fileManager moveItemAtPath:logPath toPath:logbakPath error:&error];
        }
    }
    // 将日志文件重定向到文件
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
#else
#endif
}

+ (NSString *)randomGenerateChineseCharacter:(NSUInteger)bits {
    NSString *values = @"";
    for (int i = 0; i < bits; i++) {
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1+1);
        NSInteger randomL = 0xB0+arc4random()%(0xF7 - 0xB0+1);
        NSInteger number = (randomH<<8)+randomL;
        NSData *data = [NSData dataWithBytes:&number length:2];
        NSString *string = [[NSString alloc] initWithData:data encoding:gbkEncoding];
        values = [NSString stringWithFormat:@"%@%@",values,string];
    }
    return values;
}

+ (CGFloat)calculateTheVerticalDistanceFromPointToLineStart:(CGPoint)start endPoint:(CGPoint)end point:(CGPoint)point {
    //直线方程 直线方程的一般式Ax+By+C = 0
    //A=y2-y1
    //B=x1-x2
    //C=x2*y1-x1*y2
    CGFloat A = end.y - start.y;
    CGFloat B = start.x - end.x;
    CGFloat C = end.x * start.y - start.x * end.y;
    //点到直线的距离公式 d = ( Ax0 + By0 + C ) / sqrt ( A*A + B*B )
    CGFloat d = (A * point.x + B * point.y + C) / sqrt(A * A + B * B);
    return fabs(d);
}


+ (NSArray<NSValue *> *)douglasPeucker:(NSArray<NSValue *> *)points epsilon:(float)epsilon {
    NSUInteger count = [points count];
    if(count < 3) {
        return points;
    }
    
    float dmax = 0;
     NSUInteger index = 0;
    for(int i = 1; i < count - 1; i++) {
        CGPoint point = points[i].CGRectValue.origin;
        CGPoint lineA = points.firstObject.CGRectValue.origin;
        CGPoint lineB = points.lastObject.CGRectValue.origin;
        float d = [self calculateTheVerticalDistanceFromPointToLineStart:lineA endPoint:lineB point:point];
        if(d > dmax) {
            index = i;
            dmax = d;
        }
    }
    
    NSArray *resultList;
    if(dmax > epsilon) {
        NSArray *recResults1 = [self douglasPeucker:[points subarrayWithRange:NSMakeRange(0, index + 1)] epsilon:epsilon];
        NSArray *recResults2 = [self douglasPeucker:[points subarrayWithRange:NSMakeRange(index, count - index)] epsilon:epsilon];
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:recResults1];
        [tmpList removeLastObject];
        [tmpList addObjectsFromArray:recResults2];
        resultList = tmpList;
    } else {
        resultList = [NSArray arrayWithObjects:[points objectAtIndex:0], [points objectAtIndex:count - 1],nil];
    }
    return resultList;
}

@end
