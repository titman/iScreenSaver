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

#import "LCModel.h"

@interface __LCModelTest : NSObject

@end

@implementation __LCModelTest

-(instancetype) initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
   if (self = [super init]) {
      
   }
   
   return self;
}

@end

@interface LCModel ()

@end

@implementation LCModel

+(NSMutableArray *) modelArrayWithArray:(NSArray *)array
{
   NSMutableArray * result = [NSMutableArray array];
   
   for (NSDictionary * dic in array) {
      
      [result addObject:[self objectWithDictionary:dic]];
   }
   
   return result;
}

+(instancetype) objectWithDictionary:(NSDictionary *)dictionary
{
   id value = [self.class alloc];
   
   if ([value respondsToSelector:@selector(initWithDictionary:error:)]) {
      
      return [value initWithDictionary:dictionary error:nil];
   }
   else{
      
      value = [self.class modelWithDictionary:dictionary];
   }
      
   return value;
}

-(void) modelMappingComplete:(NSDictionary *)dictionary
{
   
}

-(NSDictionary *) checkDictionary:(NSDictionary *)dict
{
   NSMutableDictionary * dic = [dict mutableCopy];
   
   NSArray * keys = dict.allKeys;
   
   NSMutableArray * need = [NSMutableArray array];
   
   for (NSString * key in keys) {
      
      id value = dict[key];
      
      if ([value isKindOfClass:[NSNull class]]) {
         
         [need addObject:key];
      }
   }
   
   for (NSString * key in need) {
      
      [dic removeObjectForKey:key];
   }

   return dic;
}


@end
