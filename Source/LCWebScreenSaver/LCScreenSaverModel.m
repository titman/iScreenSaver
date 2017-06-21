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

#import "LCScreenSaverModel.h"
#import "AFNetworking.h"
#import "LCScreenSaverRequest.h"
#import "LCScreenSaverDefaults.h"

@implementation LCScreenSaverModel

-(void) requestHTMLWithCompletion:(void (^)(NSString * html, BOOL finished))completion
{
    if (self.html && [self.html hasPrefix:@"iScreenSaver"]) {
        
        NSString * htmlCache = [LCScreenSaverDefaults loadHTMLFromCache:self.name];
        
        if (htmlCache && htmlCache.length) {
            
            if (completion) {
                completion(htmlCache, YES);
            }
            return;
        }
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer     = [AFHTTPResponseSerializer serializer];
        
        NSString * url = [NSString stringWithFormat:@"%@%@", MAIN_URL, [self.html stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString * responseHTML = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            [LCScreenSaverDefaults saveHTMLtoCache:responseHTML name:self.name];
            
            if (completion) {
                completion(responseHTML, YES);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
            if (completion) {
                completion(@"请求失败", NO);
            }
        }];
    }
    else{
        
    }
    
    if (completion) {
        completion(@"前缀不是iScreenSaver", NO);
    }
}

@end
