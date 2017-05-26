//
//  LHLockModel.h
//  lockTitleScrollDemo
//
//  Created by 陈良辉 on 2017/5/24.
//  Copyright © 2017年 陈良辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHLockModel : NSObject

@property (nonatomic,assign) BOOL isLock;
@property (nonatomic,copy) NSString *powerNumber;
@property (nonatomic,copy) NSString *WiFiName;

@end
