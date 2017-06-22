//
//  NSObject+LCModelMapping.h
//  LCModelMapping
//
//  Created by Leer on 16/1/13.
//  Copyright © 2016年 RenAi Co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@protocol LCModelMapping <YYModel>

@optional
+(NSArray *) modelMapping;

@end

#pragma mark -

@interface NSObject (LCModelMapping)

+(instancetype) modelWithJSON:(id)json;
+(instancetype) modelWithDictionary:(NSDictionary *)dictionary;

@end
