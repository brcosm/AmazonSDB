//
//  SDBOperation.h
//  AmazonSDB
//
//  Created by Brandon Smith on 7/2/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBOperation.h"
#import "APIKey.h"
#import <CommonCrypto/CommonHMAC.h>

@interface SDBOperation()

- (NSString *)timeStamp;
- (NSData *)encrypt:(NSString *)string withKey:(NSString *)privateKey;
- (NSString *)base64encode:(NSData *)data;
- (NSString *)escapedSignatureWithString:(NSString *)string;
- (NSString *)escapedSelectWithString:(NSString *)selectExpression;

@end

@implementation SDBOperation
@synthesize regionEndPoint, version, responseDictionary;

/*
 Sets up parameters common to all SDB Operations
 */
- (id)init {
    self = [super init];
    if (self) {
        self.regionEndPoint = kSDBRegionEndpointDefault;
        self.version = kSDBVersion;
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:version forKey:@"Version"];
        [_parameters setValue:@"HmacSHA256" forKey:@"SignatureMethod"];
        [_parameters setValue:@"2" forKey:@"SignatureVersion"];
        [_parameters setValue:[self timeStamp] forKey:@"Timestamp"];
    }
    return self;
}

#pragma  mark - Response parsing

- (void)parseResponseData:(NSData *)data {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    parser.shouldProcessNamespaces = NO;
    parser.shouldReportNamespacePrefixes = NO;
    parser.shouldResolveExternalEntities = NO;
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError) NSLog(@"%@",[parseError localizedDescription]);
}

#pragma mark - Signature composition

/*
 The canonical string is generated using the request parameters
 and formatted specifically for use in the signature
 */
- (NSString *)canonicalString {
    
    NSMutableString *canonicalString = [[NSMutableString alloc] init];
    
    // create GET request lines
    [canonicalString appendString:@"GET\n"];
    [canonicalString appendFormat:@"%@\n/\n",self.regionEndPoint];
    [canonicalString appendFormat:@"AWSAccessKeyId=%@",ACCESS_KEY];
    
    // append sorted parameters
    NSArray *keys = [[_parameters allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop){
        NSString *val = [_parameters valueForKey:key];
        [canonicalString appendFormat:@"&%@=%@",key,[self escapedSelectWithString:val]]; 
    }];
    return [NSString stringWithString:canonicalString];
}

/*
 Gets the canonical string and encrypts it with the API private key
 using HMAC256.  It then encodes and escapes the string for use in the url
 */
- (NSString *)signature {
    
    // encrypt the canonical string
    NSData *encryptedData = [self encrypt:[self canonicalString] withKey:SECRET_KEY];
    
    // encode the data as a base 64 string
    NSString *encodedData = [self base64encode:encryptedData];
    
    // escape the encoded data so that there are no illegal characters
    return [self escapedSignatureWithString:encodedData];
}

/*
 Adds the signature to the parameters
 and then composes the URL string by iterating
 through each of the action parameters
 */
- (NSString *)signedUrlString {
    
    NSMutableString *url = [[NSMutableString alloc] init];
    [_parameters setValue:[self signature] forKey:@"Signature"];
    
    [url appendFormat:@"https://%@?", self.regionEndPoint];
    [url appendFormat:@"AWSAccessKeyId=%@",ACCESS_KEY];
    [_parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *val, BOOL *stop) {
        [url appendFormat:@"&%@=%@",key,[self escapedSelectWithString:val]];
    }];
    return [NSString stringWithString:url];
}


#pragma mark - Signature helpers

- (NSString *)timeStamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	NSString *date = [dateFormatter stringFromDate:[NSDate date]];
	NSString *dateString = [NSString stringWithFormat:@"%@",date];
    
	return [dateString  stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
}

- (NSData *)encrypt:(NSString *)string withKey:(NSString *)privateKey {
    
    // encode the string and the private key as NSData
    NSData *clearTextData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *privateKeyData = [privateKey dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    
    // create a crypto context and apply hmac algorithm
    CCHmacContext hmacContext;
    CCHmacInit(&hmacContext, kCCHmacAlgSHA256, privateKeyData.bytes, privateKeyData.length);
    CCHmacUpdate(&hmacContext, clearTextData.bytes, clearTextData.length);
    CCHmacFinal(&hmacContext, digest);
    
    // convert the encrypted bytes back into a NS data object
    NSData *encryptedData = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    
    // am I leaking the context here?  it may be cleaned up in the CCHmacFinal call
    
    return encryptedData;
    
}

- (NSString *)base64encode:(NSData *)data {
    
    static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
	if ([data length] == 0)
		return @"";
	
	char *characters = malloc((([data length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (i < [data length])
	{
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [data length])
			buffer[bufferLength++] = ((char *)[data bytes])[i++];
		
		// Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '='; 
	}
	
	NSString *encodedString = [[NSString alloc] initWithBytesNoCopy:characters
                                                             length:length
                                                           encoding:NSASCIIStringEncoding
                                                       freeWhenDone:YES];
	
	return encodedString;
    
}

- (NSString *)escapedSignatureWithString:(NSString *)string {
    NSString *escapedPluses = [string stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString *escapedEquals = [escapedPluses stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    return escapedEquals;
}

- (NSString *)escapedSelectWithString:(NSString *)selectExpression {
    NSString *escapedSpaces = [selectExpression stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *escapedAsterisks = [escapedSpaces stringByReplacingOccurrencesOfString:@"*" withString:@"%2A"];
    return escapedAsterisks;
}

@end