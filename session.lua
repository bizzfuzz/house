require 'table.settings'
require 'gui.buttongroup'
require 'gui.tools'
Session = Class
{
    init = function(self,file,prefs,tiles)
        if file then
            self:load(file)
        else
            self.layers={}
            self.prefs = Settings(prefs);
            self:addlayer()
            self.name = prefs.name
            self.tiles=tiles
        end
        self.xoffset,self.yoffset=0,0
        self.cam = Camera()
        self.tileset = love.graphics.newImage(string.format('assets/%s', self.tiles))
        self.currentsprite=false
        self.currentlayer=1
        self:getquads()
        self:spritebuttons()
        self.tools = Tools(self.layers)
        self.velx=0
    end;
    spritebuttons = function(self)
        local twid,thei = self.prefs.twidth,self.prefs.theight
        local bottom = love.graphics.getHeight()
        self.sprites = ButtonGroup('pic', 5,bottom-thei-10,twid,thei,self.quads)
    end;
    getquads = function(self)
        self.quads={}
        local setW,setH = self.tileset:getWidth(), self.tileset:getHeight()
        local tilewidth, tileheight = self.prefs.twidth,self.prefs.theight

        for x = 0,setW-tilewidth,tilewidth do
            for y = 0,setH-tileheight,tileheight do
                --print(x,y)
                table.insert(self.quads, love.graphics.newQuad(x,y,tilewidth,tileheight,setW,setH))
            end
        end
    end;
    keypressed = function(self, key)
        --print(key)
        if key == 'right' then
            self.cam.x = self.cam.x + self.prefs.twidth
            self.xoffset = self.xoffset-1
        elseif key == 'left' then
            self.cam.x = self.cam.x - self.prefs.twidth
            self.xoffset = self.xoffset+1
        elseif key == 'up' then
            self.cam.y = self.cam.y - self.prefs.theight
            self.yoffset = self.yoffset+1
        elseif key == 'down' then
            self.cam.y = self.cam.y + self.prefs.theight
            self.yoffset = self.yoffset-1
        elseif key == 'r' then
            self.cam:reset()
            self.xoffset, self.yoffset = 0,0
            return
        elseif key == 's' then
            --print('in')
            self:save()
            return
        end
        love.keyboard.setKeyRepeat(true)
    end;
    mousepressed = function(self,x,y,button)
        if self.sprites:mousepressed(x,y) then
            self.currentsprite=self.sprites:current()
        end
        self.layers[self.currentlayer]:mousepressed(x,y,button,self.xoffset,self.yoffset,self.currentsprite)
        self.tools:mousepressed(x,y)
        if self.tools.row then
            for _,layer in pairs(self.layers) do
                layer:addrow()
            end
            self.tools.row=false
        elseif self.tools.col then
            for _,layer in pairs(self.layers) do
                layer:addcol()
            end
            self.tools.col=false
        elseif self.tools.layeradd then
            self:addlayer()
            self.tools:showlayers(self.layers)
            self.tools.layeradd=false
            self.currentlayer = #self.layers
        elseif self.tools.layerchange then
            self.currentlayer=self.tools.currentlayer
            self.tools.layerchange=false
        elseif self.tools.erase then
            self.currentsprite=false
            self.tools.erase=false
        end
    end;
    save = function(self)
        local dir = '/home/ian/dev/lua/house/save' --find way to use relative path
        table.save(self, string.format('%s/%s', dir,self.name))
        --[[print("--------------------")
        for i=1,#self.quads do
            print(self.tiletable.walkmap[i])
        end
        print("--------------------")]]
    end;

    load = function(self, file)
        --local dir = '/home/ian/dev/lua/house/save'
        local saved = table.load(file)
        self.layers={}
        for _,layer in pairs(saved.layers) do
            table.insert(self.layers,Tiletable(layer))
        end
        self.prefs = Settings(saved.prefs)
        self.tiles=saved.tiles
        --self.tileset = love.graphics.newImage(string.format('assets/%s.png', saved.tilesource))
        self.name = saved.name
    end;
    addlayer = function(self)
        table.insert(self.layers,Tiletable(false,self.prefs))
    end;
    draw = function(self)
        self.cam:set()
        for _,layer in pairs(self.layers) do
            layer:draw(self.tileset,self.quads)
        end
        self.cam:unset()
        self.sprites:draw(self.tileset)
        self.tools:draw()
    end;
    wheelmoved = function(self, x,y)
        --print(self.velx)
        self.velx = self.velx+2*y
        --print(self.vely)
    end;
    update = function(self)
        self.sprites:update()
        self.tools:update()
        for _,button in pairs(self.sprites.buttons) do
            button.x = button.x+self.velx
        end
        self.velx = self.velx*0.95
    end;
}
