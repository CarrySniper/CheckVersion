# CheckVersion
版本检查更新


###百度经验

http://jingyan.baidu.com/article/335530da8b1e0419cb41c305.html

###比较版本方法
```
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
        return YES;
    }else{
        NSLog(@"没有新版本");
        return NO;
    }
}
```

###获取AppStore应用版本号等信息
```
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
        NSString *trackCensoredName = resultsDic[@"trackName"];
        
        // 下载地址
        NSString *trackViewUrl = resultsDic[@"trackViewUrl"];
        
        // FIXME: 比较版本号
        return [self compareVersion:version];
    }else{
        // 返回错误，则相当于无更新吧，看你怎么想咯
        return NO;
    }
}
```
