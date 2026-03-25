/// @description Encrypts a plain-text phrase using the substitution cipher.
/// @param {string} plain_phrase  Uppercase phrase with spaces (no punctuation).
/// @returns {string} Encrypted phrase — same length, spaces preserved.
/// Requires scr_build_cipher() to have been called first.
function scr_encrypt_phrase(plain_phrase) {
	var result  = "";
	var ph_len  = string_length(plain_phrase);
	var i, ch, ascii_val, enc_index;

	for (i = 1; i <= ph_len; i++) {
		ch = string_char_at(plain_phrase, i);
		if (ch == " ") {
			result += " ";
		} else {
			ascii_val = string_byte_at(ch, 1);   // A=65 .. Z=90
			enc_index = global.cipher[ascii_val - 65];
			result += chr(enc_index + 65);
		}
	}

	return result;
}
