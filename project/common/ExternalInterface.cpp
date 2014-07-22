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

    static value openflwebview_sample_method (value inputValue) {
	
        int returnValue = SampleMethod(val_int(inputValue));
        return alloc_int(returnValue);
	
    }
    DEFINE_PRIM (openflwebview_sample_method, 1);
    
    static void openflwebview_test(){
        test();
    }
    DEFINE_PRIM(openflwebview_test, 0);

    int openflwebview_register_prims () { return 0; }
}