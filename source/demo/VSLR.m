function varargout = VSLR(varargin)
% VSLR MATLAB code for VSLR.fig
%      VSLR, by itself, creates a new VSLR or raises the existing
%      singleton*.
%
%      H = VSLR returns the handle to a new VSLR or the handle to
%      the existing singleton*.
%
%      VSLR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VSLR.M with the given input arguments.
%
%      VSLR('Property','Value',...) creates a new VSLR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VSLR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VSLR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VSLR

% Last Modified by GUIDE v2.5 12-Jul-2016 09:43:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VSLR_OpeningFcn, ...
                   'gui_OutputFcn',  @VSLR_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before VSLR is made visible.
function VSLR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VSLR (see VARARGIN)

% Choose default command line output for VSLR
handles.output = hObject;
%load file model
global model1;
global model2;
model1 = libsvmloadmodel('model_lbp_static_12.model',2891);
model2 = libsvmloadmodel('model_lbp_dynamic_15_poly.model',2891);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VSLR wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VSLR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnBrowse.
function btnBrowse_Callback(hObject, eventdata, handles)
handles.stop_now = 0;
guidata(hObject,handles); 

% hObject    handle to btnBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName FilePath]=uigetfile(('*.3gp;*.avi'),'Select video');
checkDB = get(handles.groupDB,'SelectedObject');
checkDB = get(checkDB,'Tag');
if ischar(FileName)
    global model1;
    global model2;
    set(handles.btnResultVideo,'String','');
    switch checkDB
        case 'rbtnDB2'
            vid = VideoReader([FilePath FileName]);
            set(handles.nameVideo,'Title',FileName);
            label_Num = [150 152 157 161 162 165 176 177 180 183 185 186 187 189 195];
            label_Text = {'<HTML>Gia &#273;ình' '<HTML>Ng&#432;&#7901;i' 'Bà' ...
                '<HTML>C&#7853;u' 'Dì' '<HTML>D&#432;&#7907;ng' 'Em bé' ...
                '<HTML>Tr&#7867; em' '<HTML>H&#7885; hàng' 'Cháu' ...
                '<HTML>Máu m&#7911;' '<HTML>Th&#7871; h&#7879;' ...
                '<HTML>Tr&#7867;' '<HTML>Tu&#7893;i' '<HTML>&#272;ám c&#432;&#7899;i'};

            k = 1; 
            while ~(handles.stop_now | k > vid.NumberOfFrames)   
                tic
                I = read(vid,k);
                imshow(I,'Parent',handles.showImage);
                pause(1/1000000000);
                frameGray = preprocessing(I);
               
                compute_Features = computeLBPFeatures(frameGray);
                predict_label(k) = svmpredict(0,double(compute_Features),model2);

                i = find(label_Num==predict_label(k));

                set(handles.txtResult,'String',label_Text(i));  
                handles = guidata(hObject);  
                k = k + 1;
                toc
            end
            i = find(label_Num==mode(predict_label));
            set(handles.btnResultVideo,'String',label_Text(i));  
        case 'rbtnDB1'      
            vid = VideoReader([FilePath FileName]);
            set(handles.nameVideo,'Title',FileName);
            label_Num = [151 153 154 155 156 158 159 160 172 179 188 199];
            label_Text = {'NHÀ' 'BA' 'CON' '<HTML>M&#7864;' 'ÔNG' 'BÁC' 'CHÚ' 'CÔ' 'EM' 'EM' 'GIÀ' 'ÚT'};
            k = 1; 
            while ~(handles.stop_now | k > vid.NumberOfFrames)   
                tic
                I = read(vid,k);
                imshow(I,'Parent',handles.showImage);
                pause(1/10000000000);
                frameGray = preprocessing(I);
                compute_Features = computeLBPFeatures(frameGray);
                predict_label(k) = svmpredict(0,double(compute_Features),model1);

                i = find(label_Num==predict_label(k));

                set(handles.txtResult,'String',label_Text(i));  
                handles = guidata(hObject);  
                k = k + 1;
                toc
            end
             i = find(label_Num==mode(predict_label));
            set(handles.btnResultVideo,'String',label_Text(i)); 
    end
end


% --- Executes on button press in btnStop.
function btnStop_Callback(hObject, eventdata, handles)
% hObject    handle to btnStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stop_now = 1;
guidata(hObject, handles); % Update handles structure
