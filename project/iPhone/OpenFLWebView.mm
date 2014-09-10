#include <vector>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// used from external interface

@interface OpenFLWebView : UIWebView

@property (assign) int mId;

- (id) initWithUrlAndFrame: (NSString*)url width: (int)width height: (int)height;
- (int)getId;

@end

@implementation OpenFLWebView

@synthesize mId;

static int mLastId = 0;

- (id)initWithUrlAndFrame:(NSString *)url width:(int)width height:(int)height{
    mId = mLastId;
    ++mLastId;
    NSURL* _url = [[NSURL alloc] initWithString: url];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:_url];
    self = [self initWithFrame: CGRectMake(0,0,width,height)];
    self.scrollView.bounces = NO;
    [self loadRequest:req];
    return self;
}

- (int)getId {
    return mId;
}

@end

namespace openflwebview {
    
    static std::vector<OpenFLWebView*> webViews;
    
    /**
     * Create a WebView
     * @param url default url to load
     * @param width webview width
     * @param height webview height
     */
    int create(const char* url, int width, int height){
        NSString* defaultUrl = [[NSString alloc] initWithUTF8String:url];
        OpenFLWebView* webView = [[OpenFLWebView alloc] initWithUrlAndFrame:defaultUrl width:width height:height];
        webViews.push_back(webView);
        return [webView getId];
    }
    
    /**
     * get the webView with corresponding id
     * @param id
     **/
    OpenFLWebView* getWebView(int id){
        std::vector<OpenFLWebView*>::iterator iter = webViews.begin();

        while(iter != webViews.end()){
            OpenFLWebView* current = *iter;
            if([current getId] == id)
                return current;
            iter++;
        }

        return NULL;
    }
    
    void onAdded(int id){
        UIWindow* win = [[UIApplication sharedApplication] keyWindow ];
        UIViewController* parentController = [win rootViewController];
        
        int w = win.frame.size.width;
        int h = win.frame.size.height;
        
        NSLog(@"w : %d h : %d", w, h);
        [parentController.view addSubview: getWebView(id)];
    }
    
    void onRemoved(int id){
        OpenFLWebView* webView = getWebView(id);
        [webView removeFromSuperview];
    }
    
    void setPos(int id, int x, int y){
        UIWebView* webView = getWebView(id);
        
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        
        CGRect newFrame = webView.frame;
        newFrame.origin = CGPointMake(x / screenScale,y / screenScale);
        
        [webView setFrame: newFrame];
    }
    
    void setDim(int id, int x, int y){
        UIWebView* webView = getWebView(id);
        
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        
        CGRect newFrame = webView.frame;
        newFrame.size = CGSizeMake(x / screenScale,y / screenScale);
        
        [webView setFrame: newFrame];
    }
    
    void dispose(int id){
        std::vector<OpenFLWebView*>::iterator iter = webViews.begin();

        while(iter != webViews.end()){
            OpenFLWebView* current = *iter;
            if([current getId] == id){
                webViews.erase(iter);
                break;
            }
            iter++;
        }
    }
}