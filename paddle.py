from libsgd import sgd

class Paddle:
    def __init__(self,mesh):
        self.model = sgd.createModel(mesh)
        self.colliders = [None] * 4
        self.collision_points = [None] * 4
        for i in range(4):
            self.collision_points[i] = sgd.createModel(0)
            sgd.setEntityParent(self.collision_points[i],self.model)
            sgd.setEntityPosition(self.collision_points[i],i - 1.5,0,0)
            self.colliders[i] = sgd.createSphereCollider(self.collision_points[i],0,0.5)
        self.velocity=(0,0)
        self.acceleration=(0,0)
        sgd.setEntityPosition(self.model,0,1,30)
    def update(self):
        pass