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

#import "LCScreenSaverRequest.h"
#import "AFNetworking.h"


@interface LCScreenSaverRequest()

@property(nonatomic, assign) LCScreenSaverRequestType type;
@property(nonatomic, copy) void(^successBlock) (NSURLSessionDataTask *task, id responseObject);
@property(nonatomic, copy) void(^failureBlock) (NSURLSessionDataTask *task, NSError *error);

@end

@implementation LCScreenSaverRequest

+(instancetype) requestWithType:(LCScreenSaverRequestType)type
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
{
    LCScreenSaverRequest * request = [[LCScreenSaverRequest alloc] initWithType:type success:success failure:failure];
    
    [request request];
    
    return request;
}

-(instancetype) initWithType:(LCScreenSaverRequestType)type
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if (self = [super init]) {
        
        self.type = type;
        self.successBlock = success;
        self.failureBlock = failure;
    }
    
    return self;
}

-(void) request
{
    NSString * url = nil;
    
    switch (self.type) {
        case LCScreenSaverRequestTypeLoad:
            url = [NSString stringWithFormat:@"%@iScreenSaver/screensaver.xml", MAIN_URL];
            break;
        default:
            url = MAIN_URL;
            break;
    }
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer     = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil progress:nil success:self.successBlock failure:self.failureBlock];    
}

@end
