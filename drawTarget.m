function [target_num,index] = drawTarget(img_rgb,region,result,WEIGHTTHRESHOLD)

[Weight,Weight_index]=sort(-result(2,:));
index = zeros(1,20);
%****************** 标定目标区域 ******************%
target_num = 0;
subplot(224),imshow(img_rgb);hold on;
for i = 1 : size(region,1)
    weight = result(2,Weight_index(i));
    
    if(weight > WEIGHTTHRESHOLD)
        rectangle('Position',region(Weight_index(i)).BoundingBox,'Curvature',[0,0],'LineWidth',3 ,'LineStyle','-','EdgeColor','y');
        target_num = target_num + 1;
        index(target_num) =  Weight_index(i);
    end
end