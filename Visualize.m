function varargout = Visualize(varargin)
% VISUALIZE MATLAB code for Visualize.fig
%      VISUALIZE, by itself, creates a new VISUALIZE or raises the existing
%      singleton*.
%
%      H = VISUALIZE returns the handle to a new VISUALIZE or the handle to
%      the existing singleton*.
%
%      VISUALIZE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALIZE.M with the given input arguments.
%
%      VISUALIZE('Property','Value',...) creates a new VISUALIZE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Visualize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Visualize_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Visualize

% Last Modified by GUIDE v2.5 05-Dec-2020 16:38:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Visualize_OpeningFcn, ...
                   'gui_OutputFcn',  @Visualize_OutputFcn, ...
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


% --- Executes just before Visualize is made visible.
function Visualize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Visualize (see VARARGIN)

% Choose default command line output for Visualize
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes Visualize wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Visualize_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SetFolder.
function SetFolder_Callback(hObject, eventdata, handles)               
% hObject    handle to SetFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    handles.dfolder=uigetdir();   
    dfile=dir(handles.dfolder);
    dfile=dfile(3:end);
catch
    disp('No folder selected.');
    return
end

if isempty(dfile)
    disp('No file available for the chosen folder.');
    return;        
end

if dfile(1).bytes==0
    disp('Apparently not a DICOM file');
    return;
end

handles.img=readImages(handles.dfolder);

set(handles.Path,'String',char(handles.dfolder));
set(handles.TextSize1,'String',handles.img.imSz1);
set(handles.TextSize2,'String',handles.img.imSz2);
set(handles.TextSize3,'String',handles.img.imSz3);
set(handles.TextMod,'String',handles.img.modality);

set(handles.SliderMain,'Min',1);
set(handles.SliderMain,'Max',handles.img.imSz3);
set(handles.SliderMain,'Value',1);
set(handles.SliderMain,'SliderStep',[1/(handles.img.imSz3-1) , 10/(handles.img.imSz3-1)]);

set(handles.TextMain,'String',handles.SliderMain.Min);

set(handles.SliderLat1,'Min',1);
set(handles.SliderLat1,'Max',handles.img.imSz2);
set(handles.SliderLat1,'Value',1);
set(handles.SliderLat1,'SliderStep',[1/(handles.img.imSz2-1) , 10/(handles.img.imSz2-1)]);

set(handles.TextLat1,'String',handles.SliderLat1.Min);

set(handles.SliderLat2,'Min',1);
set(handles.SliderLat2,'Max',handles.img.imSz1);
set(handles.SliderLat2,'Value',1);
set(handles.SliderLat2,'SliderStep',[1/(handles.img.imSz1-1) , 10/(handles.img.imSz1-1)]);

set(handles.TextLat2,'String',handles.SliderLat2.Min);

set(handles.SliderMain,'Enable','on');
set(handles.SliderLat1,'Enable','on');
set(handles.SliderLat2,'Enable','on');

set(handles.MainRotR,'Enable','on');
set(handles.MainRotL,'Enable','on');
set(handles.Lat1RotR,'Enable','on');
set(handles.Lat1RotL,'Enable','on');
set(handles.Lat2RotR,'Enable','on');
set(handles.Lat2RotL,'Enable','on');

handles.rotMain=3;
if handles.img.modality=='CT'
    handles.rotLat1=3;
    handles.rotLat2=3;
elseif handles.img.modality=='MR'
    handles.rotLat1=1;
    handles.rotLat2=1;
elseif handles.img.modality~='CT'
    handles.rotLat1=0;
    handles.rotLat2=0;
end

colormap gray(512)
axes(handles.Main);
imagesc(imrotate(handles.img.volumes(:,:,handles.SliderMain.Min),90*handles.rotMain));
axis off
axis image

axes(handles.Lat1);
imagesc(imrotate(squeeze(handles.img.volumes(handles.SliderLat1.Min,:,:)),90*handles.rotLat1));
axis off

axes(handles.Lat2);
imagesc(imrotate(squeeze(handles.img.volumes(:,handles.SliderLat2.Min,:)),90*handles.rotLat2));
axis off

guidata(hObject,handles);


% --- Executes on slider movement.
function SliderMain_Callback(hObject, eventdata, handles)
% hObject    handle to SliderMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.SliderMain.Value=round(handles.SliderMain.Value);

colormap gray(512)
axes(handles.Main);
imagesc(imrotate(handles.img.volumes(:,:,handles.SliderMain.Value),90*handles.rotMain));
axis off
axis image

set(handles.TextMain,'String',handles.SliderMain.Value);

guidata(hObject,handles);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SliderMain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function SliderLat1_Callback(hObject, eventdata, handles)
% hObject    handle to SliderLat1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.SliderLat1.Value=round(handles.SliderLat1.Value);

colormap gray(512)
axes(handles.Lat1);
imagesc(imrotate(squeeze(handles.img.volumes(handles.SliderLat1.Value,:,:)),90*handles.rotLat1));
axis off

set(handles.TextLat1,'String',handles.SliderLat1.Value);

guidata(hObject,handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SliderLat1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderLat1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function SliderLat2_Callback(hObject, eventdata, handles)
% hObject    handle to SliderLat2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.SliderLat2.Value=round(handles.SliderLat2.Value);

colormap gray(512)
axes(handles.Lat2);
imagesc(imrotate(squeeze(handles.img.volumes(:,handles.SliderLat2.Value,:)),90*handles.rotLat2));
axis off

set(handles.TextLat2,'String',handles.SliderLat2.Value);

guidata(hObject,handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SliderLat2_CreateFcn(hObject, ~, ~)
% hObject    handle to SliderLat2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in MainRotL.
function MainRotL_Callback(hObject, eventdata, handles)
% hObject    handle to MainRotL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rotMain=handles.rotMain+1;
axes(handles.Main);
imagesc(imrotate(squeeze(handles.img.volumes(:,:,handles.SliderMain.Value)),90*handles.rotMain));
axis off
axis image
guidata(hObject,handles);

% --- Executes on button press in MainRotR.
function MainRotR_Callback(hObject, eventdata, handles)
% hObject    handle to MainRotR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rotMain=handles.rotMain-1;
axes(handles.Main);
imagesc(imrotate(squeeze(handles.img.volumes(:,:,handles.SliderMain.Value)),90*handles.rotMain));
axis off
axis image
guidata(hObject,handles);



% --- Executes on button press in Lat1RotL.
function Lat1RotL_Callback(hObject, eventdata, handles)
% hObject    handle to Lat1RotL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rotLat1=handles.rotLat1+1;
axes(handles.Lat1);
imagesc(imrotate(squeeze(handles.img.volumes(handles.SliderLat1.Value,:,:)),90*handles.rotLat1));
axis off
guidata(hObject,handles);



% --- Executes on button press in Lat1RotR.
function Lat1RotR_Callback(hObject, eventdata, handles)
% hObject    handle to Lat1RotR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rotLat1=handles.rotLat1-1;
axes(handles.Lat1);
imagesc(imrotate(squeeze(handles.img.volumes(handles.SliderLat1.Value,:,:)),90*handles.rotLat1));
axis off
guidata(hObject,handles);



% --- Executes on button press in Lat2RotL.
function Lat2RotL_Callback(hObject, eventdata, handles)
% hObject    handle to Lat2RotL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rotLat2=handles.rotLat2+1;
axes(handles.Lat2);
imagesc(imrotate(squeeze(handles.img.volumes(:,handles.SliderLat2.Value,:)),90*handles.rotLat2));
axis off
guidata(hObject,handles);



% --- Executes on button press in Lat2RotR.
function Lat2RotR_Callback(hObject, eventdata, handles)
% hObject    handle to Lat2RotR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rotLat2=handles.rotLat2-1;
axes(handles.Lat2);
imagesc(imrotate(squeeze(handles.img.volumes(:,handles.SliderLat2.Value,:)),90*handles.rotLat2));
axis off
guidata(hObject,handles);
