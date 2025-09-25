function cadena = removeDuplicateChar(cadena,caracter)
%REMOVEDUPLICATECHAR Removes consecutive duplicates of a specified character 
% in a string.
%
%   cadena = REMOVEDUPLICATECHAR(cadena, caracter) takes a string or character
%   array and replaces any sequence of two or more consecutive occurrences 
%   of the specified character with a single instance of that character.
%
%   Inputs:
%       cadena   - Input string or character array to process.
%       caracter - Character (char) for which consecutive duplicates will 
%                  be removed.
%
%   Output:
%       cadena   - Resulting string with duplicate characters removed

caracter_esc = regexptranslate('escape', caracter);
cadena = regexprep(cadena, [caracter_esc '{2,}'], caracter);

end

