//
//  RunsControlProtocol.h
//  DrawingBoard
//
//  Created by runs on 2017/8/14.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RunsControlCallback)(NSInteger type, id obj);

@protocol RunsControlProtocol <NSObject>

- (void)setType:(NSInteger)type;
- (void)setCallback:(RunsControlCallback)callback;

- (void)run;
- (void)stop;
@end
