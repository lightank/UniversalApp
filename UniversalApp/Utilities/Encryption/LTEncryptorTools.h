

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///  加密工具类
///  提供RSA & AES加密方法
@interface LTEncryptorTools : NSObject

@end

@interface LTEncryptorTools (AES)

#pragma mark - AES 加密/解密
///  AES 加密
///
///  @param data      要加密的二进制数据
///  @param keyString 加密密钥,根据 AES 规范，可以是16字节、24字节和32字节长，分别对应128位、192位和256位
///  @param iv        IV向量,16字节,除ECB以外的其他加密模式均需要传入一个初始向量，其大小与Block Size相等（AES的Block Size为128 bits,而两个平台的API文档均指明当不传入初始向量时，系统将默认使用一个全0的初始向量
///
///  @return 加密后的二进制数据
+ (NSData *)AESEncryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv;

///  AES 加密字符串
///
///  @param string    要加密的字符串
///  @param keyString 加密密钥,根据 AES 规范，可以是16字节、24字节和32字节长，分别对应128位、192位和256位
///  @param iv        IV向量,16字节,除ECB以外的其他加密模式均需要传入一个初始向量，其大小与Block Size相等（AES的Block Size为128 bits）,而两个平台的API文档均指明当不传入初始向量时，系统将默认使用一个全0的初始向量
///
///  @return 加密后的 BASE64 编码字符串
+ (NSString *)AESEncryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv;

///  AES 解密
///
///  @param data      要解密的二进制数据
///  @param keyString 加密密钥,根据 AES 规范，可以是16字节、24字节和32字节长，分别对应128位、192位和256位
///  @param iv        IV向量,16字节,除ECB以外的其他加密模式均需要传入一个初始向量，其大小与Block Size相等（AES的Block Size为128 bits）,而两个平台的API文档均指明当不传入初始向量时，系统将默认使用一个全0的初始向量
///
///  @return 解密后的二进制数据
+ (NSData *)AESDecryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv;

///  AES 解密
///
///  @param string    要解密的 BASE64 编码字符串
///  @param keyString 加密密钥,根据 AES 规范，可以是16字节、24字节和32字节长，分别对应128位、192位和256位
///  @param iv        IV向量,16字节,除ECB以外的其他加密模式均需要传入一个初始向量，其大小与Block Size相等（AES的Block Size为128 bits）,而两个平台的API文档均指明当不传入初始向量时，系统将默认使用一个全0的初始向量
///
///  @return 解密后的二进制数据
+ (NSString *)AESDecryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv;

@end

@interface LTEncryptorTools (RSA)

#pragma mark - RSA 加密/解密算法
///  加载公钥
///
///  @param filePath DER 公钥文件路径
- (void)loadPublicKeyWithFilePath:(NSString *)filePath;

///  加载私钥
///
///  @param filePath P12 私钥文件路径
///  @param password P12 密码
- (void)loadPrivateKey:(NSString *)filePath password:(NSString *)password;

///  RSA 加密数据
///
///  @param data 要加密的数据
///
///  @return 加密后的二进制数据
- (NSData *)RSAEncryptData:(NSData *)data;

///  RSA 加密字符串
///
///  @param string 要加密的字符串
///
///  @return 加密后的 BASE64 编码字符串
- (NSString *)RSAEncryptString:(NSString *)string;

///  RSA 解密数据
///
///  @param data 要解密的数据
///
///  @return 解密后的二进制数据
- (NSData *)RSADecryptData:(NSData *)data;

///  RSA 解密字符串
///
///  @param string 要解密的 BASE64 编码字符串
///
///  @return 解密后的字符串
- (NSString *)RSADecryptString:(NSString *)string;

/**
 加载公钥,加密指定字符串,返回base64编码的加密后字符串

 @param str 要加密的字符串
 @param publicKey 公钥字符串
 @return 返回base64编码的加密后字符串
 */
+ (NSString *)RSAEncryptString:(NSString *)str publicKey:(NSString *)publicKey;

/**
 加载公钥,加密指定数据,返回base64编码的加密后字符串

 @param data 要加密的字符串
 @param publicKey 公钥字符串
 @return 返回base64编码的加密后字符串
 */
+ (NSData *)RSAEncryptData:(NSData *)data publicKey:(NSString *)publicKey;
/**
 加载私钥,解密指定字符串,返回字符串

 @param str 要解密的字符串
 @param privateKey 私钥字符串
 @return 返回解密后字符串
 */
+ (NSString *)RSADecryptString:(NSString *)str privateKey:(NSString *)privateKey;
/**
 加载私钥,解密指定字符串,返回字符串

 @param data 要解密的数据
 @param privateKey 私钥字符串
 @return 返回解密后字符串
 */
+ (NSData *)RSADecryptData:(NSData *)data privateKey:(NSString *)privateKey;

@end

NS_ASSUME_NONNULL_END
