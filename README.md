# SafeTimer
避免定时器因为没有执行停止函数，而导致的内存泄露问题

使用示例：

#import "SafeTimer.h"

[SafeTimer scheduledTimerWithTimeInterval:5 invocation:invocation repeats:YES];

[SafeTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(handleTimer:) userInfo:[NSObject new] repeats:YES];
