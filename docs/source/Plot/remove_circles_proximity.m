% Remove circles, which have centers very close to each other.
function [radii,X,Y] = remove_circles_proximity(radii,X,Y,radii_stay,X_stay,Y_stay)

% Parameters, that can be used to tune the result:
accuracy_factor = 0.01;

% For every (remaining) circle, check, if there are close circles nearby
% If yes, only keep the largest one
% The circels with parameters ending with _stay will not be removed

%% Step1
% Therefore, first use every circle, that stays, to check, wether any other
% circle can be removed
number_circles = length(radii);

if exist('radii_stay','var')
    for i = 1:length(radii_stay)
        X_check = X_stay(i);
        Y_check = Y_stay(i);
        radius_check = radii_stay(i);
        accuracy = accuracy_factor*radius_check;
        for j = 1:number_circles
            if (X(j)-X_check)^2+(Y(j)-Y_check)^2 < accuracy
                radii(j) = 0;
            end
        end
    end
end

% Keep only circles with nonzero-radius
remaining_indices = find(radii);
X = X(remaining_indices);
Y = Y(remaining_indices);
radii = radii(remaining_indices);

%% Step2
% Now, the remaining circles are checked, wether some can be removed
if ~isempty(radii)
    
number_circles = length(radii);
    
X_check = X(1);
Y_check = Y(1);
radius_check = radii(1);
accuracy = accuracy_factor*radius_check;
index_check = 1;

for i = 2:number_circles
    for j = i:number_circles
        if (X(j)-X_check)^2+(Y(j)-Y_check)^2 < accuracy
            if radii(j) > radius_check
                radii(index_check) = 0;
                X_check = X(j);
                Y_check = Y(j);
                radius_check = radii(j);
                accuracy = accuracy_factor*radius_check;
                index_check = j;
            else
                radii(j) = 0;
            end
        end
    end
    X_check = X(i);
    Y_check = Y(i);
    radius_check = radii(i);
    accuracy = accuracy_factor*radius_check;
    index_check = i;
end

%Keep only circles with nonzero-radius
remaining_indices = find(radii);
X = X(remaining_indices);
Y = Y(remaining_indices);
radii = radii(remaining_indices);

end

end
