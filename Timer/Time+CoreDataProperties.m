//
//  Time+CoreDataProperties.m
//  Timer
//
//  Created by 刘帝 on 2018/5/18.
//  Copyright © 2018年 LD. All rights reserved.
//
//

#import "Time+CoreDataProperties.h"

@implementation Time (CoreDataProperties)

+ (NSFetchRequest<Time *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Time"];
}

@dynamic time;
@dynamic date;

@end
