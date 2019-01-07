function scroll_wheel
% Shows how to use WindowScrollWheelFcn property
%
   f = uifigure('WindowScrollWheelFcn',@figScroll,'Name','Scroll Wheel Demo');
   x = 0:.1:40;
   y = 4.*cos(x)./(x+2);
   a = axes(f); 
   h = plot(a,x,y);
   title(a,'Rotate the scroll wheel')

   function figScroll(~,event)
      if event.VerticalScrollCount > 0 
         xd = h.XData;
         inc = xd(end)/20;
         x = [0:.1:xd(end)+inc];
         re_eval(x)
      elseif event.VerticalScrollCount < 0 
         xd = h.XData;
         inc = xd(end)/20;
         % Don't let xd = 0
         x = [0:.1:xd(end)-inc+.1]; 
         re_eval(x)
      end
   end

   function re_eval(x)
      y = 4.*cos(x)./(x+2);
      h.YData = y;
      h.XData = x;
      a.XLim = [0 x(end)];
      drawnow
   end
end