//
//  ViewController.h
//  BFME2 ROTWK Updater
//
//  Created by Tyler hostager on 11/20/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SystemCheckFunctor.h"

@interface ViewController : NSViewController <NSTextViewDelegate>
NS_ASSUME_NONNULL_BEGIN

#pragma mark - IBOutlets
@property (strong) IBOutlet NSView *mainView;
@property (weak) IBOutlet NSButton *checkForUpdatesBtn;
@property (weak) IBOutlet NSTextView *usrMsgTxtView;
@property (weak) IBOutlet NSTextField *msgViewTitleLabel;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *detailsLabel;
@property (weak) IBOutlet NSTextField *copyrightLabel;
@property (weak) IBOutlet NSTextField *versionLabel;
@property (weak) IBOutlet NSButton *hideOutputDisclosureIndicator;
@property (weak) IBOutlet NSProgressIndicator *checkingForUpdatesCircle;
@property (strong) IBOutlet NSScrollView *msgScrollView;



#pragma mark - Global properties
@property (nonatomic) BOOL userHasInternetConnection;
@property (nonatomic, retain) NSString *usrErrMsg;
@property (nonatomic, retain) SystemCheckFunctor *sysChecker;

#pragma mark - Class functions
- (bool)hasInternetConnection;
- (NSString *)outputErrMsgToUser:(nonnull NSString *)errMsg;

NS_ASSUME_NONNULL_END
@end


