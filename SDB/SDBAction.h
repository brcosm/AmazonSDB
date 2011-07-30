
/*
 Created by Brandon Smith on 7/2/11.
 Copyright 2011 Brandon Smith. All rights reserved.

 The SDBAction class is an abstract superclass for SDB Operations.
 Currently available operations: 
 http://docs.amazonwebservices.com/AmazonSimpleDB/latest/DeveloperGuideindex.html?SDB_API_Operations.html
 Each SDBAction subclass should customize the init method to include
 parameters specific to the operation.  The signedUrlString method compiles
 a url string that can be used as part of an NSURLRequest/Connection
 */

/*
 Currently available region endpoints
 More info at: 
 http://docs.amazonwebservices.com/AmazonSimpleDB/latest/DeveloperGuideindex.html?Endpoints.html
 */
#define kSDBRegionEndpointDefault @"sdb.amazonaws.com"
#define kSDBRegionEndpointUSEast @"sdb.amazonaws.com"
#define kSDBRegionEndpointUSWest @"sdb.us-west1.amazonaws.com"
#define kSDBRegionEndpointEUWest @"sdb.eu-west1.amazonaws.com"
#define kSDBRegionEndpointAPSouth @"sdb.ap-southeast-1.amazonaws.com"
#define kSDBRegionEndpointAPNorth @"sdb.ap-northeast-1.amazonaws.com"

/*
 AWS API Version
 More info at: 
 http://docs.amazonwebservices.com/AmazonSimpleDB/latest/DeveloperGuideindex.html?SDB_API_WSDL.html
 */
#define kSDBVersion @"2009-04-15"

@interface SDBAction : NSObject {
@protected
    NSMutableDictionary *_parameters;
}

@property (copy, nonatomic) NSString *regionEndPoint;
@property (copy, nonatomic) NSString *version;

- (NSString *)signedUrlString;

@end