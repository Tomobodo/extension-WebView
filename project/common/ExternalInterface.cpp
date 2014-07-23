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

    static void openflwebview_test(){
        test();
    }
    DEFINE_PRIM(openflwebview_test, 0);
    
    static value openflwebview_create(value defaultUrl, value width, value height){
        int rep = create(val_string(defaultUrl), val_int(width), val_int(height));
        return alloc_int(rep);
    }
    DEFINE_PRIM(openflwebview_create, 3);

    int openflwebview_register_prims () { return 0; }
}