//
//  PBNavigator.h
//  PBNavigator
//
//  Created by DaMaiIOS on 17/9/16.
//  Copyright © 2017年 DaMaiIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for PBNavigator.
FOUNDATION_EXPORT double PBNavigatorVersionNumber;

//! Project version string for PBNavigator.
FOUNDATION_EXPORT const unsigned char PBNavigatorVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PBNavigator/PublicHeader.h>


// 对外,只能是本工程内自定义的文件对外,不包含将本工程内引用的三方库文件对外的功能
// 控制器不用对外暴露.其他bundle如果要调用本bundle内的控制器,可以将本bundle内的控制器定义为全局变量
#import <PBNavigator/PBRouter.h>
#import <PBNavigator/UIViewController+PBRouter.h>
