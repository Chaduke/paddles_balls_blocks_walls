from globals import *

class Block:
    def __init__(self,mesh,x,y,block_type):
        self.block_type = block_type
        self.model = sgd.createModel(mesh)
        self.collision_point_left = sgd.createModel(0)
        sgd.setEntityParent(self.collision_point_left,self.model)
        sgd.setEntityPosition(self.collision_point_left,-0.5,0,0)
        self.collider_left = sgd.createSphereCollider(self.collision_point_left,3,0.5)
        self.collision_point_right = sgd.createModel(0)
        sgd.setEntityParent(self.collision_point_right, self.model)
        sgd.setEntityPosition(self.collision_point_left, 0.5, 0, 0)
        self.collider_right = sgd.createSphereCollider(self.collision_point_right, 3, 0.5)
        sgd.setEntityPosition(self.model,x,y,37)
    def to_dict(self):
        return {"x": sgd.getEntityX(self.model), "y": sgd.getEntityY(self.model), "block_type": self.block_type}
