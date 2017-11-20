//
//  ViewController.m
//  JSBridgeTest
//
//  Created by 陆鑫 on 2017/11/18.
//  Copyright © 2017年 陆鑫. All rights reserved.
//

#import "ViewController.h"

#import "WebViewJavascriptBridge.h"

@interface ViewController ()<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = webview;
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL* htmlURL = [NSURL fileURLWithPath:htmlPath];
    [webview loadHTMLString:appHtml baseURL:htmlURL];
    
    UIButton *notifyJSButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [notifyJSButton setFrame:CGRectMake(60, 300, 200, 40)];
    [notifyJSButton setTitle:@"Native To Javascript" forState:UIControlStateNormal];
    [notifyJSButton addTarget:self action:@selector(Edit:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:notifyJSButton];
    
    NSLog(@"app start");

    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webview];
    
    [self.bridge registerHandler:@"JsToNative" handler:^(id data, WVJBResponseCallback responseCallback) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"message from JS" message:data preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"close" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
//
//    [self.bridge callHandler:@"JS Call" data:nil responseCallback:^(id responseData) {
//        NSLog(@"ObjC received response: %@", responseData);
//    }];
    
}

- (IBAction)Edit:(id)sender {
    [self.bridge callHandler:@"NativeToJs" data:@"This is a message from Native to javascript" responseCallback:^(id responseData) {
        NSLog(@"send a message from native to javascript!");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
