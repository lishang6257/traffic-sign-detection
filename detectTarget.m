function [region,result ] = detectTarget(img_bigest_eroded_restruct_fill,CIRCLEWEIGHT,CIRCLESIMILARITYTHRESHOLD,AREAWEIGHTTHRESHOLD,WEIGHTTHRESHOLD) 


% %****************** 提取目标区域 ******************%
% CIRCLEWEIGHT = 0.7;
% CIRCLESIMILARITYTHRESHOLD = 0.7;
% AREAWEIGHTTHRESHOLD = 0.2;
% WEIGHTTHRESHOLD = 0.5;

region = regionprops(bwlabel(img_bigest_eroded_restruct_fill),'Area','Perimeter','Centroid','Boundingbox');


result = zeros(4,size(region,1));

[Area,Area_index]=sort(-[region.Area]);
maxarea = 0;
if size(region,1) > 1
    maxarea = -Area(1);
end

for i = 1 : size(region,1)
    
    circle_simliarity = 4*pi*region(i).Area/(region(i).Perimeter^2);
    area_weight = region(i).Area/maxarea;
    
    if circle_simliarity < CIRCLESIMILARITYTHRESHOLD
%         circle_simliarity
        circle_simliarity = 0;
    end
    
    if area_weight < AREAWEIGHTTHRESHOLD
        weight = 0;
    else 
        weight = circle_simliarity*CIRCLEWEIGHT + area_weight*(1-CIRCLEWEIGHT);
    end
    
    result(1,i) = i;
    result(2,i) = weight;
    result(3,i) = circle_simliarity;
    result(4,i) = area_weight;
    
end
