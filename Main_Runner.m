filename='C:\picture 1.bmp';
J=imread(filename);
I=J;
I=I(183:721,171:1115,:);
I=I(:,6:942,:);
I=I(2:504,6:936,:);

I=imrotate(I,360);

%I=I(151:721,61:1199,:);


C=I;
imshow(C);
[h,w,~]=size(I);


for i=1:h 
    for j=1:w
       if I(i,j,1)>150 && I(i,j,2)<90 && I(i,j,3)<90
            I(i,j,1)=255;I(i,j,2)=0;I(i,j,3)=0;
       end
    end
end


for i=1:h 
    for j=1:w
       if I(i,j,1)==255 && I(i,j,2)==0 && I(i,j,3)==0
            C(i,j,1)=0;C(i,j,2)=255;C(i,j,3)=0;
       end
    end
end

for i=1:h 
    for j=1:w
       if C(i,j,1)>130 && C(i,j,2)<140 && C(i,j,3)<110
            C(i,j,1)=0;C(i,j,2)=0;C(i,j,3)=0;
       end
    end
end

for i=1:h %BLACK
    for j=1:w
       if C(i,j,1)<70 && C(i,j,2)<80 && C(i,j,3)<70
            C(i,j,1)=0;C(i,j,2)=0;C(i,j,3)=0;
       end
    end
end

% for i=1:h %BLACK
%     for j=1:w
%        if C(i,j,1)<90 && C(i,j,2)>115 && C(i,j,3)<100
%             C(i,j,1)=0;C(i,j,2)=0;C(i,j,3)=0;
%        else
%            C(i,j,1)=255;C(i,j,2)=255;C(i,j,3)=255;
%        end
%     end
% end

for i=1:h %Blue to black
    for j=1:w
       if C(i,j,1)<90 && C(i,j,2)<110 && C(i,j,3)>150
            C(i,j,1)=0;C(i,j,2)=0;C(i,j,3)=0;
       end
    end
end

for i=1:h %white to black
    for j=1:w
       if C(i,j,1)>200 && C(i,j,2)>200 && C(i,j,3)>150
            C(i,j,1)=0;C(i,j,2)=0;C(i,j,3)=0;
       end
    end
end

for i=1:h %BLACK only black
    for j=1:w
       if C(i,j,1)==0 && C(i,j,2)==0 && C(i,j,3)==0
            C(i,j,1)=0;C(i,j,2)=0;C(i,j,3)=0;
       else
           C(i,j,1)=255;C(i,j,2)=255;C(i,j,3)=255;
       end
    end
end


C=rgb2gray(C);
C=~C;
C=imfill(C,'holes');
imshow(C);
bm=regionprops(C,'area','centroid');
AllAreas=[bm.Area];
[L,i]=sort(AllAreas,'descend');
AllAreas(i);
[Areas]=[AllAreas(i)];
NewAreas=Areas(1:9);

NewStruct=bm(i);
NewStruct=NewStruct(1:10);




 RemoteName = 'PX1178';
  instrhwinfo('Bluetooth', RemoteName)
b = Bluetooth(RemoteName, 1);
b.Terminator='CR';
fopen(b);

fprintf(1,'\n DONE BT init\n');

 pause on;


fprintf(b,'%s','#GRUP#0000#');

min_red_pixels=4;
d1='N';
for a=1:(length(NewStruct)-1)
    count=0;
for k=a+1:9
    current_red_pixels=0;
    px=[NewStruct(a).Centroid(1),NewStruct(k).Centroid(1)];
    py=[NewStruct(a).Centroid(2),NewStruct(k).Centroid(2)];
    [nxc,nyc]=interpolateLine(500,px,py);
    nnxc=round(nxc);
    nnyc=round(nyc);
    for l=1:501
        if (I(nnyc(l),nnxc(l),1)>235 && I(nnyc(l),nnxc(l),2)<10 && I(nnyc(l),nnxc(l),3)<10)
            current_red_pixels=current_red_pixels+1;
        end
    end
        if current_red_pixels<min_red_pixels
                fprintf(1,'YES this route');
                
                
                
                if py(2)-py(1)<-150 && py(2)-py(1)<px(2)-px(1) 
                   d2='N';
                end
                if px(2)-px(1)>150 && px(2)-px(1)>py(2)-py(1)
                   d2='E';
                end
                if py(2)-py(1)>150 && py(2)-py(1)>px(2)-px(1)
                   d2='S';
                end
                if px(2)-px(1)<-150 && px(2)-px(1)<py(2)-py(1)
                   d2='W';
                end
                %if (py(2)-py(1)<-150&&px(2)-px(1)<-150) || (py(2)-py(1)>150&&px(2)-px(1)>150)
                 %   d2='U';
                %end
                
                if ((d1=='N' && d2=='E')||( d1=='E' && d2=='S')||(d1=='S' && d2=='W') || (a==4) || (a==5))
                    fprintf(1,'   Turn RIGHT Then Forward');
                    mm=pixel2mm(px,py);
                    ms=round(mm2motorSteps(mm));
                    fprintf(1,'    move motor steps %d',ms);
                    
                   i=4;
                    while(i>1)
                        
                        v(i)=mod(ms,10);
                        next=round(ms/10);
                        ms=ms/10;
                        if next>ms
                            next=next-1;
                        end
                        ms=next;
                        i=i-1;
                        
                    end
                    v(1)=0;
                   v=num2str(v);
                   v=strcat(v,'#');
                  q(1)=v(1);
                  q(2)=v(4);
                  q(3)=v(7);
                  q(4)=v(10);
                  q(5)=v(11);
                    u='#FRWD#';
                    w=strcat(u,q);
                    
                    while(text_string)
                        text_string=fscanf(b);
                    end
                    
                    buffer1='#RSPN#0096#';
                    while(text_string)
                        text_string=fscanf(b);
                    end
                    
                     fprintf(b,'%s', buffer1);
                     pause(4);
                    while(text_string)
                        text_string=fscanf(b);
                    end
                    fprintf(1,'%s',w);
                    
                     fprintf(b,'%s',w );
                     pause(4);
                     clear u
                     clear v
                     clear w
                     
%                      text_string = fscanf(b);
%     fprintf(1,'\n The result is : %s', text_string);
% 
    % pause(1);
                    
                elseif ((d1==d2)||a==6)
                    fprintf(1,'Move forward');
                    mm=pixel2mm(px,py);
                    ms=round(mm2motorSteps(mm));
                    fprintf(1,'    move motor steps %d',ms);

                       i=4;
                    while(i>1)
                        
                        v(i)=mod(ms,10);
                        next=round(ms/10);
                        ms=ms/10;
                        if next>ms
                            next=next-1;
                        end
                        ms=next;
                        i=i-1;
                        
                    end
                    v(1)=0;
                   v=num2str(v);
                   v=strcat(v,'#');
                   q(1)=v(1);
                  q(2)=v(4);
                  q(3)=v(7);
                  q(4)=v(10);
                  q(5)=v(11);
                    u='#FRWD#';
                    w=strcat(u,q);
                     text_string = fscanf(b);
                     
                    while(text_string)
                        text_string=fscanf(b);
                    end
                    if a==2
                        buffer='#PATO#';
                        w=strcat(buffer,q);
                        fprintf(1,'%s','pato and then gripper up');
                        fprintf(b,'%s',w);
                    else
                    fprintf(b,'%s',w );
                    end
                    pause(4);
                     clear u
                     clear v
                     clear w
%                      text_string = fscanf(b);
%     fprintf(1,'\n The result is : %s', text_string);
% 
     
                    
                   % fprintf(b,'#FRWD#%4d#', ms);
                    
%                     text_string = fscanf(b);
%     fprintf(1,'\n The result is : %s', text_string);
%                     
% 
%     pause(1);
                    
                elseif (d2=='U')
                    %suggest direction
                    [path_x,path_y,d2,rd]=SuggestDirection(px(1),py(1),I,d1);
                    
                     px=[NewStruct(a).Centroid(1),path_x(end)];
                     py=[NewStruct(a).Centroid(2),path_y(end)];
                      mm=pixel2mm(px,py);
                    ms=round(mm2motorSteps(mm));
                    fprintf(1,'    move motor steps %d',ms);
                    if(rd=='F')
                       %fprintf(b,'#FRWD#%4d#',ms ); 
                         i=4;
                    while(i>1)
                        
                        v(i)=mod(ms,10);
                        next=round(ms/10);
                        ms=ms/10;
                        if next>ms
                            next=next-1;
                        end
                        ms=next;
                        i=i-1;
                        
                    end
                    v(1)=0;
                    
                   v=num2str(v);
                   v=strcat(v,'#');
                  q(1)=v(1);
                  q(2)=v(4);
                  q(3)=v(7);
                  q(4)=v(10);
                  q(5)=v(11);
                    u='#FRWD#';
                    w=strcat(u,q);
                    while(text_string)
                        text_string=fscanf(b);
                    end
                    fprintf(b,'%s',w );
                    pause(4);
                     clear u
                     clear v
                     clear w
%                        text_string = fscanf(b);
%     fprintf(1,'\n The result is : %s', text_string);
% 
     
                        
                    end
                    
                    if(rd=='L')
                        
                        buffer1='#LSPN#0096#';
                        while(text_string)
                        text_string=fscanf(b);
                        end
                    
                        fprintf(b,'%s', buffer1);
                        pause(4);
                       i=4;
                    while(i>1)
                        
                        v(i)=mod(ms,10);
                        next=round(ms/10);
                        ms=ms/10;
                        if next>ms
                            next=next-1;
                        end
                        ms=next;
                        i=i-1;
                        
                    end
                    v(1)=0;
                   v=num2str(v);
                   v=strcat(v,'#');
                   q(1)=v(1);
                  q(2)=v(4);
                  q(3)=v(7);
                  q(4)=v(10);
                  q(5)=v(11);
                    u='#FRWD#';
                    w=strcat(u,q);
                    while(text_string)
                        text_string=fscanf(b);
                    end
                    
                    fprintf(b,'%s',q );
                    pause(4);
                     clear u
                     clear v
                     clear w
                        %fprintf(b,'#FRWD#%4d#',ms );
%                         text_string = fscanf(b);
%     fprintf(1,'\n The result is : %s', text_string);
% 
     
                        
                    end
                    
                    if(rd=='R')
                        
                       buffer1='#RSPN#0096#';
                       while(text_string)
                        text_string=fscanf(b);
                       end
                       
                       fprintf(b,'%s', buffer1);
                       pause(4);
%                        %fprintf(b,'#FRWD#%4d#',ms );
                         i=4;
                    while(i>1)
                        
                        v(i)=mod(ms,10);
                        next=round(ms/10);
                        ms=ms/10;
                        if next>ms
                            next=next-1;
                        end
                        ms=next;
                        i=i-1;
                        
                    end
                    v(1)=0;
                   v=num2str(v);
                   v=strcat(v,'#');
                   q(1)=v(1);
                  q(2)=v(4);
                  q(3)=v(7);
                  q(4)=v(10);
                  q(5)=v(11);
                    u='#FRWD#';
                    w=strcat(u,v);
                    while(text_string)
                        text_string=fscanf(b);
                    end
                    
                    fprintf(b,'%s',q );
                    pause(4);
                    clear u
                     clear v
                     clear w
%                        text_string = fscanf(b);
%     fprintf(1,'\n The result is : %s', text_string);
% 
     
                       
                    end
                    
                    
                    temp=NewStruct(a+1);
                    NewStruct(a+1).Centroid(1)=path_x(end);
                    NewStruct(a+1).Centroid(2)=path_y(end);
                    NewStruct(end+1)=temp;
                    break;
                else
                    fprintf(1,'   Turn LEFT Then Forward');
                    mm=pixel2mm(px,py);
                    ms=round(mm2motorSteps(mm));
                    fprintf(1,'    move motor steps %d',ms);
                     buffer1='#LSPN#0096#';
                     while(text_string)
                        text_string=fscanf(b);
                     end
                    
                     fprintf(b,'%s', buffer1);
                     pause(4);
%                      %fprintf(b,'#FRWD#%4d#', ms);
                       i=4;
                    while(i>1)
                        
                        v(i)=mod(ms,10);
                        next=round(ms/10);
                        ms=ms/10;
                        if next>ms
                            next=next-1;
                        end
                        ms=next;
                        i=i-1;
                        
                    end
                    v(1)=0;
                   v=num2str(v);
                   v=strcat(v,'#');
                    q(1)=v(1);
                  q(2)=v(4);
                  q(3)=v(7);
                  q(4)=v(10);
                  q(5)=v(11);
                    u='#FRWD#';
                    w=strcat(u,v);
                    while(text_string)
                        text_string=fscanf(b);
                    end
                    
                    fprintf(b,'%s',q );
                    pause(4);
                    clear u
                     clear v
                     clear w
%                      text_string = fscanf(b);
%     fprintf(1,'\n The result is : %s', text_string);
% 
     
                    
                    
                end
                d1=d2;
                
                
                
                CurrentStructure=NewStruct(k);
                NewStruct(k)=NewStruct(a+1);
                NewStruct(a+1)=CurrentStructure;
               
                
                
                
         else
                fprintf(1,'Not This Route');
                count=count+1;
        end
    
end
if a==6
    fprintf(1,'%s','      Gripper up');
    grp='#GRUP#0000#';
    fprintf(b,'%s',grp);
    pause(4);
end
end



 if py(2)-py(1)<-150
     d2='N';
 end
 if px(2)-px(1)>150
     d2='E';
 end
 if py(2)-py(1)>150
     d2='S';
 end
 if px(2)-px(1)<-150
     d2='W';
 end

