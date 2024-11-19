from globals import *
from editor import load_stage,edit_stage

def show_menu(game):
    menu_loop = True
    while menu_loop:
        e = sgd.pollEvents()
        if e == sgd.EVENT_MASK_CLOSE_CLICKED: menu_loop = False
        if sgd.isKeyHit(sgd.KEY_ESCAPE): menu_loop = False
        if sgd.isKeyHit(sgd.KEY_P):
            sgd.setEntityVisible(game.paddle.model, True)
            load_stage(game,1)
            game.run_stage()
        if sgd.isKeyHit(sgd.KEY_E):
            edit_stage(game)
        sgd.clear2D()
        game.menu.display()
        sgd.renderScene()
        sgd.present()

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
        self.left_margin = 20
    def draw_title(self):
        # draw the title
        w = sgd.getWindowWidth() / 2
        h = sgd.getWindowHeight() / 2
        # draw the subtitle shadow first
        sgd.set2DTextColor(0.80, 0.19, 0.26, 1)
        sgd.set2DFont(self.subtitle_font)
        sgd.draw2DText(self.subtitle, self.left_margin, 15)
        sgd.set2DFont(self.title_font)
        sgd.draw2DText(self.title1, self.left_margin, 50)
        sgd.draw2DText(self.title2, self.left_margin, 100)
        sgd.draw2DText(self.title3, self.left_margin, 150)
        sgd.draw2DText(self.title4, self.left_margin, 200)
        sgd.set2DTextColor(.4, .85, .19, 1)
        sgd.set2DFont(self.subtitle_font)
        sgd.draw2DText(self.subtitle, self.left_margin+2, 17)
        sgd.set2DFont(self.title_font)
        sgd.set2DTextColor(.90, .85, .19, 1)
        sgd.draw2DText(self.title1, self.left_margin+4, 54)
        sgd.draw2DText(self.title2, self.left_margin+4, 104)
        sgd.draw2DText(self.title3, self.left_margin+4, 154)
        sgd.draw2DText(self.title4, self.left_margin+4, 204)
    def display(self):
        self.draw_title()
        sgd.set2DTextColor(1, 1, 1, 1)
        sgd.set2DFont(self.subtitle_font)
        sgd.draw2DText("P - Play", self.left_margin,300)
        sgd.draw2DText("E - Editor", self.left_margin,340)
        sgd.draw2DText("ESC - Quit", self.left_margin,380)

