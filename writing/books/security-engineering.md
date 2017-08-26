# Security Engineering #

## Challenges ##

* Encrypt and decrypt text with a symmetric key, using AES-512, and ECC (with a lesser sized curve).
* Encrypt and decrypt text with an asymmetric keypair.

* What's the difference between AES and RSA/ECC?

## Questions ##

* What is the difference between a MAC and an HMAC?
  * HMAC : Hash the message with a key, then hash the results with a variation
    of the key.


* What are the differences between hash functions (MD5 vs SHA)?

* What are the differences between block ciphers (DES / AES / EC)?
  * The difference is between the algorithms used in each cipher.

  * Is DES with a larger block size more secure than AES with a smaller block
    size?

### Block ciphers ###

  * Plaintext is encrypted in blocks. Each unique block of plaintext has
    a corresponding block of ciphertext. Two identical plaintext blocks have
    identical ciphertext blocks.

  * Block ciphers are based on keys. With a given key, you encrypt or decrypt.

  * May have one key for both encryption / decryption (symmetric)
  * May have separate keys for encryption / decryption (asymmetric (or public key)).
  * Frequently used in software.

  * DES = Data Encryption Standard - 64bit block length (8 characters), 48 bit key.
    * DES is completely broken.
    * Triple DES runs DES three times w/ different keys. Acceptable, but AES is
      recommended over DES.
  * AES = Advanced Encryption Standard - the gold standard algorithm!

  * Block cipher properties:

    * Block size. A small block size (16 bit) is worthless. The attacker could
      build a dictionary of plaintext / ciphertext blocks for the entire space.

	  * Number of rounds. Each cipher performs a set of functions on the input to
      produce the output. Running the set of functions once is called a "round".
      The more rounds, the more difficult it is to decrypt.

    * AES256 (AES w/ 256 bit key) is recommended!

* Modes of operation - how you *use* the block cipher to encrypt large messages.
  * ECB : Electronic Code Book : simply encrypts each block size of bits one after another.
    * Produces identical output for the same input. Attackers could use the block
      output of a known block of nulls to help predict the key.
  * CBC : Cipher Block Chaining : Each block is XORd with the previous block of ciphertext.
    * This disguises patterns in plaintext.
    * Uses an IV (which acts as a seed) to prevent plaintext headers from emitting
      identical ciphertext blocks.
    * An error could be inserted into the ciphertext, it will affect only two blocks
      of plaintext. **You must use integrity protection (hash) on the plaintext** in
      addition to encrypting it.
  * MAC : message authentication code. To compute a MAC on a message using a block
    cipher, we encrypt it using CBC and keep the last block.


### Hash (one-way) Functions ###

* Use SHA-256 or greater.

* Even knowing the key, you cannot recover the plaintext from the hash.
* All passwords should be stored as hashes.
* Used to verify data (message / file) integrity. In messaging, hashes are often
  called "message digests".

* Properties
  * Hash functions are random.
  * Hash functions do **not** reveal anything about the input.
  * Hash functions should not produce collisions. Collisions occur when two
    inputs produce the same hash. (MD5 is succeptable to this).

  * MD5 = 128bit output - requires 2^64 computations to break.
  * SHA1 = 160bit output - requires 2^80 computations to break.

* Both MD5 and SHA1 are succeptable to collisions. You can't *prevent*
  collisions. Collisions simply must be large enough to be impractical to
  discover for your domain.


### Random Generators (Stream Ciphers) ###

* Stream ciphers:
  * Plaintext is encrypted based on position in the stream.
  * Commonly used in hardware applications.

  * Random number generators are stream ciphers. Stream ciphers have a small
    input keyand can encrypt large amounts of data.

  * To recover the data, we use the same generator with the same key.

  * Keys must be negotiated in advance. Protocols have to be designed to ensure
    both parties can synchronize on the right working key even in the presence
    of an adversary.


### Public Key Cryptography ###

* Asymmetric Primitives
  * Public key : used for others to encrypt messages. Only the holder of the
    private key can decrypt them.

  * Digital signatures:
    * Only created by a single person, but can be verified by anyone.


  * A message is signed using a private signing key. Anyone
    can check this using a public signature verification key.
