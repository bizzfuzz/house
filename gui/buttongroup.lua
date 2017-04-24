ButtonGroup = Class
{
    init = function(self, type,px,py,w,h,quads)
        self.buttons = {}
        self.selected = {false,0}

        local x,y = px,py
        if type == 'pic' then
            for _,quad in pairs(quads) do
                table.insert(self.buttons, PicButton(x,py,w,h,quad))
                x = x+self.buttons[1].width+1
            end
        elseif type=='layer' then
            for i,layer in ipairs(tileset) do
                table.insert(self.buttons,Button(i,x,y,30,30))
                y=y+self.buttons[1].height+5
            end
        end
    end;

    update = function(self)
        for _,button in pairs(self.buttons) do
            button:update(love.mouse.getPosition())
        end

    end;

    select = function(self, i)
        self.buttons[i]:toggleSelect()
        self.selected = {true,i}

        for y,button in ipairs(self.buttons) do
            if y~=i and button.selected then
                button:toggleSelect()
                break
            end
        end
    end;

    current = function(self)
        if self.selected[1] then return self.selected[2] end
    end;

    deselect = function(self)
        self.selected = {false,0}
        for _,button in pairs(self.buttons) do
            if button.selected then
                button:toggleSelect()
            end
        end
    end;

    overany = function(self, x,y)
        for i,button in ipairs(self.buttons) do
            --print(Ops:colliding(x,y,button))
            if button:hovered(x,y) then
                return i
            end
        end
        return false
    end;
    mousepressed = function(self,x,y)
        local selected = self:overany(x,y)
        if selected then
            self:select(selected)
        end
        return selected
    end;
    isSelected = function(self, i)
        return self.buttons[i].selected
    end;

    draw = function(self,tileset)
        for _,button in pairs(self.buttons) do
            button:draw(tileset)
        end
    end
}
