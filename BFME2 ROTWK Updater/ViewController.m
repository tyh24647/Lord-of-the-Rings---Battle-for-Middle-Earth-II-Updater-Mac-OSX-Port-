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
#define NEW_LINE "\n"
#define ERROR_TAG "ERROR: "
#define TEST_HTTP_URL "http://www.google.com"
#define UPDATE_SERVER_URL "test test test test"
#define BLACK "Black"

#pragma mark - Define runtime constants
static const float kDefaultOutputXPos = 20.0f;
static const float kDefaultOutputYPos = 20.0f;
static const float kDefaultOutputViewHeight = 82.0f;
static const float kDefaultOutputViewWidth = 436.0f;

#pragma mark - Private properties
@interface ViewController()
@property (nonatomic) BOOL updateIsAvailable;
@property (nonatomic) BOOL showConsole;
@property (nonatomic) BOOL isFirstDisclosureClick;
@property (nonatomic, retain) NSString *usrMsg;
@property (nonatomic) float initialMainViewFrameHeight;
@end

#pragma mark - Implementation of the view controller
@implementation ViewController
@synthesize mainView;
@synthesize checkForUpdatesBtn;
@synthesize userHasInternetConnection;
@synthesize usrErrMsg;
@synthesize usrMsgTxtView;
@synthesize sysChecker;
@synthesize msgViewTitleLabel;
@synthesize copyrightLabel;
@synthesize versionLabel;
@synthesize checkingForUpdatesCircle;
@synthesize msgScrollView;

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
        self.showConsole = YES;
        
        if (usrMsgTxtView) {
            [self.usrMsgTxtView setDelegate:self];
        }
    }

    return self;
}

- (void)viewDidLoad {
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
    
    if (self.checkingForUpdatesCircle) {
        [self.checkingForUpdatesCircle setHidden:YES];
        [self.checkingForUpdatesCircle stopAnimation:nil];
    }
    
    self.isFirstDisclosureClick = YES;
    self.initialMainViewFrameHeight = self.view.frame.size.height;
    //[self performUpdateCheckInBackground];
    
#ifdef DEBUG
    [self printStringToMsgConsole:@"DEBUG MODE ENABLED" isErrorMessage:NO];
#endif
}

- (NSString *)outputErrMsgToUser:(NSString *)errMsg {
    NSString *retVal = @EMPTY;
    
    if (errMsg && ![errMsg isEqualToString:@EMPTY]) {
        retVal = errMsg;
        
        // asynchronously update the view to display the message
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self printStringToMsgConsole:errMsg isErrorMessage:YES];
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
        
        [self printStringToMsgConsole:@"Internet connection detected and is active" isErrorMessage:NO];
    } else {
        [self printStringToMsgConsole:@"No internet connection detected. Please connect to the internet in order to install updates" isErrorMessage:YES];
    }
}

- (IBAction)outputDisclosureIndicatorPressed:(id)sender {
    if (!self.isFirstDisclosureClick) {
        self.hideOutputDisclosureIndicator.state = !self.showConsole ? NSControlStateValueOn : NSControlStateValueOff;
    } else {
        self.hideOutputDisclosureIndicator.state = NSControlStateValueOff;
        self.showConsole = NO;
    }
    
    // add 'resize output box'task to the dispatch queue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        float x = self.showConsole ? kDefaultOutputXPos : 0.0f;
        float y = self.showConsole ? kDefaultOutputYPos : 0.0f;
        float width = self.showConsole ? kDefaultOutputViewWidth : 0.f;
        float height = self.showConsole ? kDefaultOutputViewHeight : 0.0f;
        
#ifdef DEBUG
        [self printStringToMsgConsole:[NSString stringWithFormat:@"%@ console output", self.showConsole ? @"Showing" : @"Hiding"] isErrorMessage:NO];
#endif
        
        CGRect scrollViewRect = self.msgScrollView.frame;
        scrollViewRect.size.height = 0.0f;
        self.msgScrollView.frame = scrollViewRect;
        
        [self.usrMsgTxtView setHidden:!self.showConsole];
        [self.msgScrollView setHidden:!self.showConsole];
        
        // resize text view
        [self resizeViewRect:self.usrMsgTxtView.frame
                    withName:@"Output viezw"
                   xPosition:x
                   yPosition:y
                       width:width
                      height:height
          completionHandeler:^BOOL(NSError *error, NSString *errorTitle) {
              if (error) {
                  [self printStringToMsgConsole:[NSString stringWithFormat:@"%@. %@", error, errorTitle] isErrorMessage:YES];
                  return NO;
              }
              
              return YES;
          }];
    }];
    
    // add 'resize main window' task to the dispatch queue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        float wHeight = self.showConsole ? self.initialMainViewFrameHeight : (self.initialMainViewFrameHeight - kDefaultOutputViewHeight);
        
#ifdef DEBUG
        [self printStringToMsgConsole:[NSString stringWithFormat:@"%@ main window frame", self.showConsole ? @"Expanding" : @"Shrinking"] isErrorMessage:NO];
        [self printStringToMsgConsole:@"Test error" isErrorMessage:YES];
#endif
        
        // resize main window
        NSRect windowFrame = [self.view.window frame];
        float offset = (wHeight - windowFrame.size.height);
        windowFrame.size.height += offset;
        windowFrame.origin.y -= offset;
        [self.view.window setFrame:windowFrame display:YES animate:NO];
    }];
    
    if (!self.isFirstDisclosureClick) {
        self.showConsole = !self.showConsole;
    } else {
        self.isFirstDisclosureClick = NO;
    }
}

- (void)resizeViewRect:(CGRect)rect withName:(NSString *)rectName xPosition:(float)x yPosition:(float)y width:(float)width height:(float)height completionHandeler:(BOOL (^)(NSError *error, NSString *errorTitle))completion {
    
    BOOL hasError;
    NSString *consoleOutput = @EMPTY;
    
    if (x < 0.0f || y < 0.0f || width < 0.0f || height < 0.0f) {
        hasError = YES;
        consoleOutput = [NSString stringWithFormat:@"Unable to resize view rect \"%@\" to the specified dimensions:\n\t- X Position: %f\n\t- Y Position: %f\n\t- Width: %f\n\t- Height: %f\n> Please verify that the specified size is valid and within the bounds of the window", rectName, x, y, width, height];
        completion([[NSError alloc] init], @"Err");
    } else {
        hasError = NO;
        consoleOutput = [NSString stringWithFormat:@"Resizing view rect \"%@\" to dimensions:\n\t- X Position: %f\n\t- Y Position: %f\n\t- Width: %f\n\t- Height: %f", rectName, x, y, width, height];
    }
    
    //NSLog(@"%@", consoleOutput);
    [self printStringToMsgConsole:consoleOutput isErrorMessage:hasError];
    //[self.usrMsgTxtView insertNewline:nil];
}

- (void)printStringToMsgConsole:(NSString *)outStr isErrorMessage:(BOOL)isErrorMsg {
    
    // print new line if message is empty or null
    outStr = !outStr || [outStr isEqualToString:@EMPTY] ? @NEW_LINE : outStr;
    NSLog(@"\nUSER_MSG> %@", outStr);   // log the console output to the debugger
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSString *formattedStr = [NSString stringWithFormat:@"> %@%@%@", isErrorMsg ? @ERROR_TAG : @EMPTY, outStr, @NEW_LINE];
        
        // Add string to text view--red if error, else black
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:isErrorMsg ? [NSColor redColor] : [NSColor blackColor] forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:formattedStr attributes:attributes];
        [[self.usrMsgTxtView textStorage] appendAttributedString:attributedString];
        
        // scroll to the bottom line of the text view
        [self.usrMsgTxtView scrollRangeToVisible:NSMakeRange([[usrMsgTxtView string] length], 0)];
    }];
}

- (void)outputNoConnectivity {
    
}

- (IBAction)updatesBtnPressed:(id)sender {
    [self printStringToMsgConsole:@"Checking for updates..." isErrorMessage:NO];
    [self.checkForUpdatesBtn setEnabled:NO];
    [self.checkingForUpdatesCircle setHidden:NO];
    [self.checkingForUpdatesCircle setIndeterminate:YES];
    [self.checkingForUpdatesCircle setUsesThreadedAnimation:YES];
    [self.checkingForUpdatesCircle startAnimation:nil];
    
    // TODO set up NSTimer for network timeout of 30 seconds
    
    [self checkForUpdates];
}

- (BOOL)checkForUpdates {
    BOOL updateFound = NO;
    
    // TODO make web request for update check
    
    return updateFound;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
