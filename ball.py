from globals import *

def get_ball_radius(game):
    if game.current_ball_size==0:
        return 0.25
    elif game.current_ball_size==1:
        return 0.5
    elif game.current_ball_size == 2:
        return 1.0
    elif game.current_ball_size == 3:
        return 2

class Ball:
    def __init__(self,mesh,size,x,y,xvel,yvel):
        self.model = sgd.createModel(mesh)
        self.size = size
        if self.size == 0:
            collider_radius = 0.25
        elif self.size == 1:
            collider_radius = 0.5
        elif self.size == 2:
            collider_radius = 1
        elif self.size == 3:
            collider_radius = 2
        else:
            collider_radius = 1
        self.collider = sgd.createSphereCollider(self.model,1,collider_radius)
        self.velocity= [xvel, yvel]
        self.acceleration=[0,-0.015]
        sgd.setEntityPosition(self.model,x,y,37)
        self.active = True
    def update(self):
        self.velocity[0] += self.acceleration[0]
        self.velocity[1] += self.acceleration[1]
        sgd.moveEntity(self.model,self.velocity[0],self.velocity[1],0)
        if sgd.getEntityY(self.model) < 0:
            self.active = False
