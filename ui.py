from globals import *

def draw_game_ui(game):
    if game.paused:
        display_text_centered("PAUSED", game.menu.title_font, sgd.getWindowHeight() / 2, 0)
    game.menu.draw_title()
    sgd.set2DFont(game.assets.regular_font)
    sgd.set2DTextColor(1, 1, 1, 1)
    sgd.draw2DText("Left Mouse - Swing Paddle", 15, 300)
    sgd.draw2DText("Right Mouse - Release Ball", 15, 320)
    sgd.draw2DText("Escape - Menu", 15, 340)
    sgd.draw2DText("P - Pause", 15, 360)
    sgd.draw2DText("FPS : " + str(round(sgd.getFPS(), 2)), 0, sgd.getWindowHeight() - 40)
    sgd.draw2DText("Paddle Location X : " + str(round(sgd.getEntityX(game.paddle.model), 2)), 0,
                   sgd.getWindowHeight() - 60)
    # HUD
    sgd.set2DFont(game.menu.title_font)
    sgd.set2DTextColor(0.2, 0.2, 0.2, 1)
    sgd.draw2DText("STAGE", 1410, 35)
    sgd.set2DTextColor(1, 0.2, 0.2, 1)
    sgd.draw2DText("STAGE", 1414, 39)
    sgd.set2DTextColor(0.2, 0.2, 1, 1)
    if game.current_stage < 10:
        stage_string = "0" + str(game.current_stage)
    else:
        stage_string = str(game.current_stage)
    sgd.set2DFont(game.menu.subtitle_font)
    sgd.draw2DText(stage_string, 1570, 60)
    # time area
    sgd.set2DFont(game.menu.title_font)
    sgd.set2DTextColor(0.2, 0.2, 0.2, 1)
    sgd.draw2DText("TIME", 1410, 90)
    sgd.set2DTextColor(1, 0.2, 0.2, 1)
    sgd.draw2DText("TIME", 1414, 94)

def draw_editor_ui(game):
    sgd.set2DFont(game.menu.subtitle_font)
    sgd.set2DTextColor(1, 1, 0, 1)
    sgd.draw2DText("STAGE EDITOR", 15, 0)
    sgd.set2DFont(game.assets.regular_font)
    sgd.set2DTextColor(0.8, 0.8, 0.8, 1)
    sgd.draw2DText("G = Toggle Grid", 15, 50)
    sgd.draw2DText("A = Toggle Audio", 15, 70)
    sgd.draw2DText("Left Mouse = Place Block", 15, 90)
    sgd.draw2DText("Right Mouse = Erase Block", 15, 110)
    sgd.draw2DText("Mouse Wheel = Select Block", 15, 130)
    sgd.draw2DText("Numpad 0-9 = Load Stage", 15, 170)
    sgd.draw2DText("Left CTRL + Numpad 0-9 = ", 15, 190)
    sgd.draw2DText("Save Stage", 15, 210)
    sgd.draw2DText("Numpad + = Bank Up", 15, 230)
    sgd.draw2DText("Numpad - = Bank Down", 15, 250)
    sgd.draw2DText("C = Clear Stage", 15, 270)
    sgd.draw2DText("P = Play Stage", 15, 290)

    # draw Bank / Stages Square
    sgd.set2DFillColor(0, 0, 0, 0)
    sgd.set2DOutlineColor(1, 1, 1, 1)
    sgd.set2DOutlineEnabled(True)
    sgd.draw2DRect(15, 800, 220, 900)
    sgd.draw2DText("BANK = " + str(game.bank), 20, 810)
    sgd.draw2DText("STAGES =", 20, 830)
    indent = 5
    for current_number in game.stage_numbers:
        indent += 15
        sgd.draw2DText(str(current_number), indent, 850)

    if not game.audio_on:
        sgd.draw2DText("AUDIO MUTED", 15, 1030)
    sgd.draw2DText("Cursor X,Y : " + str(sgd.getEntityX(game.cursor)) + "," + str(sgd.getEntityY(game.cursor)), 15,
                   1060)
class UI:
    def __init__(self):
        pass
