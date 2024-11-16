from globals import *

class Ball:
    def __init__(self,mesh,x,y,xvel,yvel):
        self.model = sgd.createModel(mesh)
        self.collider = sgd.createSphereCollider(self.model,1,0.5)
        self.velocity= [xvel, yvel]
        self.acceleration=[0,-0.02]
        sgd.setEntityPosition(self.model,x,y,37)
        self.active = True
    def update(self):
        self.velocity[0] += self.acceleration[0]
        self.velocity[1] += self.acceleration[1]
        sgd.moveEntity(self.model,self.velocity[0],self.velocity[1],0)
        if sgd.getEntityY(self.model) < 0:
            self.active = False
