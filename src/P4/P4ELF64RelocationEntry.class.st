Class {
	#name : #P4ELF64RelocationEntry,
	#superclass : #P4Object,
	#instVars : [
		'offset',
		'symbol',
		'type'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #'as yet unclassified' }
P4ELF64RelocationEntry class >> pname [
	<preventExport>
	^ pname ifNil: [ pname := (self name copyFrom: 'P4ELF' size + 1 to: self name size) asSymbol ]
]

{ #category : #accessing }
P4ELF64RelocationEntry >> absolute [
	type := 16rB
]

{ #category : #accessing }
P4ELF64RelocationEntry >> info [
	^ symbol symbolTableIndex
]

{ #category : #accessing }
P4ELF64RelocationEntry >> offset [
	^ offset
]

{ #category : #accessing }
P4ELF64RelocationEntry >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
P4ELF64RelocationEntry >> relative [
	type := 16r2
]

{ #category : #accessing }
P4ELF64RelocationEntry >> symbol [
	^ symbol
]

{ #category : #accessing }
P4ELF64RelocationEntry >> symbol: anObject [
	symbol := anObject
]

{ #category : #accessing }
P4ELF64RelocationEntry >> type [
	"
	0 	R_X86_64_NONE
	1 	R_X86_64_64
	2 	R_X86_64_PC32                     == RELATIVE
	3 	R_X86_64_GOT32
	4 	R_X86_64_PLT32
	5 	R_X86_64_COPY
	6 	R_X86_64_GLOB_DAT
	7 	R_X86_64_JUMP_SLO
	8 	R_X86_64_RELATIVE
	9 	R_X86_64_GOTPCREL
	A 	R_X86_64_32
	B 	R_X86_64_32S                         == ABSOLUTE
	C 	R_X86_64_16
	D 	R_X86_64_PC16
	E 	R_X86_64_8
	F 	R_X86_64_PC8
	"
	^ type
]

{ #category : #writing }
P4ELF64RelocationEntry >> writeOn: aStream [
	aStream pointerPut: offset.

	" this is 64bit specific. on 32 bit it's info << 8 + type "
	aStream pointerPut: (self info << 32 + self type).
	"aStream wordPut: self type.
	aStream wordPut: self info."
	"aStream pointerPut: (self info << 8 + self type)"
]
