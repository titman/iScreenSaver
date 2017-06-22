//
//
//      _|          _|_|_|
//      _|        _|
//      _|        _|
//      _|        _|
//      _|_|_|_|    _|_|_|
//
//
//  Copyright (c) 2014-2015, Licheng Guo. ( http://nsobject.me )
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

#import "DragView.h"
#import "AppDelegate.h"
#import "ResultViewController.h"

@implementation DragView

-(void) awakeFromNib
{
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
}

- (void)draggingEnded:(nullable id <NSDraggingInfo>)sender
{
    NSPasteboard * pb = [sender draggingPasteboard];
    
    NSArray * list = [pb propertyListForType:NSFilenamesPboardType];
    
    if (list.count) {
        
        NSString * path = list[0];
        
        BOOL isDir = NO;
        
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
        
        if(isDir){
            
            // 处理
            [self handleWithPath:path];
        }
        else{
            
            NSAlert * alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setMessageText:@"拖入的必须是一个文件夹"];
            [alert setAlertStyle:NSAlertStyleWarning];
            [alert beginSheetModalForWindow:self.window completionHandler:nil];
        }
    }
}

-(void) handleWithPath:(NSString *)floderPath
{
    NSString * indexHTMLPath = [NSString stringWithFormat:@"%@/index.html", floderPath];
    NSString * cssPath = [NSString stringWithFormat:@"%@/css/style.css", floderPath];
    NSString * jsPath = [NSString stringWithFormat:@"%@/js/index.js", floderPath];
    
    NSString * html = [NSString stringWithContentsOfFile:indexHTMLPath encoding:NSUTF8StringEncoding error:nil];
    NSString * css = [NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:nil];
    NSString * js = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    
    
    html = [html stringByReplacingOccurrencesOfString:@"<link rel=\"stylesheet\" href=\"css/style.css\">" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"<head>" withString:[NSString stringWithFormat:@"<style>%@</style><head>", css]];
    html = [html stringByReplacingOccurrencesOfString:@"<script src=\"js/index.js\"></script>" withString:[NSString stringWithFormat:@"<script>%@</script>", js]];
    
    
    ResultViewController * result = [[ResultViewController alloc] initWithString:html];
    
    [self.parentViewController presentViewControllerAsModalWindow:result];
    
    
        //        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        //                                                                               options:NSRegularExpressionCaseInsensitive
        //                                                                            error:nil];
        //
        //        __block NSMutableString * newHtml = [html mutableCopy];
        //
        //        [regex enumerateMatchesInString:html
        //                                options:0
        //                                  range:NSMakeRange(0, [html length])
        //                             usingBlock:^(NSTextCheckingResult * result, NSMatchingFlags flags, BOOL *stop) {
        //
        //                                 NSString * url = [html substringWithRange:result.range];
        //
        //                                 if ([url hasSuffix:@""]) {
        //                                     <#statements#>
        //                                 }
        //
        //                                 newHtml = [[newHtml stringByReplacingOccurrencesOfString: withString:@""] mutableCopy];
        //                             }];
        
        
//        BOOL finish = [html writeToFile:[NSString stringWithFormat:@"%@%@.html", output, [[value lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
//
//        NSLog(@"%@ %@", value, @(finish));

}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSPasteboard * pb = [sender draggingPasteboard];
    NSArray * array= [pb types];
    
    if ([array containsObject:NSFilenamesPboardType]) {
        
        return NSDragOperationEvery;
    }
    
    return NSDragOperationNone;
}

@end
