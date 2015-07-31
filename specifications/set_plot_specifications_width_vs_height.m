% Format:
% 'width_vs_height', height_threshold, max_width_in_kb, {samples}, {colors}

blue = [0 68 252]/256;
red = [252 34 13]/256;
tan = [253 158 65]/256;
green = [24 140 18]/256;
black = [0 0 0]/256;
gray = [145 145 145]/256;

plot_specifications_width_vs_height = {

%4

{'width_vs_height', {'A4'}, {blue}};
{'width_vs_height', {'B4'}, {blue}};
{'width_vs_height', {'C4'}, {blue}};
{'width_vs_height', {'D4'}, {blue}};
{'width_vs_height', {'E4'}, {blue}};
{'width_vs_height', {'F4'}, {blue}};
{'width_vs_height', {'G4'}, {blue}};
{'width_vs_height', {'H4'}, {blue}};
{'width_vs_height', {'A4','B4'}, {blue, red}};
{'width_vs_height', {'A4','C4'}, {blue, red}};
{'width_vs_height', {'A4','D4'}, {blue, red}};
{'width_vs_height', {'A4','E4'}, {blue, red}};
{'width_vs_height', {'A4','F4'}, {blue, red}};
{'width_vs_height', {'A4','G4'}, {blue, red}};
{'width_vs_height', {'A4','H4'}, {blue, red}};
{'width_vs_height', {'C4','D4'}, {blue, red}};
{'width_vs_height', {'E4','F4'}, {blue, red}};
{'width_vs_height', {'G4','H4'}, {blue, red}};
{'width_vs_height', {'A4','C4','E4','G4'}, {blue, gray, red, tan}};
{'width_vs_height', {'B4','D4','F4','H4'}, {blue, gray, red, tan}};
{'width_vs_height', {'A4','C4','E4','G4', 'H4'}, {blue, gray, red, tan, green}} %;

%5

{'width_vs_height', {'A5'}, {blue}};
{'width_vs_height', {'B5'}, {blue}};
{'width_vs_height', {'C5'}, {blue}};
{'width_vs_height', {'D5'}, {blue}};
{'width_vs_height', {'E5'}, {blue}};
{'width_vs_height', {'F5'}, {blue}};
{'width_vs_height', {'G5'}, {blue}};
{'width_vs_height', {'H5'}, {blue}};
{'width_vs_height', {'I5'}, {blue}};
{'width_vs_height', {'J5'}, {blue}};

{'width_vs_height', {'A5','B5'}, {blue,red}};
{'width_vs_height', {'A5','C5'}, {blue,red}};
{'width_vs_height', {'A5','D5'}, {blue,red}};
{'width_vs_height', {'A5','E5'}, {blue,red}};
{'width_vs_height', {'A5','F5'}, {blue,red}};
{'width_vs_height', {'A5','G5'}, {blue,red}};
{'width_vs_height', {'A5','H5'}, {blue,red}};

{'width_vs_height', {'C5','D5'}, {blue,red}};
{'width_vs_height', {'E5','F5'}, {blue,red}};
{'width_vs_height', {'G5','H5'}, {blue,red}};

%6

{'width_vs_height', {'A6'}, {blue}};
{'width_vs_height', {'B6'}, {blue}};
{'width_vs_height', {'C6'}, {blue}};
{'width_vs_height', {'D6'}, {blue}};
{'width_vs_height', {'E6'}, {blue}};
{'width_vs_height', {'F6'}, {blue}};

{'width_vs_height', {'A6','B6'}, {blue,red}};
{'width_vs_height', {'A6','C6'}, {blue,red}};
{'width_vs_height', {'A6','D6'}, {blue,red}};
{'width_vs_height', {'A6','E6'}, {blue,red}};
{'width_vs_height', {'A6','F6'}, {blue,red}};
{'width_vs_height', {'D6','E6'}, {blue,red}};
{'width_vs_height', {'D6','F6'}, {blue,red}};
{'width_vs_height', {'D6','E6','F6'}, {blue,red,tan}};

{'width_vs_height', {'G6'}, {blue}};
{'width_vs_height', {'H6'}, {blue}};
{'width_vs_height', {'I6'}, {blue}};
{'width_vs_height', {'J6'}, {blue}};
{'width_vs_height', {'K6'}, {blue}};
{'width_vs_height', {'L6'}, {blue}};

{'width_vs_height', {'G6','H6','I6'}, {blue,red,tan}};
{'width_vs_height', {'J6','K6','L6'}, {blue,red,tan}};
{'width_vs_height', {'G6','J6'}, {blue,red}};
{'width_vs_height', {'H6','K6'}, {blue,red}};
{'width_vs_height', {'I6','L6'}, {blue,red}};

%7

{'width_vs_height', {'A7'}, {blue}};
{'width_vs_height', {'B7'}, {blue}};
{'width_vs_height', {'C7'}, {blue}};
{'width_vs_height', {'D7'}, {blue}};
{'width_vs_height', {'E7'}, {blue}};
{'width_vs_height', {'F7'}, {blue}};
{'width_vs_height', {'G7'}, {blue}};


{'width_vs_height', {'A7','B7'}, {blue,red}};
{'width_vs_height', {'A7','C7'}, {blue,red}};
{'width_vs_height', {'A7','D7'}, {blue,red}};
{'width_vs_height', {'A7','E7'}, {blue,red}};
{'width_vs_height', {'A7','F7'}, {blue,red}};
{'width_vs_height', {'A7','G7'}, {blue,red}};
{'width_vs_height', {'A7','B7','C7','D7'}, {blue,red,tan,gray}};
{'width_vs_height', {'A7','C7','F7','G7'}, {blue,red,tan,gray}};
{'width_vs_height', {'C7','D7'}, {blue,red}};
{'width_vs_height', {'C7','E7'}, {blue,red}};
{'width_vs_height', {'C7','G7'}, {blue,red}};
{'width_vs_height', {'C7','D7','E7','G7'}, {blue,red,tan,gray}};

{'width_vs_height', {'H7'}, {blue}};
{'width_vs_height', {'I7'}, {blue}};
{'width_vs_height', {'J7'}, {blue}};
{'width_vs_height', {'K7'}, {blue}};
{'width_vs_height', {'L7'}, {blue}};

{'width_vs_height', {'H7','I7'}, {blue,red}};
{'width_vs_height', {'H7','J7'}, {blue,red}};
{'width_vs_height', {'H7','J7','K7'}, {blue,red,tan}};
{'width_vs_height', {'H7','J7','L7'}, {blue,red,tan}};
{'width_vs_height', {'H7','J7','K7','L7'}, {blue,red,tan,gray}};

{'width_vs_height', {'J7','K7'}, {blue,red}};
{'width_vs_height', {'J7','L7'}, {blue,red}};
{'width_vs_height', {'J7','K7','L7'}, {blue,red,tan}};

{'width_vs_height', {'H7_c'}, {blue}};
{'width_vs_height', {'I7_c'}, {blue}};
{'width_vs_height', {'J7_c'}, {blue}};
{'width_vs_height', {'K7_c'}, {blue}};
{'width_vs_height', {'L7_c'}, {blue}};

{'width_vs_height', {'H7_c','I7_c'}, {blue,red}};
{'width_vs_height', {'H7_c','J7_c'}, {blue,red}};
{'width_vs_height', {'H7_c','J7_c','K7_c'}, {blue,red,tan}};
{'width_vs_height', {'H7_c','J7_c','L7_c'}, {blue,red,tan}};
{'width_vs_height', {'H7_c','J7_c','K7_c','L7_c'}, {blue,red,tan,gray}};

{'width_vs_height', {'J7_c','K7_c'}, {blue,red}};
{'width_vs_height', {'J7_c','L7_c'}, {blue,red}};
{'width_vs_height', {'J7_c','K7_c','L7_c'}, {blue,red,tan}};

%8

{'width_vs_height', {'A8'}, {blue}};
{'width_vs_height', {'B8'}, {blue}};
{'width_vs_height', {'C8'}, {blue}};
{'width_vs_height', {'D8'}, {blue}};
{'width_vs_height', {'E8'}, {blue}};
{'width_vs_height', {'F8'}, {blue}};

{'width_vs_height', {'A8','B8','C8'}, {blue,red,tan}};
{'width_vs_height', {'D8','E8','F8'}, {blue,red,tan}};

{'width_vs_height', {'A8','D8'}, {tan,red}};
{'width_vs_height', {'B8','E8'}, {tan,red}};
{'width_vs_height', {'C8','F8'}, {tan,red}};

{'width_vs_height', {'I8'}, {blue}};
{'width_vs_height', {'J8'}, {blue}};
{'width_vs_height', {'K8'}, {blue}};
{'width_vs_height', {'L8'}, {blue}};
{'width_vs_height', {'M8'}, {blue}};
{'width_vs_height', {'N8'}, {blue}};

{'width_vs_height', {'J8','I8'}, {red,blue}};
{'width_vs_height', {'K8','I8'}, {red,blue}};
{'width_vs_height', {'L8','I8'}, {red,blue}};
{'width_vs_height', {'M8','I8'}, {red,blue}};
{'width_vs_height', {'N8','I8'}, {red,blue}};

{'width_vs_height', {'L8','M8','N8'}, {blue,red,tan}};
{'width_vs_height', {'K8','J8','L8'}, {blue,red,tan}};

%10

{'width_vs_height', {'A10'}, {blue}};
{'width_vs_height', {'B10'}, {blue}};
{'width_vs_height', {'C10'}, {blue}};
{'width_vs_height', {'D10'}, {blue}};
{'width_vs_height', {'E10'}, {blue}};
{'width_vs_height', {'F10'}, {blue}};
{'width_vs_height', {'G10'}, {blue}};
{'width_vs_height', {'H10'}, {blue}};  

{'width_vs_height', {'A10','B10'}, {blue,gray}};
{'width_vs_height', {'A10','C10'}, {blue,gray}};
{'width_vs_height', {'A10','D10'}, {blue,gray}};
{'width_vs_height', {'A10','E10'}, {blue,gray}};
{'width_vs_height', {'A10','F10'}, {blue,gray}};
{'width_vs_height', {'A10','G10'}, {blue,gray}};
{'width_vs_height', {'A10','H10'}, {blue,gray}}

};