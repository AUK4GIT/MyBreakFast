//
//  CTSCVVEncryptor.m
//  CTS iOS Sdk
//
//  Created by Yadnesh Wankhede on 12/28/15.
//  Copyright © 2015 Citrus. All rights reserved.
//

#import "CTSCVVEncryptor.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import <CommonCrypto/CommonDigest.h>
#import "UserLogging.h"
#import "CTSUtility.h"
#define Key @"fhdjad444$$R888radcafcarecaec"

@implementation CTSCVVEncryptor
//+ (id)sharedManager {
//    static CTSCVVEncryptor *sharedMyManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedMyManager = [[self alloc] init];
//    });
//    return sharedMyManager;
//}

- (instancetype)initWithPass:(NSString *)passString
{
    self = [super init];
    if (self) {
        cryptoPassString = passString;
//        NSString *crptoPass = [self generateBigIntegerString:cryptoPassString];
//        NSData *cvvData = [NSKeyedArchiver archivedDataWithRootObject:@{@"65656565655675":@"789"}];
//        LogTrace(@"crptoPass %@",crptoPass);
//        NSError *encryptionError;
//        NSData *ciphertext = [RNEncryptor encryptData:cvvData withSettings:kRNCryptorAES256Settings password:crptoPass error:&encryptionError];
//        LogTrace(@"encryptionError %@",encryptionError);
//        // Decryption
//        NSError *decryptionError;
//        crptoPass = [self generateBigIntegerString:cryptoPassString];
//        NSData *decryptedData = [RNDecryptor decryptData:ciphertext withSettings:kRNCryptorAES256Settings password:crptoPass error:&decryptionError];
//        if (decryptionError != nil) {
//            NSLog(@"ERROR:%@", decryptionError);
//        }
//          NSDictionary * myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:cvvData];
//        LogTrace(@"decryptedData %@",myDictionary);
//
//        myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
//        LogTrace(@"decryptedData %@",myDictionary);

    }
    return self;
}

-(instancetype)initWithDefaultLoginId{
    self = [super init];
    if (self) {
        if([CTSUtility getLoginId]){
         LogTrace(@"[CTSUtility getLoginId] %@",[CTSUtility getLoginId]);
        cryptoPassString = [CTSUtility getLoginId];
        }
        else{
            LogTrace(@"no encryption key found");
            return nil;
        }
    }
    return self;


}


-(void)storeCVV:(NSString *)cvv signature:(NSString *)signature{
    NSMutableDictionary *decrepted = [self getDecryptedCVVStore];
    if(decrepted){
        [decrepted addEntriesFromDictionary:@{signature:cvv}];
    
    }
    else{
        decrepted = [[NSMutableDictionary alloc] init];
        [decrepted addEntriesFromDictionary:@{signature:cvv}];
    }
    NSError * encryptionError;
    NSData *cvvData = [NSKeyedArchiver archivedDataWithRootObject:decrepted];
    NSString* crptoPass = [self generateBigIntegerString:cryptoPassString];

    NSData *ciphertext = [RNEncryptor encryptData:cvvData withSettings:kRNCryptorAES256Settings password:crptoPass error:&encryptionError];
    
    [CTSUtility saveToDisk:ciphertext as:Key];

    LogTrace(@"encryptionError %@",encryptionError);
    LogTrace(@"ciphertext %@",ciphertext);

}

-(NSString *)getCVVForSignature:(NSString *)signature{
    if(signature){
    NSDictionary *decrypted = [self getDecryptedCVVStore];
    return [decrypted valueForKey:signature];
    }
    else{
        return nil;
    }
}

-(BOOL)isCVVStored:(NSString *)signature{
    if([self getCVVForSignature:signature] == nil){
        return NO;
    }
    else{
        return YES;
    }
}


-(NSMutableDictionary *)getDecryptedCVVStore{
   NSData *data = [CTSUtility readDataFromDisk:Key];
    //LogTrace(@"getDecryptedCVVStore %@",data);
    if(data != nil){
        NSError *decryptionError;
       NSString* crptoPass = [self generateBigIntegerString:cryptoPassString];
        NSData *decryptedData = [RNDecryptor decryptData:data withSettings:kRNCryptorAES256Settings password:crptoPass error:&decryptionError];
        if (decryptionError != nil) {
            NSLog(@"ERROR:%@", decryptionError);
        }
        NSMutableDictionary * myDictionary = (NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
        //LogTrace(@"decryptedData %@",myDictionary);
        
        return myDictionary;
    }
    return nil;

}

+(void)removeStoredCVV{
    [CTSUtility removeFromDisk:Key];
}

//- (NSString*)generatePseudoRandomPassword {
//    // Build the password using C strings - for speed
//    int length = 7;
//    char* cPassword = calloc(length + 1, sizeof(char));
//    char* ptr = cPassword;
//    
//    cPassword[length - 1] = '\0';
//    
//    char* lettersAlphabet = "abcdefghijklmnopqrstuvwxyz";
//    ptr = appendRandom(ptr, lettersAlphabet, 2);
//    
//    char* capitalsAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    ptr = appendRandom(ptr, capitalsAlphabet, 2);
//    
//    char* digitsAlphabet = "0123456789";
//    ptr = appendRandom(ptr, digitsAlphabet, 2);
//    
//    char* symbolsAlphabet = "!@#$%*[];?()";
//    ptr = appendRandom(ptr, symbolsAlphabet, 1);
//    
//    // Shuffle the string!
//    for (int i = 0; i < length; i++) {
//        int r = arc4random() % length;
//        char temp = cPassword[i];
//        cPassword[i] = cPassword[r];
//        cPassword[r] = temp;
//    }
//    return [NSString stringWithCString:cPassword encoding:NSUTF8StringEncoding];
//}

//char* appendRandom(char* str, char* alphabet, int amount) {
//    for (int i = 0; i < amount; i++) {
//        int r = arc4random() % strlen(alphabet);
//        *str = alphabet[r];
//        str++;
//    }
//    
//    return str;
//}

- (void)generator:(int)seed {
    seedState = seed;
}

- (int)nextInt:(int)max {
    seedState = 7 * seedState % 3001;
    return (seedState - 1) % max;
}
- (char)nextLetter {
    int n = [self nextInt:52];
    return (char)(n + ((n < 26) ? 'A' : 'a' - 26));
}
static NSData* digest(NSData* data,
                      unsigned char* (*cc_digest)(const void*,
                                                  CC_LONG,
                                                  unsigned char*),
                      CC_LONG digestLength) {
    unsigned char md[digestLength];
    (void)cc_digest([data bytes], (unsigned int)[data length], md);
    return [NSData dataWithBytes:md length:digestLength];
}

- (NSData*)md5:(NSString*)email {
    NSData* data = [email dataUsingEncoding:NSASCIIStringEncoding];
    return digest(data, CC_MD5, CC_MD5_DIGEST_LENGTH);
}

- (NSArray*)copyOfRange:(NSArray*)original from:(int)from to:(int)to {
    int newLength = to - from;
    NSArray* destination;
    if (newLength < 0) {
    } else {
        // int copy[newLength];
        destination = [original subarrayWithRange:NSMakeRange(from, newLength)];
    }
    return destination;
}
- (int)genrateSeed:(NSString*)data {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSData* hashed = [self md5:data];
    NSUInteger len = [hashed length];
    Byte* byteData = (Byte*)malloc(len);
    [hashed getBytes:byteData length:len];
    
    int result1[16];
    for (int i = 0; i < 16; i++) {
        Byte b = byteData[i];  // 0xDC;
        result1[i] = (b & 0x80) > 0 ? b - 0xFF - 1 : b;
        [array addObject:[NSNumber numberWithInt:result1[i]]];
    }
    
    NSArray* val = [self copyOfRange:array
                                from:(unsigned int)[array count] - 3
                                  to:(unsigned int)[array count]];
    NSData* arrayData = [NSKeyedArchiver archivedDataWithRootObject:val];
    LogTrace(@"%@", arrayData);
    int x = 0;
    for (int i = 0; i < [val count]; i++) {
        int z = [[val objectAtIndex:(val.count - 1 - i)] intValue];
        if (z < 0) {
            z = z + 256;
        }
        z = z << (8 * i);
        x = x + z;
        LogTrace(@"%d", x);
    }
    return x;
}
- (NSString*)generateBigIntegerString:(NSString*)email {
    LogTrace(@"email %@",email);
    int ran = [self genrateSeed:email];
    
    [self generator:ran];
    NSMutableString* large_CSV_String = [[NSMutableString alloc] init];
    for (int i = 0; i < 8; i++) {
        // Add something from the key?? Your format here.
        [large_CSV_String appendFormat:@"%c", [self nextLetter]];
    }
    LogTrace(@"random password:%@", large_CSV_String);
    return large_CSV_String;
}

@end
