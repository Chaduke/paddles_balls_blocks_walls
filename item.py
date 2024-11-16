from globals import *

class Item:
    def __init__(self,mesh,type,x,y):
        self.model = sgd.createModel(mesh)
        self.pivot = sgd.createModel(0)
        sgd.setEntityParent(self.model,self.pivot)
        self.type = type
        sgd.setEntityPosition(self.pivot,x,y,37)
        self.speed = -0.05
        self.angle = 0
        self.active = True
    def move(self):
        sgd.moveEntity(self.pivot,0,self.speed,0)
        sgd.setEntityRotation(self.model,self.angle,0,0)
        self.angle += 2
        if self.angle > 359 : self.angle = 0
        if sgd.getEntityY(self.pivot) < 0:
            self.active = False
