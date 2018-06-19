//
//  ViewController.m
//  Timer
//
//

#import "ViewController.h"
#import "NewViewController.h"

@interface ViewController ()

@property(nonatomic, weak) id wwwww;

@property(nonatomic, strong) id sssss;

@property(nonatomic, weak) id viewCon;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMethodSignature *method = [[self class] instanceMethodSignatureForSelector:@selector(handleInvocation:)];
    NSInvocation *invovation = [NSInvocation invocationWithMethodSignature:method];
    invovation.selector = @selector(handleInvocation:);
    invovation.target = self;
    [invovation setArgument:(__bridge void * _Nonnull)([NSObject new]) atIndex:2];
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 invocation:invovation repeats:YES];
//    [timer fire];
    UIButton *btn = [UIButton new];
    [btn setFrame:CGRectMake(10, 10, 100, 100)];
    [btn setTitle:@"店家" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleInvocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NewViewController *ViewController = [NewViewController new];
    self.viewCon = ViewController;
    [self.navigationController pushViewController:ViewController animated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) handleInvocation:(id)obj 
{
    NSLog(@"%p", self.viewCon);
}


@end
