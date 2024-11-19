from globals import *

def setup_libsgd_collisions():
    if collision_system == 0:
        # ball with walls, ball = 1, walls = 0
        sgd.enableCollisions(1, 0, sgd.COLLISION_RESPONSE_NONE)
        # ball with paddle, ball = 1, paddle = 2
        sgd.enableCollisions(1, 2 ,sgd.COLLISION_RESPONSE_NONE)
        # ball with blocks, ball = 1, blocks = 3
        sgd.enableCollisions(1, 3, sgd.COLLISION_RESPONSE_NONE)
        # items with paddle, items = 4, paddle = 2
        sgd.enableCollisions(4, 2, sgd.COLLISION_RESPONSE_NONE)