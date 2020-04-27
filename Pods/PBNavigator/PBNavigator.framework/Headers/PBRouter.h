//
//  PBRouter.h
//  PBMine
//
//  Created by DaMaiIOS on 2017/11/30.
//  Copyright © 2017年 DaMaiIOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+PBRouter.h"

@interface PBRouter : NSObject

+(void)routerWithGoPageName:(NSString *)pageName andParas:(NSDictionary *)paras;
+(void)routerWithBackPageName:(NSString *)pageName andParas:(NSDictionary *)paras;

@end
