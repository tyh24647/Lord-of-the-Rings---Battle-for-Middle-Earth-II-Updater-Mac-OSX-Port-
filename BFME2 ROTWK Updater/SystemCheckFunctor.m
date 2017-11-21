//
//  SystemCheckFunctor.m
//  BFME2 ROTWK Updater
//
//  Created by Tyler hostager on 11/20/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

#import "SystemCheckFunctor.h"

#pragma mark - Define compile-time constants
#define EMPTY ""
#define DEFAULT_REQUIRED_DISK_SPACE 2000

@interface SystemCheckFunctor()
@property (nonatomic, retain) NSBlockOperation *defaultCompletionHandler;
@property (nonatomic) float usrFreeSpaceMB;
@end

@implementation SystemCheckFunctor
@synthesize hasFreeSpace;
@synthesize usrHasBFME;
@synthesize usrHasROTWK;
@synthesize usrHasAdminPermissions;
@synthesize appsInValidDir;
@synthesize shouldCapDownloadSpeed;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDefaults];
        [self initHandlerBlockOperation];
        [self shouldInstallUpdates];
    }
    
    return self;
}

- (void)initHandlerBlockOperation {
    self.defaultCompletionHandler = [[NSBlockOperation alloc] init];
    [self.defaultCompletionHandler setCompletionBlock:^{
        // TODO
    }];
}

- (BOOL)shouldInstallUpdates:(void (^)(NSError *err, NSString *errTitle))completionHandler {
    BOOL doUpdates = NO;
    
    if ([self hasFreeSpace]
        && [self usrHasBFME]
        && [self usrHasAdminPermissions]
        && [self appsInValidDir]) {
        
        // ensure that the user has enough space for install
        self.usrFreeSpaceMB = [SystemCheckFunctor userFreeMegabytesOnDrive:completionHandler];
        if (self.usrFreeSpaceMB >= DEFAULT_REQUIRED_DISK_SPACE) {
            doUpdates = YES;
        }
    }
    
    return doUpdates;
}

#pragma mark - Functor methods
+ (float)userFreeMegabytesOnDrive:(void (^)(NSError *err, NSString *errTitle))handler {
    float availableMB = -1;
    
    NSError *error = nil;
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfFileSystemForPath:@"/" error:&error];
    if (!error) {
        availableMB = [[attr objectForKey:NSFileSystemFreeSize] floatValue];
    } else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"ERROR: %@: %@", error, [error description]);
            handler(error, [error description]);
        }];
    }
    
    return availableMB;
}

- (BOOL)shouldInstallUpdates {
    return [self shouldInstallUpdates:nil];
}

- (BOOL)usrHasAdminPermissions {
    return self.usrHasAdminPermissions;
}

- (BOOL)shouldCapDownloadSpeed {
    BOOL hasSlowInternet = NO;
    
    // TODO
    
    return hasSlowInternet;
}


- (void)initDefaults {
    self.hasFreeSpace = YES;
    self.usrHasAdminPermissions = kUsrHasAdminPermissions;
    self.usrHasBFME = kUsrHasAppsInDir;
    self.usrHasROTWK = kUsrHasAppsInDir;
    self.appsInValidDir = kUsrHasAppsInDir;
    self.shouldCapDownloadSpeed = kShouldCapDownloadSpeed;
    self.usrFreeSpaceMB = -1;
}


@end
