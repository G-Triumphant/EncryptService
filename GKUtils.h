
/**
 * 加解密可能用到的工具
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKUtils : NSObject

#pragma mark - Hex 编码/解码

/// 字符串 16 进制编码。返回值：16 进制编码的字符串
/// @param str 待编码的字符串
+ (nullable NSString *)stringToHex:(NSString *)str;

/// NSData 16 进制编码。返回值：16 进制编码的字符串
/// @param data 原数据（NSData 格式）
+ (nullable NSString *)dataToHex:(NSData *)data;

/// 16 进制字符串解码。返回值：解码后的原文
/// @param hexStr 16 编码进制字符串
+ (nullable NSString *)hexToString:(NSString *)hexStr;

/// 16 进制字符串解码为 NSData。返回值：解码后的 NSData 对象
/// @param hexStr 16 编码进制字符串
+ (nullable NSData *)hexToData:(NSString *)hexStr;

#pragma mark - Base64 编码/解码

/// base64 编码。返回值：编码后的 base64 字符串
/// @param data 待编码的数据
+ (nullable NSString *)base64Encode:(NSData *)data;

/// base64 解码。返回值：解码后的 NSData 对象
/// @param base64Str base64 编码格式字符串
+ (nullable NSData *)base64Decode:(NSString *)base64Str;

#pragma mark - NSString/NSData、Base64 相互转化

/// NSData 转 NSString。返回值：utf-8 的字符串
/// @param data 待转的二进制数据
+ (nullable NSString *)utf8WithData:(NSData *)data;

/// NSString 转 NSData。返回值：编码后的 NSData 对象
/// @param str 待转的字符串
+ (nullable NSData *)dataWithUft8Str:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
