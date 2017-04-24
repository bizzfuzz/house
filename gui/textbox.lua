
TextBox = Class
{
    init = function(self, label,x,y,w,h)
        self.x,self.y=x,y
        self.label=label
        self.width = w or 200
        self.height = h or 80
        self.value=''
        self.set=false
        self.active=false
    end;
    draw = function(self)
        if self.active then
            rbox(self.x-5,self.y-5,self.width+5,self.height+5)
        end
        box(self.x,self.y,self.width,self.height)
        love.graphics.print(self.label, self.x+20, self.y+10)
        love.graphics.print(self.value, self.x+20, self.y+40)
    end;
    backspace = function(self)
        local utf8 = require("utf8")
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(self.value, -1)
        if byteoffset then
           -- remove the last UTF-8 character.
            self.value =  string.sub(self.value, 1, byteoffset-1)
       end
    end;
    textinput = function(self,t)
        self.value = self.value..t
    end;
    keypressed = function(self,key)
        if self.active then
            if key=='backspace' then
                self:backspace()
            elseif key=='return' then
                self.set=true
            end
        end
    end;
    mousepressed = function(self,x,y)
        if colliding(x,y,self) and not self.active then
            self.active=true
            return
        end
        self.active=false
    end;
}
