function []=plot_STL(V,F,color)
% 
% plot_STL plots a geometry, which is given in an stl-like datastructure.
% It either plots a mesh, if the color is "none", or it plots filled faces,
% if the color is "yes".
%
%Inputs:
%           :V,F: vertices and faces of the given geometry
%           :color: if "none", only the edges are plotted, if "yes", the faces
%                   are filled with color
%Outputs:
%           :no outputs

AofT=length(F(:,1));
if nargin < 3
    color = "yes";
end
if color == "none"
    for i=1:AofT
        x_values = [V(F(i,1),1),V(F(i,2),1),V(F(i,3),1),V(F(i,1),1)];
        y_values = [V(F(i,1),2),V(F(i,2),2),V(F(i,3),2),V(F(i,1),2)];
        z_values = [V(F(i,1),3),V(F(i,2),3),V(F(i,3),3),V(F(i,1),3)];
        plot3(x_values,y_values,z_values,'k')
        hold on 
    end 
else
    for i=1:AofT

        xt=V(i*3-2:i*3,1);
        yt=V(i*3-2:i*3,2);
        zt=V(i*3-2:i*3,3);
        fill3(xt,yt,zt,'blue');
        hold on 
    end 
end
end