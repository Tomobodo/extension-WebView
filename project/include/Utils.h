#ifndef OPENFLWEBVIEW_H
#define OPENFLWEBVIEW_H


namespace openflwebview {
	
	int create(const char* url, int width, int height);
    void onAdded(int id);
    void onRemoved(int id);
    void setPos(int id, int x, int y);
    void setDim(int id, int x, int y);
    
}


#endif