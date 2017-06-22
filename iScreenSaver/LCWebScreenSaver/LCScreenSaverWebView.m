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

#import "LCScreenSaverWebView.h"
#import "WebPreferences+LCWebOptimize.h"

@implementation LCScreenSaverWebView

-(instancetype) initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        
        [self initSelf];
    }
    
    return self;
}

-(instancetype) initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        
        [self initSelf];
    }
    
    return self;
}

-(void) initSelf
{
    self.mainFrame.frameView.allowsScrolling = NO;
    
    self.drawsBackground       = NO;
    self.wantsLayer            = YES;
    self.layer.backgroundColor = [NSColor blackColor].CGColor;
    
    WebPreferences * prefs = [self preferences];
    
    [prefs setLocalStorageEnabled:YES];
    [prefs setWebGLEnabled:YES];
    [prefs setRequestAnimationFrameEnabled:YES];
    [prefs setAccelerated2dCanvasEnabled:YES];
    [prefs setAcceleratedDrawingEnabled:YES];
    [prefs setCanvasUsesAcceleratedDrawing:YES];
    [prefs setAcceleratedCompositingEnabled:YES];
    
    [self setPreferences:prefs];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
}

-(void) drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void) mouseDown:(NSEvent *)theEvent
{
    
}

-(NSView *) hitTest:(NSPoint)point
{
    return nil;
}

@end
