//
//  NSObject+DeepCopy.m
//  DrawingBoard
//
//  Created by runs on 2017/9/25.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "NSObject+DeepCopy.h"

@implementation NSObject (DeepCopy)

- (instancetype)rs_deepCopy {
    NSData *archiveForCopy = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSObject *deepCoy = [NSKeyedUnarchiver unarchiveObjectWithData:archiveForCopy];
    return deepCoy;
}

@end
