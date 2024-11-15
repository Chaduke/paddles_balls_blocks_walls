from libsgd import sgd

class Block:
    def __init__(self,mesh,x,y):
        self.model = sgd.createModel(mesh)
        self.velocity=(0,0)
        self.acceleration=(0,0)
        sgd.setEntityPosition(self.model,x,y,37)