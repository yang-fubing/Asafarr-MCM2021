% 计算了每次抛物线上下移动相等的距离所产生的新的伸长量,第一次迭代
surface_1 = surface.';
o = zeros(2226,2);
rad = zeros(2226,2);
for i = 1:2226
% 处理第二问，需要将旋转坐标轴后的点坐标带入
    x = inv_r_base_axis(i,1);
    y = inv_r_base_axis(i,2);
    z = inv_r_base_axis(i,3);
    
    beta_d = asind(z/sqrt(x^2+y^2+z^2));
    theta_d = atand(y/x);
    beta = asin(z/sqrt(x^2+y^2+z^2));
    theta = atan(y/x);
    o(i,1) = real(beta_d);
    o(i,2) = real(theta_d);
    rad(i,1) = real(beta);
    rad(i,2) = real(theta);
end

z0 = -300.4;
F = 139.8;
unique_rad = unique(rad(:,1));
unique_angle = unique(o(:,1));
for i = 2:length(unique(rad(:,1)))
    if abs(unique_rad(i)) < pi/3 
%             由于光照区域角度是60度，所以大于一定角度的点直接舍去,根据角度索引筛出符合条件的点
%             将不在光照区域内的角度除去
        unique_rad(i) = 0;
        unique_angle(i) = 0;
        continue;
    end
end
%  去除不满足的点
unique_rad(unique_rad == 0) = [];
unique_angle(unique_angle == 0) = [];
% 能够满足正负0.6的顶点移动距离条件的顶点移动距离
success_dl = zeros(num,1);
success_index = 1;
fail_up = 0;
fail_down = 0;
max_move_length = zeros(num,0);
min_move_length = zeros(num,0);
begin = 0.1;
pace = 0.1;
final = 0.6;
num = ((final - begin)/pace + 1)*2;
update_length = zeros(2226,num);
sum = zeros(1,num);
show_length = zeros(1,length(unique_rad));

figure;
for dl = begin:pace:final
    fail_down = 0;
    x = (-500:500);
%      顶点向上移动
    z1 = z0 + dl;
%     z = x.^2/(4*(F-dl))+z1; 
%     plot(x,z)
%     hold on

%   up_result代表向上移动后，各主索节点的横坐标
    up_result = zeros(1,length(unique_rad));
    for i = 1:length(unique_rad)
        if unique_rad(i) == -pi/2 && unique_rad(i) == pi/2
%             垂直的线不画出
            continue;
        else
            z_line = tan(unique_rad(i))*x;
%             plot(x,z_line);
            syms x_1;
            eqn = tan(unique_rad(i))*x_1 == x_1^2/(4*(F-dl))+z1;
%             联立方程
            S = solve(eqn, x_1);
            S_double = double(S);
            if abs(S_double(1,1)) > abs(S_double(2,1))
                up_result(1,i) = S_double(2,1);
            else
                up_result(1,i) = S_double(1,1);
            end
        end
    end
    up_result(up_result==0) = [];
%   根据满足条件的各点横坐标计算各点到c的距离，将多次的结果都存储在update_length中, print_up是各下拉锁移动距离的绝对值
    print_up = zeros(length(up_result),1);
    for i = 1:length(up_result)
        print_up(i,1) = up_result(i)/cos(unique_rad(i)) + z0;
%         检索当前角度的主索节点
        angle_x = find(abs(o(:,1) - unique_angle(i)) < 0.000001);
        for j = 1:length(angle_x)
            update_length(angle_x(j,1),int32(num/2+dl/pace)) = abs(up_result(i)/cos(unique_rad(i)));
        end
%         第一问得到706行的update_length，第二问得到692行update_length
%         对每一次各个长度的求和
        sum(int32(num/2+dl/pace)) = sum(int32(num/2+dl/pace)) + abs(print_up(i,1));
        if abs(print_up(i,1)) > 0.6
            fail_up = 1;
            break;
        end
    end
%     假如促动器全部满足条件，视为成功
        if fail_up == 0
            success_dl(success_index,1) = dl;
            success_index = success_index + 1;
            plot(up_result(1,2:end), -print_up(2:end,1));
            hold on
            max_move_length(int32(num/2+dl/pace),1) = max(print_up(2:end,1));
            min_move_length(int32(num/2+dl/pace),1) = min(print_up(2:end,1));
        end  
    
    
%     顶点向下移动
    z2 = z0 - dl;
    down_result = zeros(1,length(unique_rad));
    for i = 1:length(unique_rad)
        if unique_rad(i) == -pi/2 && unique_rad(i) == pi/2
%             垂直的线不画出
             continue;
        else
            z_line = tan(unique_rad(i))*x;
%             plot(x,z_line);
            syms x_2;
            eqn = tan(unique_rad(i))*x_2 == x_2^2/(4*(F+dl))+z2;
%             联立方程
            S = solve(eqn, x_2);
            S_double = double(S);
            if abs(S_double(1,1)) > abs(S_double(2,1))
                down_result(1,i) = S_double(2,1);
            else
                down_result(1,i) = S_double(1,1);
            end
        end
    end
    down_result(down_result==0) = [];
%     促动器运动距离有超出范围的，失败, 继续下一次循环
    print_down = zeros(length(down_result),1);
    for i = 1:length(down_result)
        print_down(i,1) = down_result(i)/cos(unique_rad(i)) + z0;
%         检索当前角度的主索节点
        angle_x = find(abs(o(:,1) - unique_angle(i)) < 0.0001);
        for j = 1:length(angle_x)
            update_length(angle_x(j,1),int32(num/2+1-dl/pace)) = abs(down_result(i)/cos(unique_rad(i)));
        end
        sum(int32(num/2+1-dl/pace)) = sum(int32(num/2+1-dl/pace)) + abs(print_down(i,1));
        if abs(print_down(i,1)) > 0.6
            fail_down = 1;
            break;
        end
    end
    %     假如促动器全部满足条件，视为成功
   if fail_down == 0
        success_dl(success_index,1) = -dl;
        success_index = success_index + 1;
        plot(down_result(1,2:end), -print_down(2:end,1));
        hold on
        max_move_length(int32(num/2+1-dl/pace),1) = max(print_down(2:end,1));
        min_move_length(int32(num/2+1-dl/pace),1) = min(print_down(2:end,1));
   end
end
%%
% update_length(all(update_length==0,2),:) = []; 
%%



    
   