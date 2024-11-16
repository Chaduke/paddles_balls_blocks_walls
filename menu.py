from globals import *

class Menu:
    def __init__(self):
        self.title_font = sgd.loadFont("assets/bb.ttf",160)
        self.subtitle_font = sgd.loadFont("assets/bb.ttf",40)
        self.menu_sound = sgd.loadSound("assets/wave/close.wav")
        self.last_hover = 0
        self.title = "Paddles, Balls, Blocks and Walls"
        self.subtitle = "Chaduke's"
    def hover(self,num):
        if self.last_hover != num:
            sgd.playSound(self.menu_sound)
            self.last_hover = num
    def display(self):
        # draw the title
        w = sgd.getWindowWidth() / 2
        h = sgd.getWindowHeight() / 2
        # draw the subtitle shadow first
        sgd.set2DTextColor(0.15, 0.19, 0.26, 1)
        display_text_centered(self.subtitle, self.subtitle_font, 0, 0)
        display_text_centered(self.title, self.title_font, 0, 0)
        sgd.set2DTextColor(.90, .85, .19, 1)
        display_text_centered(self.subtitle, self.subtitle_font, 0, 0)
        display_text_centered(self.title,self.title_font, 0, 0)

        if mouse_in_rect(400, h - 60, w - 400, h - 30):
            self.hover(1)
            if sgd.isMouseButtonHit(0):
                # game_state is regular mode
                sgd.set2DTextColor(1, 1, 0, 1)
            else:
                sgd.set2DTextColor(1, 1, 1, 1)
        display_text_centered("Play", self.subtitle_font, -60)

