//
//  ViewController.m
//  BFME2 ROTWK Updater
//
//  Created by Tyler hostager on 11/20/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

#import "ViewController.h"

#pragma mark - Define compile-time constants
#define EMPTY ""
#define TEST_HTTP_URL "http://www.google.com"
#define UPDATE_SERVER_URL "test test test test"
#define BLACK "Black"

@interface ViewController()
@property (nonatomic) BOOL updateIsAvailable;
@property (nonatomic, retain) NSString *usrMsg;
@end

@implementation ViewController
@synthesize mainView;
@synthesize checkForUpdatesBtn;
@synthesize userHasInternetConnection;
@synthesize usrErrMsg;
@synthesize usrMsgTxtView;
@synthesize sysChecker;

//
// Constructor method called immediately when memory is allocated for the
// view controller object. Allows for things such as internet connectivity
// to be tested before initializing the view
//
- (instancetype)init {
    self = [super init];
    if (self) {
        self.usrErrMsg = @EMPTY;
        [self hasInternetConnection] ? [self checkForUpdates] : [self outputNoConnectivity];
        self.sysChecker = [[SystemCheckFunctor alloc] init];
        
        if (usrMsgTxtView) {
            [self.usrMsgTxtView setDelegate:self];
        }
    }
    
    return self;
}

- (void)viewDidLoadn{
    [super viewDidLoad];
    
    if (self.checkForUpdatesBtn) {
        [self.checkForUpdatesBtn setTitle:@"Check for Updates..."];
        [self.checkForUpdatesBtn setTransparent:NO];
        [self.checkForUpdatesBtn sizeToFit];
        
    }
    
    if (self.usrMsgTxtView) {
        [self.usrMsgTxtView sizeToFit];
        [self.usrMsgTxtView setEditable:NO];
        [self.usrMsgTxtView setTextColor:[NSColor colorNamed:@BLACK]];
    }
}

- (NSString *)outputErrMsgToUser:(NSString *)errMsg {
    NSString *retVal = @EMPTY;
    
    if (errMsg && ![errMsg isEqualToString:@EMPTY]) {
        retVal = errMsg;
        
        // asynchronously update the view to display the message
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.usrMsgTxtView setString:errMsg];
        }];
    }
    
    return retVal ? @EMPTY : retVal;
}

#pragma mark - NSTextView override functions
- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    return !replacementString || [replacementString isEqualToString:@EMPTY];
}

// Check whether the user has internet
- (bool)hasInternetConnection {
    NSURL *url = [[NSURL alloc] initWithString:@TEST_HTTP_URL];
    
    // create web request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    NSURLSession *connectionTestSession = [[NSURLSession alloc] init];
    NSURLSessionDataTask *dataTask = [connectionTestSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *err) {
        
        if (err || !data || !request) {      // check for bad request
            NSString *errorMessage = [NSString stringWithFormat:@"Error performing request -- please verify the request data: \nWeb request: %@\nData: %@\nResponse: %@, Error message: %@", request, data, response, err, nil];
            
            if (errorMessage) {
                NSLog(errorMessage, nil);
                [self outputErrMsgToUser:errorMessage];
            }
        }
    }];
    
    // get the http response status code
    NSInteger httpStatusCode = -1;
    if ([dataTask.response isKindOfClass:NSHTTPURLResponse.class]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)[dataTask response];
        httpStatusCode = httpResponse.statusCode;
    }
    
    return httpStatusCode == 200;       // return true if 200 (successful)
}

- (void)performUpdateCheckInBackground {
    if ([self hasInternetConnection]) {
        // TODO add github link here for repository
        
        
    }
}

- (void)outputNoConnectivity {
    
}

- (IBAction)updatesBtnPressed:(id)sender {
    
}

- (void)checkForUpdates {
    // TODO make web request for update check
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
