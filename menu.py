from globals import *

class Menu:
    def __init__(self):
        self.title_font = sgd.loadFont("assets/bb.ttf",65)
        self.subtitle_font = sgd.loadFont("assets/bb.ttf",40)
        self.menu_sound = sgd.loadSound("assets/wave/close.wav")
        self.title1 = "Paddles"
        self.title2 = "Balls"
        self.title3 = "Blocks"
        self.title4 = "and Walls!"
        self.subtitle = "Chaduke's"
    def draw_title(self):
        # draw the title
        w = sgd.getWindowWidth() / 2
        h = sgd.getWindowHeight() / 2
        # draw the subtitle shadow first
        sgd.set2DTextColor(0.80, 0.19, 0.26, 1)
        sgd.set2DFont(self.subtitle_font)
        sgd.draw2DText(self.subtitle, 15, 15)
        sgd.set2DFont(self.title_font)
        sgd.draw2DText(self.title1, 15, 50)
        sgd.draw2DText(self.title2, 15, 100)
        sgd.draw2DText(self.title3, 15, 150)
        sgd.draw2DText(self.title4, 15, 200)
        sgd.set2DTextColor(.4, .85, .19, 1)
        sgd.set2DFont(self.subtitle_font)
        sgd.draw2DText(self.subtitle, 17, 17)
        sgd.set2DFont(self.title_font)
        sgd.set2DTextColor(.90, .85, .19, 1)
        sgd.draw2DText(self.title1, 15, 54)
        sgd.draw2DText(self.title2, 15, 104)
        sgd.draw2DText(self.title3, 15, 154)
        sgd.draw2DText(self.title4, 15, 204)
    def display(self):
        self.draw_title()
        sgd.set2DTextColor(1, 1, 1, 1)
        sgd.set2DFont(self.subtitle_font)
        sgd.draw2DText("P - Play", 15,300)
        sgd.draw2DText("E - Editor", 15,340)
        sgd.draw2DText("ESC - Quit", 15,380)

