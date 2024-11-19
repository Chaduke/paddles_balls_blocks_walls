from globals import *

def resize_paddle(game, new_size):
    # create a new paddle and delete the old one
    old_x = sgd.getEntityX(game.paddle.model)
    sgd.destroyEntity(game.paddle.model)
    game.paddle = Paddle(game.assets.paddle_meshes[new_size], new_size)
    sgd.setEntityPosition(game.paddle.model, old_x, sgd.getEntityY(game.paddle.model),
                          sgd.getEntityZ(game.paddle.model))

class Paddle:
    def __init__(self,mesh,size):
        self.model = sgd.createModel(mesh)
        self.point_count = 4 * (size+1)
        self.colliders = [None] * self.point_count
        self.collision_points = [None] * self.point_count
        for i in range(self.point_count):
            self.collision_points[i] = sgd.createModel(0)
            sgd.setEntityParent(self.collision_points[i],self.model)
            sgd.setEntityPosition(self.collision_points[i],i - (self.point_count / 2) + 0.5,0,0)
            self.colliders[i] = sgd.createSphereCollider(self.collision_points[i],2,0.5)
        self.velocity=(0,0)
        self.acceleration=(0,0)
        sgd.setEntityPosition(self.model,0,2,37)
        self.bounds_left = -18.5 + self.point_count / 2
        self.bounds_right = 11.5 - self.point_count / 2
    def update(self):
        # control the paddle with mouse
        sgd.moveEntity(self.model,sgd.getMouseVX() * 0.02,0,0)
        # stay in the "playfield"
        if sgd.getEntityX(self.model) < self.bounds_left:
            sgd.setEntityPosition(self.model,self.bounds_left,sgd.getEntityY(self.model),37)
        if sgd.getEntityX(self.model) > self.bounds_right:
            sgd.setEntityPosition(self.model,self.bounds_right,sgd.getEntityY(self.model),37)
        # "swing" the paddle using left mouse
        if sgd.isMouseButtonDown(0):
            if sgd.getEntityY(self.model) > 0:
                sgd.moveEntity(self.model,0,-0.3,0)
        else:
            # if the mouse button is released, get the paddle the back to its original position
            if sgd.getEntityY(self.model) < 2:
                sgd.moveEntity(self.model, 0, 0.3, 0)