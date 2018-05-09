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

#import "LCScreenSaverItemCell.h"
#import "UIImageView+WebCache.h"
#import "LCScreenSaverRequest.h"
#import "WebPreferences+LCWebOptimize.h"
#import "LCScreenSaverWebView.h"

@implementation LCScreenSaverItemCell

-(void) setModel:(LCScreenSaverModel *)model
{
    NSString * currentHTML = _model.html;
    
    _model = model;
    
    self.webImageView.image = nil;
    self.webImageView.wantsLayer = YES;
    self.webImageView.layer.cornerRadius = 4;
    self.webImageView.layer.masksToBounds = YES;
    self.webImageView.layer.contentsGravity = kCAGravityResizeAspectFill;

    
    NSString * url = [NSString stringWithFormat:@"%@%@",MAIN_URL, [model.preview stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.webImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    
    self.titleLabel.stringValue      = model.name;
    self.uploadTimeLabel.stringValue = model.date;
    self.fileSizeLabel.stringValue   = [NSString stringWithFormat:@"%@kb", model.size];
    
    
    self.editButton.hidden   = NO;
    self.deleteButton.hidden = NO;
    self.typeLabel.hidden    = NO;
    self.webView.hidden      = NO;

    if (model.type == LCScreenSaverModelTypeNetworking) {
        
        self.deleteButton.hidden = YES;
        self.typeLabel.hidden    = YES;
        self.webView.hidden      = YES;
        self.editButton.hidden   = YES;
    }
    else{
        
        self.webView.editingDelegate = self;
        self.webView.UIDelegate = self;

        
        if (model.html.length && ![currentHTML isEqualToString:model.html]) {
            
            [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
            
            if ([model.html hasPrefix:@"http://"] || [model.html hasSuffix:@"https://"]) {
                
                self.typeLabel.stringValue = @"URL";
                [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.html]]];
            }
            else if([model.html hasPrefix:@"javascript:"]){
                
                self.typeLabel.stringValue = @"SCRIPT";

                [self.webView stringByEvaluatingJavaScriptFromString:model.html];
            }
            else{
                
                self.typeLabel.stringValue = @"HTML";
                
                [self.webView.mainFrame loadHTMLString:model.html baseURL:nil];
            }
        }
    }
}

#pragma mark -

-(IBAction) deleteAction:(id)sender
{
    if (self.deleteAction) {
        self.deleteAction(self.row);
    }
}

-(IBAction) editAction:(id)sender
{
    if (self.editAction) {
        self.editAction(self.row);
    }
}

-(void) setFlagNo
{
    [self flag:NO];
}

-(void) flag:(BOOL)flag
{
    if (flag) {
        
        self.stateLabel.stringValue = @"IN USE";
        self.stateLabel.textColor = [NSColor redColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFlagNo) name:@"LCScreenSaverItemCellSetFalgNo" object:nil];
    }
    else{
        
        self.stateLabel.stringValue = @"UNUSED";
        self.stateLabel.textColor = [NSColor lightGrayColor];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LCScreenSaverItemCellSetFalgNo" object:nil];
    }
}

#pragma mark -
    
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
