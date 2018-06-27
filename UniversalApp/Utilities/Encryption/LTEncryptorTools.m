

#import "LTEncryptorTools.h"
#import <CommonCrypto/CommonCrypto.h>
#include <zlib.h>

// 填充模式
#define kTypeOfWrapPadding		kSecPaddingPKCS1

@interface LTEncryptorTools ()
{
    SecKeyRef _publicKeyRef;                             // 公钥引用
    SecKeyRef _privateKeyRef;                            // 私钥引用
}

@end

@implementation LTEncryptorTools

@end

@implementation LTEncryptorTools (AES)

#pragma mark - AES 加密/解密
#pragma mark 加密
+ (NSData *)AESEncryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv
{
    return [self AESData:data operation:kCCEncrypt keyString:keyString iv:iv];
}

+ (NSString *)AESEncryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self AESEncryptData:data keyString:keyString iv:iv];
    
    // BASE 64 编码
    return [result base64EncodedStringWithOptions:0];
}

#pragma mark 解密
+ (NSData *)AESDecryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv
{
    return [self AESData:data operation:kCCDecrypt keyString:keyString iv:iv];
}

+ (NSString *)AESDecryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv
{
    if (!string) return nil;
    // BASE 64 解码
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSData *result = [self AESDecryptData:data keyString:keyString iv:iv];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

#pragma mark AES 加密&解密
+ (NSData *)AESData:(NSData *)data operation:(CCOperation)operation keyString:(NSString *)keyString iv:(NSData *)iv
{
    if (keyString.length != 16 && keyString.length != 24 && keyString.length != 32)
    {
        return nil;
    }
    if (iv.length != 16 && iv.length != 0)
    {
        return nil;
    }

    // 设置密钥
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[kCCKeySizeAES128];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:kCCKeySizeAES128];
    
    // 设置 IV 向量
    uint8_t cIv[kCCBlockSizeAES128];
    bzero(cIv, kCCBlockSizeAES128);
    int option = kCCOptionPKCS7Padding | kCCOptionECBMode;
    if (iv)
    {
        [iv getBytes:cIv length:kCCBlockSizeAES128];
        option = kCCOptionPKCS7Padding;
    }
    
    // 设置输出缓冲区
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    // 加密或解密
    size_t cryptorSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,    //加密还是解密,枚举值
                                          kCCAlgorithmAES,  //加密类型
                                          option,   //填充方式
                                          keyData.bytes,    //加密密钥
                                          keyData.length,   //加密密钥长度
                                          cIv,      //初始向量
                                          [data bytes],     //要加密的原始数据
                                          [data length],    //要加密的原始数据长度
                                          buffer,       //加密后的数据
                                          bufferSize,   //加密后的数据长度
                                          &cryptorSize);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess)
    {
        result = [NSData dataWithBytesNoCopy:buffer length:cryptorSize];
    }
    else
    {
        free(buffer);
        NSLog(@"[错误] 加密或解密失败 | 状态编码: %d", cryptStatus);
    }
    
    return result;
}

@end

@implementation LTEncryptorTools (RSA)

#pragma mark - RSA 加密/解密算法
#pragma mark - ---对象方法
#pragma mark - 加载公私钥
- (void)loadPublicKeyWithFilePath:(NSString *)filePath
{
    NSAssert(filePath.length != 0, @"公钥路径为空");
    
    // 删除当前公钥
    if (_publicKeyRef) CFRelease(_publicKeyRef);
    
    // 从一个 DER 表示的证书创建一个证书对象
    NSData *certificateData = [NSData dataWithContentsOfFile:filePath];
    SecCertificateRef certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    NSAssert(certificateRef != NULL, @"公钥文件错误");
    
    // 返回一个默认 X509 策略的公钥对象，使用之后需要调用 CFRelease 释放
    SecPolicyRef policyRef = SecPolicyCreateBasicX509();
    // 包含信任管理信息的结构体
    SecTrustRef trustRef;
    
    // 基于证书和策略创建一个信任管理对象
    OSStatus status = SecTrustCreateWithCertificates(certificateRef, policyRef, &trustRef);
    NSAssert(status == errSecSuccess, @"创建信任管理对象失败");
    
    // 信任结果
    SecTrustResultType trustResult;
    // 评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(trustRef, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    // 评估之后返回公钥子证书
    _publicKeyRef = SecTrustCopyPublicKey(trustRef);
    NSAssert(_publicKeyRef != NULL, @"公钥创建失败");
    
    if (certificateRef) CFRelease(certificateRef);
    if (policyRef) CFRelease(policyRef);
    if (trustRef) CFRelease(trustRef);
}

- (void)loadPrivateKey:(NSString *)filePath password:(NSString *)password
{
    NSAssert(filePath.length != 0, @"私钥路径为空");
    
    // 删除当前私钥
    if (_privateKeyRef) CFRelease(_privateKeyRef);
    
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:filePath];
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    CFStringRef passwordRef = (__bridge CFStringRef)password;
    
    // 从 PKCS #12 证书中提取标示和证书
    SecIdentityRef myIdentity = NULL;
    SecTrustRef myTrust = NULL;
    const void *keys[] = {kSecImportExportPassphrase};
    const void *values[] = {passwordRef};
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    // 返回 PKCS #12 格式数据中的标示和证书
    OSStatus status = SecPKCS12Import(inPKCS12Data, optionsDictionary, &items);
    
    if (status == noErr)
    {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        myIdentity = (SecIdentityRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        myTrust = (SecTrustRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
    }
    
    if (optionsDictionary) CFRelease(optionsDictionary);
    
    NSAssert(status == noErr, @"提取身份和信任失败");
    
    SecTrustResultType trustResult;
    // 评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(myTrust, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    // 提取私钥
    status = SecIdentityCopyPrivateKey(myIdentity, &_privateKeyRef);
    NSAssert(status == errSecSuccess, @"私钥创建失败");
    CFRelease(items);
}
#pragma mark - 加密
- (NSString *)RSAEncryptString:(NSString *)string
{
    NSData *cipher = [self RSAEncryptData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [cipher base64EncodedStringWithOptions:0];
}

- (NSData *)RSAEncryptData:(NSData *)data
{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(_publicKeyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for (int idx=0; idx<srclen; idx+=src_block_size)
    {
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size)
        {
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(_publicKeyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0)
        {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }
        else
        {
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);

    return ret;
}
#pragma mark - 解密
- (NSString *)RSADecryptString:(NSString *)string
{
    NSData *keyData = [self RSADecryptData:[[NSData alloc] initWithBase64EncodedString:string options:0]];
    
    return [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
}

- (NSData *)RSADecryptData:(NSData *)data
{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(_privateKeyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size)
    {
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size)
        {
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(_privateKeyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0)
        {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }
        else
        {
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ )
            {
                if ( outbuf[i] == 0 )
                {
                    if ( idxFirstZero < 0 )
                    {
                        idxFirstZero = i;
                    }
                    else
                    {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero + 1] length:idxNextZero-idxFirstZero - 1];
        }
    }
    
    free(outbuf);
    return ret;
}

#pragma mark - ---类方法
#pragma mark - 加载公私钥
static NSString *base64_encode_data(NSData *data)
{
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str)
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key
{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx	 = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

//credit: http://hg.mozilla.org/services/fx-home/file/tip/Sources/NetworkAndStorage/CryptoUtils.m#l1036
+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key
{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx	 = 22; //magic byte at offset 22
    
    if (0x04 != c_key[idx++]) return nil;
    
    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }
    
    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}


+ (SecKeyRef)loadPublicKeyWithString:(NSString *)key
{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (SecKeyRef)loadPrivateKeyWithString:(NSString *)key
{
    NSRange spos;
    NSRange epos;
    spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    if(spos.length > 0){
        epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    }else{
        spos = [key rangeOfString:@"-----BEGIN PRIVATE KEY-----"];
        epos = [key rangeOfString:@"-----END PRIVATE KEY-----"];
    }
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPrivateKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PrivKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);
    
    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
     kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

#pragma mark - 加密
+ (NSString *)RSAEncryptString:(NSString *)str publicKey:(NSString *)publicKey
{
    NSData *data = [self RSAEncryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:publicKey];
    NSString *ret = base64_encode_data(data);
    return ret;
}

+ (NSData *)RSAEncryptData:(NSData *)data publicKey:(NSString *)publicKey
{
    if(!data || !publicKey)
    {
        return nil;
    }
    SecKeyRef keyRef = [self loadPublicKeyWithString:publicKey];
    if(!keyRef)
    {
        return nil;
    }
    return [self RSAEncryptData:data withKeyRef:keyRef];
}

+ (NSData *)RSAEncryptData:(NSData *)data withKeyRef:(SecKeyRef)keyRef
{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size)
        {
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

#pragma mark - 解密
+ (NSString *)RSADecryptString:(NSString *)str privateKey:(NSString *)privateKey
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self RSADecryptData:data privateKey:privateKey];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+ (NSData *)RSADecryptData:(NSData *)data privateKey:(NSString *)privateKey
{
    if(!data || !privateKey)
    {
        return nil;
    }
    SecKeyRef keyRef = [self loadPrivateKeyWithString:privateKey];
    if(!keyRef)
    {
        return nil;
    }
    return [self RSADecryptData:data withKeyRef:keyRef];
}

+ (NSData *)RSADecryptData:(NSData *)data withKeyRef:(SecKeyRef)keyRef
{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}


@end
