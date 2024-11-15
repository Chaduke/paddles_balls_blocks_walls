from ball import *
from block import *
from paddle import *

class Game:
    def __init__(self):
        sgd.init()
        sgd.createWindow(1920,1080,"Paddles, Balls, Blocks, and Walls",sgd.WINDOW_FLAGS_FULLSCREEN)
        self.env = sgd.loadCubeTexture("assets/night.jpg",sgd.TEXTURE_FORMAT_SRGBA8,sgd.TEXTURE_FLAGS_DEFAULT)
        sgd.setEnvTexture(self.env)
        self.skybox = sgd.createSkybox(self.env)
        self.camera = sgd.createPerspectiveCamera()
        sgd.moveEntity(self.camera,0,12,0)
        self.light = sgd.createDirectionalLight()
        sgd.turnEntity(self.light,-45,-45,0)
        sgd.setLightShadowsEnabled(self.light,True)
        # ground
        #ground_material = sgd.loadPBRMaterial("assets/Gravel041_1K-JPG")
        #ground_mesh = sgd.createBoxMesh(-32,-0.1,-32,32,0,32,ground_material)
        #sgd.transformTexCoords(ground_mesh,16,16,0,0)
        #self.ground = sgd.createModel(ground_mesh)
        # balls
        self.balls=[]
        self.ball_mesh = sgd.loadMesh("assets/ball1.glb")
        sgd.setMeshShadowsEnabled(self.ball_mesh,True)

        # block
        self.block_mesh = sgd.loadMesh("assets/yellow_block.glb")
        sgd.setMeshShadowsEnabled(self.block_mesh, True)
        self.blocks = []
        for i in range(10):
            self.blocks.append(Block(self.block_mesh,i * 2 - 8,16))
        # paddle
        self.paddle_mesh = sgd.loadMesh("assets/paddle_4m.glb")
        sgd.setMeshShadowsEnabled(self.paddle_mesh, True)
        self.paddle = Paddle(self.paddle_mesh)

        self.loop = True
        sgd.setMouseCursorMode(3)
        sgd.enableCollisions(1,0,sgd.COLLISION_RESPONSE_NONE)
        self.colliding = False
    def load_stage(self,stage):
        pass
    def run_stage(self):
        while self.loop:
            e=sgd.pollEvents()
            if e==sgd.EVENT_MASK_CLOSE_CLICKED: self.loop = False
            if sgd.isKeyHit(sgd.KEY_ESCAPE): self.loop = False
            if sgd.isMouseButtonHit(1):
                self.balls.append(Ball(self.ball_mesh,sgd.getEntityX(self.paddle.model),sgd.getEntityY(self.paddle.model) + 1,0,0.6))

            for ball in self.balls:
                ball.update()
                if sgd.getCollisionCount(ball.collider) > 0:
                    self.colliding = True
                    paddle_collider = sgd.getCollisionCollider(ball.collider,0)
                    paddle_entity = sgd.getColliderEntity(paddle_collider)
                    paddle_height = sgd.getEntityY(paddle_entity)
                    sgd.setEntityPosition(ball.model,sgd.getEntityX(ball.model),paddle_height + 1.1,sgd.getEntityZ(ball.model))
                    ball.velocity[1] = abs(ball.velocity[1])
                else:
                    self.colliding = False
                if not ball.active:
                    sgd.destroyEntity(ball.model)
                    self.balls.remove(ball)
            sgd.cameraUnproject(self.camera, sgd.getMouseX(), sgd.getMouseY(), 1)
            sgd.setEntityPosition(self.paddle.model, sgd.getUnprojectedX() * 25, 1, 30)
            sgd.updateColliders()
            sgd.renderScene()
            sgd.clear2D()
            if self.colliding: sgd.draw2DText("Colliding",0,0)
            sgd.draw2DText("FPS : " + str(sgd.getFPS()),0,sgd.getWindowHeight() - 20)
            sgd.present()
    def __del__(self):
        sgd.terminate()

