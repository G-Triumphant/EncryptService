
#import "GKEncryService.h"

#import "sm4.h"
#import "GKSm2Utils.h"
#import "GKUtils.h"
#import "sm3.h"

@implementation GKEncryService

// 随机数
+ (NSString *)randomString4Length:(unsigned int)len {
    if (len <= 0) {
        return nil;
    }
    NSString *sourceString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    NSMutableString *result = [[NSMutableString alloc] init];
    unsigned c_len = (unsigned)sourceString.length;
    for (int i = 0; i < len; i++){
        unsigned index = arc4random() % c_len;
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result.copy;
}

#pragma mark --- SM4 ALGORITHM ---

+ (NSString *)randomSM4Key {
    return [self randomString4Length:SM4_BLOCK_SIZE];
}

+ (NSData *)sm4_encryptData:(NSData *)plainData withCipherKey:(NSString *)key {
    if (plainData == nil) {
        NSLog(@"got an empty data!");
        return plainData;
    }
    if (key.length != SM4_BLOCK_SIZE) {
        NSLog(@"got a bad sm4 key!");
        return nil;
    }

    // a.对明文数据进行填充来保证位数是16的倍数
    int plainDataLength = (int)plainData.length;
    // p是需要填充的数据也是填充的位数
    int p = SM4_BLOCK_SIZE - plainDataLength % SM4_BLOCK_SIZE;
    unsigned char plainChar[plainDataLength + p];
    memcpy(plainChar, plainData.bytes, plainDataLength);
    // 进行数据填充
    for (int i = 0; i < p; i++) {
        plainChar[plainDataLength + i] = p;
    }

    // 定义输出密文的变量
    unsigned char cipherOutChar[plainDataLength + p];
    unsigned char iv[16]   = {0x01,0x23,0x45,0x67,0x89,0xab,0xcd,0xef,0xfe,0xdc,0xba,0x98,0x76,0x54,0x32,0x10};
    const char* utf8Key = [key UTF8String];
    size_t len = strlen(utf8Key) + 1;
    unsigned char sm4Key[len];
    memcpy(sm4Key, utf8Key, len);
    sm4_context ctx;
    // 设置上下文和密钥
    sm4_setkey_enc(&ctx,sm4Key);
    // 加密
    sm4_crypt_cbc(&ctx, SM4_ENCRYPT, plainDataLength + p, iv, plainChar, cipherOutChar);
    // 对加密的数据输出
    NSData *cipherTextData =  [[NSData alloc]initWithBytes:cipherOutChar length:sizeof(cipherOutChar)];

    return cipherTextData;
}

+ (NSData *)sm4_decryptData:(NSData *)cipherData withCipherKey:(NSString *)key {
    if (cipherData == nil) {
        NSLog(@"got an empty data!");
        return cipherData;
    }
    if (key.length != SM4_BLOCK_SIZE) {
        NSLog(@"got a bad sm4 key!");
        return nil;
    }
    unsigned char iv[16]   = {0x01,0x23,0x45,0x67,0x89,0xab,0xcd,0xef,0xfe,0xdc,0xba,0x98,0x76,0x54,0x32,0x10};
    const char* utf8Key = [key UTF8String];
    size_t len = strlen(utf8Key) + 1;
    unsigned char sm4Key[len];
    memcpy(sm4Key, utf8Key, len);
    // 将data拷贝到字符数组中
    unsigned char cipherTextChar[cipherData.length];
    memcpy(cipherTextChar, cipherData.bytes, cipherData.length);
    // 调用解密方法，输出是明文plainOutChar
    unsigned char plainOutChar[cipherData.length];
    // 设置上下文和密钥
    sm4_context ctx;
    sm4_setkey_dec(&ctx,sm4Key);
    sm4_crypt_cbc(&ctx, SM4_DECRYPT, (int)cipherData.length, iv, cipherTextChar, plainOutChar);

    // 由于明文是填充过的，解密时候要去填充，去填充要在解密后才可以，在解密前是去不了的
    int p2 = plainOutChar[sizeof(plainOutChar) - 1];// p2是填充的数据，也是填充的长度
    int outLength = (int)cipherData.length-p2;// 明文的长度
    // 去掉填充得到明文
    unsigned char plainOutWithoutPadding[outLength];
    memcpy(plainOutWithoutPadding, plainOutChar, outLength);
    // 明文转成NSData 再转成NSString打印
    NSData *outData = [[NSData alloc]initWithBytes:plainOutWithoutPadding length:sizeof(plainOutWithoutPadding)];

    return outData;
}

#pragma mark - SM2 ALGORITHM For key1

+ (NSString * _Nullable)sm2_encryptPubKey:(NSString *)pubkey withCipherKey:(NSString *)key {
    NSString *enResult1 = [GKSm2Utils encryptText:key publicKey:@""]; // 加密普通字符串
    
    return enResult1;
}

+ (NSString *)sm2_decryptData:(NSString *)cipherData withPriKey:(NSString *)priKey {
    NSString *deResult1 = [GKSm2Utils decryptToText:cipherData privateKey:@""];
    return deResult1;
}

#pragma mark --- SM3 ALGORITHM For hash（key1 + data1） ---

- (NSData *)sm3_hashWithPainData:(NSData *)plainData {
    if (plainData == nil) {
        NSLog(@"got an empty input!");
        return plainData;
    }
    int plainLen = (int)plainData.length;
    unsigned char plainInChar[plainLen];
    memcpy(plainInChar, plainData.bytes, plainLen);
     
    int outputLen = 32;
    unsigned char output[outputLen];
    sm3(plainInChar, plainLen, output);
    return [NSData dataWithBytes:output length:outputLen];
}

@end
