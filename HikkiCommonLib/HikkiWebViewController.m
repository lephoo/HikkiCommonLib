//
//  HikkiWebViewController.m
//  HikkiCommonLib
//
//  Created by jiangtao on 2016/10/20.
//  Copyright © 2016年 Hikki. All rights reserved.
//

#import "HikkiWebViewController.h"

@interface HikkiWebViewController ()

@end

@implementation HikkiWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //JS: window.location.href="http://www.google.com";
    //will call this function
    NSString* urlstr = [[request URL]absoluteString];
    NSArray* urlComps = [urlstr componentsSeperatedByString:@":"];
    //window.location.href="obj:doFunc1";
    if([urlComps count] && [[urlComps objectAtIndex:o]isEqualToString:@"objc"]){
        NSString* funcStr = [urlComps objectAtIndex:1];
        if([funcStr isEqualToString:@"doFunc1"]){
            
        }
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //function getString(){return "abc";}
    NSString* str = [self.webview stringByEvaluatingJavaScriptFromString:@"getString();"];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end
