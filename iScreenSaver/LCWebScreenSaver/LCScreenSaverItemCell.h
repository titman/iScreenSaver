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

#import <Cocoa/Cocoa.h>
#import "LCScreenSaverModel.h"
#import <WebKit/WebKit.h>

@class LCScreenSaverWebView;

typedef void(^LCScreenSaverItemCellDeleteAction)(NSInteger row);
typedef void(^LCScreenSaverItemCellEditAction)(NSInteger row);

@interface LCScreenSaverItemCell : NSTableCellView <WebEditingDelegate, WebUIDelegate>

@property(nonatomic, strong) IBOutlet NSImageView * webImageView;
@property(nonatomic, strong) IBOutlet NSTextField * titleLabel;
@property(nonatomic, strong) IBOutlet NSTextField * fileSizeLabel;
@property(nonatomic, strong) IBOutlet NSTextField * uploadTimeLabel;
@property(nonatomic, strong) IBOutlet NSTextField * stateLabel;
@property(nonatomic, strong) IBOutlet NSTextField * typeLabel;

@property(nonatomic, strong) IBOutlet LCScreenSaverWebView * webView;

@property(nonatomic, strong) IBOutlet NSButton * deleteButton;
@property(nonatomic, strong) IBOutlet NSButton * editButton;

@property(nonatomic, assign) NSInteger row;
@property(nonatomic, strong) LCScreenSaverModel * model;

@property(nonatomic, copy) LCScreenSaverItemCellDeleteAction deleteAction;
@property(nonatomic, copy) LCScreenSaverItemCellEditAction editAction;

-(void) flag:(BOOL)flag;

@end
