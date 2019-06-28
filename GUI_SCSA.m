%% GUI SCSA for signal denoising and reconstruction 
function varargout = GUI_SCSA(varargin)
% GUI_SCSA MATLAB code for GUI_SCSA.fig
%      GUI_SCSA, by itself, creates a new GUI_SCSA or raises the existing
%      singleton*.
%
%      H = GUI_SCSA returns the handle to a new GUI_SCSA or the handle to
%      the existing singleton*.
%
%      GUI_SCSA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SCSA.M with the given input arguments.
%
%      GUI_SCSA('Property','Value',...) creates a new GUI_SCSA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SCSA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SCSA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SCSA

% Last Modified by GUIDE v2.5 20-Jun-2019 11:55:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_SCSA_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_SCSA_OutputFcn, ...
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

% --- Executes just before GUI_SCSA is made visible.
addpath ./Functions
addpath ./Functionsm

% addpath G:\My Drive\MyCodes\GitHub\InProcess_Projects\SCSA_Rec_Denoising_Scripts\Function\SCSA_main_functions
% addpath G:\My Drive\MyCodes\GitHub\InProcess_Projects\SCSA_Rec_Denoising_Scripts\Function\SCSA_main_functions\Denoising



function GUI_SCSA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SCSA (see VARARGIN)

% Choose default command line output for GUI_SCSA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_SCSA wait for user response (see UIRESUME)
% uiwait(handles.figure1);

if strcmp(get(hObject,'Visible'),'off')

    update_displays
end






% --- Outputs from this function are returned to the command line.
function varargout = GUI_SCSA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in up_plot.
function up_plot_Callback(hObject, eventdata, handles)


arrayfun(@cla,findall(0,'type','axes'));
msg_butom=get(handles.up_plot,'string') ;
set(handles.up_plot,'string',' In process') ;
% set(handles.up_plot,'enable','off') ;
set(handles.fs,'enable','on') ;

%% Update the new signal
update_displays

%% Apply SCSA for reconstruction
SCSA_reconstruction


%% Plot the wavelent of the eigenfunctions
Plot_the_Wavelengths

            
%% compute performnace 
% yscsa3=yscsa3-(min(yscsa3)-min(gen_data));

MSE =1/immse(yscsa3,gen_data);
 %% compute Signal to Noise ratio   
[PSNR, SNR] = psnr(yscsa3,gen_data);
RLERR=(norm(yscsa3,1)-norm(gen_data,1))/norm(gen_data,1);

%% History of h values

   set(handles.psnr_a1,'string',num2str(floor(PSNR))) ;
   set(handles.h_a1,'string',num2str(floor(h))) ;
   set(handles.Nh_a1,'string',num2str(floor(Nh))) ;

%% plot SCSA reconsrtucted signal results
axes(handles.axes3);
cla;

if norm(sig_noised3-gen_data)==0
    
%         plot (New_time, sig_orgin-mean2(sig_orgin),'g','LineWidth',3) 
        plot (Totale_time, gen_data ,'g','LineWidth',3)  
        hold on 
        plot (Totale_time, yscsa3 ,'r','LineStyle',':','LineWidth',3.5)            
        lgdd=legend('Reference signal','SCSA signal');

else
%        plot (New_time, sig_orgin-mean2(sig_orgin),'g','LineWidth',3) 
        plot (Totale_time, sig_noised3,'b','LineWidth',2) 
        hold on
        plot (Totale_time, gen_data ,'g','LineWidth',3)  
        hold on 
        plot (Totale_time, yscsa3 ,'r','LineStyle',':','LineWidth',3.5)            
        lgdd=legend('Noisy  Signal ','Reference signal','SCSA signal');

end





                
                
                
                set(lgdd,'FontSize',12); 
                xlabel('Temps (s)')
%                 xlim([0 10])
%                 ylabel('Signal')
                grid on                
                title( 'Signal reconstruction using SCSA')
%                 xlabel([ ' alpha = ', num2str(-alp)])%,' betha = ', num2str(betha),' A1 = ', num2str(A1)])
                xL = xlim;yL = ylim;
                if SCSA_slice>1
                    for iter=1:SCSA_slice
                        slice_border=Totale_time(iter*SCSA_Dw_fs);
                        line([slice_border slice_border], yL,'color','c','LineStyle',':','linewidth',2) %y-axis
                        line(xL, [0 0],'color','k','linewidth',2) %x-axis
                    end
                end
%% Play the output sound
set(handles.N_a1,'string', SCSA_Dw_fs );
set(handles.MSE_a1,'string', MSE );

set(handles.MSE_a1,'string', sprintf('%.1e',MSE) );


% sound(sig_orgin,Fs_audio);                     % original
% audiowrite('sig_orgin.wav',sig_orgin,Fs_audio)
% sound(sig_noised3,Fs_audio);                     % Noised
% audiowrite('sig_noised.wav',sig_noised,Fs_audio)
% sound(yscsa3,Fs_audio);                     % Denoised
% audiowrite('yscsa3.wav',yscsa3,Fs_audio)
% 



set(handles.up_plot,'enable','on') ;
set(handles.up_plot,'string',msg_butom) ;
toc
close(figure(100))

%% Frequencial analysis 
% [freq y_fft y_psd]=Fourier_of_signal(gen_data,yscsa3,One_Sec_rate);
 

% toc
% end

%% save the output SCSA signal
% 
% sv_sig=get(handles.save_sig_reuse,'Value');
% 
% if sv_sig == 1
%  save('scsa_data.mat','yscsa3','One_Sec_rate','gen_data','Totale_time')
% end 
% set(handles.save_sig_reuse,'Value',0)
set(handles.up_plot,'string',' Signal reconstruction ') ;


%% #######   STOP PARALLELISM   #################
% delete(parallelism)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

function nb_eig_Callback(hObject, eventdata, handles)
% hObject    handle to nb_eig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nb_eig as text
%        str2double(get(hObject,'String')) returns contents of nb_eig as a double


% --- Executes during object creation, after setting all properties.
function nb_eig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nb_eig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function slice_Callback(hObject, eventdata, handles)
% hObject    handle to slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slice as text
%        str2double(get(hObject,'String')) returns contents of slice as a double


% --- Executes during object creation, after setting all properties.
function slice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on selection change in type_signal.
% function type_signal_Callback(hObject, eventdata, handles)
% % hObject    handle to type_signal (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns type_signal contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from type_signal
% 
% 
% % --- Executes during object creation, after setting all properties.
% function type_signal_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to type_signal (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


function type_signal_Callback(hObject, eventdata, handles)
update_displays     
   
function type_signal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end 
% --- Executes on selection change in acdmc_sig.
function acdmc_sig_Callback(hObject, eventdata, handles)
% hObject    handle to acdmc_sig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns acdmc_sig contents as cell array
%        contents{get(hObject,'Value')} returns selected item from acdmc_sig

       
 %%  display signal function 
   sig_num= get(handles.acdmc_sig, 'Value'); 
   sig_num=sig_num+1;  % because we ignnored constant case
   
 switch sig_num
    case 1
        msg_sig='Signal = A1';
        
    case 2
        msg_sig='Signal = A1*Rect(t/alpha) repeated alpha times of  periode 1/ alpha';
        
     case 3        
        msg_sig='Signal = A1*t + A2*t';
        
     case 4
        msg_sig='Signal = A1*t^2 + A2*t^2';
            
    case 5      
        msg_sig='Signal = A1*Exp(alpha*t) + A2*Exp(beta*t)';
        
 
    case 6
        msg_sig='Signal = A1*sin(2*pi*alpha.*t) + A2*sin(2*pi*beta.*t)';
       
    case 7
        msg_sig='Signal = A1*sinc(alpha.*t) + A2*sinc(beta.*t)';
        
      
    case 8
        msg_sig='Signal = RC circuit decharge ';
        
    case 9
        
       msg_sig='';
       
    otherwise
        msg_sig='num of the signal does mnot exist, PLZ choose an other one';
 end  
 
% set(handles.listbox2,'string',msg_sig) ;


        if sig_num==9
        set(handles.sig_equ,'Visible','on') ; 
        
        else
          set(handles.sig_equ,'Visible','off') ; 
          
        end
    

        update_displays
        
    MSE_min=max(gen_data)*0.004;
    update_displays    
% --- Executes during object creation, after setting all properties.
function acdmc_sig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acdmc_sig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sig_equ_Callback(hObject, eventdata, handles)
% hObject    handle to sig_equ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sig_equ as text
%        str2double(get(hObject,'String')) returns contents of sig_equ as a double


% --- Executes during object creation, after setting all properties.
function sig_equ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sig_equ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_sig_reuse.
function save_sig_reuse_Callback(hObject, eventdata, handles)
% hObject    handle to save_sig_reuse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_sig_reuse



function gold_h_Callback(hObject, eventdata, handles)
% hObject    handle to gold_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gold_h as text
%        str2double(get(hObject,'String')) returns contents of gold_h as a double


% --- Executes during object creation, after setting all properties.
function gold_h_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gold_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nh0_Callback(hObject, eventdata, handles)
% hObject    handle to Nh0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nh0 as text
%        str2double(get(hObject,'String')) returns contents of Nh0 as a double


% --- Executes during object creation, after setting all properties.
function Nh0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nh0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function H00_Callback(hObject, eventdata, handles)
% hObject    handle to H00 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of H00 as text
%        str2double(get(hObject,'String')) returns contents of H00 as a double


% --- Executes during object creation, after setting all properties.
function H00_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H00 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alp_h_Callback(hObject, eventdata, handles)
% hObject    handle to alp_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alp_h as text
%        str2double(get(hObject,'String')) returns contents of alp_h as a double


% --- Executes during object creation, after setting all properties.
function alp_h_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alp_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in best_psnr.
function best_psnr_Callback(hObject, eventdata, handles)
% hObject    handle to best_psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of best_psnr


% --- Executes on button press in use_it.
function use_it_Callback(hObject, eventdata, handles)
% hObject    handle to use_it (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_it



function var_x_Callback(hObject, eventdata, handles)
% hObject    handle to var_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var_x as text
%        str2double(get(hObject,'String')) returns contents of var_x as a double


% --- Executes during object creation, after setting all properties.
function var_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mean_x_Callback(hObject, eventdata, handles)
% hObject    handle to mean_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mean_x as text
%        str2double(get(hObject,'String')) returns contents of mean_x as a double


% --- Executes during object creation, after setting all properties.
function mean_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mean_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h_stoch_Callback(hObject, eventdata, handles)
% hObject    handle to h_stoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h_stoch as text
%        str2double(get(hObject,'String')) returns contents of h_stoch as a double


% --- Executes during object creation, after setting all properties.
function h_stoch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h_stoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function itertn_Callback(hObject, eventdata, handles)
% hObject    handle to itertn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itertn as text
%        str2double(get(hObject,'String')) returns contents of itertn as a double


% --- Executes during object creation, after setting all properties.
function itertn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itertn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MSE_min_Callback(hObject, eventdata, handles)
% hObject    handle to MSE_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MSE_min as text
%        str2double(get(hObject,'String')) returns contents of MSE_min as a double


% --- Executes during object creation, after setting all properties.
function MSE_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSE_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h22_Callback(hObject, eventdata, handles)
% hObject    handle to h22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h22 as text
%        str2double(get(hObject,'String')) returns contents of h22 as a double


% --- Executes during object creation, after setting all properties.
function h22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function psnr_a2_Callback(hObject, eventdata, handles)
% hObject    handle to psnr_a2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of psnr_a2 as text
%        str2double(get(hObject,'String')) returns contents of psnr_a2 as a double


% --- Executes during object creation, after setting all properties.
function psnr_a2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psnr_a2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h_m_Callback(hObject, eventdata, handles)
% hObject    handle to h_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h_m as text
%        str2double(get(hObject,'String')) returns contents of h_m as a double


% --- Executes during object creation, after setting all properties.
function h_m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function psnr_m_Callback(hObject, eventdata, handles)
% hObject    handle to psnr_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of psnr_a1 as text
%        str2double(get(hObject,'String')) returns contents of psnr_a1 as a double


% --- Executes during object creation, after setting all properties.
function psnr_m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psnr_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h_a1_Callback(hObject, eventdata, handles)
% hObject    handle to h_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h_a1 as text
%        str2double(get(hObject,'String')) returns contents of h_a1 as a double


% --- Executes during object creation, after setting all properties.
function h_a1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function psnr_a1_Callback(hObject, eventdata, handles)
% hObject    handle to psnr_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of psnr_a1 as text
%        str2double(get(hObject,'String')) returns contents of psnr_a1 as a double


% --- Executes during object creation, after setting all properties.
function psnr_a1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psnr_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nh_a2_Callback(hObject, eventdata, handles)
% hObject    handle to Nh_a2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nh_a2 as text
%        str2double(get(hObject,'String')) returns contents of Nh_a2 as a double


% --- Executes during object creation, after setting all properties.
function Nh_a2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nh_a2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nh_m_Callback(hObject, eventdata, handles)
% hObject    handle to Nh_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nh_a1 as text
%        str2double(get(hObject,'String')) returns contents of Nh_a1 as a double


% --- Executes during object creation, after setting all properties.
function Nh_m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nh_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nh_a1_Callback(hObject, eventdata, handles)
% hObject    handle to Nh_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nh_a1 as text
%        str2double(get(hObject,'String')) returns contents of Nh_a1 as a double


% --- Executes during object creation, after setting all properties.
function Nh_a1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nh_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lamda_max_Callback(hObject, eventdata, handles)
% hObject    handle to lamda_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lamda_max as text
%        str2double(get(hObject,'String')) returns contents of lamda_max as a double


% --- Executes during object creation, after setting all properties.
function lamda_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lamda_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lamda_min_Callback(hObject, eventdata, handles)
% hObject    handle to lamda_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lamda_min as text
%        str2double(get(hObject,'String')) returns contents of lamda_min as a double


% --- Executes during object creation, after setting all properties.
function lamda_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lamda_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lamda_min1_Callback(hObject, eventdata, handles)
% hObject    handle to lamda_min1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lamda_min1 as text
%        str2double(get(hObject,'String')) returns contents of lamda_min1 as a double


% --- Executes during object creation, after setting all properties.
function lamda_min1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lamda_min1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lamda_max1_Callback(hObject, eventdata, handles)
% hObject    handle to lamda_max1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lamda_max1 as text
%        str2double(get(hObject,'String')) returns contents of lamda_max1 as a double


% --- Executes during object creation, after setting all properties.
function lamda_max1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lamda_max1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function H_paramtr_Callback(hObject, eventdata, handles)
% hObject    handle to H_paramtr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of H_paramtr as text
%        str2double(get(hObject,'String')) returns contents of H_paramtr as a double


% --- Executes during object creation, after setting all properties.
function H_paramtr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H_paramtr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Data_size_Callback(hObject, eventdata, handles)
% hObject    handle to Data_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Data_size as text
%        str2double(get(hObject,'String')) returns contents of Data_size as a double


% --- Executes during object creation, after setting all properties.
function Data_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Data_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fs_Callback(hObject, eventdata, handles)
% hObject    handle to fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fs as text
%        str2double(get(hObject,'String')) returns contents of fs as a double

update_displays
% --- Executes during object creation, after setting all properties.
function fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function feh_Callback(hObject, eventdata, handles)
% hObject    handle to feh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of feh as text
%        str2double(get(hObject,'String')) returns contents of feh as a double


% --- Executes during object creation, after setting all properties.
function feh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to feh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function level_Callback(hObject, eventdata, handles)
% hObject    handle to level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of level as text
%        str2double(get(hObject,'String')) returns contents of level as a double

update_displays


% --- Executes during object creation, after setting all properties.
function level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function betha_Callback(hObject, eventdata, handles)
% hObject    handle to betha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of betha as text
%        str2double(get(hObject,'String')) returns contents of betha as a double

update_displays

% --- Executes during object creation, after setting all properties.
function betha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alp_Callback(hObject, eventdata, handles)
% hObject    handle to alp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alp as text
%        str2double(get(hObject,'String')) returns contents of alp as a double


% --- Executes during object creation, after setting all properties.
function alp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A1_Callback(hObject, eventdata, handles)
% hObject    handle to A1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A1 as text
%        str2double(get(hObject,'String')) returns contents of A1 as a double

update_displays

% --- Executes during object creation, after setting all properties.
function A1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A2_Callback(hObject, eventdata, handles)
% hObject    handle to A2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A2 as text
%        str2double(get(hObject,'String')) returns contents of A2 as a double
update_displays

% --- Executes during object creation, after setting all properties.
function A2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in up_plot.
function Plot_lamda_Callback(hObject, eventdata, handles)
% hObject    handle to up_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%% the signal parameters    

h=str2double(get(handles.H_paramtr,'string'))
alp=str2double(get(handles.alp,'string')) 
beta=str2double(get(handles.betha,'string')) ;
A1=str2double(get(handles.A1,'string') );
A2=str2double(get(handles.A2,'string') );
fs=str2double(get(handles.fs,'string') );
feh=str2double(get(handles.feh,'string')) ;
Data_size=str2double(get(handles.Data_size,'string')) ;
noise=str2double(get(handles.level,'string')) 
stepp=2048/Data_size;

%% Generate the SCSA input signal 
[gen_y New_time]=generate_signal(1,2048,alp,beta,A1,A2);
sig=gen_y(1:stepp:end)
SCSA_Dw_fs=max(size(sig));


%% generate noise 
e= rand(1, SCSA_Dw_fs);
e = e- mean(e);



%% without spectrum analysis
sig_noised = sig + noise*e;                                                         % noisy signal 
sig_orgin = sig;                                                                  % non noisy signal 

% New_time= 0:0.01:(SCSA_Dw_fs-1)*0.01;

%% Plot the signal 
% axes(handles.axes22);
axes(handles.axes3);
cla;

plot (New_time, sig_noised,'b','LineWidth',2)   

%% remove the negative part if any

for i=1:length(sig_noised)
if sig_noised(i)<0
Ind=1;
sig_noised(i);
break
else 
    Ind = 0;
end 
end  

sig2positive = sig_noised- Ind*min(sig_noised);



%%

%% show the eigenvalues in the table Define the data
d_new=get(handles.t,'data');

    for kk=1:max(size(d_new))
      
    if (strcmp(d_new{kk,2},'true') )
        dd(kk)=str2num(d_new{kk,1});
            else
            dd(kk)=0;
    end  
    end

    
y=sig2positive;
M = length(sig_noised);
feh = 2*pi/M;
D = delta(M,fs,feh);
%% SCSA Algorithm
% [ yscsa2,Nh,All_lamda,psin,Kpsin,All_lamda_recon ,ind] = scsa(y,D,fs,h_optml,intervl0,intervl0)
%% FSCSA
[yscsa2,h,Dic,psinnor,S,Nh,Ymin,squaredEIGF0]= Fast_SCSA1D(y,fs,h_optml,gm)

%MSE1 = mean2((abs(yscsa2)-abs(sig_orgin)).^2);
MSE1 = mean2((yscsa2-sig_orgin).^2)

MSE2 = abs((yscsa2-sig_orgin)/sig_orgin);


%% plots
yscsa2=yscsa2-(min(yscsa2)-min(sig_orgin));
axes(handles.axes3);
cla;
                plot (Totale_time,gen_data,'b','LineWidth',2) 
                hold on
                plot (New_time, sig_orgin,'g','LineWidth',3)    
                hold on 
                plot (New_time, yscsa2,'r','LineStyle',':','LineWidth',3.5)            
                lgdd=legend('Desired Signal ','Reference signal', 'SCSA signal');
                set(lgdd,'FontSize',15); 
                xlabel('Temps (s)')
%                 xlim([0 10])
                ylabel('Signal')
                grid on
                title([ ' h = ' num2str(h),'  SNR=' ,num2str(SNR), '    MSE = ', num2str(MSE1),'   N= ', num2str(SCSA_Dw_fs),' samples'])
                xlabel([ ' alpha = ', num2str(-alp)])%,' betha = ', num2str(beta),' A1 = ', num2str(A1)])
            

                

function nb_sec_Callback(hObject, eventdata, handles)
% hObject    handle to nb_sec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nb_sec as text
%        str2double(get(hObject,'String')) returns contents of nb_sec as a double



% --- Executes during object creation, after setting all properties.
function nb_sec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nb_sec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in denoising_plot.
function denoising_plot_Callback(hObject, eventdata, handles)
% hObject    handle to denoising_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%% #######   STOP PARALLELISM   #################
% delete(parallelism)


% --- Executes on key press with focus on man_h and none of its controls.
function man_h_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to man_h (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in man_h.
function man_h_Callback(hObject, eventdata, handles)
% hObject    handle to man_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of man_h
set(handles.H_paramtr,'Enable', 'on'); 
set(handles.uipanel1,'Visible', 'on'); 
set(handles.uipanel2,'Visible', 'on'); 
set(handles.uipanel3,'Visible', 'on'); 

% --- Executes on button press in auto_h.
function auto_h_Callback(hObject, eventdata, handles)
% hObject    handle to auto_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of auto_h
set(handles.H_paramtr,'Enable', 'off'); 
set(handles.uipanel1,'Visible', 'off'); 
set(handles.uipanel2,'Visible', 'off'); 
set(handles.uipanel3,'Visible', 'off'); 



function N_a1_Callback(hObject, eventdata, handles)
% hObject    handle to N_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N_a1 as text
%        str2double(get(hObject,'String')) returns contents of N_a1 as a double


% --- Executes during object creation, after setting all properties.
function N_a1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MSE_a1_Callback(hObject, eventdata, handles)
% hObject    handle to MSE_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MSE_a1 as text
%        str2double(get(hObject,'String')) returns contents of MSE_a1 as a double


% --- Executes during object creation, after setting all properties.
function MSE_a1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSE_a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
