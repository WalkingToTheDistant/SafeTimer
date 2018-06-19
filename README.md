# SafeTimer
避免定时器因为没有执行停止函数，而导致的内存泄露问题

使用方法和定时器是一样的
使用示例：

#import "SafeTimer.h"

NSTimer *timer1 = [SafeTimer scheduledTimerWithTimeInterval:5 invocation:invocation repeats:YES];

NSTimer *timer2 = [SafeTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(handleTimer:) userInfo:[NSObject new] repeats:YES];


-(void) handleInvocation:(id)obj withObj2:(id)obj2
{
    //处理定时器事情
}

-(BOOL) handleTimer:(NSTimer*)timer
{ 
    // 处理定时器事情
    NSLog(@"%p", [timer userInfo]);
    return YES;
}
