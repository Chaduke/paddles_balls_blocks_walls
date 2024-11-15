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
        ground_material = sgd.loadPBRMaterial("assets/Gravel041_1K-JPG")
        ground_mesh = sgd.createBoxMesh(-32,-0.1,-32,32,0,32,ground_material)
        sgd.transformTexCoords(ground_mesh,16,16,0,0)
        self.ground = sgd.createModel(ground_mesh)
        # ball
        self.ball_mesh = sgd.loadMesh("assets/ball1.glb")
        sgd.setMeshShadowsEnabled(self.ball_mesh,True)
        self.ball = Ball(self.ball_mesh)
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
    def load_stage(self,stage):
        pass
    def run_stage(self):
        while self.loop:
            e=sgd.pollEvents()
            if e==sgd.EVENT_MASK_CLOSE_CLICKED: self.loop = False
            if sgd.isKeyHit(sgd.KEY_ESCAPE): self.loop = False
            self.ball.update()
            sgd.cameraUnproject(self.camera, sgd.getMouseX(), sgd.getMouseY(), 1)
            sgd.setEntityPosition(self.paddle.model, sgd.getUnprojectedX() * 25, 1, 30)
            sgd.renderScene()
            sgd.present()
    def __del__(self):
        sgd.terminate()

