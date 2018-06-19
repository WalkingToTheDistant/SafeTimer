//
//  NewViewController.m
//  Timer
//
//

#import "NewViewController.h"
#import "SafeTimer.h"

@interface NewViewController ()

@property(nonatomic, retain) SafeTimer *safeTimer;

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SEL sel = @selector(handleInvocation: withObj2:);
    NSMethodSignature *method = [self methodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:method];
    invocation.target = self;
    invocation.selector = sel;
//    _safeTimer = [SafeTimer scheduledTimerWithTimeInterval:5 invocation:invocation repeats:YES];
    [SafeTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(handleTimer:) userInfo:[NSObject new] repeats:YES];
}

- (void) viewDidAppear:(BOOL)animated{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) handleInvocation:(id)obj withObj2:(id)obj2
{
    
}

-(BOOL) handleTimer:(NSTimer*)timer
{
    NSLog(@"%p", [timer userInfo]);
    return YES;
}


@end
