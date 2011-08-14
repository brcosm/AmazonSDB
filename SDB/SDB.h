//
//  SDB.h
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBOperation.h"
#import "SDBListDomains.h"
#import "SDBDomainMetadata.h"
#import "SDBCreateDomain.h"
#import "SDBDeleteDomain.h"
#import "SDBSelect.h"
#import "SDBPut.h"
#import "SDBGet.h"
#import "SDBDelete.h"
#import "SDBBatchPut.h"
#import "SDBBatchDelete.h"

@protocol SDBDataDelegate

- (void)didReceiveSDBData:(NSDictionary *)sdbData fromOperation:(SDBOperation *)operation;

@end

@interface SDB : NSObject <NSURLConnectionDataDelegate>

@property (weak, nonatomic) id<SDBDataDelegate> dataDelegate;

+ (void)selectWithExpression:(NSString *)expression dataDelegate:(id<SDBDataDelegate>)dataDelegate;
+ (void)getItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain dataDelegate:(id<SDBDataDelegate>)dataDelegate;

+ (void)putItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain dataDelegate:(id<SDBDataDelegate>)dataDelegate;
+ (void)putItems:(NSDictionary *)items domain:(NSString *)domain dataDelegate:(id<SDBDataDelegate>)dataDelegate;

+ (void)deleteItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain dataDelegate:(id<SDBDataDelegate>)dataDelegate;
+ (void)deleteItems:(NSDictionary *)items domain:(NSString *)domain dataDelegate:(id<SDBDataDelegate>)dataDelegate;

+ (void)listDomainsWithMaximum:(int)max dataDelegate:(id<SDBDataDelegate>)dataDelegate;
+ (void)metadataForDomain:(NSString *)domain dataDelegate:(id<SDBDataDelegate>)dataDelegate;

+ (void)createDomain:(NSString *)domain dataDelegate:(id<SDBDataDelegate>)dataDelegate;
+ (void)deleteDomain:(NSString *)domain dataDelegate:(id<SDBDataDelegate>)dataDelegate;

@end