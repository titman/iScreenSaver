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

#import "LCScreenSaverDefaults.h"
#import "YYModel.h"

#define __DEFAULTS_NAME        @"LCScreenSaverDefaults"
#define __NETWORKING_CACHE_KEY @"LCScreenSaverDefaults.networking.cache"
#define __LOCAL_CACHE_KEY      @"LCScreenSaverDefaults.local.cache"
#define __INUSE_FLAG_KEY       @"LCScreenSaverDefaults.inuse.flag"

#define __NETWORKING_SOURCE_CACHE_KEY(name) [NSString stringWithFormat:@"LCScreenSaverDefaults.networking.cache.%@", name]

@implementation LCInUseScreenSaverModel

@end

@implementation LCScreenSaverDefaults

+(instancetype) shareInstance
{
    static LCScreenSaverDefaults * defaults = nil;
    
    if (!defaults) {
        
        defaults = [LCScreenSaverDefaults defaultsForModuleWithName:__DEFAULTS_NAME];
    }
    
    return defaults;
}

+(NSMutableArray<LCScreenSaverModel *> *) loadNetworkingDatasourceCache
{
    NSArray * array = [self.shareInstance objectForKey:__NETWORKING_CACHE_KEY];
    
    NSMutableArray * result = [NSMutableArray array];
    
    for (NSDictionary * object in array) {
        
        LCScreenSaverModel * model = [LCScreenSaverModel modelWithDictionary:object];
        
        model.type = LCScreenSaverModelTypeNetworking;
        
        [result addObject:model];
    }
    
    return result;
}

+(void) saveNetworkingDatasourceCache:(NSArray<NSDictionary *> *)cache
{
    [self.shareInstance setObject:cache forKey:__NETWORKING_CACHE_KEY];
    [self.shareInstance synchronize];
}

+(NSMutableArray<LCScreenSaverModel *> *) loadLocalDatasourceCache
{
    NSArray * array = [self.shareInstance objectForKey:__LOCAL_CACHE_KEY];
    
    NSMutableArray * result = [NSMutableArray array];
    
    for (NSDictionary * object in array) {
        
        LCScreenSaverModel * model = [LCScreenSaverModel modelWithDictionary:object];
        
        model.type = LCScreenSaverModelTypeLocal;
        
        [result addObject:model];
    }
    
    return result;
}

+(void) saveLocalDatasourceCache:(NSArray<NSDictionary *> *)cache
{
    [self.shareInstance setObject:cache forKey:__LOCAL_CACHE_KEY];
    [self.shareInstance synchronize];
}

+(void) addLocalDataToCache:(LCScreenSaverModel *)model
{
    NSMutableArray * array = [self loadLocalDatasourceCache];
    
    NSMutableArray * result = [NSMutableArray array];
    
    for (LCScreenSaverModel * object in array) {
        
        [result addObject:[object yy_modelToJSONObject]];
    }
    
    [result addObject:[model yy_modelToJSONObject]];
    
    [self saveLocalDatasourceCache:result];
}

+(void) deleteLocalDataWithIndex:(NSInteger)index
{
    NSMutableArray * array = [self loadLocalDatasourceCache];
    
    [array removeObjectAtIndex:index];
    
    NSMutableArray * result = [NSMutableArray array];
    
    for (LCScreenSaverModel * object in array) {
        
        [result addObject:[object yy_modelToJSONObject]];
    }

    [self saveLocalDatasourceCache:result];
}
    
+(void) updateLocalDataToCache:(LCScreenSaverModel *)model index:(NSInteger)index
{
    NSMutableArray * array = [self loadLocalDatasourceCache];
    
    if (array.count >= index + 1) {
        
        NSMutableArray * result = [NSMutableArray array];
        
        NSInteger i = 0;
        
        for (LCScreenSaverModel * object in array) {
            
            if (i == index) {
                
                [result addObject:[model yy_modelToJSONObject]];
            }
            else{
                
                [result addObject:[object yy_modelToJSONObject]];
            }
            
            i++;
        }
        
        [self saveLocalDatasourceCache:result];
    }
}


+(void) clearAllNetworkingCache
{
    NSArray * allKeys = [self.shareInstance dictionaryRepresentation].allKeys;
    
    for (NSString * key in allKeys) {
        
        if ([key hasPrefix:__NETWORKING_CACHE_KEY] && key.length > __NETWORKING_CACHE_KEY.length) {
            
            [self.shareInstance removeObjectForKey:key];
        }
    }
    
    [self.shareInstance removeObjectForKey:__INUSE_FLAG_KEY];
    [self.shareInstance synchronize];

}

+(NSString *) loadHTMLFromCache:(NSString *)name
{
    return [self.shareInstance objectForKey:__NETWORKING_SOURCE_CACHE_KEY(name)];
}


+(void) saveHTMLtoCache:(NSString *)html name:(NSString *)name
{
    [self.shareInstance setObject:html forKey:__NETWORKING_SOURCE_CACHE_KEY(name)];
    [self.shareInstance synchronize];
}

+(void) flagInUseScreenSaverWithIndex:(NSInteger)index type:(LCScreenSaverModelType)type
{
    [self.shareInstance setObject:[NSString stringWithFormat:@"%@.%@", @(type), @(index)] forKey:__INUSE_FLAG_KEY];
    [self.shareInstance synchronize];
}

+(LCInUseScreenSaverModel *) inUseScreenSaver
{
    NSString * flag = [self.shareInstance objectForKey:__INUSE_FLAG_KEY];
    
    
    if (flag) {
        
        LCInUseScreenSaverModel * model = [[LCInUseScreenSaverModel alloc] init];
        
        NSArray * array = [flag componentsSeparatedByString:@"."];
        
        model.type  = [array[0] integerValue];
        model.index = [array[1] integerValue];
        
        return model;
    }
    
    return nil;
}


@end
