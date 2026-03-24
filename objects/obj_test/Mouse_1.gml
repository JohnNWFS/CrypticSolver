k_check = keyboard_check(vk_lshift);
if (k_check) {blend_b -= 1} else {blend_b += 1;}
if (blend_b == 256) {blend_b = 0;}
if (blend_b == -1) {blend_b = 255;}


