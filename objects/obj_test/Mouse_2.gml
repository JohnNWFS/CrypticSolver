k_check = keyboard_check(vk_lshift);
if (k_check) {blend_g -= 1} else {blend_g += 1;}
if (blend_g == 256) {blend_g = 0;}
if (blend_g == -1) {blend_g = 255;}

