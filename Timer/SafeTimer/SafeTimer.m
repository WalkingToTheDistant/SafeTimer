//
//  SafeTimer.m
//  Timer
//
//

#import "SafeTimer.h"
#import <UIKit/UIKit.h>

// =======================================================================
#pragma mark - SafeObj

@interface SafeObj : NSObject

@property(nonatomic, weak) NSTimer *safeTimer;

@property(nonatomic, weak) id target;

@property(nonatomic) SEL selector;

@property(nonatomic, retain) NSInvocation *invocation;

@property(nonatomic, assign) IMP impOfSelector;

- (NSInvocation*) replaceSafeInvocation:(NSInvocation *)invocation;

- (SEL) replaceSafeTarget:(id)aTarget withSelector:(SEL)aSelector;

- (void) handleTimer:(NSTimer*)timer;

- (void) handleTimerInvocation;

@end

@implementation SafeObj

- (NSInvocation*) replaceSafeInvocation:(NSInvocation *)invocation
{
    _target = invocation.target;
    invocation.target = nil;
    _invocation = invocation;
    
    SEL sel = @selector(handleTimerInvocation);
    NSMethodSignature *method = [self methodSignatureForSelector:sel];
    NSInvocation *result = [NSInvocation invocationWithMethodSignature:method];
    result.target = self;
    result.selector = sel;
    
    return result;
}
- (SEL) replaceSafeTarget:(id)aTarget withSelector:(SEL)aSelector
{
    _target = aTarget;
    _selector = aSelector;
    if(_target != nil
       && _selector != nil){ // 加快调用函数的速度
        _impOfSelector = [_target methodForSelector:_selector];
    } else {
        _impOfSelector = nil;
    }
    
    return @selector(handleTimer:);
}
- (void) handleTimer:(NSTimer*)timer
{
    if(_target != nil
       && _selector != nil
       && [_target respondsToSelector:_selector] == YES){

        if(_impOfSelector != nil){
            ((void(*)(id, SEL, id))_impOfSelector)(_target, _selector, timer);
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_target performSelector:_selector withObject:timer];
#pragma clang diagnostic pop
        }
        
    } else {
        if(_safeTimer != nil){
            [_safeTimer invalidate];
        }
        _safeTimer = nil;
        _invocation = nil;
        _impOfSelector = nil;
    }
}
- (void) handleTimerInvocation
{
    if(_target != nil
       && _invocation != nil){
        [_invocation invokeWithTarget:_target];
        _invocation.target = nil;
    } else {
        if(_safeTimer != nil){
            [_safeTimer invalidate];
        }
        _safeTimer = nil;
        _invocation = nil;
        _impOfSelector = nil;
    }
}

@end

// =======================================================================
#pragma mark - SafeTimer
@implementation SafeTimer

+ (NSTimer*)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo
{
    SafeObj *obj = [SafeObj new];
    NSInvocation *newInvocation = [obj replaceSafeInvocation:invocation];
    
    NSTimer *timer = nil;
    if([[self class] isUseBlock] == YES){
        timer = [NSTimer timerWithTimeInterval:ti repeats:yesOrNo block:^(NSTimer * _Nonnull timer) {
            if(obj != nil){
                [obj handleTimerInvocation];
            }
        }];
    } else {
        timer = [NSTimer timerWithTimeInterval:ti invocation:newInvocation repeats:yesOrNo];
    }
    
    obj.safeTimer = timer;
    return timer;
}
+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo
{
    SafeObj *obj = [SafeObj new];
    NSInvocation *newInvocation = [obj replaceSafeInvocation:invocation];
    
    NSTimer *timer = nil;
    if([[self class] isUseBlock] == YES){
        timer = [NSTimer scheduledTimerWithTimeInterval:ti repeats:yesOrNo block:^(NSTimer * _Nonnull timer) {
            if(obj != nil) {
                [obj handleTimerInvocation];
            }
        }];
    } else {
        timer = [NSTimer scheduledTimerWithTimeInterval:ti invocation:newInvocation repeats:yesOrNo];
    }
    obj.safeTimer = timer;
    
    return timer;
}

+ (NSTimer*)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
    SafeObj *obj = [SafeObj new];
    SEL newSel = [obj replaceSafeTarget:aTarget withSelector:aSelector];
    
    NSTimer *timer = nil;
    if([[self class] isUseBlock] == YES){
        timer = [NSTimer timerWithTimeInterval:ti repeats:yesOrNo block:^(NSTimer * _Nonnull timer) {
            if(obj != nil) {
                [obj handleTimer:timer];
            }
        }];
    } else {
        timer = [NSTimer timerWithTimeInterval:ti target:obj selector:newSel userInfo:userInfo repeats:yesOrNo];;
    }
    obj.safeTimer = timer;
    
    return timer;
}
+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
    SafeObj *obj = [SafeObj new];
    SEL newSel = [obj replaceSafeTarget:aTarget withSelector:aSelector];
    
    NSTimer *timer = nil;
    if([[self class] isUseBlock] == YES){
        timer = [NSTimer scheduledTimerWithTimeInterval:ti repeats:yesOrNo block:^(NSTimer * _Nonnull timer) {
            
            if(obj != nil) {
                [obj handleTimer:timer];
            }
        }];
    } else {
        timer = [NSTimer scheduledTimerWithTimeInterval:ti target:obj selector:newSel userInfo:userInfo repeats:yesOrNo];
    }
    obj.safeTimer = timer;
    
    return timer;
}
+ (BOOL) isUseBlock{ // 在iOS10之后，NSTimer增加了block方法，就是为了避免循环引用而造成的内存泄露问题
    
    return [[UIDevice currentDevice].systemVersion floatValue] >= 10.0;
}

@end
