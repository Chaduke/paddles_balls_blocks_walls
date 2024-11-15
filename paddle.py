from libsgd import sgd

class Paddle:
    def __init__(self,mesh):
        self.model = sgd.createModel(mesh)
        self.velocity=(0,0)
        self.acceleration=(0,0)
        sgd.setEntityPosition(self.model,0,1,30)
    def update(self):
        pass