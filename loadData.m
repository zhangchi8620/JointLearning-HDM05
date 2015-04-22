function loadData(path, mode)
    path = [path, mode, '/'];
    numInstance = 1;
    for folder=1:11
        % list all ACM files
        files = dir([path,num2str(folder),'/*.amc']);        
%         delete(['train/',num2str(folder),'/*.mat']);
        numAmcFile = size(files, 1);
        for i = 1 : numAmcFile
            % extract subject name of ACM flie
            s = strsplit(files(i).name,{'_'});
            subName = s{2};        
            
            skelFile = [path,num2str(folder), '/HDM_', subName, '.asf'];
            motFile = [path,num2str(folder),'/', files(i).name];
            [skel,mot]  = readMocap(skelFile, motFile);
            video(numInstance).action = folder;
            video(numInstance).subject = subName;
            video(numInstance).mot = mot;
            video(numInstance).skel = skel;
            
            numInstance = numInstance+1;
        end
    end

     for i = 1 : size(video,2)

        mot = video(i).mot;
     
%         plotSkt(video(i).data.skel, video(i).data.mot);

        root = mot.jointTrajectories{trajectoryID(mot,'root')};
        neck = mot.jointTrajectories{trajectoryID(mot,'neck')};
        
        %RArm
        rshoulder = mot.jointTrajectories{trajectoryID(mot,'rshoulder')};
        relbow = mot.jointTrajectories{trajectoryID(mot,'relbow')};
        rwrist = mot.jointTrajectories{trajectoryID(mot,'rwrist')};
        %LArm
        lshoulder = mot.jointTrajectories{trajectoryID(mot,'lshoulder')};
        lelbow = mot.jointTrajectories{trajectoryID(mot,'lelbow')};
        lwrist = mot.jointTrajectories{trajectoryID(mot,'lwrist')};
        
        %RLeg
        rhip = mot.jointTrajectories{trajectoryID(mot,'rhip')};
        rknee = mot.jointTrajectories{trajectoryID(mot,'rknee')};
        rankle = mot.jointTrajectories{trajectoryID(mot,'rankle')};
        %LLeg
        lhip = mot.jointTrajectories{trajectoryID(mot,'lhip')};
        lknee = mot.jointTrajectories{trajectoryID(mot,'lknee')};
        lankle = mot.jointTrajectories{trajectoryID(mot,'lankle')};
        
%         %% plot
%     if i== 7
%         for time = 1 : size(rshoulder,2)
%             x = [rshoulder(1,time);relbow(1,time);rwrist(1,time);
%                  lshoulder(1,time);lelbow(1,time);lwrist(1,time);
%                  rhip(1,time);rknee(1,time);rankle(1,time);
%                  lhip(1,time);lknee(1,time);lankle(1,time);
%                  neck(1,time);root(1,time)];
%             y = [rshoulder(2,time);relbow(2,time);rwrist(2,time);
%                  lshoulder(2,time);lelbow(2,time);lwrist(2,time);
%                  rhip(2,time);rknee(2,time);rankle(2,time);
%                  lhip(2,time);lknee(2,time);lankle(2,time);
%                  neck(2,time);root(2,time)];
%             z = [rshoulder(3,time);relbow(3,time);rwrist(3,time);
%                  lshoulder(3,time);lelbow(3,time);lwrist(3,time);
%                  rhip(3,time);rknee(3,time);rankle(3,time);
%                  lhip(3,time);lknee(3,time);lankle(3,time);
%                  neck(3,time);root(3,time)];
%                     
%         S = [x, y, z];
%         
%         plot3(x,y,z, 'r.');
%         plot3(S(end,1), S(end,2), S(end, 3), 'b*');
% 
%         c1 = [1,2,4,5,7,8,10,11, 13,13,13, 7, 10];
%         c2 = [2,3,5,6,8,9,11,12,  1, 4,14,14,14];
%         for i = 1 :size(c1,2)
%             line([S(c1(i),1) S(c2(i),1)], [S(c1(i),2) S(c2(i),2)], [S(c1(i),3) S(c2(i),3)]);           
%         end
%         pause;
%         
%         end
% end
        %% cal theta
        theta = asin(-(rshoulder(3,:) - relbow(3,:)) ./ dist(rshoulder, relbow));
        theta =[theta; -asin((rshoulder(1,:) - relbow(1,:)) ./ dist(rshoulder, relbow))];
        theta =[theta; -asin((relbow(1,:) - rwrist(1,:)) ./ dist(relbow, rwrist))];
        
        theta =[theta; acos( ...
        (dist(rshoulder, rwrist).^2 - dist(rshoulder, relbow).^2 - dist(relbow,rwrist).^2)./ ...
        (2*dist(rshoulder,relbow).*dist(relbow,rwrist)) ...
        )];

        theta =[theta; asin(-(lshoulder(3,:) - lelbow(3,:)) ./ dist(lshoulder, lelbow))];
        theta =[theta; -asin((lshoulder(1,:) - lelbow(1,:)) ./ dist(lshoulder, lelbow))];
        theta =[theta; -asin((lelbow(1,:) - lwrist(1,:)) ./ dist(lelbow, lwrist))];
        theta =[theta; acos( ...
        (dist(lshoulder, lwrist).^2 - dist(lshoulder, lelbow).^2 - dist(lelbow,lwrist).^2)./ ...
        (2*dist(lshoulder,lelbow).*dist(lelbow,lwrist)) ...
        )];

        theta =[theta; asin((rhip(2,:) - rknee(2,:)) ./ dist(rhip, rknee))];
        theta =[theta; asin((rhip(1,:) - rknee(1,:)) ./ dist(rhip, rknee))];
        theta =[theta; asin((rknee(1,:) - rankle(1,:)) ./ dist(rknee, rankle))];

        theta =[theta; asin((lhip(2,:) - lknee(2,:)) ./ dist(lhip, lknee))];
        theta =[theta; asin((lhip(1,:) - lknee(1,:)) ./ dist(lhip, lknee))];
        theta =[theta; asin((lknee(1,:) - lankle(1,:)) ./ dist(lknee, lankle))];

        video(i).data = theta;
     end
    
     save(['video_', mode, '.mat'], 'video');
end

function s = numbering(x)
     m = num2str(fix(x/10));
     n = num2str(mod(x,10));   
     s = strcat('0',m,n);
end

function d = dist(p1, p2)
    d = sqrt(((p1(1,:) - p2(1,:)) .^ 2 + (p1(2,:) - p2(2,:)) .^2 + (p1(3,:) - p2(3,:)) .^2));
end

% figure;
% for time = 1 : 202
% %     set(gca, 'xlim', xlim, ...
% %              'ylim', ylim, ...
% %              'zlim', zlim);
% 
% %     rotate(h,[0 45], -180);
% %     axis([0 400 0 400 0 400])
% % 
% %     for j = 1 : 31
% %         tmp = allJoint(j);
% %         joint = tmp{1,1};
% %         x(j) = joint(1,time);
% %         y(j) = joint(2,time);
% %         z(j) = joint(3,time);
% %     end
%     x = [lshoulder(1,time);lelbow(1,time);lwrist(1,time);root(1,time)];
%     y = [lshoulder(2,time);lelbow(2,time);lwrist(2,time);root(2,time)];
%     z = [lshoulder(3,time);lelbow(3,time);lwrist(3,time);root(3,time)];
%     S = [x, y, z];
%     plot3(x,y,z, 'r.');
%     plot3(S(end,1), S(end,2), S(end, 3), 'b*');
%     plot3(S(1,1), S(1,2), S(1, 3), 'g*');
%     
%     line([S(4,1) S(1,1)], [S(4,2) S(1,2)], [S(4,3) S(1,3)]);    
%     line([S(1,1) S(2,1)], [S(1,2) S(2,2)], [S(1,3) S(2,3)]);
%     line([S(3,1) S(2,1)], [S(3,2) S(2,2)], [S(3,3) S(2,3)]);
% 
%     pause(1/10);
%     grid on;
% %     xlabel('x');
% %     ylabel('y');
% %     zlabel('z');
% end

function plotSkt(skel,mot)
    npaths = size(skel.paths,1);        
    skel_lines = cell(npaths,1);
    for current_frame = 1 : mot.nframes
        for k = 1:npaths
            path = skel.paths{k};
            nlines = length(path)-1;
            px = zeros(2,1); py = zeros(2,1); pz = zeros(2,1);
            px(1) = mot.jointTrajectories{path(1)}(1,current_frame); 
            py(1) = mot.jointTrajectories{path(1)}(2,current_frame); 
            pz(1) = mot.jointTrajectories{path(1)}(3,current_frame);        
            for j = 2:nlines % path number
                px(2) = mot.jointTrajectories{path(j)}(1,current_frame); 
                py(2) = mot.jointTrajectories{path(j)}(2,current_frame); 
                pz(2) = mot.jointTrajectories{path(j)}(3,current_frame);
                skel_lines{k}(j-1) = line(px,py,pz);
                px(1) = px(2);
                py(1) = py(2);
                pz(1) = pz(2);
            end
            px(2) = mot.jointTrajectories{path(nlines+1)}(1,current_frame); 
            py(2) = mot.jointTrajectories{path(nlines+1)}(2,current_frame); 
            pz(2) = mot.jointTrajectories{path(nlines+1)}(3,current_frame);
            skel_lines{k}(nlines) = line(px,py,pz);
        end
        pause;
        for k = 1 : npaths
        delete(skel_lines{k});
        end
    end
end