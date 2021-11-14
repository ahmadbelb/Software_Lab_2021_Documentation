% Function
function varargout = game(varargin)
% GAME MATLAB code for game.fig
% game - controls the GUI game Rock Paper Scissors
%
%----------------
% START THE GAME
%----------------
% The game can be started by entering game in the command window or
% executing the file game.fig.
%
%------------
% GAME TYPES
%------------
% The current version consists of two game types.
% In the left column you can choose between
% Game Type "User v. PC"
% Game Type "Simulation"
%
% For every game type the three provided policies can be choosen. Predict 1
% allows the input of two parameters a and b, where 0 <= a <= b <= 1.
%
% For game type "User v. PC" new buttons for the manual choice of either 
% rock, paper or scissors show up in the middle.
%
% For game type "Simulation" the player can choose the number of rounds to
% be simulated as well as a user defined transition matrix. The remaining 
% simulation time is shown by the progress bar.
%
%-----------------------
% RESULT REPRESENTATION 
%-----------------------
% In the second column a graphical representation of the history of the 
% game is provided. Additionally the total number of rounds, wins, losses
% and draws can be seen above. Underneath the current round result, i.e.
% the choice of the computer, can be found.
%
%---------------
% SAVE THE GAME
%---------------
% Accumulated game data, consisting of the transition matrices transm,
% transm2 and the result vector, can be saved in a .mat-file via the save
% button in the lower row of the GUI.
%   transm      3x3 right stochastic matrix
%                prediction of the next human player move
%   transm2     3x3 right stochastic matrix
%                prediction of the next computer player move
%   result      1xn integer result vector, where n is the total number of
%                rounds; result(i) represents the current number of human 
%                player wins in round i
% The save games are stored in the current folder with filname
% "data_x_y_n.mat", where x = game type, y = policy and n the number of
% rounds played. If already existing, the filename will be extended to
% "data_x_y_n_noZZZ.mat", where ZZZ is a three digit number filled with
% leading zeros. 
%
%---------------
% EXIT THE GAME
%---------------
% To exit the game just press the Exit-button on the lower left. The window
% will close automatically. 
%

%%%
% Begin initialization code --- DO NOT EDIT ---
%%%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @game_OpeningFcn, ...
    'gui_OutputFcn',  @game_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
%%%
% End initialization code
%%%


%
%%% --- SECTION WHERE YOU CAN EDIT (MODIFY/ADD FUNCTIONS AS NEEDED) --- %%%
%


% --- Executes on button press in pushbuttonsave.
function pushbuttonsave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% save last transition matrix and anything else you want saved before exit
global transm transm2 results numrounds policy gametype
filename = strcat('data_',num2str(gametype),'_',...
    num2str(policy),'_',num2str(numrounds));

% check if file with same name already exists (prevent overwriting)
if exist(sprintf([filename,'.mat']),'file') == 2
    filename_temp = sprintf([filename,'_no001']);
    k = 2;
    % rename until unused name is found
    while exist(sprintf([filename_temp,'.mat']),'file') == 2
        filename_temp = sprintf([filename,'_no',num2str(k,'%03d')]);
        k = k + 1;
    end
    filename = filename_temp;
end
save(filename,'transm','transm2','results')


function testChoice(userchoice,handles)
global history nowins nolosses nodraws results
%history
switch userchoice
    case 1 % rock
        if history(end,1) == 3
            nowins = nowins + 1;
            result = 'You win, computer chose scissors!';
        elseif history(end,1) == 1
            nodraws = nodraws + 1;
            result = 'Draw, computer chose rock as well!';
        else 
            nolosses = nolosses + 1;
            result = 'You lose, computer chose paper!';
        end
    case 2 % paper
        if history(end,1) == 1
            nowins = nowins + 1;
            result = 'You win, computer chose rock!';
        elseif history(end,1) == 2
            nodraws = nodraws + 1;
            result = 'Draw, computer chose paper as well!';
        else
            nolosses = nolosses + 1;
            result = 'You lose, computer chose scissors!';
        end
    case 3 % scissors
        if history(end,1) == 2
            nowins = nowins + 1;
            result = 'You win, computer chose paper!';
        elseif history(end,1) == 3
            nodraws = nodraws + 1;
            result = 'Draw, computer chose scissors as well!';
        else
            nolosses = nolosses + 1;
            result = 'You lose, computer chose rock!';
        end
end
handles.textlosses.String = strcat('Losses: ',num2str(nolosses));
handles.textwins.String = strcat('Wins: ',num2str(nowins));
handles.textdraws.String = strcat('Draws: ',num2str(nodraws));
norounds = size(history,1);
handles.textround.String = strcat('Round: ',num2str(norounds));
handles.textresult.String = result;
results = [results,nowins-nolosses];
history(end,2) = userchoice;
history
if norounds == 1
    line([1,1],[0,results],'Parent',handles.axes,'LineWidth',3)
    next = mchoice(norounds,0,0);
else
    plot(handles.axes,1:norounds,results,'LineWidth',3)
    %history
    next = mchoice(norounds,history(end-1,2),history(end,2),history(end-1,1),history(end,1));   % human
end
history = [history;[next,0]];
%history


%
%%% --- DO NOT EDIT THE CODE BELOW ---  %%%
%


% --- Executes just before game is made visible.
function game_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to game (see VARARGIN)

global history nowins nolosses nodraws results policy numrounds
% Choose default command line output for game
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

policy = 1; numrounds = 1;
history = [randi(3),0];
%history
nowins = 0; nolosses = 0; nodraws = 0; results = [];
handles.textlosses.String = strcat('Losses: ',num2str(nolosses));
handles.textwins.String = strcat('Wins: ',num2str(nowins));
handles.textdraws.String = strcat('Draws: ',num2str(nodraws));
handles.textround.String = strcat('Round: ',num2str(size(history,1)-1));

handles.axes.Title.String = '#Wins-#Losses vs. #Rounds'; 
handles.axes.FontSize = 12;

% UIWAIT makes game wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = game_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbuttonrock.
function pushbuttonrock_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonrock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global numrounds
numrounds = numrounds + 1;
testChoice(1,handles);

% --- Executes on button press in pushbuttonpaper.
function pushbuttonpaper_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonpaper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global numrounds
numrounds = numrounds + 1;
testChoice(2,handles);

% --- Executes on button press in pushbuttonscissors.
function pushbuttonscissors_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonscissors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global numrounds
numrounds = numrounds + 1;
testChoice(3,handles);


% --- Executes on button press in pushbuttonstart.
function pushbuttonstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global policy numrounds gametype param_a param_b

% Interpret GUI information
gametype = str2double(handles.gametypegroup.SelectedObject.Tag(end));
policy = str2double(handles.policiesgroup.SelectedObject.Tag(end));
numrounds = 0; % as a default

param_a = 0; param_b = 0; % some default values

if policy == 1 % check the policy parameters
    param_a = str2double(handles.editparam1.String);
    param_b = str2double(handles.editparam2.String);
    if param_a < 0 || param_a > 1 || param_b < 0 || ...
            param_b > 1 || param_a > param_b
        handles.texterror.String = 'ERROR: Invalid transition matrix! Retry';
        return;
    end
end

switch gametype
    case 1
        % disable/enabele GUI elements
        handles.gametype1.Enable = 'Off';
        handles.gametype2.Enable = 'Off';
        handles.noroundsedit.Enable = 'Off';
        handles.policy1.Enable = 'Off';
        handles.policy2.Enable = 'Off';
        handles.policy3.Enable = 'Off';
        handles.checkboxtransm.Enable = 'Off';
        handles.fixedtransm11.Enable = 'Off';
        handles.fixedtransm12.Enable = 'Off';
        handles.fixedtransm13.Enable = 'Off';
        handles.fixedtransm21.Enable = 'Off';
        handles.fixedtransm22.Enable = 'Off';
        handles.fixedtransm23.Enable = 'Off';
        handles.fixedtransm31.Enable = 'Off';
        handles.fixedtransm32.Enable = 'Off';
        handles.fixedtransm33.Enable = 'Off';
        set(hObject,'Visible','Off');
        
        handles.editparam1.Enable = 'Off';
        handles.editparam2.Enable = 'Off';

        handles.textresult.Visible = 'On';
        handles.texterror.Visible = 'Off';
        
        % Enable player buttons
        handles.pushbuttonrock.Visible = 'On';
        handles.pushbuttonpaper.Visible = 'On';
        handles.pushbuttonscissors.Visible = 'On';
        
        % Enable exit and save buttons
        handles.pushbuttonexit.Visible = 'On';
        handles.pushbuttonsave.Visible = 'On';
    case 2
        htransm = [];
        % check if transition matrix is given by user directly
        if handles.checkboxtransm.Value == 1
            % get htransm and check it
            htransm = ...
               [double(sym(handles.fixedtransm11.String)), ...
                double(sym(handles.fixedtransm12.String)), ...
                double(sym(handles.fixedtransm13.String)); ...
                double(sym(handles.fixedtransm21.String)), ...
                double(sym(handles.fixedtransm22.String)), ...
                double(sym(handles.fixedtransm23.String)); ...
                double(sym(handles.fixedtransm31.String)), ...
                double(sym(handles.fixedtransm32.String)), ...
                double(sym(handles.fixedtransm33.String))];
            if check_transm(htransm) == 0
                handles.texterror.String = sprintf(strcat( ...
                    'ERROR: Invalid transition matrix! Retry', ...
                    ' using rational entries (e.g. 2/3, 5/7 etc.)'));
                return
            end
        end        
        % get number of simulated rounds
        numrounds = max(1,round(str2double(handles.noroundsedit.String)));
        
        % disable/enabele GUI elements
        handles.gametype1.Enable = 'Off';
        handles.gametype2.Enable = 'Off';
        handles.noroundsedit.Enable = 'Off';
        handles.policy1.Enable = 'Off';
        handles.policy2.Enable = 'Off';
        handles.policy3.Enable = 'Off';
        handles.checkboxtransm.Enable = 'Off';
        handles.fixedtransm11.Enable = 'Off';
        handles.fixedtransm12.Enable = 'Off';
        handles.fixedtransm13.Enable = 'Off';
        handles.fixedtransm21.Enable = 'Off';
        handles.fixedtransm22.Enable = 'Off';
        handles.fixedtransm23.Enable = 'Off';
        handles.fixedtransm31.Enable = 'Off';
        handles.fixedtransm32.Enable = 'Off';
        handles.fixedtransm33.Enable = 'Off';
        set(hObject,'Visible','Off');
        
        handles.editparam1.Enable = 'Off';
        handles.editparam2.Enable = 'Off';

        handles.textresult.Visible = 'On';
        handles.texterror.Visible = 'Off';
        
        % run simulation
        run_sim(handles, htransm);
        
        % show exit and save buttons when done
        handles.pushbuttonexit.Visible = 'On';
        handles.pushbuttonsave.Visible = 'On';
    otherwise
        disp('How did you manage to get here? You shouldn",t be seeing this...');
end


%%% Main function for the simulation gametype
function run_sim(handles, htransm)
global numrounds

wbh = waitbar(0,'Simulation in progress');
if isempty(htransm)
    userchoice = randi(3); % first move is random; no need for a strategy
    testChoice(userchoice,handles);
    for i=2:numrounds
        userchoice = gen_human_move(i); % explicit strategy instead of a human move
        testChoice(userchoice,handles);
        waitbar(i/numrounds,wbh);
    end
else
    userchoice = randi(3); % first move is random; no need for a strategy
    testChoice(userchoice,handles);
    for i=2:numrounds
        userchoice = get_move_from_transm(htransm); % get human move from transition matrix
        testChoice(userchoice,handles);
        waitbar(i/numrounds,wbh);
    end
end

delete(wbh);


%%% Get the move of the player from a given transition matrix
function userchoice = get_move_from_transm(htransm)
% htransm = transition matrix for human moves
global history
i = history(end-1,2); % get last human move (we start with move two, so it exists!)
r = rand;
userchoice = sum(r>=cumsum([0,htransm(i,:)]));


%%% Checks if the given transition matrix is valid
function res = check_transm(htransm)
if abs(sum(htransm(1,:)) - 1) < 1e-5 && ...
   abs(sum(htransm(2,:)) - 1) < 1e-5 && ...
   abs(sum(htransm(3,:)) - 1) < 1e-5
    res = 1; return;
end
res = 0;


% --- Executes on button press in pushbuttonexit.
function pushbuttonexit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonexit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);


% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in checkboxtransm.
function checkboxtransm_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxtransm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxtransm
val = get(hObject,'Value');
if val == 1
    handles.transmgroup.Visible = 'On';
else
    handles.transmgroup.Visible = 'Off';
end


% --- Executes during object creation, after setting all properties.
function fixedtransm11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function noroundsedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noroundsedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gametype1.
function gametype1_Callback(hObject, eventdata, handles)
% hObject    handle to gametype1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gametype1
% User v. PC game
handles.noroundsgroup.Visible = 'Off';
handles.checkboxtransm.Visible = 'Off';
handles.transmgroup.Visible = 'Off';


% --- Executes on button press in gametype2.
function gametype2_Callback(hObject, eventdata, handles)
% hObject    handle to gametype2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gametype2
handles.noroundsgroup.Visible = 'On';
handles.checkboxtransm.Visible = 'On';
if handles.checkboxtransm.Value == 1
    handles.transmgroup.Visible = 'On';
else
    handles.transmgroup.Visible = 'Off';
end


% --- Executes during object creation, after setting all properties.
function editparam1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editparam1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function editparam2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editparam2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in policiesgroup.
function policiesgroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in policiesgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = handles.policiesgroup.SelectedObject.Tag(end);
if val == '1'
    handles.panelparams.Visible = 'On';
else
    handles.panelparams.Visible = 'Off';
end


% --- Executes on key press with focus on pushbuttonrock and none of its controls.
function pushbuttonrock_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonrock (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on pushbuttonpaper and none of its controls.
function pushbuttonpaper_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonpaper (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on pushbuttonscissors and none of its controls.
function pushbuttonscissors_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonscissors (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on pushbuttonsave and none of its controls.
function pushbuttonsave_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonsave (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on pushbuttonexit and none of its controls.
function pushbuttonexit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonexit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end
