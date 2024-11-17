from globals import *

class Item:
    def __init__(self,mesh,item_type,x,y):
        self.model = sgd.createModel(mesh)
        self.item_type = item_type
        self.pivot = sgd.createModel(0)
        sgd.setEntityParent(self.model,self.pivot)
        self.collision_point_left = sgd.createModel(0)
        sgd.setEntityParent(self.collision_point_left, self.pivot)
        sgd.setEntityPosition(self.collision_point_left, -0.5, 0, 0)
        self.collider_left = sgd.createSphereCollider(self.collision_point_left, 4, 0.5)
        self.collision_point_right = sgd.createModel(0)
        sgd.setEntityParent(self.collision_point_right, self.pivot)
        sgd.setEntityPosition(self.collision_point_left, 0.5, 0, 0)
        self.collider_right = sgd.createSphereCollider(self.collision_point_right, 4, 0.5)
        sgd.setEntityPosition(self.pivot,x,y,37)
        self.speed = -0.08
        self.angle = 0
        self.active = True
    def move(self):
        sgd.moveEntity(self.pivot,0,self.speed,0)
        sgd.setEntityRotation(self.model,self.angle,0,0)
        self.angle += 2
        if self.angle > 359 : self.angle = 0
        if sgd.getEntityY(self.pivot) < 0:
            self.active = False
