from libsgd import sgd

def display_text_centered(text,font,yoffset=0,xoffset=0):
    sgd.set2DFont(font)
    center = sgd.getWindowWidth()/2
    tw = sgd.getTextWidth(font,text)/2
    sgd.draw2DText(text,center - tw + xoffset,yoffset)

def display_text_right(text,font,yoffset=0,xoffset=0):
    sgd.set2DFont(font)
    tw = sgd.getTextWidth(font,text) + 10
    right = sgd.getWindowWidth() - tw
    sgd.draw2DText(text,right+xoffset,yoffset)

def mouse_in_rect(x1,y1,x2,y2):
    mx = sgd.getMouseX()
    my = sgd.getMouseY()
    return x1 < mx < x2 and y1 < my < y2