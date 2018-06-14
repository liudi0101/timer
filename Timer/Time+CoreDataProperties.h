//
//  Time+CoreDataProperties.h
//  Timer
//
//  Created by 刘帝 on 2018/5/18.
//  Copyright © 2018年 LD. All rights reserved.
//
//

#import "Time+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Time (CoreDataProperties)

+ (NSFetchRequest<Time *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSObject *time;
@property (nullable, nonatomic, retain) NSObject *date;

@end

NS_ASSUME_NONNULL_END
