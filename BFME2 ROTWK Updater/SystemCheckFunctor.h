//
//  SystemCheckFunctor.h
//  BFME2 ROTWK Updater
//
//  Created by Tyler hostager on 11/18/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Define compile-time constants
#define DEFAULT_MIN_DOWN_KBPS 512
#define DEFAULT_MAX_DOWN_KBPS 20000

#pragma mark - Init runtime constants
static const BOOL kUsrHasAdminPermissions = YES;
static const BOOL kAppHasBeenModified = NO;
static const BOOL kUsrHasAppsInDir = NO;
static const BOOL kShouldCapDownloadSpeed = NO;
static const BOOL kDiffInstallDrive = NO;
static const NSString * kDefaultInstallDir = @"/Applications";
static const char kDefaultInstallDriveLtr = 'C';

//
// Functor interface provides various methods which check the user's machine
// to ensure the software updates can be installed properly by probing specifications
// such as internet speed, free space on installation disk, whether the user hes
// administrative permissions, etc.
//
@interface SystemCheckFunctor : NSObject

#pragma mark - Global properties
@property (nonatomic) BOOL usrHasBFME;
@property (nonatomic) BOOL usrHasROTWK;
@property (nonatomic) BOOL appsInValidDir;
@property (nonatomic) BOOL hasFreeSpace;
@property (nonatomic) BOOL usrHasAdminPermissions;
@property (nonatomic) BOOL shouldCapDownloadSpeed;

#pragma mark - Object methods
// Booleans
+ (BOOL)userHasBFMEInstalled;
+ (BOOL)userHasROTWKInstalled;
+ (BOOL)userHasBFMEInstalledinDirectory:(NSString *)usrDirPath;
+ (BOOL)userHasROTWKInstalledInDirecctory:(NSString *)usrDirPath;
+ (BOOL)userHasAdminPermissions;
+ (BOOL)shouldCapDownloadSpeed;
+ (BOOL)shouldCapDownloadSpeedWithTestKBPS:(float)testKBPS;
+ (BOOL)userHasInternetConnection;
+ (BOOL)userHasInternetConnection:(void (^)(NSError *err, NSString *errTitle))handler;

// Numeric
+ (float)userMinimumDownloadSpeed;
+ (float)userMaximumDownloadSpeed;
+ (float)userMinimumDownloadSpeed:(void (^)(NSError *err, NSString *errTitle))handler;
+ (float)userMaximumDownloadSpeed:(void (^)(NSError *err, NSString *errTitle))handler;
+ (float)userFreeMegabytesOnDrive;
+ (float)userFreeMegabytesOnDrive:(void (^)(NSError *err, NSString *errTitle))handler;
+ (float)userFreeMegabytesOnDrive:(char)driveLetter withCompletionHandler:(void (^)(NSError *err, NSString *errTitle))handler;

- (BOOL)shouldInstallUpdates;
- (BOOL)shouldInstallUpdates:(void (^)(NSError*, NSString*))completionHandler;

@end
