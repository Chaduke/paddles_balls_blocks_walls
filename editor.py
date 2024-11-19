from globals import *
import os
import json
from paddle import resize_paddle
from block import *
from ui import draw_editor_ui

# noinspection PyTypeChecker
def save_stage(game,stage):
    stage_path = "stages/system/stage" + str(stage) + ".json"
    with open(stage_path, 'w') as f:
        json.dump([block.to_dict() for block in game.blocks], f, ensure_ascii=False,indent=4)
    if game.audio_on: sgd.playSound(game.assets.block2_sound)
    update_stage_numbers(game)
def clear_stage(game):
    clear_blocks(game)
    clear_balls(game)
    clear_items(game)
    game.current_ball_size = 1
    if not game.editor: resize_paddle(game,0)
def clear_blocks(game):
    to_remove = []  # Temporary list to collect blocks to be removed
    for block in game.blocks:
        sgd.destroyEntity(block.model)
        to_remove.append(block)  # Collect the blocks to be removed
    for block in to_remove:
        game.blocks.remove(block)  # Remove the collected blocks
    game.blocks.clear()
def clear_balls(game):
    to_remove = []  # Temporary list to collect balls to be removed
    for ball in game.balls:
        sgd.destroyEntity(ball.model)
        to_remove.append(ball) # Collect the balls to be removed
    for ball in to_remove:
        game.balls.remove(ball) # Remove the collected balls
    game.balls.clear()
def clear_items(game):
    to_remove = []  # Temporary list to collect items to be removed
    for item in game.items:
        sgd.destroyEntity(item.model)
        to_remove.append(item) # Collect the items to be removed
    for item in to_remove:
        game.items.remove(item) # Remove the collected blocks
    game.items.clear()
def load_stage(game,stage):
    clear_stage(game)
    stage_path = "stages/system/stage" + str(stage) + ".json"
    if os.path.exists(stage_path) and os.path.isfile(stage_path):
        with open(stage_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            game.blocks = [Block(game.assets.block_meshes[item["block_type"]],item["x"], item["y"], item["block_type"]) for item in data]
        if game.audio_on : sgd.playSound(game.assets.title_sound)
        game.current_stage = stage
def position_cursor(game):
    sgd.cameraUnproject(game.camera, sgd.getMouseX(), sgd.getMouseY(), 37)
    x = sgd.getUnprojectedX()
    y = sgd.getUnprojectedY()
    z = sgd.getUnprojectedZ()
    x = int(x) - 0.5
    if x < -17.5: x = -17.5
    if x > 10.5: x = 10.5
    y = int(y) + 0.5
    if y > 28.5: y = 28.5
    if y < 0.5: y = 0.5
    sgd.setEntityPosition(game.cursor, x, y, z)
def get_new_xy(game):
    new_x = int(sgd.getEntityX(game.cursor))
    new_y = int(sgd.getEntityY(game.cursor))
    if new_x < 0:
        new_x -= 0.5
    else:
        new_x += 0.5
    new_y += 0.5
    return new_x,new_y
def remove_block(game):
    new_xy = get_new_xy(game)
    for block in game.blocks:
        if sgd.getEntityX(block.model) == new_xy[0]:
            if sgd.getEntityY(block.model) == new_xy[1]:
                sgd.destroyEntity(block.model)
                game.blocks.remove(block)
                if game.audio_on: sgd.playSound(game.assets.close_sound)
def add_block(game,block_type):
    # make sure one doesn't already exist there
    remove_block(game)
    new_xy = get_new_xy(game)
    game.blocks.append(Block(game.assets.block_meshes[block_type], new_xy[0], new_xy[1],block_type))
    if game.audio_on: sgd.playSound(game.assets.block_sound)
def pre_edit_stage(game):
    # upon edit stage we need to make sure everything is set up properly
    game.editor = True
    sgd.setEntityVisible(game.paddle.model, False)
    sgd.setEntityVisible(game.grid, True)
    sgd.setEntityVisible(game.cursor, True)
    clear_stage(game)
    if game.background_music is not None: sgd.stopAudio(game.background_music)
def edit_stage(game):
    pre_edit_stage(game)
    current_block_index = 0
    edit_loop = True
    while edit_loop:
        e = sgd.pollEvents()
        if e == sgd.EVENT_MASK_CLOSE_CLICKED: edit_loop = False
        if sgd.isKeyHit(sgd.KEY_ESCAPE): edit_loop = False
        # toggle grid
        if sgd.isKeyHit(sgd.KEY_G):
            if sgd.isEntityVisible(game.grid):
                sgd.setEntityVisible(game.grid,False)
            else:
                sgd.setEntityVisible(game.grid,True)
        # toggle audio
        if sgd.isKeyHit(sgd.KEY_A):
            if game.audio_on:
                game.audio_on = False
            else: game.audio_on = True
        # numpad saves / load
        for k in range(10):
            if sgd.isKeyHit(320+k):
                if sgd.isKeyDown(sgd.KEY_LEFT_CONTROL):
                    save_stage(game,k)
                else:
                    load_stage(game,k)
        # bank select
        if sgd.isKeyHit(sgd.KEY_KP_ADD):
            game.bank+=1
            update_stage_numbers(game)
        if sgd.isKeyHit(sgd.KEY_KP_SUBTRACT):
            game.bank-=1
            if game.bank < 0: game.bank=0
            update_stage_numbers(game)
        # clear stage
        if sgd.isKeyHit(sgd.KEY_C):
            clear_stage(game)
        # play stage
        if sgd.isKeyHit(sgd.KEY_P):
            # when we play from the editor
            # everything is stage 0
            save_stage(game,0)
            game.current_stage=0
            game.run_stage()
            pre_edit_stage(game)
            load_stage(game,0)
        # add a block
        if sgd.isMouseButtonHit(0):
            add_block(game,current_block_index)
        # delete a block
        if sgd.isMouseButtonHit(1):
            remove_block(game)
        # select block
        mz = abs(int(sgd.getMouseZ()))
        if mz != current_block_index:
            current_block_index = mz
            if current_block_index > 6: current_block_index = 0
            sgd.destroyEntity(game.cursor)
            game.cursor = sgd.createModel(game.assets.block_meshes[current_block_index])

        position_cursor(game)
        sgd.renderScene()
        sgd.clear2D()
        draw_editor_ui(game)
        sgd.present()

def update_stage_numbers(game):
    game.stage_numbers.clear()
    for stage_number in range(10):
        # find out is file exists
        current_number = game.bank * 10 + stage_number
        file_path = "stages/system/stage" + str(current_number) + ".json"
        if os.path.exists(file_path) and os.path.isfile(file_path):
            game.stage_numbers.append(stage_number)

class Editor:
    def __init__(self):
        pass