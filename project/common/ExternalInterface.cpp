#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include "Utils.h"

using namespace openflwebview;

extern "C" {
    
    static value openflwebview_create(value defaultUrl, value width, value height){
        int rep = create(val_string(defaultUrl), val_int(width), val_int(height));
        return alloc_int(rep);
    }
    DEFINE_PRIM(openflwebview_create, 3);
    
    static void openflwebview_onAdded(value webviewId){
        int id = val_int(webviewId);
        onAdded(id);
    }
    DEFINE_PRIM(openflwebview_onAdded, 1);
    
    static void openflwebview_onRemoved(value webviewId){
        int id = val_int(webviewId);
        onRemoved(id);
    }
    DEFINE_PRIM(openflwebview_onRemoved, 1);
    
    static void openflwebview_setPos(value webviewId, value x, value y){
        int id = val_int(webviewId);
        int valX = val_int(x);
        int valY = val_int(y);
        
        setPos(id,valX,valY);
    }
    DEFINE_PRIM(openflwebview_setPos, 3);
    
    static void openflwebview_setDim(value webviewId, value x, value y){
        int id = val_int(webviewId);
        int valX = val_int(x);
        int valY = val_int(y);
        
        setDim(id,valX,valY);
    }
    DEFINE_PRIM(openflwebview_setDim, 3);
    
    static void openflwebview_dispose(value webviewId){
        int id = val_int(webviewId);
        dispose(id);
    }
    DEFINE_PRIM(openflwebview_dispose, 1);
    
    static void openflwebview_loadUrl(value webviewId, value url){
        const char* urlval = val_string(url);
        int id = val_int(webviewId);
        loadUrl(id, urlval);
    }

    int openflwebview_register_prims () { return 0; }
}