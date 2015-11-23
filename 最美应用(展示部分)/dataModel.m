//
//  dataModel.m
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/11.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "dataModel.h"

@implementation dataModel
+(instancetype)modelWithDict:(NSDictionary *)dict{
    dataModel *mod = [dataModel new];
    [mod setValuesForKeysWithDictionary:dict];
    return mod;
}
@end
