yy = [1 4 3 7 6 ];
xx = [6 4 16 2 14 ];
  loglog(xx,yy,'.');
  axis ([0,10000,0,10000]);
  grid on;
  xlabel('X');
  ylabel('Y');
print ('-deps', 'a-total')