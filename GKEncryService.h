
#import <Foundation/Foundation.h>

static unsigned int const SM4_BLOCK_SIZE = 16;

NS_ASSUME_NONNULL_BEGIN

@interface GKEncryService : NSObject

/// 随机数生成 (位数 8/16/32)
+ (NSString *)randomString4Length:(unsigned int)len;

#pragma mark --- SM4 ALGORITHM For data1 ---

///随机数
+ (NSString *)randomSM4Key;

/// 对Data进行SM4加密处理
/// @param plainData 原始数据
/// @param key 随机key
+ (NSData * _Nullable)sm4_encryptData:(NSData *)plainData withCipherKey:(NSString *)key;

/// 对Data进行SM4解密处理
/// @param cipherData 加密数据
/// @param key 随机key
+ (NSData * _Nullable)sm4_decryptData:(NSData *)cipherData withCipherKey:(NSString *)key;

#pragma mark - SM2 ALGORITHM For key1

+ (NSString * _Nullable)sm2_encryptPubKey:(NSString *)pubkey withCipherKey:(NSString *)key;

+ (NSString * _Nullable)sm2_decryptData:(NSString *)cipherData withPriKey:(NSString *)priKey;

#pragma mark --- SM3 ALGORITHM For hash（key1 + data1） ---

///  hash data 进行SM3处理
/// @param plainData 原始数据
- (NSData * _Nullable)sm3_hashWithPainData:(NSData *)plainData;

@end

NS_ASSUME_NONNULL_END
