k_check = keyboard_check(vk_lshift);
if (k_check) {blend_r -= 1} else {blend_r += 1;}
if (blend_r == 256) {blend_r = 0;}
if (blend_r == -1) {blend_r = 255;}


