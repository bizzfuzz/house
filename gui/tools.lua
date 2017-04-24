require 'gui.button'
Tools = Class
{
    init = function(self,layers)
        self.row,self.col,self.erase,self.layeradd,self.layerchange=false,false,false,false,false;
        local controls = {'r','c','l','e'}
        self.buttons = {}
        self.currentlayer=false

        local x = love.graphics.getWidth()-35
        for _,action in pairs(controls) do
            table.insert(self.buttons,Button(action,x,5,30))
            x=x-self.buttons[1].width-5
        end
        self:showlayers(layers)
    end;
    showlayers = function(self,layers)
        self.layers={}
        local y = self.buttons[1].height+10
        local x = love.graphics.getWidth()-35
        for i,layer in ipairs(layers) do
            table.insert(self.layers, Button(i,x,y,30))
            y=y+35
        end
    end;
    mousepressed = function(self,x,y)
        for _,button in pairs(self.buttons) do
            if(button:hovered(x,y)) then
                if button.label=='r' then
                    self.row=true
                elseif button.label=='c' then
                    self.col=true
                elseif button.label=='l' then
                    self.layeradd=true
                elseif button.label=='e' then
                    self.erase=true
                end
            end
        end
        for _,button in pairs(self.layers) do
            if(button:hovered(x,y)) then
                self.currentlayer=button.label
                self.layerchange=true
            end
        end
    end;
    update = function(self)
        for _,button in pairs(self.buttons) do
            button:update(love.mouse.getPosition())
        end
        for _,button in pairs(self.layers) do
            button:update(love.mouse.getPosition())
        end
    end;
    draw = function(self)
        for _,button in pairs(self.buttons) do
            button:draw()
        end
        for _,button in pairs(self.layers) do
            button:draw()
        end
    end;
}
