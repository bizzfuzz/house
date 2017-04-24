Settings = Class
{
    init = function(self,saved)
        if saved then
            self.width=saved.width
            self.height = saved.height
            --self.scale = saved.scale
            self.twidth = saved.twidth
            self.theight = saved.theight
        end
        self.scale=1
        self.x,self.y=0,0
    end;
    setname = function(self,name)
        self.name=name
    end;
    setx = function(self,x)
        self.x=x
    end;
    sety = function(self,y)
        self.y=y
    end;
    setwidth = function(self,width)
        self.width=width
    end;
    setheight = function(self,height)
        self.height=height
    end;
    setscale = function(self,scale)
        self.scale=scale
    end;
    settile = function(self,tsize)
        self.twidth=tsize
        self.theight=tsize
    end;
    settile = function(self,wid,hei)
        self.twidth=wid
        self.theight=hei
    end;
}
