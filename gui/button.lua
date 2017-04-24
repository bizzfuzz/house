local highlight = {250,100,100}

Button = Class
{
    init = function(self, label,x,y,w,h)
        self.x = x
        self.y = y
        self.inity = y
        self.width = w or 150
        self.height = h or 30
        self.label = label
        self.highlight = false
        self.toggled = false
        self.selected = false
    end;

    boundary = function(self)
        if self.y ~= self.inity then
            self.y = self.inity
        end
    end;

    setLabel = function(self, text)
        self.label = text
    end;

    highlightToggle = function(self)
        if not self.toggled then
            self.highlight = not self.highlight
            self.toggled = not self.toggled
        end
    end;

    unlight = function(self)
        self.highlight = false
        self.toggled = false
    end;

    toggleSelect = function(self)
        self.selected = not self.selected
    end;

    update = function(self, x,y)
        if colliding(x,y, self) then
            self:highlightToggle()
        elseif self.highlight then
            self:unlight()
        end
    end;

    hovered = function(self, x,y)
        return colliding(x,y, self)
    end;

    draw = function(self)
        box(self.x, self.y, self.width, self.height)

        if self.highlight or self.selected then
            love.graphics.setColor(highlight[1], highlight[2], highlight[3])
        end
        love.graphics.print(self.label, self.x+10, self.y+10)
        if self.highlight or self.selected then
            love.graphics.setColor(255,255,255)
        end
    end;
}

PicButton = Class
{
    __includes = Button,

    init = function(self, x,y,w,h,quad)
        self.quad = quad
        self.x, self.y = x,y
        self.width = w+5
        self.height = h+5
    end;

    draw = function(self,tileset)
        if self.highlight or self.selected then
            rbox(self.x, self.y, self.width, self.height)
        else
            box(self.x, self.y, self.width, self.height)
        end
        love.graphics.draw(tileset, self.quad, self.x+5, self.y+5,0,
            self.scale,self.scale)
        if self.highlight or self.selected then
            love.graphics.setColor(255,255,255)
        end
    end;
}
