//
//
//      _|          _|_|_|
//      _|        _|
//      _|        _|
//      _|        _|
//      _|_|_|_|    _|_|_|
//
//
//  Copyright (c) 2014-2015, Licheng Guo. ( http://titm.me )
//  http://github.com/titman
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "LCWebScreenSaverView.h"
#import <WebKit/WebKit.h>
#import <IOKit/ps/IOPowerSources.h>
#import "LCScreenSaverManager.h"
#import "AFNetworking.h"

#import "WebPreferences+LCWebOptimize.h"

typedef NS_ENUM(NSInteger, LCBatteryStatus) {
    
    LCBatteryStatusPlugged,
    LCBatteryStatusRecentlyUnplugged,
    LCBatteryStatusTimeRemaining,
};

@interface LCWebScreenSaverView() <WebFrameLoadDelegate, WebUIDelegate, WebEditingDelegate>

@property(nonatomic, strong) WebView * webView;
@property(nonatomic, strong) NSTextField * textField;

@property(nonatomic, strong) NSString * debuggingString;

@property(nonatomic, assign) BOOL batteryStatus;
@property(nonatomic, assign) BOOL debugMode;

@end

@implementation LCWebScreenSaverView

-(instancetype) initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) {
        
        self.batteryStatus = [self getBatteryStatus];
        
        [self setAnimationTimeInterval:self.batteryStatus == LCBatteryStatusPlugged ? 1. / 60. : 1. / 30.];
        

        [LCScreenSaverManager shareInstance];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeDisplayText:) name:@"LCChangeDisplayTextNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadHTMLWithNotification:) name:@"LCNeedDisplayNotification"
                                                   object:nil];
        
        CTFontManagerSetAutoActivationSetting(NULL, kCTFontManagerAutoActivationDisabled);
    }
    
    return self;
}

#pragma mark - Display

-(LCBatteryStatus) getBatteryStatus
{
    CFTimeInterval timeRemaining = IOPSGetTimeRemainingEstimate();
    
    if (timeRemaining == -2.0) {
        return LCBatteryStatusPlugged;
    } else if (timeRemaining == -1.0) {
        return LCBatteryStatusRecentlyUnplugged;
    } else {
        //NSInteger minutes = timeRemaining / 60;
        return LCBatteryStatusTimeRemaining;
    }
}

-(void) changeDisplayText:(NSNotification *)notification
{
    self.debuggingString = [NSString stringWithFormat:@"%@\n%@", (self.debuggingString ? self.debuggingString : @""), notification.object];
    
    [self.textField performSelectorOnMainThread:@selector(setStringValue:) withObject:self.debuggingString waitUntilDone:NO];
}

-(void) loadWithHTML:(NSString *)html
{
    if ([html hasPrefix:@"http://"] || [html hasPrefix:@"https://"]) {
        
        [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:html]]];
    }
    else if([html hasPrefix:@"javascript:"]){
        
        [self.webView stringByEvaluatingJavaScriptFromString:html];
    }
    else{
        
        [self.webView.mainFrame loadHTMLString:html baseURL:nil];
    }
}

-(void) loadHTMLWithNotification:(NSNotification *)notification
{
    [self loadWithHTML:notification.object];
}

#pragma mark - Overwrite

-(void) startAnimation
{
    [super startAnimation];
    
    LCScreenSaverModel * model = [LCScreenSaverManager shareInstance].inUseModel;
    
    if (model) {
        
        if (!self.webView) {
            
            self.webView = [[WebView alloc] initWithFrame:self.bounds];
            self.webView.frameLoadDelegate = self;
            self.webView.UIDelegate        = self;
            self.webView.editingDelegate   = self;
            
            self.webView.mainFrame.frameView.allowsScrolling = NO;
            
            self.webView.drawsBackground       = NO;
            self.webView.wantsLayer            = YES;
            self.webView.layer.backgroundColor = [NSColor blackColor].CGColor;
            
            WebPreferences * prefs = [self.webView preferences];
            
            [prefs setLocalStorageEnabled:YES];
            [prefs setWebGLEnabled:YES];
            [prefs setRequestAnimationFrameEnabled:YES];
            [prefs setAccelerated2dCanvasEnabled:YES];
            [prefs setAcceleratedDrawingEnabled:YES];
            [prefs setCanvasUsesAcceleratedDrawing:YES];
            [prefs setAcceleratedCompositingEnabled:YES];
            
            [self.webView setPreferences:prefs];
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            
            [self addSubview:self.webView];
        }
        
        if (model.type == LCScreenSaverModelTypeNetworking) {
            
            [model requestHTMLWithCompletion:^(NSString *html, BOOL finished) {
                
                if (finished) {
                    
                    [self loadWithHTML:html];
                }
            }];
        }
        else if (model.type == LCScreenSaverModelTypeLocal){
            
            [self loadWithHTML:model.html];
        }
        else{
            
        }
    }
    else{
        
        if (!self.textField) {
            
            self.textField = [[NSTextField alloc] initWithFrame:self.bounds];
            self.textField.font = [NSFont systemFontOfSize:20];
            self.textField.textColor = [NSColor redColor];
            self.textField.alignment = NSTextAlignmentCenter;
            self.textField.stringValue = @"请点击下方“屏幕保护程序选项”";
            [self addSubview:self.textField];
        }
    }
}

-(void) stopAnimation
{
    [super stopAnimation];
    
    if (self.webView) {
        [self.webView removeFromSuperview];
    }
    
    self.webView = nil;
    
    if (self.textField) {
        [self.textField removeFromSuperview];
    }
    
    self.textField = nil;
}

-(void) drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

-(BOOL) hasConfigureSheet
{
    return YES;
}

-(NSWindow *) configureSheet
{
    return [LCScreenSaverManager shareInstance].sheet;
}

-(void) webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    
}
    
-(NSArray *) webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element
    defaultMenuItems:(NSArray *)defaultMenuItems
{
    // disable right-click context menu
    return nil;
}

-(BOOL) webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange
 toDOMRange:(DOMRange *)proposedRange
   affinity:(NSSelectionAffinity)selectionAffinity
stillSelecting:(BOOL)flag
{
    // disable text selection
    return NO;
}

@end
