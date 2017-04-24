require 'table.tiletable'
require 'table.settings'
require 'gui.button'
require 'gui.textbox'
require 'session'
require 'camera'

Program=Class
{
    init = function(self)
        self.session = false
        self.editing=false
        self.menu={
            {Button('new',20,75),self.new},
            {Button('open',20,110),self.open}
        }
        self.openmenu=false
        self.newmenu=false
        self.tileselect=false
        self.dir = '/home/ian/dev/lua/house/'
        self.tiles=''
    end;
    new = function(self)
        --self.session = Session()
        self.openmenu=false
        self.newmenu={
            TextBox('filename',180,75),
            TextBox('tile width',180,160),
            TextBox('tile height',180,245),
            TextBox('map width',180,330),
            TextBox('map height',180,415),
        }
        self.launch = Button('start',600,75)
        self.tileselect={}
        local ty=75
        for _,pic in pairs(self:ls(self.dir..'assets/')) do
            table.insert(self.tileselect,Button(pic,400,ty))
            ty=ty+self.tileselect[1].height+5
        end
    end;
    open = function(self)
        self.newmenu=false
        self.openmenu={}
        local y = 110
        for _,file in pairs(self:ls(self.dir..'save/')) do
            table.insert(self.openmenu,Button(file,180,y))
            y=y+35
        end
    end;
    load = function(self,file)
        self.session = Session(file)
    end;
    update = function(self)
        if self.session then
            self.session:update()
        else
            for _,button in pairs(self.menu) do
                button[1]:update(love.mouse.getPosition())
            end
            if self.openmenu then
                for _,button in pairs(self.openmenu) do
                    button:update(love.mouse.getPosition())
                end
            end
            if self.newmenu then
                self.launch:update(love.mouse.getPosition())
                for _,button in pairs(self.tileselect) do
                    button:update(love.mouse.getPosition())
                end
            end
        end
    end;
    draw = function(self)
        if self.session then
            self.session:draw()
        else
            for _,button in pairs(self.menu) do
                button[1]:draw()
            end
            if self.openmenu then
                for _,button in pairs(self.openmenu) do
                    button:draw()
                end
            end
            if self.newmenu then
                for _,field in pairs(self.newmenu) do
                    field:draw()
                end
                for _,button in pairs(self.tileselect) do
                    button:draw()
                end
                self.launch:draw()
            end
        end
    end;
    textinput = function(self,t)
        if self.newmenu then
            for _,field in pairs(self.newmenu) do
                if field.active then
                    field:textinput(t)
                end
            end
        end
    end;
    keypressed = function(self, key)
        if self.session then
            self.session:keypressed(key)
        else
            if self.newmenu then
                for _,field in pairs(self.newmenu) do
                    field:keypressed(key)
                end
            end
        end
    end;
    mousepressed = function(self,x,y,button)
        if self.session then
            self.session:mousepressed(x,y,button)
        else
            for _,button in pairs(self.menu) do
                if button[1]:hovered(x,y) then
                    button[2](self)
                    break
                end
            end
            if self.openmenu then
                for _,button in pairs(self.openmenu) do
                    if button:hovered(x,y) then
                        local file = self.dir..'save/'..button.label
                        print(file)
                        self:load(file)
                        break
                    end
                end
            end
            if self.newmenu then
                for _,field in pairs(self.newmenu) do
                    field:mousepressed(x,y)
                end
                for _,button in pairs(self.tileselect) do
                    if button:hovered(x,y) then
                        button.selected=true
                        self.tiles=button.label
                    else
                        button.selected=false
                    end
                end
                if self.launch:hovered(x,y) then
                    self:start()
                end
            end
        end
    end;
    start = function(self)
        local prefs = Settings()
        prefs:setname(self.newmenu[1].value)
        prefs:settile(self.newmenu[2].value,self.newmenu[3].value)
        prefs:setwidth(self.newmenu[4].value)
        prefs:setheight(self.newmenu[5].value)
        print(self.tiles)
        self.session = Session(false,prefs,self.tiles)
    end;
    wheelmoved = function(self, x,y)
        self.session:wheelmoved(x,y)
    end;
    ls = function(self, dir)--Open directory look for files, save data in p. By giving '-type f' as parameter, it returns all files.
        local files,results,split = io.popen('find "'..dir..'" -type f'), {}
        for file in files:lines() do                         --Loop through all files
            split = self:split(file, '/')
            table.insert(results,split[#split])
        end
        return results
    end;

    split = function(self, str, pat)
       local t = {}  -- NOTE: use {n = 0} in Lua-5.0
       local fpat = "(.-)" .. pat
       local last_end = 1
       local s, e, cap = str:find(fpat, 1)
       while s do
          if s ~= 1 or cap ~= "" then
	         table.insert(t,cap)
          end
          last_end = e+1
          s, e, cap = str:find(fpat, last_end)
       end
       if last_end <= #str then
          cap = str:sub(last_end)
          table.insert(t, cap)
       end
       return t
   end;
}
