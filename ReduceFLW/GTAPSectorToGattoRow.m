function irow=GT(sec);

seclist={'gro','wht','pdr','v_f','ocr','osd','c_b','ctl','rmk','oap','fsh'};

irow=strmatch(char(sec),seclist);

% if numel(irow)==0
%     error
% end
% 
