# Digital Signatures

Two digital signaturesschnorr signature algorithmschnorr signature algorithmdigital signaturesECDSAECDSA (Elliptic Curve Digital Signature Algorithm)transactionssignaturessee=digital signaturessignature algorithms are currently used in Bitcoin, the *schnorr signature algorithm* and the *Elliptic Curve Digital Signature Algorithm* (*ECDSA*). These algorithms are used for digital signatures based on elliptic curve private/public key pairs, as described in [???](#elliptic_curve). They are used for spending segwit v0 P2WPKH outputs, segwit v1 P2TR keypath spending, and by the script functions OP\_CHECKSIG, OP\_CHECKSIGVERIFY, OP\_CHECKMULTISIG, OP\_CHECKMULTISIGVERIFY, and OP\_CHECKSIGADD. Any time one of those is executed, a signature must be provided.

A digital signaturedigital signaturespurpose of serves three purposes in Bitcoin. First, the signature proves that the controller of a private key, who is by implication the owner of the funds, has *authorized* the spending of those funds. Secondly, the proof of authorization is *undeniable* (nonrepudiation). Thirdly, that the authorized transaction cannot be changed by unauthenticated third parties—​that its *integrity* is intact.

<div class="note">

Each transaction input and any signatures it may contain is *completely* independent of any other input or signature. Multiple parties can collaborate to construct transactions and sign only one input each. Several protocols use this fact to create multiparty transactions for privacy.

</div>

In this chapter we look at how digital signatures work and how they can present proof of control of a private key without revealing that private key.

## How Digital Signatures Work

A digital signature consists of two parts. The first part is an algorithm for creating a signature for a message (the transaction) using a private key (the signing key). The second part is an algorithm that allows anyone to verify the signature, given also the message and the corresponding public key.

### Creating a Digital Signature

In Bitcoin’sdigital signaturescreating use of digital signature algorithms, the "message" being signed is the transaction, or more accurately a hash of a specific subset of the data in the transaction, commitment hashcalled the *commitment hash* (see [Signature Hash Types (SIGHASH)](#sighash_types)). The signing key is the user’s private key. The result is the signature:

\[\begin{equation}
Sig = F_{sig}(F_{hash}(m), x)
\end{equation}\]

where:

  - *x* is the signing private key

  - *m* is the message to sign, the commitment hash (such as parts of a transaction)

  - *F*<sub>*hash*</sub> is the hashing function

  - *F*<sub>*sig*</sub> is the signing algorithm

  - *Sig* is the resulting signature

You can find more details on the mathematics of schnorr and ECDSA signatures in [Schnorr Signatures](#schnorr_signatures) and [ECDSA Signatures](#ecdsa_signatures).

In both schnorr and ECDSA signatures, the function *F*<sub>*sig*</sub> produces a signature Sig that is composed of two values. There are differences between the two values in the different algorithms, which we’ll explore later. After the two values are calculated, they are serialized into a byte stream. For ECDSA signatures, the encoding uses an international standard encoding scheme called the *Distinguished Encoding Rules*, or *DER*. For schnorr signatures, a simpler serialization format is used.

### Verifying the Signature

Thedigital signaturesverifyingverifyingdigital signatures signature verification algorithm takes the message (a hash of parts of the transaction and related data), the signer’s public key and the signature, and returns TRUE if the signature is valid for this message and public key.

To verify the signature, one must have the signature, the serialized transaction, some data about the output being spent, and the public key that corresponds to the private key used to create the signature. Essentially, verification of a signature means "Only the controller of the private key that generated this public key could have produced this signature on this transaction."

### Signature Hash Types (SIGHASH)

Digital signaturesdigital signaturesSIGHASH flagsid=digital-signature-sighashSIGHASH flagsid=sighash apply to messages, which in the case of Bitcoin, are the transactions themselves. The signature proves a *commitment* by the signer to specific transaction data. In the simplest form, the signature applies to almost the entire transaction, thereby committing to all the inputs, outputs, and other transaction fields. However, a signature can commit to only a subset of the data in a transaction, which is useful for a number of scenarios as we will see in this section.

Bitcoin signatures have a way of indicating which part of a transaction’s data is included in the hash signed by the private key using a SIGHASH flag. The SIGHASH flag is a single byte that is appended to the signature. Every signature has either an explicit or implicit SIGHASH flag, and the flag can be different from input to input. A transaction with three signed inputs may have three signatures with different SIGHASH flags, each signature signing (committing) to different parts of the transaction.

Remember, each input may contain one or more signatures. As a result, an input may have signatures with different SIGHASH flags that commit to different parts of the transaction. Note also that Bitcoin transactions may contain inputs from different "owners," who may sign only one input in a partially constructed transaction, collaborating with others to gather all the necessary signatures to make a valid transaction. Many of the SIGHASH flag types only make sense if you think of multiple participants collaborating outside the Bitcoin network and updating a partially signed transaction.

There are three SIGHASH flags: ALL, NONE, and SINGLE, as shown in [table\_title](#sighash_types_and_their).

| `SIGHASH` flag | Value  | Description                                                                                            |
| -------------- | ------ | ------------------------------------------------------------------------------------------------------ |
| `ALL`          | `0x01` | Signature applies to all inputs and outputs                                                            |
| `NONE`         | `0x02` | Signature applies to all inputs, none of the outputs                                                   |
| `SINGLE`       | `0x03` | Signature applies to all inputs but only the one output with the same index number as the signed input |

`SIGHASH` types and their meanings

In addition, there is a modifier flag, SIGHASH\_ANYONECANPAY, which can be combined with each of the preceding flags. When ANYONECANPAY is set, only one input is signed, leaving the rest (and their sequence numbers) open for modification. The ANYONECANPAY has the value 0x80 and is applied by bitwise OR, resulting in the combined flags as shown in [table\_title](#sighash_types_with_modifiers).

| `SIGHASH` flag         | Value  | Description                                                              |
| ---------------------- | ------ | ------------------------------------------------------------------------ |
| `ALL\|ANYONECANPAY`    | `0x81` | Signature applies to one input and all outputs                           |
| `NONE\|ANYONECANPAY`   | `0x82` | Signature applies to one input, none of the outputs                      |
| `SINGLE\|ANYONECANPAY` | `0x83` | Signature applies to one input and the output with the same index number |

`SIGHASH` types with modifiers and their meanings

The way SIGHASH flags are applied during signing and verification is that a copy of the transaction is made and certain fields within are either omitted or truncated (set to zero length and emptied). The resulting transaction is serialized. The SIGHASH flag is included in the serialized transaction data and the result is hashed. The hash digest itself is the "message" that is signed. Depending on which SIGHASH flag is used, different parts of the transaction are included. By including the SIGHASH flag itself, the signature commits the SIGHASH type as well, so it can’t be changed (e.g., by a miner).

In [Serialization of ECDSA Signatures (DER)](#serialization_of_signatures_der), we will see that the last part of the DER-encoded signature was 01, which is the SIGHASH\_ALL flag for ECDSA signatures. This locks the transaction data, so Alice’s signature is committing to the state of all inputs and outputs. This is the most common signature form.

Let’s look at some of the other SIGHASH types and how they can be used in practice:

  - ALL|ANYONECANPAY  
    This crowdfundingconstruction can be used to make a "crowdfunding”-style transaction. Someone attempting to raise funds can construct a transaction with a single output. The single output pays the "goal" amount to the fundraiser. Such a transaction is obviously not valid, as it has no inputs. However, others can now amend it by adding an input of their own as a donation. They sign their own input with ALL|ANYONECANPAY. Unless enough inputs are gathered to reach the value of the output, the transaction is invalid. Each donation is a "pledge," which cannot be collected by the fundraiser until the entire goal amount is raised. Unfortunately, this protocol can be circumvented by the fundraiser adding an input of their own (or from someone who lends them funds), allowing them to collect the donations even if they haven’t reached the specified value.

  - NONE  
    This construction can be used to create a "bearer check" or "blank check" of a specific amount. It commits to all inputs but allows the outputs to be changed. Anyone can write their own Bitcoin address into the output script. By itself, this allows any miner to change the output destination and claim the funds for themselves, but if other required signatures in the transaction use SIGHASH\_ALL or another type that commits to the output, it allows those spenders to change the destination without allowing any third parties (like miners) to modify the outputs.

  - NONE|ANYONECANPAY  
    This construction can be used to build a "dust collector." Users who have tiny UTXOs in their wallets can’t spend these without the cost in fees exceeding the value of the UTXO; see [???](#uneconomical_outputs). With this type of signature, the uneconomical UTXOs can be donated for anyone to aggregate and spend whenever they want.

There are some proposals to modify or expand the SIGHASH system. The most widely discussed proposal as of this writing is BIP118 SIGHASH flagsBIP118, which proposes to add two new sighash flags. A signature using SIGHASH\_ANYPREVOUT would not commit to an input’s outpoint field, allowing it to be used to spend any previous output for a particular witness program. For example, if Alice receives two outputs for the same amount to the same witness program (e.g., requiring a single signature from her wallet), a SIGHASH\_ANYPREVOUT signature for spending either one of those outputs could be copied and used to spend the other output to the same destination.

A signature using SIGHASH\_ANYPREVOUTANYSCRIPT would not commit to the outpoint, the amount, the witness program, or the specific leaf in the taproot merkle tree (script tree), allowing it to spend any previous output that the signature could satisfy. For example, if Alice received two outputs for different amounts and different witness programs (e.g., one requiring a single signature and another requiring her signature plus some other data), a SIGHASH\_ANYPREVOUTANYSCRIPT signature for spending either one of those outputs could be copied and used to spend the other output to the same destination (assuming the extra data for the second output was known).

The main expected use for the two SIGHASH\_ANYPREVOUT opcodes is improved payment channels, such as those used in the Lightning Network (LN), although several other uses have been described.

<div class="note">

You will not often see SIGHASH flags presented as an option in a user’s wallet application. Simple wallet applications sign with SIGHASH\_ALL flags. More sophisticated applications, such as LN nodes, may use alternative SIGHASH flags, but they use protocols that have been extensively reviewed to understand the influence of the alternative digital signaturesSIGHASH flagsstartref=digital-signature-sighashSIGHASH flagsstartref=sighashflags.

</div>

## Schnorr Signatures

In 1989, digital signaturesschnorr signature algorithmid=digital-sigs-schnorrschnorr signature algorithmid=schnorrClaus Schnorr published a paper describing the signature algorithm that’s become eponymous with him. The algorithm isn’t specific to the elliptic curve cryptography (ECC) that Bitcoin and many other applications use, although it is perhaps most strongly associated with ECC today. Schnorr signatures have a number of nice properties:

  - Provable security  
    A mathematical digital signaturesschnorr signature algorithmproperties ofschnorr signature algorithmproperties ofproof of the security of schnorr signatures depends on only the difficulty of solving the Discrete Logarithm Problem (DLP), particularly for elliptic curves (EC) for Bitcoin, and the ability of a hash function (like the SHA256 function used in Bitcoin) to produce unpredictable values, called the random oracle model (ROM). Other signature algorithms have additional dependencies or require much larger public keys or signatures for equivalent security to ECC-Schnorr (when the threat is defined as classical computers; other algorithms may provide more efficient security against quantum computers).

  - Linearity  
    Schnorr signatures have a property that mathematicians linearitycall *linearity*, which applies to functions with two particular properties. The first property is that summing together two or more variables and then running a function on that sum will produce the same value as running the function on each of the variables independently and then summing together the results, e.g., *f(x* + *y* + *z)* == *f(x)* + *f(y)* + *f(z)*; this property isadditivity called *additivity*. The second property is that multiplying a variable and then running a function on that product will produce the same value as running the function on the variable and then multiplying it by the same amount, e.g., *f(a* × *x)* == *a* × *f(x)*; this property is homogeneity of degree 1called *homogeneity of degree 1*.
    
    In cryptographic operations, some functions may be private (such as functions involving private keys or secret nonces), so being able to get the same result whether performing an operation inside or outside of a function makes it easy for multiple parties to coordinate and cooperate without sharing their secrets. We’ll see some of the specific benefits of linearity in schnorr signatures in [Schnorr-based Scriptless Multisignatures](#schnorr_multisignatures) and [Schnorr-based Scriptless Threshold Signatures](#schnorr_threshold_signatures).

  - Batch verification  
    When usedbatch verification of digital signatures in a certain way (which Bitcoin does), one consequence of schnorr’s linearity is that it’s relatively straightforward to verify more than one schnorr signature at the same time in less time than it would take to verify each signature independently. The more signatures that are verified in a batch, the greater the speed up. For the typical number of signatures in a block, it’s possible to batch verify them in about half the amount of time it would take to verify each signature independently.

Later in this chapter, we’ll describe the schnorr signature algorithm exactly as it’s used in Bitcoin, but we’re going to start with a simplified version of it and work our way toward the actual protocol in stages.

Alicedigital signaturesschnorr signature algorithmexamples of usageschnorr signature algorithmexamples of usage starts by choosing a large random number (*x*), which we call her *private key*. She also knows a public point on Bitcoin’s elliptic curve called the Generator (*G*) (see [???](#public_key_derivation)). Alice uses EC multiplication to multiply *G* by her private key *x*, in which case *x* is called a *scalar* because it scales up *G*. The result is *xG*, which we call Alice’s *public key*. Alice gives her public key to Bob. Even though Bob also knows *G*, the DLP prevents Bob from being able to divide *xG* by *G* to derive Alice’s private key.

At some later time, Bob wants Alice to identify herself by proving that she knows the scalar *x* for the public key (*xG*) that Bob received earlier. Alice can’t give Bob *x* directly because that would allow him to identify as her to other people, so she needs to prove her knowledge of *x* without revealing *x* to Bob,zero-knowledge proof called a *zero-knowledge proof*. For that, we begin the schnorr identity process:

1.  Alice chooses another large random number (*k*), which we call the *private nonce*. Again she uses it as a scalar, multiplying it by *G* to produce *kG*, which we call the *public nonce*. She gives the public nonce to Bob.

2.  Bob chooses a large random number of his own, *e*, which we call the *challenge scalar*. We say "challenge" because it’s used to challenge Alice to prove that she knows the private key (*x*) for the public key (*xG*) she previously gave Bob; we say "scalar" because it will later be used to multiply an EC point.

3.  Alice now has the numbers (scalars) *x*, *k*, and *e*. She combines them together to produce a final scalar *s* using the formula *s* = *k* + *ex*. She gives *s* to Bob.

4.  Bob now knows the scalars *s* and *e*, but not *x* or *k*. However, Bob does know *xG* and *kG*, and he can compute for himself *sG* and *exG*. That means he can check the equality of a scaled-up version of the operation Alice performed: *sG* == *kG* + *exG*. If that is equal, then Bob can be sure that Alice knew *x* when she generated *s*.

It might be easier to understand the interactive schnorr identity protocol if we create an insecure oversimplification by substituting each of the preceding values (including *G*) with simple integers instead of points on an elliptic curve. For example, we’ll use the prime numbers starting with 3:

Setup: Alice chooses *x* = 3 as her private key. She multiplies it by the generator *G* = 5 to get her public key *xG* = 15. She gives Bob 15.

1.  Alice chooses the private nonce *k* = 7 and generates the public nonce *kG* = 35. She gives Bob 35.

2.  Bob chooses *e* = 11 and gives it to Alice.

3.  Alice generates *s* = 40 = 7 + 11 × 3. She gives Bob 40.

4.  Bob derives *sG* = 200 = 40 × 5 and *exG* = 165 = 11 × 15. He then verifies that 200 == 35 + 165. Note that this is the same operation that Alice performed, but all of the values have been scaled up by 5 (the value of *G*).

Of course, this is an oversimplified example. When working with simple integers, we can divide products by the generator *G* to get the underlying scalar, which isn’t secure. This is why a critical property of the elliptic curve cryptography used in Bitcoin is that multiplication is easy but division by a point on the curve is impractical. Also, with numbers this small, finding underlying values (or valid substitutes) through brute force is easy; the numbers used in Bitcoin are much larger.

Let’s discuss some of the features of the interactive schnorr identity protocol that make it secure:

  - The nonce (k)  
    In step 1, digital signaturesschnorr signature algorithmsecurity featuresschnorr signature algorithmsecurity featuresAlice chooses a number that Bob doesn’t know and can’t guess and gives him the scaled form of that number, *kG*. At that point, Bob also already has her public key (*xG*), which is the scaled form of *x*, her private key. That means when Bob is working on the final equation (*sG* = *kG* + *exG*), there are two independent variables that Bob doesn’t know (*x* and *k*). It’s possible to use simple algebra to solve an equation with one unknown variable but not two independent unknown variables, so the presence of Alice’s nonce prevents Bob from being able to derive her private key. It’s critical to note that this protection depends on nonces being unguessable in any way. If there’s anything predictable about Alice’s nonce, Bob may be able to leverage that into figuring out Alice’s private key. See [The Importance of Randomness in Signatures](#nonce_warning) for more details.

  - The challenge scalar (e)  
    Bob waits to receive Alice’s public nonce and then proceeds in step 2 to give her a number (the challenge scalar) that Alice didn’t previously know and couldn’t have guessed. It’s critical that Bob only give her the challenge scalar after she commits to her public nonce. Consider what could happen if someone who didn’t know *x* wanted to impersonate Alice, and Bob accidentally gave them the challenge scalar *e* before they told him the public nonce *kG*. This allows the impersonator to change parameters on both sides of the equation that Bob will use for verification, *sG* == *kG* + *exG*; specifically, they can change both *sG* and *kG*. Think about a simplified form of that expression: *x* = *y* + *a*. If you can change both *x* and *y*, you can cancel out *a* using *x*' = (*x* – *a*) + *a*. Any value you choose for *x* will now satisfy the equation. For the actual equation the impersonator simply chooses a random number for *s*, generates *sG*, and then uses EC subtraction to select a *kG* that equals *kG* = *sG* – *exG*. They give Bob their calculated *kG* and later their random *sG*, and Bob thinks that’s valid because *sG* == (*sG* – *exG*) + *exG*. This explains why the order of operations in the protocol is essential: Bob must only give Alice the challenge scalar after Alice has committed to her public nonce.

The interactive identity protocol described here matches part of Claus Schnorr's original description, but it lacks two essential features we need for the decentralized Bitcoin network. The first of these is that it relies on Bob waiting for Alice to commit to her public nonce and then Bob giving her a random challenge scalar. In Bitcoin, the spender of every transaction needs to be authenticated by thousands of Bitcoin full nodes—including future nodes that haven't been started yet but whose operators will one day want to ensure the bitcoins they receive came from a chain of transfers where every transaction was valid. Any Bitcoin node that is unable to communicate with Alice, today or in the future, will be unable to authenticate her transaction and will be in disagreement with every other node that did authenticate it. That's not acceptable for a consensus system like Bitcoin. For Bitcoin to work, we need a protocol that doesn't require interaction between Alice and each node that wants to authenticate her.

A simple technique, known as the Fiat-Shamir transform after its discoverers, can turn the schnorr interactive identity protocol into a noninteractive digital signature scheme. Recall the importance of steps 1 and 2—​including that they be performed in order. Alice must commit to an unpredictable nonce; Bob must give Alice an unpredictable challenge scalar only after he has received her commitment. Recall also the properties of secure cryptographic hash functions we’ve used elsewhere in this book: it will always produce the same output when given the same input but it will produce a value indistinguishable from random data when given a different input.

This allows Alice to choose her private nonce, derive her public nonce, and then hash the public nonce to get the challenge scalar. Because Alice can’t predict the output of the hash function (the challenge), and because it’s always the same for the same input (the nonce), this ensures that Alice gets a random challenge even though she chooses the nonce and hashes it herself. We no longer need interaction from Bob. She can simply publish her public nonce *kG* and the scalar *s*, and each of the thousands of full nodes (past and future) can hash *kG* to produce *e*, use that to produce *exG*, and then verify *sG* == *kG* + *exG*. Written explicitly, the verification equation becomes *sG* == *kG* + *hash*(*kG*) × *xG*.

We need one other thing to finish converting the interactive schnorr identity protocol into a digital signature protocol useful for Bitcoin. We don’t just want Alice to prove that she knows her private key; we also want to give her the ability to commit to a message. Specifically, we want her to commit to the data related to the Bitcoin transaction she wants to send. With the Fiat-Shamir transform in place, we already have a commitment, so we can simply have it additionally commit to the message. Instead of *hash*(*kG*), we now also commit to the message *m* using *hash*(*kG* || *m*), where || stands for concatenation.

We’ve now defined a version of the schnorr signature protocol, but there’s one more thing we need to do to address a Bitcoin-specific concern. In BIP32 key derivation, as described in [???](#public_child_key_derivation), the algorithm for unhardened derivation takes a public key and adds to it a nonsecret value to produce a derived public key. That means it’s also possible to add that nonsecret value to a valid signature for one key to produce a signature for a related key. That related signature is valid but it wasn’t authorized by the person possessing the private key, which is a major security failure. To protect BIP32 unhardened derivation and also support several protocols people wanted to build on top of schnorr signatures, Bitcoin’s version of schnorr signatures, called *BIP340 schnorr signatures for secp256k1*, also commits to the public key being used in addition to the public nonce and the message. That makes the full commitment *hash*(*kG* || *xG* || *m*).

Now that we’ve described each part of the BIP340 schnorr signature algorithm and explained what it does for us, we can define the protocol. Multiplication of integers are performed *modulus p*, indicating that the result of the operation is divided by the number *p* (as defined in the secp256k1 standard) and the remainder is used. The number *p* is very large, but if it was 3 and the result of an operation was 5, the actual number we would use is 2 (i.e., 5 divided by 3 has a remainder of 2).

Setup: Alice chooses a large random number (*x*) as her private key (either directly or by using a protocol like BIP32 to deterministically generate a private key from a large random seed value). She uses the parameters defined in secp256k1 (see [???](#elliptic_curve)) to multiply the generator *G* by her scalar *x*, producing *xG* (her public key). She gives her public key to everyone who will later authenticate her Bitcoin transactions (e.g., by having *xG* included in a transaction output). When she’s ready to spend, she begins generating her signature:

1.  Alice chooses a large random private nonce *k* and derives the public nonce *kG*.

2.  She chooses her message *m* (e.g., transaction data) and generates the challenge scalar *e* = *hash*(*kG* || *xG* || *m*).

3.  She produces the scalar *s* = *k* + *ex*. The two values *kG* and *s* are her signature. She gives this signature to everyone who wants to verify that signature; she also needs to ensure everyone receives her message *m*. In Bitcoin, this is done by including her signature in the witness structure of her spending transaction and then relaying that transaction to full nodes.

4.  The verifiers (e.g., full nodes) use *s* to derive *sG* and then verify that *sG* == *kG* + *hash*(*kG* || *xG* || *m*) × *xG*. If the equation is valid, Alice proved that she knows her private key *x* (without revealing it) and committed to the message *m* (containing the transaction data).

### Serialization of Schnorr Signatures

A schnorr signature digital signaturesschnorr signature algorithmserializationschnorr signature algorithmserializationserializationof schnorr signature algorithmsecondary-sortas=schnorrconsists of two values, *kG* and *s*. The value *kG* is a point on Bitcoin’s elliptic curve (called secp256k1) and would normally be represented by two 32-byte coordinates, e.g., (*x*, *y*). However, only the *x* coordinate is needed, so only that value is included. When you see *kG* in schnorr signatures for Bitcoin, note that it’s only that point’s *x* coordinate.

The value *s* is a scalar (a number meant to multiply other numbers). For Bitcoin’s secp256k1 curve, it can never be more than 32 bytes long.

Although both *kG* and *s* can sometimes be values that can be represented with fewer than 32 bytes, it’s improbable that they’d be much smaller than 32 bytes, so they’re serialized as two 32-byte values (i.e., values smaller than 32 bytes have leading zeros). They’re serialized in the order of *kG* and then *s*, producing exactly 64 bytes.

The taproot soft fork, also called v1 segwit, introduced schnorr signatures to Bitcoin and is the only way they are used in Bitcoin as of this writing. When used with either taproot keypath or scriptpath spending, a 64-byte schnorr signature is considered to use a default signature hash (sighash) that is SIGHASH\_ALL. If an alternative sighash is used, or if the spender wants to waste space to explicitly specify SIGHASH\_ALL, a single additional byte is appended to the signature that specifies the signature hash, making the signature 65 bytes.

As we’ll see, either 64 or 65 bytes is considerably more efficient that the serialization used for ECDSA signatures described in [Serialization of ECDSA Signatures (DER)](#serialization_of_signatures_der).

### Schnorr-based Scriptless Multisignatures

In thedigital signaturesschnorr signature algorithmscriptless multisignaturesschnorr signature algorithmscriptless multisignaturesid=schnorr-multisigscriptless multisignaturesin schnorr signature algorithmsecondary-sortas=schnorrmultisignature scriptsin schnorr signature algorithmsecondary-sortas=schnorr single-signature schnorr protocol described in [Schnorr Signatures](#schnorr_signatures), Alice uses a signature (*kG*, *s*) to publicly prove her knowledge of her private key, which in this case we’ll call *y*. Imagine if Bob also has a private key (*z*) and he’s willing to work with Alice to prove that together they know *x* = *y* + *z* without either of them revealing their private key to each other or anyone else. Let’s go through the BIP340 schnorr signature protocol again.

<div class="warning">

The simple protocol we are about to describe is not secure for the reasons we will explain shortly. We use it only to demonstrate the mechanics of schnorr multisignatures before describing related protocols that are believed to be secure.

</div>

Alice and Bob need to derive the public key for *x*, which is *xG*. Since it’s possible to use elliptic curve operations to add two EC points together, they start by Alice deriving *yG* and Bob deriving *zG*. They then add them together to create *xG* = *yG* + *zG*. The point *xG* is aggregated public keyspublic keysaggregatedtheir *aggregated public key*. To create a signature, they begin the simple multisignature protocol:

1.  They each individually choose a large random private nonce, *a* for Alice and *b* for Bob. They also individually derive the corresponding public nonce *aG* and *bG*. Together, they produce an aggregated public nonce *kG* = *aG* + *bG*.

2.  They agree on the message to sign, *m* (e.g., a transaction), and each generates a copy of the challenge scalar: *e* = *hash*(*kG* || *xG* || *m*).

3.  Alice produces the scalar *q* = *a* + *ey*. Bob produces the scalar *r* = *b* + *ez*. They add the scalars together to produce *s* = *q* + *r*. Their signature is the two values *kG* and *s*.

4.  The verifiers check their public key and signature using the normal equation: *sG* == *kG* + *hash*(*kG* || *xG* || *m*) × *xG*.

Alice and Bob have proven that they know the sum of their private keys without either one of them revealing their private key to the other or anyone else. The protocol can be extended to any number of participants (e.g., a million people could prove they knew the sum of their million different keys).

The preceding protocol has several security problems. Most notable is that one party might learn the public keys of the other parties before committing to their own public key. For example, Alice generates her public key *yG* honestly and shares it with Bob. Bob generates his public key using *zG* – *yG*. When their two keys are combined (*yG* + *zG* – *yG*), the positive and negative *yG* terms cancel out so the public key only represents the private key for *z* (i.e., Bob’s private key). Now Bob can create a valid signature without any assistance from Alice. This is key cancellation attackscalled a *key cancellation attack*.

There are various ways to solve the key cancellation attack. The simplest scheme would be to require each participant commit to their part of the public key before sharing anything about that key with all of the other participants. For example, Alice and Bob each individually hash their public keys and share their digests with each other. When they both have the other’s digest, they can share their keys. They individually check that the other’s key hashes to the previously provided digest and then proceed with the protocol normally. This prevents either one of them from choosing a public key that cancels out the keys of the other participants. However, it’s easy to fail to implement this scheme correctly, such as using it in a naive way with unhardened BIP32 public key derivation. Additionally, it adds an extra step for communication between the participants, which may be undesirable in many cases. More complex schemes have been proposed that address these shortcomings.

In addition to the key cancellation attack, there are a number of attacks possible against nonce attacksnonces. Recall that the purpose of the nonce is to prevent anyone from being able to use their knowledge of other values in the signature verification equation to solve for your private key, determining its value. To effectively accomplish that, you must use a different nonce every time you sign a different message or change other signature parameters. The different nonces must not be related in any way. For a multisignature, every participant must follow these rules or it could compromise the security of other participants. In addition, cancellation and other attacks need to be prevented. Different protocols that accomplish these aims make different trade-offs, so there’s no single multisignature protocol to recommend in all cases. Instead, we’ll note three from the MuSig family of protocols:

  - MuSig  
    Also called *MuSig1*, this protocolMuSig protocol requires three rounds of communication during the signing process, making it similar to the process we just described. MuSig1’s greatest advantage is its simplicity.

  - MuSig2  
    This only MuSig2 protocolrequires two rounds of communication and can sometimes allow one of the rounds to be combined with key exchange. This can significantly speed up signing for certain protocols, such as how scriptless multisignatures are planned to be used in the LN. MuSig2 is specified in BIP327 (the only scriptless multisignature protocol that has a BIP as of this writing).

  - MuSig-DN  
    DN stands MuSig-DN protocolrepeated session attacksfor Deterministic Nonce, which eliminates as a concern a problem known as the *repeated session attack*. It can’t be combined with key exchange and it’s significantly more complex to implement than MuSig or MuSig2.

For most applications, MuSig2 is the best multisignature protocol available at the timedigital signaturesschnorr signature algorithmscriptless multisignaturesschnorr signature algorithmscriptless multisignaturesstartref=schnorr-multisigscriptless multisignaturesin schnorr signature algorithmsecondary-sortas=schnorrmultisignature scriptsin schnorr signature algorithmsecondary-sortas=schnorr of writing.

### Schnorr-based Scriptless Threshold Signatures

Scriptless digital signaturesschnorr signature algorithmscriptless threshold signaturesschnorr signature algorithmscriptless threshold signaturesid=schnorr-thresholdscriptless threshold signaturesid=scriptless-threshold-schnorrthreshold signaturesin schnorr signature algorithmsecondary-sortas=schnorrmultisignature protocols only work for *k*-of-*k* signing. Everyone with a partial public key that becomes part of the aggregated public key must contribute a partial signature and partial nonce to the final signature. Sometimes, though, the participants want to allow a subset of them to sign, such as *t*-of-*k* where a threshold (*t*) number of participants can sign for a key constructed by *k* participants. That type of signature is called a *threshold signature*.

We saw script-based threshold signatures in [???](#multisig). But just as scriptless multisignatures save space and increase privacy compared to scripted multisignatures, *scriptless threshold signatures* save space and increase privacy compared to *scripted threshold signatures*. To anyone not involved in the signing, a *scriptless threshold signature* looks like any other signature that could’ve been created by a single-sig user or through a scriptless multisignature protocol.

Various methods are known for generating scriptless threshold signatures, with the simplest being a slight modification of how we created scriptless multisignatures previously. This protocol also depends on verifiable secret sharing (which itself depends on secure secret sharing).

Basic secret sharing can work through simple splitting. Alice has a secret number that she splits into three equal-length parts and shares with Bob, Carol, and Dan. Those three can combine the partial numbers they received (called *shares*) in the correct order to reconstruct Alice’s secret. A more sophisticated scheme would involve Alice adding on some additional information to each share, called a correction code, that allows any two of them to recover the number. This scheme is not secure because each share gives its holder partial knowledge of Alice’s secret, making it easier for the participant to guess Alice’s secret than a nonparticipant who didn’t have a share.

A secure secret sharing scheme prevents participants from learning anything about the secret unless they combine the minimum threshold number of shares. For example, Alice can choose a threshold of 2 if she wants any two of Bob, Carol, and Dan to be able to reconstruct her secret. The best known secure secret sharing algorithm is *Shamir’s Secret Sharing Scheme*, commonly abbreviated SSSS and named after its discoverer, one of the same discoverers of the Fiat-Shamir transform we saw in [Schnorr Signatures](#schnorr_signatures).

In some cryptographic protocols, such as the scriptless threshold signature schemes we’re working toward, it’s critical for Bob, Carol, and Dan to know that Alice followed her side of the protocol correctly. They need to know that the shares she creates all derive from the same secret, that she used the threshold value she claims, and that she gave each one of them a different share. A protocol that can accomplish all of that, and still be a secure secret sharing scheme, is a *verifiable secret sharing scheme*.

To see how multisignatures and verifiable secret sharing work for Alice, Bob, and Carol, imagine they each wish to receive funds that can be spent by any two of them. They collaborate as described in [Schnorr-based Scriptless Multisignatures](#schnorr_multisignatures) to produce a regular multisignature public key to accept the funds (k-of-k). Then each participant derives two secret shares from their private key—​one for each of two the other participants. The shares allow any two of them to reconstruct the originating partial private key for the multisignature. Each participant distributes one of their secret shares to the other two participants, resulting in each participant storing their own partial private key and one share for every other participant. Subsequently, each participant verifies the authenticity and uniqueness of the shares they received compared to the shares given to the other participants.

Later on, when (for example) Alice and Bob want to generate a scriptless threshold signature without Carol’s involvement, they exchange the two shares they possess for Carol. This enables them to reconstruct Carol’s partial private key. Alice and Bob also have their private keys, allowing them to create a scriptless multisignature with all three necessary keys.

In other words, the scriptless threshold signature scheme just described is the same as a scriptless multisignature scheme except that a threshold number of participants have the ability to reconstruct the partial private keys of any other participants who are unable or unwilling to sign.

This does point to a few things to be aware about when considering a scriptless threshold signature protocol:

  - No accountability  
    Because Alice and Bob reconstruct Carol’s partial private key, there can be no fundamental difference between a scriptless multisignature produced by a process that involved Carol and one that didn’t. Even if Alice, Bob, or Carol claim that they didn’t sign, there’s no guaranteed way for them to prove that they didn’t help produce the signature. If it’s important to know which members of the group signed, you will need to use a script.

  - Manipulation attacks  
    Imagine that Bob tells Alice that Carol is unavailable, so they work together to reconstruct Carol’s partial private key. Then Bob tells Carol that Alice is unavailable, so they work together to reconstruct Alice’s partial private key. Now Bob has his own partial private key plus the keys of Alice and Carol, allowing him to spend the funds himself without their involvement. This attack can be addressed if all of the participants agree to only communicate using a scheme that allows any one of them to see all of the other’s messages (e.g., if Bob tells Alice that Carol is unavailable, Carol is able to see that message before she begins working with Bob). Other solutions, possibly more robust solutions, to this problem were being researched at the time of writing.

No scriptless threshold signature protocol has been proposed as a BIP yet, although significant research into the subject has been performed by multiple Bitcoin contributors and we expect peer-reviewed solutions will become available after the publication of thisdigital signaturesschnorr signature algorithmstartref=digital-sigs-schnorrschnorr signature algorithmstartref=schnorrdigital signaturesschnorr signature algorithmscriptless threshold signaturesschnorr signature algorithmscriptless threshold signaturesstartref=schnorr-thresholdscriptless threshold signaturesstartref=scriptless-threshold-schnorrthreshold signaturesin schnorr signature algorithmsecondary-sortas=schnorr book.

## ECDSA Signatures

Unfortunately digital signaturesECDSAid=digital-signature-ecdsaECDSA (Elliptic Curve Digital Signature Algorithm)id=ecdsafor the future development of Bitcoin and many other applications, Claus Schnorr patented the algorithm he discovered and prevented its use in open standards and open source software for almost two decades. Cryptographers in the early 1990s who were blocked from using the schnorr signature scheme developed an alternative construction called the *Digital Signature Algorithm* (DSA), with a version adapted to elliptic curves called ECDSA.

The ECDSA scheme and standardized parameters for suggested curves it could be used with were widely implemented in cryptographic libraries by the time development on Bitcoin began in 2007. This was almost certainly the reason why ECDSA was the only digital signature protocol that Bitcoin supported from its first release version until the activation of the taproot soft fork in 2021. ECDSA remains supported today for all non-taproot transactions. Some of the differences compared to schnorr signatures include:

  - More complex  
    As we’ll see, ECDSA requires more operations to create or verify a signature than the schnorr signature protocol. It’s not significantly more complex from an implementation standpoint, but that extra complexity makes ECDSA less flexible, less performant, and harder to prove secure.

  - Less provable security  
    The interactive schnorr signature identification protocol depends only on the strength of the elliptic curve Discrete Logarithm Problem (ECDLP). The non-interactive authentication protocol used in Bitcoin also relies on the random oracle model (ROM). However, ECDSA’s extra complexity has prevented a complete proof of its security being published (to the best of our knowledge). We are not experts in proving cryptographic algorithms, but it seems unlikely after 30 years that ECDSA will be proven to only require the same two assumptions as schnorr.

  - Nonlinear  
    ECDSA signatures cannot be easily combined to create scriptless multisignatures or used in related advanced applications, such as multiparty signature adaptors. There are workarounds for this problem, but they involve additional extra complexity that significantly slows down operations and which, in some cases, has resulted in software accidentally leaking private keys.

### ECDSA Algorithm

Let’s look at the math of ECDSA. Signatures are created by a mathematical function *F*<sub>*sig*</sub> that produces a signature composed of two values. In ECDSA, those two values are *R* and *s*.

The signature algorithm first generates a private nonce (*k*) and derives from it a public nonce (*K*). The *R* value of the digital signature is then the *x* coordinate of the nonce *K*.

From there, the algorithm calculates the *s* value of the signature. Like we did with schnorr signatures, operations involving integers are modulus p:

\[\begin{equation}
s = k^{-1} (Hash(m) + x \times R)
\end{equation}\]

where:

  - *k* is the private nonce

  - *R* is the *x* coordinate of the public nonce

  - *x* is the Alice’s private key

  - *m* is the message (transaction data)

Verification is the inverse of the signature generation function, using the *R*, *s* values and the public key to calculate a value *K*, which is a point on the elliptic curve (the public nonce used in signature creation):

\[\begin{equation}
K = s^{-1} \times Hash(m) \times G + s^{-1} \times R \times X
\end{equation}\]

where:

  - *R* and *s* are the signature values

  - *X* is Alice’s public key

  - *m* is the message (the transaction data that was signed)

  - *G* is the elliptic curve generator point

If the *x* coordinate of the calculated point *K* is equal to *R*, then the verifier can conclude that the signature is valid.

<div class="tip">

ECDSA is necessarily a fairly complicated piece of math; a full explanation is beyond the scope of this book. A number of great guides online take you through it step by step: search for "ECDSA explained."

</div>

### Serialization of ECDSA Signatures (DER)

Let’s serializationECDSA signatureslook at the following DER-encoded signature:

    3045022100884d142d86652a3f47ba4746ec719bbfbd040a570b1deccbb6498c75c4ae24cb02204
    b9f039ff08df09cbe9f6addac960298cad530a863ea8f53982c09db8f6e381301

That signature is a serialized byte stream of the *R* and *s* values produced by the signer to prove control of the private key authorized to spend an output. The serialization format consists of nine elements as follows:

  - 0x30, indicating the start of a DER sequence

  - 0x45, the length of the sequence (69 bytes)

  - 0x02, an integer value follows

  - 0x21, the length of the integer (33 bytes)

  - R, 00884d142d86652a3f47ba4746ec719bbfbd040a570b1deccbb6498c75c4ae24cb

  - 0x02, another integer follows

  - 0x20, the length of the integer (32 bytes)

  - S, 4b9f039ff08df09cbe9f6addac960298cad530a863ea8f53982c09db8f6e3813

  - A suffix (0x01) indicating the type of hashdigital signaturesECDSAstartref=digital-signature-ecdsaECDSA (Elliptic Curve Digital Signature Algorithm)startref=ecdsa used (SIGHASH\_ALL)

## The Importance of Randomness in Signatures

As wedigital signaturesrandomness, importance ofid=digital-signature-randomrandomness, importance in digital signaturesid=random-digital-signature saw in [Schnorr Signatures](#schnorr_signatures) and [ECDSA Signatures](#ecdsa_signatures), the signature generation algorithm uses a random number *k* as the basis for a private/public nonce pair. The value of *k* is not important, *as long as it is random*. If signatures from the same private key use the private nonce *k* with different messages (transactions), then the signing *private key* can be calculated by anyone. Reuse of the same value for *k* in a signature algorithm leads to exposure of the private key\!

<div class="warning">

If the same value *k* is used in the signing algorithm on two different transactions, the private key can be calculated and exposed to the world\!

</div>

This is not just a theoretical possibility. We have seen this issue lead to exposure of private keys in a few different implementations of transaction-signing algorithms in Bitcoin. People have had funds stolen because of inadvertent reuse of a *k* value. The most common reason for reuse of a *k* value is an improperly initialized random-number generator.

To avoid this vulnerability, the industry best practice is to not generate *k* with a random-number generator seeded only with entropy, but instead to use a process seeded in part with the transaction data itself plus the private key being used to sign. This ensures that each transaction produces a different *k*. The industry-standard algorithm for deterministic initialization of *k* for ECDSA is defined in [RFC6979](https://oreil.ly/yuabl), published by the Internet Engineering Task Force. For schnorr signatures, BIP340 recommends a default signing algorithm.

BIP340 and RFC6979 can generate *k* entirely deterministically, meaning the same transaction data will always produce the same *k*. Many wallets do this because it makes it easy to write tests to verify their safety-critical signing code is producing *k* values correctly. BIP340 and RFC6979 both also allow including additional data in the calculation. If that data is entropy, then a different *k* will be produced even if the exact same transaction data is signed. This can increase protection against sidechannel and fault-injection attacks.

If you are implementing an algorithm to sign transactions in Bitcoin, you *must* use BIP340, RFC6979, or a similar algorithm to ensure you generate a different *k* for each digital signaturesrandomness, importance ofstartref=digital-signature-randomrandomness, importance in digital signaturesstartref=random-digital-signaturetransaction.

## Segregated Witness’s New Signing Algorithm

Signatures indigital signaturessegregated witness andsegregated witness (segwit)digital signatures andcommitment hash Bitcoin transactions are applied on a *commitment hash*, which is calculated from the transaction data, locking specific parts of the data indicating the signer’s commitment to those values. For example, in a simple SIGHASH\_ALL type signature, the commitment hash includes all inputs and outputs.

Unfortunately, the way the legacy commitment hashes were calculated introduced the possibility that a node verifying a signature can be forced to perform a significant number of hash computations. Specifically, the hash operations increase roughly quadratically with respect to the number of inputs in the transaction. An attacker could therefore create a transaction with a very large number of signature operations, causing the entire Bitcoin network to have to perform hundreds or thousands of hash operations to verify the transaction.

Segwit represented an opportunity to address this problem by changing the way the commitment hash is calculated. For segwit version 0 witness programs, signature verification occurs using an improved commitment hash algorithm as specified in BIP143.

The new algorithm allows the number of hash operations to increase by a much more gradual O(n) to the number of signature operations, reducing the opportunity to create denial-of-service attacks with overly complex transactions.

In this chapter, we learned about schnorr and ECDSA signatures for Bitcoin. This explains how full nodes authenticate transactions to ensure that only someone controlling the key to which bitcoins were received can spend those bitcoins. We also examined several advanced applications of signatures, such as scriptless multisignatures and scriptless threshold signatures that can be used to improve the efficiency and privacy of Bitcoin. In the past few chapters, we’ve learned how to create transactions, how to secure them with authorization and authentication, and how to sign them. We will next learn how to encourage miners to confirm them by adding fees to the transactions we create.
