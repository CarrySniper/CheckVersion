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
