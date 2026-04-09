function cadena = remove_duplicate_char(cadena,caracter)
%remove_duplicate_char Removes consecutive duplicates of a specified 
% character in a string.
%
% cadena = remove_duplicate_char(cadena, caracter) takes a string or 
% character array and replaces any sequence of two or more consecutive 
% occurrences of the specified character with a single instance of that 
% character.
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

