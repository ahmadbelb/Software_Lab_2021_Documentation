function [P, P_end] = convert_polyshape(polygon)
%
% convert_polyshape converts polyshape objects into another format for
% polygons.
% In polyshape objects, the points at the boundaries of interior regions are always
% sorted clockwise and boundaries of holes always sorted counterclockwise
% The polygons will be transformed into another format: Two lists of points
% are used to define the start and endpoints of each edge of the polygon.
%
%Inputs:
%         :polygon: a polyshape-object, that should be transformed
%Outputs:
%         :P: array of all points of the polygon
%         :P_end: array of points, that has the same length as P. Together
%                  with P, this defines all edges of the polygon in the new
%                  data-structure.
    
    
P = [];
P_end = [];
hole_boundaries = ishole(polygon); % gives logical array with length = number of boundaries
number_boundaries = length(hole_boundaries);
for i = 1:number_boundaries
    [points_x,points_y] = boundary(polygon,i);
    P_new = zeros(length(points_x)-1,2);
    P_new(:,1) = points_x(1:end-1);
    P_new(:,2) = points_y(1:end-1);
    P_end_new = zeros(length(points_x)-1,2);
    P_end_new(:,1) = points_x(2:end);
    P_end_new(:,2) = points_y(2:end);
    P = [P;P_new];
    P_end = [P_end;P_end_new];
end
end

