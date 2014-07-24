#ifndef OPENFLWEBVIEW_H
#define OPENFLWEBVIEW_H


namespace openflwebview {
	
	void test();
	int create(const char* url, int width, int hright);
    void onAdded(int id);
    void onRemoved(int id);
}


#endif