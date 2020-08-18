//
//  AppDelegate.m
//  PBAPortal
//
//  Created by DaMaiIOS on 17/9/15.
//  Copyright © 2017年 DaMaiIOS. All rights reserved.
//

/**
                   ---------------------
                  |     PBNavigator     |
                  |    [alone build]    |
                   ---------------------
                            |
                       [dependency]
                            |
                            V
                   ---------------------
                  |       PBOther       |
                  |    [alone build]    |
                   ---------------------
                            |
                          [link]
                            |
                            V
                   ---------------------                    ---------------------
                  |      PBAPortal      |  <————[link]———— |     PBNavigator     |
                  |      [execute]      |                  |    [alone build]    |
                   ---------------------                    ---------------------
                  ^                      ^
                 /                        \
             [link]                     [link]
               /                           \
   ---------------------            ---------------------
  |        PBHome       |          |       PBMine        |
  |    [alone build]    |          |    [alone build]    |
   ---------------------            ---------------------
             ^                                ^
             |                                |
        [dependency]                     [dependency]
             |                                |
   ---------------------            ---------------------
  |     PBNavigator     |          |     PBNavigator     |
  |    [alone build]    |          |    [alone build]    |
   ---------------------            ---------------------
 
 1.PBHome、PBMine、PBOther、PBNavigator等bundle单独编译生成framework
 2.PBAPortal主工程(壳工程)链接所有的framework生成可执行文件
 3.PBHome、PBMine、PBOther等业务bundle互不依赖,PBHome、PBMine、PBOther均会依赖PBNavigator等底层bundle
 4.PBHome依赖PBNavigator,且PBNavigator修改了暴露的头文件,则联编时需要先编译PBNavigator,在编译PBHome,最后多次编译PBAPortal
 */

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Controller
    Class vc1Class = NSClassFromString(@"PBHomeController");
    UIViewController *vc1 = [[vc1Class alloc]init];
    vc1.view.backgroundColor = [UIColor whiteColor];
    vc1.title = @"首页";
    
    Class vc2Class = NSClassFromString(@"PBMineController");
    UIViewController *vc2 = [[vc2Class alloc]init];
    vc2.view.backgroundColor = [UIColor whiteColor];
    vc2.title = @"我的";
    
    // tab
    UITabBarController *tab = [[UITabBarController alloc]init];
    tab.viewControllers = @[vc1, vc2];
    
    // nav
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tab];
    
    // window.rootViewController
    self.window.rootViewController = nav;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
