function ImportedStruct = csv2struct(file)
%csv2struct Imports ascii data into a struct
%   Detailed explanation goes here
% 2011 - avelo

[~, ~, ext] = fileparts(file);
ext=lower(ext); 

ImportedStruct=struct();

% TODO: Deal with non-numeric data

if(strcmp(ext,'.xlsx'))
  ImportedStruct=xlsx2struct(file);
else
  DummyData=importdata(file);
  for iH=1:length(DummyData.colheaders)
    ImportedStruct.(DummyData.colheaders{iH})=DummyData.data(:,iH);
  end
end

end

