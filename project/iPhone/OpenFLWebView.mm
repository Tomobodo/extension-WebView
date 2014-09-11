#include <vector>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// used from external interface

@interface OpenFLWebView : UIWebView

@property (assign) int mId;
@property (assign) UIButton* mCloseBtn;

- (id) initWithUrlAndFrame: (NSString*)url width: (int)width height: (int)height;
- (int) getId;
- (void) addCloseBtn;
- (void) updateCloseFrame;

@end

@implementation OpenFLWebView

@synthesize mId;
@synthesize mCloseBtn;

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

- (void) addCloseBtn {
    NSString *dpi = @"mdpi";
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    if(scale > 1)
        dpi = @"xhdpi";
    UIImage* closeImage = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat:@"assets/webviewui/close_%@.png", dpi] ofType: nil]];
    
    if(closeImage == NULL) NSLog(@"NULL");
    
    mCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mCloseBtn setImage:closeImage forState:UIControlStateNormal];
    mCloseBtn.adjustsImageWhenHighlighted = NO;
    
    [self updateCloseFrame];
    
    [self addSubview:mCloseBtn];
}

- (void) updateCloseFrame {
    if(mCloseBtn != NULL){
        CGFloat scale = [[UIScreen mainScreen] scale];
    
        UIImage *closeImage = [mCloseBtn imageForState:UIControlStateNormal];
    
        CGFloat offsetX = closeImage.size.width / 1.5;
        CGFloat offsetY = closeImage.size.height / 3;
    
        int x = self.frame.size.width - offsetX/scale;
        int y = 0 - offsetY/scale;
    
        mCloseBtn.frame = CGRectMake(x,y,closeImage.size.width/scale, closeImage.size.height/scale);
    }
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
        OpenFLWebView* webView = getWebView(id);
        
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        
        CGRect newFrame = webView.frame;
        newFrame.size = CGSizeMake(x / screenScale,y / screenScale);
        
        [webView setFrame: newFrame];
        [webView updateCloseFrame];
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
    
    void loadUrl(int id, const char* url){
        OpenFLWebView* webView = getWebView(id);
        NSString* urlStr = [[NSString alloc] initWithUTF8String: url];
        NSURL* _url = [[NSURL alloc] initWithString:urlStr ];
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL: _url];
        [webView loadRequest: req];
    }
    
    void addCloseBtn(int id){
        OpenFLWebView* webview = getWebView(id);
        [webview addCloseBtn];
    }
    
}