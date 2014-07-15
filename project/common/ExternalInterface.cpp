#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"


using namespace openflwebview;



static value openflwebview_sample_method (value inputValue) {
	
	int returnValue = SampleMethod(val_int(inputValue));
	return alloc_int(returnValue);
	
}
DEFINE_PRIM (openflwebview_sample_method, 1);



extern "C" void openflwebview_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (openflwebview_main);



extern "C" int openflwebview_register_prims () { return 0; }