Camera = Class
{
    init = function(self)
        self.x = 0
        self.y = 0
        self.scalex = 1
        self.scaley = 1
        self.speed = 100
        self.rotation = 0
    end;

    reset = function(self)
        self.x = 0
        self.y = 0
        self.scalex = 1
        self.scaley = 1
    end;

    zoom = function(self, dt)
        self.scalex = self.scalex-dt*0.1
        self.scaley = self.scaley-dt*0.1
    end;

    set = function(self)
        love.graphics.push()
        love.graphics.rotate(-self.rotation)
        love.graphics.scale(1/self.scalex, 1/self.scaley)
        love.graphics.translate(-self.x, -self.y)
    end;

    unset= function (self)
        love.graphics.pop()
    end;

    rotate = function (self, dr)
        self.rotation = self.rotation + dr
    end;

    scale = function (self, sx,sy)
        sx = sx or 1
        self.scalex = self.scalex * sx
        self.scaley = self.scaley * (sy or sx)
    end;

    setPosition = function (self, x,y)
        self.x = x or self.x
        self.y = y or self.y
    end;

    setScale = function (self, sx,sy)
        self.scalex = sx or self.scalex
        self.scaley = sy or self.scaley
    end;

    move = function(self, x, y)
        self.x = math.floor(self.x + x)
        self.y = math.floor(self.y + y)
    end;
}
