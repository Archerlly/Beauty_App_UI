//
//  dataModel.h
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/11.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataModel : NSObject
@property (nonatomic ,copy) NSString *imgName;
@property (nonatomic ,copy) NSString *intro;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *detailIntro;
@property (nonatomic ,copy) NSString *author;

+(instancetype)modelWithDict:(NSDictionary *)dict;
@end
