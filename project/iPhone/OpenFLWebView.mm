#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (*OnUrlChangingFunctionType)(NSString *);
typedef void (*OnCloseClickedFunctionType)();

@interface OpenFLWebViewDelegate : NSObject <UIWebViewDelegate>
@property (nonatomic) OnUrlChangingFunctionType onUrlChanging;
@property (nonatomic) OnCloseClickedFunctionType onCloseClicked;
@end

@implementation OpenFLWebViewDelegate
@synthesize onUrlChanging;
@synthesize onCloseClicked;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    onUrlChanging([[request URL] absoluteString]);
    return YES;
}
- (void) onCloseButtonClicked:(UIButton *)closeButton {
    onCloseClicked();
}
@end

namespace openflwebview {
    
    void test(){
        NSLog(@"Hello world!");
        
        OpenFLWebViewDelegate* webView = [[OpenFLWebViewDelegate alloc] init];
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        
        UIWebView* instance = [[UIWebView alloc] initWithFrame:screen];
        instance.opaque = NO;
        instance.backgroundColor = [UIColor clearColor];
        [[[UIApplication sharedApplication] keyWindow] addSubview:instance];
        
        NSURL *_url = [[NSURL alloc] initWithString:@"http://www.baudon.me"];
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:_url];
        [instance loadRequest:req];
        
    }
    
}