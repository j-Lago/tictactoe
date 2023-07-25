function varargout = tictactoe(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tictactoe_OpeningFcn, ...
                   'gui_OutputFcn',  @tictactoe_OutputFcn, ...
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


% --- Executes just before tictactoe is made visible.
function tictactoe_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global CELL_WIDTH; CELL_WIDTH = 126;
global CELL_HEIGHT; CELL_HEIGHT = 126;
global T; 
T   = [ 0 0 0 ;
        0 0 0 ;
        0 0 0 ]; 

    refresh(hObject, eventdata, handles)


% --- Outputs from this function are returned to the command line.
function varargout = tictactoe_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

global T; 
T   = [ 0 0 0 ;
        0 0 0 ;
        0 0 0 ]; 
    
set(handles.text2, 'String', '')
refresh(hObject, eventdata, handles)


%--------------------------------------------------------------------------
% function [board_state, outcome] = move_eval(board_state, next_move)
% sz = size(board_state);
% if  sz(1) ~= 3 || sz(2) ~= 3
%     outcome = -2;
%     return
% end
% 
% [outcome, player] = check_state(board_state);
% if outcome ~= 0
%     return
% end
% 
% 
% if length(next_move) ~= 2
%     outcome = -1;
%     return
% end
% 
% if (next_move(1) > 3 || ...
%     next_move(1) < 1 || ...
%     next_move(2) > 3 || ...
%     next_move(2) < 1)
% 
%     outcome = -1;
%     return
% end
% 
% if board_state(next_move(1), next_move(2)) ~= 0
%     outcome = -1;
%     return
% else
%     if player == 1
%         board_state(next_move(1), next_move(2)) = 1;
%     else
%         board_state(next_move(1), next_move(2)) = -1;
%     end
% end
%     
% outcome = check_state(board_state);
%     
% %end move_eval
% 
% function [outcome, next_player] = check_state(board_state)
% outcome = 0;
% next_player = 0;
% 
% sum_hor = sum(board_state);
% if sum(sum_hor == 3)
%     outcome = 1;
%     return
% elseif sum(sum_hor == -3)
%     outcome = 2;
%     return
% end
% 
% sum_ver = sum(board_state');
% if sum(sum_ver == 3)
%     outcome = 1;
%     return
% elseif sum(sum_ver == -3)
%     outcome = 2;
%     return
% end
% 
% sum_diag1 = board_state(1,1) + board_state(2,2) + board_state(3,3);
% if sum_diag1 == 3
%     outcome = 1;
%     return
% elseif sum_diag1 == -3
%     outcome = 2;
%     return
% end
% 
% sum_diag2 = board_state(3,1) + board_state(2,2) + board_state(1,3);
% if sum_diag2 == 3
%     outcome = 1;
%     return
% elseif sum_diag2 == -3
%     outcome = 2;
%     return
% end
% 
% s_zeros = 9-sum(sum(abs(board_state)));
% if s_zeros == 0
%     outcome = 3;
%     return
% end
% 
% s_total = sum(sum_hor);
% if  s_total  == 0 
%     next_player = 1;
% elseif s_total == 1
%     next_player = 2;
% else
%     outcome = -1;
%     return
% end
%end check_state
%--------------------------------------------------------------------------

function click(hObject, eventdata, handles)
   position = get( ancestor(hObject,'axes'), 'CurrentPoint' );
   button = get( ancestor(hObject,'figure'), 'SelectionType' );
   
   x = position(1, 1);
   y = position(1, 2);
   
   global CELL_WIDTH;
   global CELL_HEIGHT;
   l = ceil( ( y ) / CELL_HEIGHT );
   c = ceil( ( x ) / CELL_WIDTH );
   
   global T;
   if strcmp(button, 'normal')
       [T, o] = move_eval(T, [l,c]);
       if o == 1
           set(handles.text2, 'String', 'jogador X venceu!');
       elseif o == 2
           set(handles.text2, 'String', 'jogador O venceu!');
       elseif o == 3
           set(handles.text2, 'String', 'empate!');
       elseif o < 0
           beep;
       end
   end
   
   refresh(hObject, eventdata, handles)
   
   
function img = sprite( img, sprite, x0, y0, px, py ) 

 x0 = round(x0);
 y0 = round(y0);
 
 sz_img = size(img);
 sz_spr = size(sprite);
 
 dx = round( min( sz_spr(2) * px , sz_img(2) - x0 ) );
 dy = round( min( sz_spr(1) * py , sz_img(1) - y0 ) );

r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);

sr = sprite(:,:,1);
sg = sprite(:,:,2);
sb = sprite(:,:,3);

for x = 1:dx 
    for y = 1:dy
        if  ~( sr(y,x) <= 31 && sg(y,x) <= 31 && sb(y,x) <= 31 )
            r(y + y0, x + x0) = sr(y,x);
            g(y + y0, x + x0) = sg(y,x);
            b(y + y0, x + x0) = sb(y,x);
        end
    end
end

img(:,:,1)= r; 
img(:,:,2)= g;
img(:,:,3)= b;
   
function refresh(hObject, eventdata, handles)
global CELL_WIDTH; CELL_WIDTH = 127;
global CELL_HEIGHT; CELL_HEIGHT = 127;
global T;
axes(handles.axes1)
img = imread('board.png');
x_sprite = imread('x.png');
o_sprite = imread('o.png');

for c = 1:3
    for l = 1:3
        if T(l,c) == 1
            img = sprite(img, x_sprite, (c-1)*CELL_WIDTH, (l-1)*CELL_WIDTH, 1, 1);
        elseif T(l,c) == -1
            img = sprite(img, o_sprite, (c-1)*CELL_WIDTH, (l-1)*CELL_WIDTH, 1, 1);
        end
    end
end

imh = image(img);
axis off
axis image
set(imh,'ButtonDownFcn', {@click, handles});    



    
    



   
