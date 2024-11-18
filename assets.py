from globals import *

class Assets:
    def __init__(self):
        self.env = sgd.loadCubeTexture("assets/night.jpg", sgd.TEXTURE_FORMAT_SRGBA8, sgd.TEXTURE_FLAGS_DEFAULT)
        # walls
        self.walls = sgd.loadModel("assets/walls.glb")
        # balls
        self.ball_meshes = []
        self.ball_mesh_small = sgd.loadMesh("assets/ball_small.glb")
        sgd.setMeshShadowsEnabled(self.ball_mesh_small, True)
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
        self.block_meshes.append(self.block_yellow_mesh)
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
        self.block_yellow2_mesh = sgd.loadMesh("assets/block_yellow2.glb")
        sgd.setMeshShadowsEnabled(self.block_yellow2_mesh, True)
        self.block_meshes.append(self.block_yellow2_mesh)

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

        # load audio
        self.title_sound = sgd.loadSound("assets/wave/title.wav")
        self.bgm_sound = sgd.loadSound("assets/wave/bgm.wav")
        self.paddle_sound = sgd.loadSound("assets/wave/pad.wav")
        self.close_sound = sgd.loadSound("assets/wave/close.wav")
        self.block_sound = sgd.loadSound("assets/wave/block.wav")
        self.block2_sound = sgd.loadSound("assets/wave/block2.wav")
        self.reverse_sound = sgd.loadSound("assets/wave/reverse.wav")

        self.regular_font = sgd.loadFont("assets/bb.ttf", 20)
        self.grid = sgd.loadModel("assets/grid.glb")
