function plotfunction2(w,x,y,M,i)

    pause(0.01)
    subplot(3,1,2); stem(w); xlim([0,M+1]);ylim([-.5,.9]);
    subplot(3,1,1); plot(i,x(i),'g+');hold on; plot(i+1,y(i+1),'ro');grid on;xlim([i-100,i+1])
    subplot(3,1,3); plot(i,abs(x(i)-y(i+1)),'r.');hold on;%ylim([-.5,.5])
    
    
end