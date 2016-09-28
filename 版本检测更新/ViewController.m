//
//  ViewController.m
//  版本检测更新
//
//  Created by 思久科技 on 2016/9/28.
//  Copyright © 2016年 思久科技. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 这个是哪个app的id，你们会知道的
    static NSString *appId = @"444934666";
    
    // 返回是否有新版本
    BOOL update = [self checkAppStoreVersionWithAppId:appId];
    
    // 添加自己的代码，可以弹出一个框UIAlertController，这里不实现了，不是要点。
    if (update) {
        // 下载地址可以是trackViewUrl，也可以是itms-apps://itunes.apple.com/app/id444934666
        NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
}

/**
 检查版本更新

 @param appId app的id

 @return 返回是否有更新。YES:有; NO:无。
 */
- (BOOL)checkAppStoreVersionWithAppId:(NSString *)appId
{
    // MARK: 拼接链接、转换成URL
    NSString *checkUrlString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", appId];
    NSURL *checkUrl = [NSURL URLWithString:checkUrlString];
    
    // MARK: 获取网络数据AppStore上app的信息
    NSString *appInfoString = [NSString stringWithContentsOfURL:checkUrl encoding:NSUTF8StringEncoding error:nil];
    
    // MARK: 字符串转json转字典
    NSError *error = nil;
    NSData *JSONData = [appInfoString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:&error];
    
    if (!error && appInfo) {
        // 返回没错误，那就开始获取app信息啦，很多内容，要解剖这数据 results->array[0]->version
        // NSLog(@"%@", appInfo);
        NSArray *resultsAry = appInfo[@"results"];
        NSDictionary *resultsDic = resultsAry.firstObject;
        
        // 版本号
        NSString *version = resultsDic[@"version"];
        
        // 应用名称
        NSString *trackCensoredName = resultsDic[@"trackCensoredName"];
        
        // 下载地址
        NSString *trackViewUrl = resultsDic[@"trackViewUrl"];
        
        // FIXME: 比较版本号
        return [self compareVersion:version];;
    }else{
        // 返回错误，则相当于无更新吧，看你怎么想咯
        return NO;
    }
}

/**
 比较版本大小

 @param serverVersion 服务器版本

 @return 返回是否有更新。YES:有; NO:无。
 */
- (BOOL)compareVersion:(NSString *)serverVersion
{
    // 获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    // MARK: 比较当前版本和新版本号大小
    /*
    typedef enum _NSComparisonResult {
        NSOrderedAscending = -1,    // < 升序
        NSOrderedSame,              // = 等于
        NSOrderedDescending         // > 降序
    } NSComparisonResult;
    */
    
    // MARK: 比较方法
    if ([appVersion compare:serverVersion options:NSNumericSearch] == NSOrderedAscending) {
        NSLog(@"发现新版本 %@", serverVersion);
    }else{
        NSLog(@"没有新版本");
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
