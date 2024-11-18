import os
from paddle import *
from ball import *
from block import *
from menu import *
from item import *
from globals import *
from random import random
import json

class Game:
    def __init__(self):
        sgd.init()
        sgd.createWindow(1920,1080,"Paddles, Balls, Blocks, and Walls",sgd.WINDOW_FLAGS_FULLSCREEN)
        self.env = sgd.loadCubeTexture("assets/night.jpg",sgd.TEXTURE_FORMAT_SRGBA8,sgd.TEXTURE_FLAGS_DEFAULT)
        sgd.setEnvTexture(self.env)
        self.skybox = sgd.createSkybox(self.env)
        self.camera = sgd.createPerspectiveCamera()
        sgd.moveEntity(self.camera,0,15,0)
        self.light = sgd.createDirectionalLight()
        sgd.turnEntity(self.light,-45,-45,0)
        sgd.setLightShadowsEnabled(self.light,True)
        # ground
        #ground_material = sgd.loadPBRMaterial("assets/Gravel041_1K-JPG")
        #ground_mesh = sgd.createBoxMesh(-32,-0.1,-32,32,0,32,ground_material)
        #sgd.transformTexCoords(ground_mesh,16,16,0,0)
        #self.ground = sgd.createModel(ground_mesh)

        # walls
        self.walls = sgd.loadModel("assets/walls.glb")
        sgd.moveEntity(self.walls,-19,0,37)
        self.walls_collider = sgd.createMeshCollider(self.walls,0,sgd.getModelMesh(self.walls))

        # balls
        self.balls=[]
        self.ball_meshes = []
        self.current_ball_size = 1 # regular sized balls
        self.ball_mesh_small = sgd.loadMesh("assets/ball_small.glb")
        sgd.setMeshShadowsEnabled(self.ball_mesh_small,True)
        self.ball_meshes.append(self.ball_mesh_small)
        self.ball_mesh_regular = sgd.loadMesh("assets/ball_regular.glb")
        sgd.setMeshShadowsEnabled(self.ball_mesh_regular, True)
        self.ball_meshes.append(self.ball_mesh_regular)
        self.ball_mesh_large = sgd.loadMesh("assets/ball_large.glb")
        sgd.setMeshShadowsEnabled(self.ball_mesh_large, True)
        self.ball_meshes.append(self.ball_mesh_large)
        self.ball_mesh_xl = sgd.loadMesh("assets/ball_xl.glb")
        sgd.setMeshShadowsEnabled(self.ball_mesh_xl, True)
        self.ball_meshes.append(self.ball_mesh_xl)

        # blocks
        self.block_meshes = []
        self.block_yellow_mesh = sgd.loadMesh("assets/block_yellow.glb")
        sgd.setMeshShadowsEnabled(self.block_yellow_mesh, True)
        self.block_meshes.append( self.block_yellow_mesh)
        self.block_blue_mesh = sgd.loadMesh("assets/block_blue.glb")
        sgd.setMeshShadowsEnabled(self.block_blue_mesh, True)
        self.block_meshes.append(self.block_blue_mesh)
        self.block_blue2_mesh = sgd.loadMesh("assets/block_blue2.glb")
        sgd.setMeshShadowsEnabled(self.block_blue2_mesh, True)
        self.block_meshes.append(self.block_blue2_mesh)
        self.block_pink_mesh = sgd.loadMesh("assets/block_pink.glb")
        sgd.setMeshShadowsEnabled(self.block_pink_mesh, True)
        self.block_meshes.append(self.block_pink_mesh)
        self.block_clear_mesh = sgd.loadMesh("assets/block_clear.glb")
        sgd.setMeshShadowsEnabled(self.block_clear_mesh, True)
        self.block_meshes.append(self.block_clear_mesh)
        self.block_metal_mesh = sgd.loadMesh("assets/block_metal.glb")
        sgd.setMeshShadowsEnabled(self.block_metal_mesh, True)
        self.block_meshes.append(self.block_metal_mesh)
        self.blocks = []

        # paddle
        self.paddle_meshes = []
        self.paddle_small_mesh = sgd.loadMesh("assets/paddle_4m.glb")
        sgd.setMeshShadowsEnabled(self.paddle_small_mesh, True)
        self.paddle_meshes.append(self.paddle_small_mesh)
        self.paddle_medium_mesh = sgd.loadMesh("assets/paddle_8m.glb")
        sgd.setMeshShadowsEnabled(self.paddle_medium_mesh, True)
        self.paddle_meshes.append(self.paddle_medium_mesh)
        self.paddle_large_mesh = sgd.loadMesh("assets/paddle_12m.glb")
        sgd.setMeshShadowsEnabled(self.paddle_large_mesh, True)
        self.paddle_meshes.append(self.paddle_large_mesh)
        self.paddle_xl_mesh = sgd.loadMesh("assets/paddle_16m.glb")
        sgd.setMeshShadowsEnabled(self.paddle_xl_mesh, True)
        self.paddle_meshes.append(self.paddle_xl_mesh)
        self.paddle_xxl_mesh = sgd.loadMesh("assets/paddle_20m.glb")
        sgd.setMeshShadowsEnabled(self.paddle_xxl_mesh, True)
        self.paddle_meshes.append(self.paddle_xxl_mesh)
        self.paddle_xxxl_mesh = sgd.loadMesh("assets/paddle_24m.glb")
        sgd.setMeshShadowsEnabled(self.paddle_xxxl_mesh, True)
        self.paddle_meshes.append(self.paddle_xxxl_mesh)
        self.paddle = Paddle(self.paddle_meshes[0],0)
        sgd.setEntityVisible(self.paddle.model,False)

        # items
        self.item_meshes = []
        self.shrinker_mesh = sgd.loadMesh("assets/shrinker.glb")
        sgd.setMeshShadowsEnabled(self.shrinker_mesh, True)
        self.item_meshes.append(self.shrinker_mesh)
        self.grower_mesh = sgd.loadMesh("assets/grower.glb")
        sgd.setMeshShadowsEnabled(self.grower_mesh, True)
        self.item_meshes.append(self.grower_mesh)
        self.smallballs_mesh = sgd.loadMesh("assets/smallballs.glb")
        sgd.setMeshShadowsEnabled(self.smallballs_mesh, True)
        self.item_meshes.append(self.smallballs_mesh)
        self.largeballs_mesh = sgd.loadMesh("assets/largeballs.glb")
        sgd.setMeshShadowsEnabled(self.largeballs_mesh, True)
        self.item_meshes.append(self.largeballs_mesh)
        self.items = []

        # collisions setup
        # ball with walls, ball = 1, walls = 0
        sgd.enableCollisions(1, 0, sgd.COLLISION_RESPONSE_NONE)
        # ball with paddle, ball = 1, paddle = 2
        sgd.enableCollisions(1, 2 ,sgd.COLLISION_RESPONSE_NONE)
        # ball with blocks, ball = 1, blocks = 3
        sgd.enableCollisions(1, 3, sgd.COLLISION_RESPONSE_NONE)
        self.colliding = False # flag to display collisions for debug purposes
        # items with paddle, items = 4, paddle = 2
        sgd.enableCollisions(4, 2, sgd.COLLISION_RESPONSE_NONE)
        # load audio
        self.title_sound = sgd.loadSound("assets/wave/title.wav")
        self.bgm_sound = sgd.loadSound("assets/wave/bgm.wav")
        self.background_music = None
        self.paddle_sound = sgd.loadSound("assets/wave/pad.wav")
        self.close_sound = sgd.loadSound("assets/wave/close.wav")
        self.block_sound = sgd.loadSound("assets/wave/block.wav")
        self.block2_sound = sgd.loadSound("assets/wave/block2.wav")
        self.reverse_sound = sgd.loadSound("assets/wave/reverse.wav")
        self.audio_on = False
        if self.audio_on:
            sgd.playSound(self.title_sound)
        # menu
        self.menu = Menu()
        self.regular_font = sgd.loadFont("assets/bb.ttf",20)

        # pre-loop stuff
        self.paused = False
        self.editor = False
        sgd.setMouseCursorMode(3)
        self.cursor = sgd.createModel(self.block_meshes[0])
        self.grid = sgd.loadModel("assets/grid.glb")
        sgd.moveEntity(self.grid, -19, 0, 37)
        sgd.setEntityVisible(self.grid,False)
        self.bank = int(0) # for saving levels
        self.stage_numbers = []
        self.update_stage_numbers()
        self.current_stage = 0
    def update_stage_numbers(self):
        self.stage_numbers.clear()
        for stage_number in range(10):
            # find out is file exists
            current_number = self.bank * 10 + stage_number
            file_path = "stages/system/stage" + str(current_number) + ".json"
            if os.path.exists(file_path) and os.path.isfile(file_path):
                self.stage_numbers.append(stage_number)
    def show_menu(self):
        menu_loop = True
        while menu_loop:
            e = sgd.pollEvents()
            if e == sgd.EVENT_MASK_CLOSE_CLICKED: menu_loop = False
            if sgd.isKeyHit(sgd.KEY_ESCAPE): menu_loop = False
            if sgd.isKeyHit(sgd.KEY_P):
                sgd.setEntityVisible(self.paddle.model, True)
                self.load_stage(1)
                self.run_stage()
                sgd.setEntityVisible(self.paddle.model, False)
                self.clear_balls()
                self.clear_stage()
                if self.background_music is not None : sgd.stopAudio(self.background_music)
            if sgd.isKeyHit(sgd.KEY_E):
                self.edit_stage()

            sgd.clear2D()
            self.menu.display()
            sgd.renderScene()
            sgd.present()

    # noinspection PyTypeChecker
    def save_stage(self,stage):
        stage_path = "stages/system/stage" + str(stage) + ".json"
        with open(stage_path, 'w') as f:
            json.dump([block.to_dict() for block in self.blocks], f, ensure_ascii=False,indent=4)
        if self.audio_on: sgd.playSound(self.block2_sound)
        self.update_stage_numbers()
    def clear_stage(self):
        self.clear_blocks()
        self.clear_balls()
        self.clear_items()
        self.current_ball_size = 1
    def clear_blocks(self):
        to_remove = []  # Temporary list to collect blocks to be removed
        for block in self.blocks:
            sgd.destroyEntity(block.model)
            to_remove.append(block)  # Collect the blocks to be removed
        for block in to_remove:
            self.blocks.remove(block)  # Remove the collected blocks
        self.blocks.clear()
    def clear_balls(self):
        to_remove = []  # Temporary list to collect balls to be removed
        for ball in self.balls:
            sgd.destroyEntity(ball.model)
            to_remove.append(ball) # Collect the balls to be removed
        for ball in to_remove:
            self.balls.remove(ball) # Remove the collected balls
        self.balls.clear()
    def clear_items(self):
        to_remove = []  # Temporary list to collect items to be removed
        for item in self.items:
            sgd.destroyEntity(item.model)
            to_remove.append(item) # Collect the items to be removed
        for item in to_remove:
            self.items.remove(item) # Remove the collected blocks
        self.items.clear()
    def load_stage(self,stage):
        self.clear_stage()
        stage_path = "stages/system/stage" + str(stage) + ".json"
        if os.path.exists(stage_path) and os.path.isfile(stage_path):
            with open(stage_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                self.blocks = [Block(self.block_meshes[item["block_type"]],item["x"], item["y"], item["block_type"]) for item in data]
            if self.audio_on : sgd.playSound(self.title_sound)
            self.current_stage = stage
    def position_cursor(self):
        sgd.cameraUnproject(self.camera, sgd.getMouseX(), sgd.getMouseY(), 37)
        x = sgd.getUnprojectedX()
        y = sgd.getUnprojectedY()
        z = sgd.getUnprojectedZ()
        x = int(x) - 0.5
        if x < -17.5: x = -17.5
        if x > 10.5: x = 10.5
        y = int(y) + 0.5
        if y > 28.5: y = 28.5
        if y < 0.5: y = 0.5
        sgd.setEntityPosition(self.cursor, x, y, z)
    def get_new_xy(self):
        new_x = int(sgd.getEntityX(self.cursor))
        new_y = int(sgd.getEntityY(self.cursor))
        if new_x < 0:
            new_x -= 0.5
        else:
            new_x += 0.5
        new_y += 0.5
        return new_x,new_y
    def remove_block(self):
        new_xy = self.get_new_xy()
        for block in self.blocks:
            if sgd.getEntityX(block.model) == new_xy[0]:
                if sgd.getEntityY(block.model) == new_xy[1]:
                    sgd.destroyEntity(block.model)
                    self.blocks.remove(block)
                    if self.audio_on: sgd.playSound(self.close_sound)
    def add_block(self,block_type):
        # make sure one doesn't already exist there
        self.remove_block()
        new_xy = self.get_new_xy()
        self.blocks.append(Block(self.block_meshes[block_type], new_xy[0], new_xy[1],block_type))
        if self.audio_on: sgd.playSound(self.block_sound)
    def pre_edit_stage(self):
        # upon edit stage we need to make sure everything is setup properly
        self.editor = True
        sgd.setEntityVisible(self.paddle.model, False)
        sgd.setEntityVisible(self.grid, True)
        sgd.setEntityVisible(self.cursor, True)
        self.clear_stage()
        if self.background_music is not None: sgd.stopAudio(self.background_music)
    def edit_stage(self):
        self.pre_edit_stage()
        current_block_index = 0
        edit_loop = True
        while edit_loop:
            e = sgd.pollEvents()
            if e == sgd.EVENT_MASK_CLOSE_CLICKED: edit_loop = False
            if sgd.isKeyHit(sgd.KEY_ESCAPE): edit_loop = False
            # toggle grid
            if sgd.isKeyHit(sgd.KEY_G):
                if sgd.isEntityVisible(self.grid):
                    sgd.setEntityVisible(self.grid,False)
                else:
                    sgd.setEntityVisible(self.grid,True)
            # toggle audio
            if sgd.isKeyHit(sgd.KEY_A):
                if self.audio_on:
                    self.audio_on = False
                else: self.audio_on = True
            # numpad saves / load
            for k in range(10):
                if sgd.isKeyHit(320+k):
                    if sgd.isKeyDown(sgd.KEY_LEFT_CONTROL):
                        self.save_stage(k)
                    else:
                        self.load_stage(k)
            # bank select
            if sgd.isKeyHit(sgd.KEY_KP_ADD):
                self.bank+=1
                self.update_stage_numbers()
            if sgd.isKeyHit(sgd.KEY_KP_SUBTRACT):
                self.bank-=1
                if self.bank < 0: self.bank=0
                self.update_stage_numbers()
            # clear stage
            if sgd.isKeyHit(sgd.KEY_C):
                self.clear_stage()
            # play stage
            if sgd.isKeyHit(sgd.KEY_P):
                # when we play from the editor
                # everything is stage 0
                self.save_stage(0)
                self.current_stage=0
                self.run_stage()
                self.pre_edit_stage()
                self.load_stage(0)
            # add a block
            if sgd.isMouseButtonHit(0):
                self.add_block(current_block_index)
            # delete a block
            if sgd.isMouseButtonHit(1):
                self.remove_block()
            # select block
            mz = abs(int(sgd.getMouseZ()))
            if mz != current_block_index:
                current_block_index = mz
                if current_block_index > 5: current_block_index = 0
                sgd.destroyEntity(self.cursor)
                self.cursor = sgd.createModel(self.block_meshes[current_block_index])

            self.position_cursor()
            sgd.renderScene()
            sgd.clear2D()
            sgd.set2DFont(self.menu.subtitle_font)
            sgd.set2DTextColor(1,1,0,1)
            sgd.draw2DText("STAGE EDITOR",15,0)
            sgd.set2DFont(self.regular_font)
            sgd.set2DTextColor(0.8,0.8,0.8,1)
            sgd.draw2DText("G = Toggle Grid",15,50)
            sgd.draw2DText("A = Toggle Audio",15,70)
            sgd.draw2DText("Left Mouse = Place Block",15,90)
            sgd.draw2DText("Right Mouse = Erase Block", 15, 110)
            sgd.draw2DText("Mouse Wheel = Select Block", 15, 130)
            sgd.draw2DText("Numpad 0-9 = Load Stage", 15, 170)
            sgd.draw2DText("Left CTRL + Numpad 0-9 = ", 15, 190)
            sgd.draw2DText("Save Stage", 15, 210)
            sgd.draw2DText("Numpad + = Bank Up", 15, 230)
            sgd.draw2DText("Numpad - = Bank Down", 15, 250)
            sgd.draw2DText("C = Clear Stage", 15, 270)
            sgd.draw2DText("P = Play Stage",15, 290)

            # draw Bank / Stages Square
            sgd.set2DFillColor(0,0,0,0)
            sgd.set2DOutlineColor(1,1,1,1)
            sgd.set2DOutlineEnabled(True)
            sgd.draw2DRect(15,800,220,900)
            sgd.draw2DText("BANK = " + str(self.bank),20,810)
            sgd.draw2DText("STAGES =",20,830)
            indent = 5
            for current_number in self.stage_numbers:
                indent+=15
                sgd.draw2DText(str(current_number),indent,850)

            if not self.audio_on:
                sgd.draw2DText("AUDIO MUTED",15,1030)
            sgd.draw2DText("Cursor X,Y : " + str(sgd.getEntityX(self.cursor)) + "," + str(sgd.getEntityY(self.cursor)),15,1060)

            sgd.present()
    def get_ball_radius(self):
        if self.current_ball_size==0:
            return 0.25
        elif self.current_ball_size==1:
            return 0.5
        elif self.current_ball_size == 2:
            return 1.0
        elif self.current_ball_size == 3:
            return 2
    def run_stage(self):
        self.editor = False
        sgd.setEntityVisible(self.paddle.model, True)
        sgd.setEntityVisible(self.grid, False)
        sgd.setEntityVisible(self.cursor, False)
        if self.audio_on:
            self.background_music = sgd.playSound(self.bgm_sound)
            sgd.setAudioLooping(self.background_music,True)
        game_loop = True
        while game_loop:
            e=sgd.pollEvents()
            if e==sgd.EVENT_MASK_CLOSE_CLICKED: game_loop = False
            if sgd.isKeyHit(sgd.KEY_ESCAPE): game_loop = False
            if sgd.isKeyHit(sgd.KEY_P):
                if self.paused:
                    self.paused = False
                    #sgd.setMouseCursorMode(3)
                else:
                    self.paused = True
                    #sgd.setMouseCursorMode(1)
            if not self.paused:
                # on mouse right click, release a ball (if available)
                if sgd.isMouseButtonHit(1):
                    # set which way the ball goes left or right based on X location of paddle
                    if sgd.getEntityX(self.paddle.model) < -3.9:
                        vx = 0.1 # keeping this with the way the original works for now, always to the right
                    else:
                        vx = 0.1
                    self.balls.append(Ball(self.ball_meshes[self.current_ball_size],self.current_ball_size,sgd.getEntityX(self.paddle.model),sgd.getEntityY(self.paddle.model) + 0.5,vx,1))
                # balls update loop
                for ball in self.balls:
                    ball.update()
                    if sgd.getCollisionCount(ball.collider) > 0:
                        self.colliding = True
                        collided_collider = sgd.getCollisionCollider(ball.collider,0)
                        # wall collisions
                        if sgd.getColliderType(collided_collider) == 0:
                            br = self.get_ball_radius()
                            if sgd.getEntityY(ball.model) > 28:
                                # we're probably at the ceiling
                                ball.velocity[1] = -abs(ball.velocity[1] * 0.8)
                                sgd.setEntityPosition(ball.model,sgd.getEntityX(ball.model),29 - br,37)
                            else:
                                # we're probably hitting the side walls
                                if sgd.getEntityX(ball.model) < -17:
                                    # left wall
                                    ball.velocity[0] = abs(ball.velocity[0] * 0.8)
                                    sgd.setEntityPosition(ball.model,-18.5 + br, sgd.getEntityY(ball.model), 37)
                                else:
                                    # right wall
                                    ball.velocity[0] = -abs(ball.velocity[0] * 0.8)
                                    sgd.setEntityPosition(ball.model, 11.5 - br, sgd.getEntityY(ball.model), 37)
                        elif sgd.getColliderType(collided_collider) == 2:
                            # paddle collisions
                            collided_entity = sgd.getColliderEntity(collided_collider)
                            paddle_height = sgd.getEntityY(collided_entity)
                            # prevent multiple collisions and re-triggering audio
                            br = self.get_ball_radius()
                            sgd.setEntityPosition(ball.model,sgd.getEntityX(ball.model),paddle_height + 0.5 + br,sgd.getEntityZ(ball.model))
                            # paddle collisions should always send the ball upwards
                            ball.velocity[1] = abs(ball.velocity[1])
                            # make a slight x velocity adjustment based on distance from the center of the paddle
                            #distance_from_center = sgd.getEntityX(self.paddle.model) - sgd.getEntityX(ball.model)
                            #ball.velocity[0]-=distance_from_center * 0.05
                            # THIS DOESN'T WORK LIKE THE ORIGINAL GAME SO LEAVE IT OUT
                            # WHEN TRYING TO DUPLICATE THE LEVELS IT BECOMES EVIDENT WHY
                            # IT WAS DONE THE WAY IT WAS

                            # check if the paddle is on the upswing
                            if paddle_height < 2 and not sgd.isMouseButtonDown(0):
                                # add some velocity for ball hit with "swung" paddle
                                ball.velocity[1] += ball.velocity[1] / 3
                            if self.audio_on: sgd.playSound(self.close_sound)
                        elif sgd.getColliderType(collided_collider) == 3:
                            # block collisions
                            block_collision_point = sgd.getColliderEntity(collided_collider)
                            block_model = sgd.getEntityParent(block_collision_point)

                            br = self.get_ball_radius()
                            ball_height = sgd.getEntityY(ball.model)
                            block_height = sgd.getEntityY(block_model)
                            height_difference = block_height-ball_height
                            # we should only have to do this for metal blocks
                            if height_difference > 0:
                                sgd.setEntityPosition(ball.model,
                                                  sgd.getEntityX(ball.model),
                                                  block_height - 0.5 - br,
                                                  sgd.getEntityZ(ball.model))
                            else:
                                sgd.setEntityPosition(ball.model,
                                                      sgd.getEntityX(ball.model),
                                                      block_height + 0.5 + br,
                                                      sgd.getEntityZ(ball.model))
                            to_remove = []
                            for block in self.blocks:
                                if block.model == block_model:
                                    # make the ball bounce unless it's a large ball or the block type is clear
                                    if self.current_ball_size < 2 or block.block_type!=4:
                                        # determine if the ball needs to bounce horizontally
                                        if abs(height_difference) < 0.1:
                                            # horizontal bounce
                                            ball.velocity[0] = - ball.velocity[0]
                                            # find the horizontal distance
                                            h_distance = sgd.getEntityX(block.model) - sgd.getEntityX(ball.model)
                                            if abs(h_distance) > 0.5:
                                                if h_distance > 0:
                                                    # ball is to the left side
                                                    sgd.setEntityPosition(ball.model,
                                                                          sgd.getEntityX(block_collision_point)-1,
                                                                          sgd.getEntityY(ball.model),37)
                                                else:
                                                    # ball is on the right side
                                                    sgd.setEntityPosition(ball.model,
                                                                          sgd.getEntityX(block_collision_point) + 1,
                                                                          sgd.getEntityY(ball.model), 37)
                                        else:
                                            # vertical bounce
                                            ball.velocity[1] = - ball.velocity[1]
                                    if block.block_type == 1:
                                        # blue blocks change to cracked blue
                                        self.blocks.append(Block(self.block_meshes[2],sgd.getEntityX(block.model),sgd.getEntityY(block.model),2))
                                    # pink blocks drop items
                                    if block.block_type==3:
                                        random_item = int(random() * 4)
                                        self.items.append(Item(self.item_meshes[random_item], random_item, sgd.getEntityX(block.model),
                                                               sgd.getEntityY(block.model)))
                                    # clear blocks drop balls
                                    if block.block_type==4:
                                        self.balls.append(Ball(
                                            self.ball_meshes[self.current_ball_size],
                                            self.current_ball_size,
                                            sgd.getEntityX(block.model),
                                            sgd.getEntityY(block.model),0.1,0))
                                    # metal block types stay forever
                                    if block.block_type != 5: to_remove.append(block)
                            # remove blocks that were collided with
                            if len(to_remove) > 0:
                                print("removing " + str(len(to_remove)) + " blocks.")
                                for block in to_remove:
                                    sgd.destroyEntity(block.model)
                                    self.blocks.remove(block)
                            # check if we finished the level
                            if len(self.blocks) == 0:
                                if self.current_stage!=0:
                                    self.current_stage+=1
                                    self.load_stage(self.current_stage)
                                else:
                                    # we are running from the editor
                                    # so return there
                                    return
                            if self.audio_on :
                                if random() > 0.5:
                                    sgd.playSound(self.block_sound)
                                else:
                                    sgd.playSound(self.block2_sound)
                    else:
                        self.colliding = False
                    if not ball.active:
                        sgd.destroyEntity(ball.model)
                        self.balls.remove(ball)
                self.paddle.update()
                # items update
                for item in self.items:
                    item.move()
                    # item collisions
                    cl = sgd.getCollisionCount(item.collider_left)
                    cr = sgd.getCollisionCount(item.collider_right)
                    if cl + cr > 0:
                        # we collided with the paddle
                        if item.item_type == 0:
                            # shrink the paddle
                            if self.paddle.point_count > 4:
                                # create a new paddle and delete the old one
                                new_paddle_size = int((self.paddle.point_count - 4) / 4) - 1
                                old_x = sgd.getEntityX(self.paddle.model)
                                sgd.destroyEntity(self.paddle.model)
                                self.paddle = Paddle(self.paddle_meshes[new_paddle_size],new_paddle_size)
                                sgd.setEntityPosition(self.paddle.model,old_x,sgd.getEntityY(self.paddle.model),sgd.getEntityZ(self.paddle.model))
                        elif item.item_type == 1:
                            # grow the paddle
                            if self.paddle.point_count < 28:
                                # create a new paddle and delete the old one
                                new_paddle_size = int((self.paddle.point_count + 4) / 4) - 1
                                old_x = sgd.getEntityX(self.paddle.model)
                                sgd.destroyEntity(self.paddle.model)
                                self.paddle = Paddle(self.paddle_meshes[new_paddle_size],new_paddle_size)
                                sgd.setEntityPosition(self.paddle.model,old_x,sgd.getEntityY(self.paddle.model),sgd.getEntityZ(self.paddle.model))
                        elif item.item_type == 2:
                            # shrink all balls
                            self.current_ball_size-=1
                            if self.current_ball_size < 0 : self.current_ball_size=0
                            for ball in self.balls:
                                ball.active = False
                        elif item.item_type == 3:
                            # expand all balls
                            self.current_ball_size+=1
                            if self.current_ball_size > 3: self.current_ball_size = 3
                            for ball in self.balls:
                                ball.active = False
                                # self.balls.append(Ball(
                                # self.ball_meshes[self.current_ball_size],
                                # self.current_ball_size,
                                # sgd.getEntityX(ball.model),
                                # sgd.getEntityY(ball.model),ball.velocity[0],
                                # ball.velocity[1]))

                        # regardless of item type we need to delete it
                        item.active = False
                    if not item.active:
                        sgd.destroyEntity(item.model)
                        self.items.remove(item)
                sgd.updateColliders()
            sgd.renderScene()
            sgd.clear2D()
            if self.paused:
                display_text_centered("PAUSED",self.menu.title_font,sgd.getWindowHeight()/2,0)
            #if self.colliding: sgd.draw2DText("Colliding", 0, 0)
            self.menu.draw_title()
            sgd.set2DFont(self.regular_font)
            sgd.set2DTextColor(1,1,1,1)
            sgd.draw2DText("Left Mouse - Swing Paddle",15,300)
            sgd.draw2DText("Right Mouse - Release Ball", 15, 320)
            sgd.draw2DText("Escape - Menu", 15, 340)
            sgd.draw2DText("P - Pause", 15, 360)
            sgd.draw2DText("FPS : " + str(round(sgd.getFPS(),2)), 0, sgd.getWindowHeight() - 40)
            sgd.draw2DText("Paddle Location X : " + str(round(sgd.getEntityX(self.paddle.model),2)), 0, sgd.getWindowHeight() - 60)

            # HUD
            sgd.set2DFont(self.menu.title_font)
            sgd.set2DTextColor(0.2, 0.2, 0.2, 1)
            sgd.draw2DText("STAGE",1410,35)
            sgd.set2DTextColor(1, 0.2, 0.2, 1)
            sgd.draw2DText("STAGE", 1414, 39)
            sgd.set2DTextColor(0.2, 0.2, 1, 1)
            if self.current_stage < 10:
                stage_string = "0" + str(self.current_stage)
            else:
                stage_string = str(self.current_stage)
            sgd.set2DFont(self.menu.subtitle_font)
            sgd.draw2DText(stage_string, 1570, 60)
            # time area
            sgd.set2DFont(self.menu.title_font)
            sgd.set2DTextColor(0.2, 0.2, 0.2, 1)
            sgd.draw2DText("TIME", 1410, 90)
            sgd.set2DTextColor(1, 0.2, 0.2, 1)
            sgd.draw2DText("TIME", 1414, 94)

            sgd.present()

    def __del__(self):
        sgd.terminate()

