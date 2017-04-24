require 'libs.table-save'

Tiletable = Class
{
    init = function(self, saved, prefs)
        if saved then
            self.tiles = saved.tiles
            self.prefs =  Settings(saved.prefs)
            self.drawx,self.drawy=saved.drawx,saved.drawy
        else
            self.prefs=prefs
            self.drawx,self.drawy=0,0
            self:createmap()
        end
        self.show=true
    end;
    addrow = function(self)
        local new = {}
        for i=1,self.prefs.width do
            table.insert(new,false)
        end
        table.insert(self.tiles,new)
        print('hb4',self.prefs.width)
        self.prefs.height=self.prefs.height+1
        print('ha',self.prefs.width)
    end;
    addcol = function(self)
        for _,col in pairs(self.tiles) do
            table.insert(col,false)
        end
        print('wb4',self.prefs.width)
        self.prefs.width=self.prefs.width+1
        print('wa',self.prefs.width)
    end;
    draw = function(self,tiles,quads)
        if self.show then
            self.drawy=self.prefs.y
            for x,row in ipairs(self.tiles) do
                self.drawx=self.prefs.x
                for y,tile in ipairs(row) do
                    if tile then
                        --box(self.drawx,self.drawy,self.prefs.twidth,self.prefs.theight)
                        love.graphics.draw(tiles, quads[tile],self.drawx,self.drawy,0,self.prefs.scale)
                    else
                        --rbox(self.drawx,self.drawy,self.prefs.twidth,self.prefs.theight)
                        love.graphics.print(string.format('%d,%d',x,y),self.drawx,self.drawy)
                    end
                    self.drawx=self.drawx+self.prefs.twidth
                end
                self.drawy=self.drawy+self.prefs.theight
            end
        end
    end;
    mousepressed = function(self,px,py,button,xoff,yoff,value)
        for y,row in ipairs(self.tiles) do
            for x,tile in ipairs(row) do
                local test = {}
                test.width=self.prefs.twidth
                test.height=self.prefs.theight
                test.x = (x+xoff-1)*test.width
                test.y = (y+yoff-1)*test.height
                --print(test.x,test.y,test.width,test.height,xoff,yoff)
                if(colliding(px,py,test)) then
                    print('edit',px,py,value)
                    self:edit(y,x,value)
                    break
                end
            end
        end
        print('--------')
    end;
    createmap = function(self)
        self.tiles={}
        for y=1,self.prefs.height do
            self.tiles[y]={}
            for x=1,self.prefs.width do
                self.tiles[y][x]=false
            end
        end
    end;
    edit = function(self, x,y, symbol)
        self.tiles[x][y] = symbol
    end;

    removetile = function(self, x,y)
        self.tiles[x][y] = false
    end;
}
