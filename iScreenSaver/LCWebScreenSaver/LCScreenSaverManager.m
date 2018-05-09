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

#import "LCScreenSaverManager.h"
#import "LCScreenSaverItemCell.h"
#import "LCScreenSaverRequest.h"
#import "LCScreenSaverModel.h"
#import "LCScreenSaverDefaults.h"

#import "WebPreferences+LCWebOptimize.h"

@interface LCScreenSaverManager() <NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate>

// Main UI
@property(nonatomic, strong) IBOutlet NSTableView * leftTableView;
@property(nonatomic, strong) IBOutlet NSTableView * rightTableView;

@property(nonatomic, strong) IBOutlet NSTableHeaderView * leftTableHeaderView;

// Eidt UI
@property(nonatomic, strong) IBOutlet NSTextView * editHTMLTextField;
@property(nonatomic, strong) IBOutlet NSTextField * editHTMLNameTextField;
    
@property(nonatomic, assign) NSInteger editingIndex;

// Datasource
@property(nonatomic, strong) NSMutableArray * datasourceNetwoking;
@property(nonatomic, strong) NSMutableArray * datasourceLocal;


// Add UI
@property(nonatomic, strong) IBOutlet NSTextField * HTMLTextField;
@property(nonatomic, strong) IBOutlet NSTextField * HTMLNameTextField;
@property(nonatomic, strong) IBOutlet NSButton * HTMLAddButton;


@end

@implementation LCScreenSaverManager

#pragma mark - Init

+(instancetype) shareInstance
{
    static LCScreenSaverManager * manager = nil;
    
    if (!manager) {
        
        manager = [[LCScreenSaverManager alloc] init];
    }
    
    return manager;
}

-(instancetype) init
{
    if (self = [super init]) {
        
        [self sheet];

        [self loadFromInternet];
        [self loadFromLocal];
        
        self.inUse = [LCScreenSaverDefaults inUseScreenSaver];
    }
    
    return self;
}

#pragma mark - Action

-(IBAction) dismissSheet:(id)sender
{
    [[NSApplication sharedApplication] endSheet:self.sheet];
}

-(IBAction) dismissEditSheet:(id)sender
{
    [self.editSheet close];
    self.editSheet = nil;
}
    
-(IBAction) saveEditSheet:(id)sender
{
    LCScreenSaverModel * model = self.datasourceLocal[self.editingIndex];
    
    model.name = self.editHTMLNameTextField.stringValue;
    model.html = self.editHTMLTextField.string;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd";
    
    model.date = [formatter stringFromDate:[NSDate date]];
    model.size = @(@(model.html.length / 1024.).integerValue).description;
    
    [self.rightTableView reloadData];
    
    [LCScreenSaverDefaults updateLocalDataToCache:model index:self.editingIndex];
    
    [self.editSheet close];
    self.editSheet = nil;
}

-(IBAction) showOrHideTextField:(id)sender
{
    if (self.HTMLAddButton.hidden == YES) {
        
        self.HTMLTextField.hidden     = NO;
        self.HTMLNameTextField.hidden = NO;
        self.HTMLAddButton.hidden     = NO;
    }
    else{
        
        self.HTMLTextField.hidden     = YES;
        self.HTMLNameTextField.hidden = YES;
        self.HTMLAddButton.hidden     = YES;
    }
}

-(IBAction) clearCache:(id)sender
{
    [LCScreenSaverDefaults clearAllNetworkingCache];
    
    [[NSApplication sharedApplication] endSheet:self.sheet];
}

-(IBAction) openVersionInfo:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/titman/iScreenSaver"]];
}


-(IBAction) addHTML:(id)sender
{
    NSString * html = self.HTMLTextField.stringValue;
    NSString * name = self.HTMLNameTextField.stringValue;
    
    if (html.length && name.length) {
        
        LCScreenSaverModel * model = [[LCScreenSaverModel alloc] init];
        model.type = LCScreenSaverModelTypeLocal;
        model.name = name;
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy.MM.dd";
        
        model.date = [formatter stringFromDate:[NSDate date]];
        model.size = @(@(html.length / 1024.).integerValue).description;
        model.html = html;
        
        [self.datasourceLocal addObject:model];
        [self.rightTableView reloadData];

        [self showOrHideTextField:nil];

        self.HTMLNameTextField.stringValue = @"name";
        self.HTMLTextField.stringValue     = @"URL(http:// or https://) / html code / javascript  code";
        
        [LCScreenSaverDefaults addLocalDataToCache:model];
    }
}

#pragma mark - Load

-(void) loadFromInternet
{
    self.datasourceNetwoking = [LCScreenSaverDefaults loadNetworkingDatasourceCache];
    [self.leftTableView reloadData];

    [LCScreenSaverRequest requestWithType:LCScreenSaverRequestTypeLoad success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * array = [self objectWithContentsOfData:responseObject];
        
        NSMutableArray * result = [NSMutableArray array];
        
        for (NSDictionary * object in array) {
            
            LCScreenSaverModel * model = [LCScreenSaverModel modelWithDictionary:object];
            
            model.type = LCScreenSaverModelTypeNetworking;
            
            [result addObject:model];
            
            
            NSTableColumn * column = self.leftTableView.tableColumns.lastObject;
            
            column.headerCell.stringValue = [NSString stringWithFormat:@"推荐(%@个)", @(result.count)];
        }
        
        self.datasourceNetwoking = result;
        [self.leftTableView reloadData];
        
        [LCScreenSaverDefaults saveNetworkingDatasourceCache:array];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        ;
    }];
}

-(void) loadFromLocal
{
    self.datasourceLocal = [LCScreenSaverDefaults loadLocalDatasourceCache];
    [self.rightTableView reloadData];
}

-(id) objectWithContentsOfData:(NSData *)data
{
    CFPropertyListRef list = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)data, kCFPropertyListImmutable, NULL);
    
    if(list == nil) return nil;
    
    if ([(__bridge id)list isKindOfClass:[NSDictionary class]]) {
        
        return (__bridge NSDictionary *)list;
    }
    else if([(__bridge id)list isKindOfClass:[NSArray class]]){
        
        return (__bridge NSArray *)list;
    }
    else{
        
        CFRelease(list);
        return nil;
    }
}

#pragma mark - Overwrite

-(NSWindow *) sheet
{
    if(!_sheet){
        
        if (![[NSBundle bundleForClass:[self class]] loadNibNamed:@"LCScreenSaverManagerSheet" owner:self topLevelObjects:NULL]) {
            
        }
    }
    
    _sheet.delegate = self;
    
    return _sheet;
}

-(LCScreenSaverModel *) inUseModel
{
    if (self.inUse) {
        
        if (self.inUse.type == LCScreenSaverModelTypeNetworking) {
            
            return self.datasourceNetwoking[self.inUse.index];
        }
        else{
            
            return self.datasourceLocal[self.inUse.index];
        }
    }
    
    return nil;
}

#pragma mark - Window Delegate

- (void)windowDidChangeOcclusionState:(NSNotification *)notification
{
    NSWindow * window = notification.object;
    
    if (window.occlusionState & NSWindowOcclusionStateVisible)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"LCChangeDisplayTextNotification" object:[NSString stringWithFormat:@"%@ %@ %@", self.inUse, @(self.inUse.type), @(self.inUse.index)]];
        [self loadFromInternet];
    }
}


#pragma mark - TableView

-(void)awakeFromNib
{
    self.leftTableView.rowHeight  = 140;
    self.rightTableView.rowHeight = 140;

    [self.leftTableView registerNib:[[NSNib alloc] initWithNibNamed:@"LCScreenSaverItemCell" bundle:[NSBundle bundleForClass:[self class]]] forIdentifier:@"cell"];
    
    [self.rightTableView registerNib:[[NSNib alloc] initWithNibNamed:@"LCScreenSaverItemCell" bundle:[NSBundle bundleForClass:[self class]]] forIdentifier:@"cell"];

}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == self.leftTableView) {
        
        return self.datasourceNetwoking.count;
    }
    
    return self.datasourceLocal.count;
}

- (NSView *) tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    LCScreenSaverItemCell * cell = [tableView makeViewWithIdentifier:@"cell" owner:nil];
    
    LCScreenSaverModel * model = tableView == self.leftTableView ? self.datasourceNetwoking[row] : self.datasourceLocal[row];
    
    cell.row = row;
    cell.model = model;
    
    if (self.inUse && model.type == self.inUse.type && row == self.inUse.index) {
        
        [cell flag:YES];
    }
    else{
        
        [cell flag:NO];
    }
    
    if (tableView == self.rightTableView) {
        
        __weak LCScreenSaverManager * weakSelf = self;
        
        cell.deleteAction = ^(NSInteger cellRow){
            
            if (weakSelf.inUse.type == LCScreenSaverModelTypeLocal) {
                
                weakSelf.inUse = nil;
            }
            
            [LCScreenSaverDefaults deleteLocalDataWithIndex:cellRow];
            [weakSelf.datasourceLocal removeObjectAtIndex:cellRow];

            [tableView reloadData];
        };
        
        cell.editAction = ^(NSInteger cellRow){
            
            [[NSBundle bundleForClass:[weakSelf class]] loadNibNamed:@"LCScreenSaverEidtSheet" owner:weakSelf topLevelObjects:NULL];
            
            weakSelf.editingIndex = cellRow;
            weakSelf.editHTMLNameTextField.stringValue = model.name;
            weakSelf.editHTMLTextField.string = model.html;
        };
    }
    
    return cell;
}

-(BOOL) tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    LCScreenSaverModel * model = tableView == self.leftTableView ? self.datasourceNetwoking[row] : self.datasourceLocal[row];

    
    if (tableView == self.leftTableView) {
        
        [model requestHTMLWithCompletion:^(NSString *html, BOOL finished) {
           
            if (finished) {
             
                [LCScreenSaverDefaults flagInUseScreenSaverWithIndex:row type:LCScreenSaverModelTypeNetworking];
                
                self.inUse = [[LCInUseScreenSaverModel alloc] init];
                self.inUse.type = LCScreenSaverModelTypeNetworking;
                self.inUse.index = row;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LCScreenSaverItemCellSetFalgNo" object:nil];
                
                [tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
            }
        }];
    }
    else if(tableView == self.rightTableView){
        
        [LCScreenSaverDefaults flagInUseScreenSaverWithIndex:row type:LCScreenSaverModelTypeLocal];
        
        self.inUse = [[LCInUseScreenSaverModel alloc] init];
        self.inUse.type = LCScreenSaverModelTypeLocal;
        self.inUse.index = row;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LCScreenSaverItemCellSetFalgNo" object:nil];
        
        [tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:0]];

    }
    
    return NO;
}

@end
