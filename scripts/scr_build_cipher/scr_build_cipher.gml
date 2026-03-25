/// @description Builds a random substitution cipher stored in global arrays.
/// Guarantees a derangement — no letter ever encrypts to itself.
/// global.cipher[plain_index]        = encrypted_index  (0=A .. 25=Z)
/// global.cipher_inverse[enc_index]  = plain_index
/// Call once at game start before encrypting the phrase.
function scr_build_cipher() {
	var i, j, temp, has_fixed_point;

	// Shuffle until we get a derangement (no letter maps to itself).
	// A random permutation is a derangement ~36.8% of the time, so this
	// typically resolves in 2-3 attempts.
	do {
		for (i = 0; i < 26; i++) {
			global.cipher[i] = i;
		}

		// Fisher-Yates shuffle
		for (i = 25; i > 0; i--) {
			j    = floor(irandom(i));
			temp = global.cipher[i];
			global.cipher[i] = global.cipher[j];
			global.cipher[j] = temp;
		}

		// Check for fixed points
		has_fixed_point = false;
		for (i = 0; i < 26; i++) {
			if (global.cipher[i] == i) {
				has_fixed_point = true;
				break;
			}
		}
	} until (!has_fixed_point);

	// Build inverse so we can look up: encrypted_letter -> plain_letter
	for (i = 0; i < 26; i++) {
		global.cipher_inverse[global.cipher[i]] = i;
	}
}
