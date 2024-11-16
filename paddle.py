from globals import *

class Paddle:
    def __init__(self,mesh):
        self.model = sgd.createModel(mesh)
        self.colliders = [None] * 4
        self.collision_points = [None] * 4
        for i in range(4):
            self.collision_points[i] = sgd.createModel(0)
            sgd.setEntityParent(self.collision_points[i],self.model)
            sgd.setEntityPosition(self.collision_points[i],i - 1.5,0,0)
            self.colliders[i] = sgd.createSphereCollider(self.collision_points[i],2,0.5)
        self.velocity=(0,0)
        self.acceleration=(0,0)
        sgd.setEntityPosition(self.model,0,2,37)
    def update(self):
        # control the paddle with mouse
        sgd.moveEntity(self.model,sgd.getMouseVX() * 0.02,0,0)
        # stay in the "playfield"
        if sgd.getEntityX(self.model) < -16:
            sgd.setEntityPosition(self.model,-16,sgd.getEntityY(self.model),37)
        if sgd.getEntityX(self.model) > 9.2:
            sgd.setEntityPosition(self.model,9.2,sgd.getEntityY(self.model),37)
        # "swing" the paddle using left mouse
        if sgd.isMouseButtonDown(0):
            if sgd.getEntityY(self.model) > 0:
                sgd.moveEntity(self.model,0,-0.3,0)
        else:
            # if the mouse button is released, get the paddle the back to its original position
            if sgd.getEntityY(self.model) < 2:
                sgd.moveEntity(self.model, 0, 0.3, 0)