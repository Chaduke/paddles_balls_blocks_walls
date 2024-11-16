from libsgd import playSound

from paddle import *
from ball import *
from block import *
from menu import *
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
        self.ball_mesh = sgd.loadMesh("assets/ball1.glb")
        sgd.setMeshShadowsEnabled(self.ball_mesh,True)

        # block
        self.block_mesh = sgd.loadMesh("assets/block_yellow.glb")
        sgd.setMeshShadowsEnabled(self.block_mesh, True)
        self.blocks = []

        # paddle
        self.paddle_mesh = sgd.loadMesh("assets/paddle_4m.glb")
        sgd.setMeshShadowsEnabled(self.paddle_mesh, True)
        self.paddle = Paddle(self.paddle_mesh)

        # collisions setup
        # ball with walls, ball = 1, walls = 0
        sgd.enableCollisions(1, 0, sgd.COLLISION_RESPONSE_NONE)
        # ball with paddle, ball = 1, paddle = 2
        sgd.enableCollisions(1, 2 ,sgd.COLLISION_RESPONSE_STOP)
        # ball with blocks, ball = 1, blocks = 3
        sgd.enableCollisions(1, 3, sgd.COLLISION_RESPONSE_STOP)
        self.colliding = False # flag to display collisions for debug purposes

        # load audio
        self.title_sound = sgd.loadSound("assets/wave/title.wav")
        self.bgm_sound = sgd.loadSound("assets/wave/bgm.wav")
        self.background_music = None
        self.paddle_sound = sgd.loadSound("assets/wave/pad.wav")
        self.close_sound = sgd.loadSound("assets/wave/close.wav")
        self.block_sound = sgd.loadSound("assets/wave/block.wav")
        self.block2_sound = sgd.loadSound("assets/wave/block2.wav")
        self.reverse_sound = sgd.loadSound("assets/wave/reverse.wav")
        self.audio_on = True
        if self.audio_on:
            sgd.playSound(self.title_sound)
        # menu
        self.menu = Menu()
        self.regular_font = sgd.loadFont("assets/bb.ttf",20)
        # pre-loop stuff
        self.loop = True
        self.paused = False
        self.editor = True
        sgd.setMouseCursorMode(3)
        self.cursor = sgd.createModel(self.block_mesh)
        self.grid = sgd.loadModel("assets/grid.glb")
        sgd.moveEntity(self.grid, -19, 0, 37)
    def save_stage(self,stage):
        stage_path = "stages/system/stage" + str(stage) + ".json"
        with open(stage_path, 'w') as f:
            json.dump([block.to_dict() for block in self.blocks], f, ensure_ascii=False,indent=4)
        if self.audio_on: sgd.playSound(self.block2_sound)
    def clear_stage(self):
        to_remove = []  # Temporary list to collect blocks to be removed
        for block in self.blocks:
            sgd.destroyEntity(block.model)
            to_remove.append(block) # Collect the blocks to be removed
        for block in to_remove:
            self.blocks.remove(block) # Remove the collected blocks
        if self.audio_on : sgd.playSound(self.reverse_sound)
    def clear_balls(self):
        to_remove = []  # Temporary list to collect blocks to be removed
        for ball in self.balls:
            sgd.destroyEntity(ball.model)
            to_remove.append(ball) # Collect the blocks to be removed
        for ball in to_remove:
            self.balls.remove(ball) # Remove the collected blocks
    def load_stage(self,stage):
        self.clear_stage()
        stage_path = "stages/system/stage" + str(stage) + ".json"
        with open(stage_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            self.blocks = [Block(self.block_mesh,item["x"], item["y"], item["block_type"]) for item in data]
        if self.audio_on : sgd.playSound(self.title_sound)
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
    def add_block(self):
        # make sure one doesnt already exist there
        self.remove_block()
        new_xy = self.get_new_xy()
        self.blocks.append(Block(self.block_mesh, new_xy[0], new_xy[1],0))
        if self.audio_on: sgd.playSound(self.block_sound)
    def edit_stage(self):
        sgd.setEntityVisible(self.paddle.model,False)
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
                    sgd.setEntityVisible(self.grid, True)
            # save stage
            if sgd.isKeyHit(sgd.KEY_S):
                self.save_stage(1)
            # load stage
            if sgd.isKeyHit(sgd.KEY_L):
                self.load_stage(1)
            # clear stage
            if sgd.isKeyHit(sgd.KEY_C):
                self.clear_stage()
            # play stage
            if sgd.isKeyHit(sgd.KEY_P):
                self.editor = False
                sgd.setEntityVisible(self.paddle.model,True)
                sgd.setEntityVisible(self.grid,False)
                sgd.setEntityVisible(self.cursor, False)
                self.save_stage(1)
                self.run_stage()
                self.editor = True
                sgd.setEntityVisible(self.paddle.model, False)
                sgd.setEntityVisible(self.grid, True)
                sgd.setEntityVisible(self.cursor, True)
                self.clear_balls()
                sgd.stopAudio(self.background_music)
                self.load_stage(1)
            # add a block
            if sgd.isMouseButtonHit(0):
                self.add_block()
            # delete a block
            if sgd.isMouseButtonHit(1):
                self.remove_block()
            self.position_cursor()
            sgd.renderScene()
            sgd.clear2D()
            sgd.set2DFont(self.menu.subtitle_font)
            sgd.set2DTextColor(1,1,0,1)
            sgd.draw2DText("STAGE EDITOR",15,0)
            sgd.set2DFont(self.regular_font)
            sgd.set2DTextColor(0.8,0.8,0.8,1)
            sgd.draw2DText("G - Toggle Grid",15,50)
            sgd.draw2DText("A - Toggle Audio",15,70)
            sgd.draw2DText("Left Mouse - Drop Block",15,90)
            sgd.draw2DText("Right Mouse - Erase Block", 15, 110)
            sgd.draw2DText("Mouse Wheel - Select Block", 15, 130)
            sgd.draw2DText("S - Save Stage", 15, 150)
            sgd.draw2DText("L - Load Stage", 15, 170)
            sgd.draw2DText("C - Clear Stage", 15, 190)
            sgd.draw2DText("P - Play Stage",15, 210)
            sgd.draw2DText("Cursor X,Y : " + str(sgd.getEntityX(self.cursor)) + "," + str(sgd.getEntityY(self.cursor)),15,1060)

            sgd.present()
    def run_stage(self):
        if self.editor:
            self.edit_stage()
            return
        if self.audio_on:
            self.background_music = sgd.playSound(self.bgm_sound)
            sgd.setAudioLooping(self.background_music,True)
        while self.loop:
            e=sgd.pollEvents()
            if e==sgd.EVENT_MASK_CLOSE_CLICKED: self.loop = False
            if sgd.isKeyHit(sgd.KEY_ESCAPE): self.loop = False
            if sgd.isKeyHit(sgd.KEY_P):
                if self.paused:
                    self.paused = False
                    sgd.setMouseCursorMode(3)
                else:
                    self.paused = True
                    sgd.setMouseCursorMode(1)
            if not self.paused:
                # on mouse right click, release a ball (if available)
                if sgd.isMouseButtonHit(1):
                    # set which way the ball goes left or right based on X location of paddle
                    if sgd.getEntityX(self.paddle.model) < -3.9:
                        vx = -0.1
                    else:
                        vx= 0.1
                    self.balls.append(Ball(self.ball_mesh,sgd.getEntityX(self.paddle.model),sgd.getEntityY(self.paddle.model) + 0.5,vx,0.7))
                # balls update loop
                for ball in self.balls:
                    ball.update()
                    if sgd.getCollisionCount(ball.collider) > 0:
                        self.colliding = True
                        collided_collider = sgd.getCollisionCollider(ball.collider,0)
                        # check for walls
                        if sgd.getColliderType(collided_collider) == 0:
                            if sgd.getEntityY(ball.model) > 29:
                                # we're probably at the ceiling
                                ball.velocity[1] = -abs(ball.velocity[1] * 0.8)
                            else:
                                # we're probably hitting the side walls
                                if sgd.getEntityX(ball.model) < -16:
                                    # left wall
                                    ball.velocity[0] = abs(ball.velocity[0] * 0.8)
                                else:
                                    # right wall
                                    ball.velocity[0] = -abs(ball.velocity[0] * 0.8)
                        elif sgd.getColliderType(collided_collider) == 2:
                            # check for paddle collisions
                            collided_entity = sgd.getColliderEntity(collided_collider)
                            paddle_height = sgd.getEntityY(collided_entity)
                            # prevent multiple collisions and re-triggering audio
                            sgd.setEntityPosition(ball.model,sgd.getEntityX(ball.model),paddle_height + 1,sgd.getEntityZ(ball.model))
                            # paddle collisions should always send the ball upwards
                            ball.velocity[1] = abs(ball.velocity[1])
                            # check if the paddle is on the upswing
                            if paddle_height < 2 and not sgd.isMouseButtonDown(0):
                                # add some velocity for ball hit with "swung" paddle
                                ball.velocity[1] += ball.velocity[1] / 3
                            if self.audio_on: sgd.playSound(self.close_sound)
                        elif sgd.getColliderType(collided_collider) == 3:
                            # block collisions
                            block_collision_point = sgd.getColliderEntity(collided_collider)
                            block_model = sgd.getEntityParent(block_collision_point)
                            for block in self.blocks:
                                if block.model == block_model:
                                    sgd.destroyEntity(block.model)
                                    self.blocks.remove(block)
                            ball.velocity[1] = - ball.velocity[1]
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
                sgd.updateColliders()
            sgd.renderScene()
            sgd.clear2D()
            if self.paused:
                self.menu.display()
                display_text_centered("PAUSED",self.regular_font,sgd.getWindowHeight() - 25)
            if self.colliding: sgd.draw2DText("Colliding", 0, 0)
            sgd.draw2DText("FPS : " + str(int(sgd.getFPS())), 0, sgd.getWindowHeight() - 20)
            sgd.present()

    def __del__(self):
        sgd.terminate()

