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

#pragma mark - IBOutlets
@property (strong) IBOutlet NSView *mainView;
@property (weak) IBOutlet NSButton *checkForUpdatesBtn;
@property (nonatomic, weak) IBOutlet NSTextView *usrMsgTxtView;

#pragma mark - Global properties
@property (nonatomic) BOOL userHasInternetConnection;
@property (nonatomic, retain) NSString *usrErrMsg;
@property (nonatomic, retain) SystemCheckFunctor *sysChecker;

#pragma mark - Class functions
- (bool)hasInternetConnection;
- (NSString *)outputErrMsgToUser:(nonnull NSString *)errMsg;

@end


