from paddle import *
from ball import *
from menu import *
from item import *
from assets import *
from ui import *
from collisions import *
from editor import *
from globals import *
from random import random

class Game:
    def __init__(self):
        sgd.init()
        sgd.createWindow(1920,1080,"Paddles, Balls, Blocks, and Walls",sgd.WINDOW_FLAGS_FULLSCREEN)
        self.assets = Assets()
        sgd.setEnvTexture(self.assets.env)
        self.skybox = sgd.createSkybox(self.assets.env)
        self.camera = sgd.createPerspectiveCamera()
        sgd.moveEntity(self.camera,0,15,0)
        self.light = sgd.createDirectionalLight()
        sgd.turnEntity(self.light,-45,-45,0)
        sgd.setLightShadowsEnabled(self.light,True)

        sgd.moveEntity(self.assets.walls,-19,0,37)
        self.walls_collider = sgd.createMeshCollider(self.assets.walls,0,sgd.getModelMesh(self.assets.walls))
        self.balls=[]
        self.current_ball_size = 1 # regular sized balls
        self.blocks = []
        self.paddle = Paddle(self.assets.paddle_meshes[0],0)
        sgd.setEntityVisible(self.paddle.model,False)
        self.items = []
        setup_libsgd_collisions()
        self.background_music = None
        self.audio_on = True
        if self.audio_on:
            sgd.playSound(self.assets.title_sound)

        self.menu = Menu()
        self.ui = UI()
        # pre-loop stuff
        self.paused = False
        self.editor = False
        sgd.setMouseCursorMode(3)
        self.cursor = sgd.createModel(self.assets.block_meshes[0])
        self.grid = sgd.loadModel("assets/grid.glb")
        sgd.moveEntity(self.grid, -19, 0, 37)
        sgd.setEntityVisible(self.grid,False)
        self.bank = int(0) # for saving levels
        self.stage_numbers = []
        update_stage_numbers(self)
        self.current_stage = 0


    def run_stage(self):
        self.editor = False
        sgd.setEntityVisible(self.paddle.model, True)
        sgd.setEntityVisible(self.grid, False)
        sgd.setEntityVisible(self.cursor, False)
        if self.audio_on:
            self.background_music = sgd.playSound(self.assets.bgm_sound)
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
                    self.balls.append(Ball(
                        self.assets.ball_meshes[self.current_ball_size],
                        self.current_ball_size,
                        sgd.getEntityX(self.paddle.model),
                        sgd.getEntityY(self.paddle.model) + 0.5,vx,0.9))
                # blocks update loop
                blocks_to_add = []
                for block in self.blocks:
                    if not block.active:
                        # add a cracked blue (2) in place of solid blue (1)
                        if block.block_type == 1:
                            blocks_to_add.append(Block(
                                self.assets.block_meshes[2],
                                sgd.getEntityX(block.model),
                                sgd.getEntityY(block.model), 2))
                        sgd.destroyEntity(block.model)
                        self.blocks.remove(block)
                if len(blocks_to_add) > 0:
                    for block in blocks_to_add:
                        self.blocks.append(block)
                blocks_to_add.clear()
                # then check if we are done with the level
                if len(self.blocks) == 0:
                    if self.current_stage != 0:
                        self.current_stage += 1
                        load_stage(self,self.current_stage)
                    else:
                        # we are running from the editor
                        # so return there
                        return
                # balls update loop
                # first remove inactive balls and regen the ones that are the wrong size
                balls_to_add = []
                for ball in self.balls:
                    if not ball.active:
                        # check if ball size has changed
                        if ball.size != self.current_ball_size:
                            # create a new one before deleting
                            balls_to_add.append(Ball(
                                self.assets.ball_meshes[self.current_ball_size],
                                self.current_ball_size,
                                sgd.getEntityX(ball.model),
                                sgd.getEntityY(ball.model) + 0.5, ball.velocity[0],ball.velocity[1]))
                        sgd.destroyEntity(ball.model)
                        self.balls.remove(ball)
                # add the new sized balls
                if len(balls_to_add) > 0:
                    for ball in balls_to_add:
                        self.balls.append(ball)
                    balls_to_add.clear()
                for ball in self.balls:
                    ball.update()
                    if sgd.getCollisionCount(ball.collider) > 0:
                        collided_collider = sgd.getCollisionCollider(ball.collider,0)
                        # wall collisions
                        if sgd.getColliderType(collided_collider) == 0:
                            br = get_ball_radius(self)
                            if sgd.getEntityY(ball.model) > 28:
                                # we're probably at the ceiling
                                ball.velocity[1] = -abs(ball.velocity[1])
                                sgd.setEntityPosition(ball.model,sgd.getEntityX(ball.model),29 - br,37)
                            else:
                                # we're probably hitting the side walls
                                if sgd.getEntityX(ball.model) < -17:
                                    # left wall
                                    ball.velocity[0] = abs(ball.velocity[0])
                                    sgd.setEntityPosition(ball.model,-18.5 + br, sgd.getEntityY(ball.model), 37)
                                else:
                                    # right wall
                                    ball.velocity[0] = -abs(ball.velocity[0])
                                    sgd.setEntityPosition(ball.model, 11.5 - br, sgd.getEntityY(ball.model), 37)
                        elif sgd.getColliderType(collided_collider) == 2:
                            # paddle collisions
                            collided_entity = sgd.getColliderEntity(collided_collider)
                            paddle_height = sgd.getEntityY(collided_entity)
                            # prevent multiple collisions and re-triggering audio
                            br = get_ball_radius(self)
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
                            if self.audio_on: sgd.playSound(self.assets.close_sound)
                        elif sgd.getColliderType(collided_collider) == 3:
                            # block collisions
                            block_collision_point = sgd.getColliderEntity(collided_collider)
                            block_model = sgd.getEntityParent(block_collision_point)
                            br = get_ball_radius(self)
                            for block in self.blocks:
                                if block.model == block_model:
                                    # make the ball bounce unless it's a large ball or the block type is clear
                                    if self.current_ball_size < 2 and \
                                            block.block_type!=4 and \
                                            block.block_type!=6:
                                        # determine if the ball needs to bounce horizontally
                                        v_difference = sgd.getEntityY(block.model) - sgd.getEntityY(ball.model)
                                        if abs(v_difference) < 0.1:
                                            # horizontal bounce
                                            ball.velocity[0] = - ball.velocity[0]
                                            #ball.velocity[1] = - ball.velocity[1]
                                            # find the horizontal distance
                                            h_distance = sgd.getEntityX(block.model) - sgd.getEntityX(ball.model)
                                            if h_distance > 0:
                                                # ball is to the left side
                                                sgd.setEntityPosition(ball.model,
                                                                      sgd.getEntityX(block.model) - 1.5,
                                                                      sgd.getEntityY(ball.model),37)
                                            else:
                                                # ball is on the right side
                                                sgd.setEntityPosition(ball.model,
                                                                      sgd.getEntityX(block_model) + 1.5,
                                                                      sgd.getEntityY(ball.model), 37)
                                        else:
                                            # vertical bounce
                                            ball.velocity[1] = - ball.velocity[1]
                                            # find out where the collision occurred
                                            v_difference = sgd.getEntityY(block_model) - sgd.getEntityY(ball.model)
                                            # we should only have to do this for metal blocks
                                            if v_difference > 0:
                                                # block is higher than the ball
                                                sgd.setEntityPosition(ball.model,
                                                                      sgd.getEntityX(ball.model),
                                                                      sgd.getEntityY(block.model) - 0.5 - br,
                                                                      sgd.getEntityZ(ball.model))
                                            else:
                                                # ball is higher than the block
                                                sgd.setEntityPosition(ball.model,
                                                                      sgd.getEntityX(ball.model),
                                                                      sgd.getEntityY(block.model) + 0.5 + br,
                                                                      sgd.getEntityZ(ball.model))
                                    # pink blocks drop items
                                    if block.block_type==3:
                                        random_item = int(random() * 4)
                                        self.items.append(Item(self.assets.item_meshes[random_item], random_item, sgd.getEntityX(block.model),
                                                               sgd.getEntityY(block.model)))
                                    # clear blocks drop balls
                                    if random() > 0.5:
                                        xv = -0.3
                                    else : xv = 0.3
                                    if block.block_type==4:
                                        self.balls.append(Ball(
                                            self.assets.ball_meshes[self.current_ball_size],
                                            self.current_ball_size,
                                            sgd.getEntityX(block.model),
                                            sgd.getEntityY(block.model),xv,0.3))
                                    # metal block types stay forever
                                    if block.block_type != 5: block.active = False

                            # if self.audio_on :
                            #     if random() > 0.5:
                            #         sgd.playSound(self.block_sound)
                            #     else:
                            #         sgd.playSound(self.block2_sound)
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
                                resize_paddle(self,new_paddle_size)
                        elif item.item_type == 1:
                            # grow the paddle
                            if self.paddle.point_count < 28:
                                # create a new paddle and delete the old one
                                new_paddle_size = int((self.paddle.point_count + 4) / 4) - 1
                                resize_paddle(self,new_paddle_size)
                        elif item.item_type == 2:
                            # shrink all balls
                            self.current_ball_size-=1
                            if self.current_ball_size < 0 : self.current_ball_size=0
                            for ball in self.balls:
                                ball.active = False
                        elif item.item_type == 3:
                            # expand all balls
                            self.current_ball_size+=1
                            if self.current_ball_size > 2: self.current_ball_size = 2
                            for ball in self.balls:
                                ball.active = False
                        # regardless of item type we need to delete it
                        item.active = False
                    if not item.active:
                        sgd.destroyEntity(item.model)
                        self.items.remove(item)
            if collision_system == 0 : sgd.updateColliders()
            sgd.renderScene()
            sgd.clear2D()
            draw_game_ui(self)
            sgd.present()
    def __del__(self):
        sgd.terminate()

