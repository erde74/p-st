Class {
	#name : #P4MORelocation,
	#superclass : #P4Object,
	#instVars : [
		'isAbsolute',
		'symbol',
		'address'
	],
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MORelocation >> absolute [
	isAbsolute := true
]

{ #category : #'as yet unclassified' }
P4MORelocation >> address: position [
	"In MH_OBJECT files, this is an offset from the start of the section to the item containing the address requiring relocation. If the high bit of this field is set (which you can check using the R_SCATTERED bit mask), the relocation_info structure is actually a scattered_relocation_info structure.
	In images used by the dynamic linker, this is an offset from the virtual memory address of the data of the first segment_command that appears in the file (not necessarily the one with the lowest address). For images with the MH_SPLIT_SEGS flag set, this is an offset from the virtual memory address of data of the first read/write segment_command."
	address := position
]

{ #category : #'as yet unclassified' }
P4MORelocation >> fileSize [
	"sizeof(relocation_info) = 1 * sizeof(pointer) = 8"
	^ 8
]

{ #category : #'as yet unclassified' }
P4MORelocation >> initialize [ 
	isAbsolute := false
]

{ #category : #'as yet unclassified' }
P4MORelocation >> isExternal [
	"Indicates whether the r_symbolnum field is an index into the symbol table (true) or a section number (false)."
	^ true
]

{ #category : #'as yet unclassified' }
P4MORelocation >> length [
	"long"
	isAbsolute ifFalse: [ ^ 2].
	"quad"
	^ 2
]

{ #category : #'as yet unclassified' }
P4MORelocation >> symbol: aSymbol [
	symbol := aSymbol
]

{ #category : #'as yet unclassified' }
P4MORelocation >> type [
    "For the x86-64 environment, the r_type field may contain any of these values:
        X86_64_RELOC_UNSIGNED,   (0) // for absolute addresses
        X86_64_RELOC_SIGNED,     (1) // for signed 32-bit displacement
        X86_64_RELOC_BRANCH,     (2) // a CALL/JMP instruction with 32-bit displacement
        X86_64_RELOC_GOT_LOAD,   (3) // a MOVQ load of a GOT entry
        X86_64_RELOC_GOT,        (4) // other GOT references
        X86_64_RELOC_SUBTRACTOR, (5) // must be followed by a X86_64_RELOC_UNSIGNED
        X86_64_RELOC_SIGNED_1,   (6) // for signed 32-bit displacement with a -1 addend
        X86_64_RELOC_SIGNED_2,   (7) // for signed 32-bit displacement with a -2 addend
        X86_64_RELOC_SIGNED_4,   (8) // for signed 32-bit displacement with a -4 addend
        X86_64_RELOC_TLV,        (9) // for thread local variables"
	
	isAbsolute ifTrue: [ ^ 0 "X86_64_RELOC_UNSIGNED"].
	^ 2 "X86_64_RELOC_BRANCH"
]

{ #category : #'as yet unclassified' }
P4MORelocation >> writeOn: aStream [
	|part|
	"struct relocation_info {
		int32_t r_address;
		uint32_t r_symbolnum:24,
		r_pcrel:1,
		r_length:2,
		r_extern:1,
		r_type:4;
	};"
	aStream wordPut: address. "r_address"
	part := (symbol index bitAnd: 16rFFFFFF). "r_symbolnum"
	part := part bitOr: (self type bitShift: 28). "r_type"
	part := part bitOr: (self isExternal asBit bitShift: 27). "r_extern"
	part := part bitOr: (self length bitShift:  25). "r_length"
	part := part bitOr: (isAbsolute not asBit bitShift: 24). "r_pcrel"
	aStream wordPut: part.
]
