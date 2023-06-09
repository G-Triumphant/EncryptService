

#import "GKUtils.h"
#import <openssl/crypto.h>

@implementation GKUtils

#pragma mark - Hex 编码/解码

+ (nullable NSString *)stringToHex:(NSString *)str {
    if (!str || str.length == 0) {
        return nil;
    }
    
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *tmpHex = [self dataToHex:strData];
    
    return tmpHex;
}

+ (nullable NSString *)dataToHex:(NSData *)data {
    if (!data || data.length == 0) {
        return nil;
    }
        
    char *tmp = OPENSSL_buf2hexstr((uint8_t *)data.bytes, data.length);
    NSString *tmpHex = [NSString stringWithCString:tmp encoding:NSUTF8StringEncoding];
    tmpHex = [tmpHex stringByReplacingOccurrencesOfString:@":" withString:@""];
    OPENSSL_free(tmp);
    
    return tmpHex;
}

+ (nullable NSString *)hexToString:(NSString *)hexStr {
    if (!hexStr || hexStr.length < 2) {
        return nil;
    }
    
    NSData *bufData = [self hexToData:hexStr];
    NSString *bufStr = [[NSString alloc]initWithData:bufData encoding:NSUTF8StringEncoding];
    
    return bufStr;
}

+ (nullable NSData *)hexToData:(NSString *)hexStr {
    if (!hexStr || hexStr.length < 2) {
        return nil;
    }
    
    long buf_len = 0;
    uint8_t *tmp_buf = OPENSSL_hexstr2buf(hexStr.UTF8String, &buf_len);
    NSData *tmpData = [NSData dataWithBytes:tmp_buf length:buf_len];
    OPENSSL_free(tmp_buf);
    
    return tmpData;
}

#pragma mark - Base64 编码/解码

+ (nullable NSString *)base64Encode:(NSData *)data {
    NSData *baseData = [data base64EncodedDataWithOptions:0];
    NSString *baseStr = [[NSString alloc] initWithData:baseData encoding:NSUTF8StringEncoding];
    return baseStr;
}

+ (nullable NSData *)base64Decode:(NSString *)base64Str {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

#pragma mark - String/Data 相互转化

+ (NSString *)utf8WithData:(NSData *)data {
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

+ (NSData *)dataWithUft8Str:(NSString *)str {
    NSData *decodeData = [str dataUsingEncoding:NSUTF8StringEncoding];
    return decodeData;
}

@end
