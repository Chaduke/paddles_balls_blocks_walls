from libsgd import sgd

class Ball:
    def __init__(self,mesh):
        self.model = sgd.createModel(mesh)
        self.velocity= [0, 0]
        self.acceleration=[0,-0.01]
        sgd.setEntityPosition(self.model,0,20,30)
    def update(self):
        self.velocity[0] += self.acceleration[0]
        self.velocity[1] += self.acceleration[1]
        sgd.moveEntity(self.model,self.velocity[0],self.velocity[1],0)
        if sgd.getEntityY(self.model) < 1:
            sgd.setEntityPosition(self.model,sgd.getEntityX(self.model),1,30)
            self.velocity[1] = -self.velocity[1]
