//
//  NSObject+LCModelMapping.m
//  LCModelMapping
//
//  Created by Leer on 16/1/13.
//  Copyright © 2016年 RenAi Co., LTD. All rights reserved.
//

#import "NSObject+LCModelMapping.h"

@interface NSString (LCModelMapping)

@end

@implementation NSString (LCModelMapping)

-(NSArray *) componentsSeparatedByStringArray:(NSArray *)stringArray needCount:(NSInteger)needCount
{
    NSArray * value = nil;
    
    for (NSString * string in stringArray) {
        
        value = [self componentsSeparatedByString:string];
        
        if (value.count >= needCount) {
            break;
        }
    }
    
    return value;
}

@end

#pragma mark -

@implementation NSObject (LCModelMapping)

+(instancetype) modelWithJSON:(id)json
{   
    return [self modelWithDictionary:json];
}

+(instancetype) modelWithDictionary:(NSDictionary *)dictionary
{
    id value = [self yy_modelWithDictionary:dictionary];
    
    return value;
}

+(NSDictionary *) modelCustomPropertyMapper
{
    return [self.class getModelMappingCache];
}

+(NSDictionary *) modelContainerPropertyGenericClass
{
    [self.class getModelMappingCache];
    
    return [self.class getModelClassMappingCacheWithClass:self];
}

+(NSMutableDictionary *) getModelClassMappingCacheWithClass:(Class)class
{
    static NSMutableDictionary * classCahce = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        
        classCahce = [NSMutableDictionary dictionary];
    });
    
    NSString * className = NSStringFromClass(class);
    
    NSMutableDictionary * subCache = classCahce[className];
    
    if (!subCache) {
        classCahce[className] = subCache = [NSMutableDictionary dictionary];
    }
    
    return subCache;
}

+(NSDictionary *) getModelMappingCache
{
    static NSMutableDictionary * cahce = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        cahce = [NSMutableDictionary dictionary];
    });
    
    Class class = self.class;
    NSString * className = NSStringFromClass(class);
    
    NSDictionary * modelMapping = cahce[className];
    
    if (!modelMapping) {
        
        modelMapping = [class getModelMapping];
        
        if (modelMapping) {
            
            cahce[className] = modelMapping;
        }
    }
    
    return modelMapping;
}

+(NSDictionary *) getModelMapping
{
    Class class = self.class;

    if ([class respondsToSelector:@selector(modelMapping)]) {
        
        NSArray * mappingMeta = [self.class modelMapping];

        NSMutableDictionary * tmp = [NSMutableDictionary new];
        
        [mappingMeta enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSArray * tmpArray = [obj componentsSeparatedByStringArray:@[@">>" ,@"->" ,@"->>" ,@"=>"] needCount:2];
            
            if (tmpArray.count == 2) {

                NSString * mappingKeysString = [tmpArray[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString * propertyAndClass = [tmpArray[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            
                NSArray * keys = [mappingKeysString componentsSeparatedByStringArray:@[@","] needCount:1];
                
                NSArray * proAndClassArray = [propertyAndClass componentsSeparatedByStringArray:@[@"<"] needCount:0];
                
                NSString * propertyName = proAndClassArray[0];
                
                tmp[propertyName] = keys;
                
                // class mapping cache.
                if (proAndClassArray.count >= 2) {
                    
                    NSMutableDictionary * classMappingCache = [class getModelClassMappingCacheWithClass:class];
                    classMappingCache[propertyName] = [proAndClassArray[1] stringByReplacingOccurrencesOfString:@">" withString:@""];
                }
             
            }
        }];
        
        return tmp;
    }
    
    return nil;
}


@end
