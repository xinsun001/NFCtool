//
//  AppDelegate.m
//  NFC读写工具
//
//  Created by facilityone on 2021/12/31.
//

#import "AppDelegate.h"
#import "NFCRWViewController.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
    self.window.rootViewController=[[UINavigationController alloc]initWithRootViewController:[NFCRWViewController new]];

    [self.window makeKeyAndVisible];

    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"96b49ad918affd5457b9a32810c61a80"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"96b49ad918affd5457b9a32810c61a80"];
    
    return YES;
}


@end
