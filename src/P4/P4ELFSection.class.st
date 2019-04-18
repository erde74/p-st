Class {
	#name : #P4ELFSection,
	#superclass : #P4ELFIndexable,
	#instVars : [
		'headerIndex',
		'offset',
		'addrAlign',
		'flags'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #'as yet unclassified' }
P4ELFSection class >> pname [
	<preventExport>
	^ pname ifNil: [ pname := (self name copyFrom: 'P4ELF' size + 1 to: self name size) asSymbol ]
]

{ #category : #header }
P4ELFSection >> addrAlign [
	" No alignment enforced. Should be power of 2 to enforce alignment "
	^ addrAlign
]

{ #category : #header }
P4ELFSection >> alloc [
	"
	SHF_WRITE 					0x1
	SHF_ALLOC						0x2
	SHF_EXECINSTR				0x4
	SHF_MERGE					0x10
	SHF_STRINGS					0x20
	SHF_INFO_LINK				0x40
	SHF_LINK_ORDER				0x80
	SHF_OS_NONCONFORMING	0x100
	SHF_GROUP					0x200
	SHF_TLS						0x400
	SHF_MASKOS					0x0ff00000
	SHF_MASKPROC				0xf0000000
	"
	flags := flags bitXor: 16r2
]

{ #category : #converting }
P4ELFSection >> asSymbol [
	^ self name
]

{ #category : #header }
P4ELFSection >> bind [
	"
	STB_LOCAL 	0
	STB_GLOBAL 	1
	STB_WEAK   	2
	"
	^ 0
]

{ #category : #header }
P4ELFSection >> entrySize: pointerSize [
	^ self entrySizeInPointers * pointerSize
]

{ #category : #header }
P4ELFSection >> entrySizeInPointers [
	self subclassResponsibility
]

{ #category : #header }
P4ELFSection >> exec [
	"
	SHF_WRITE 					0x1
	SHF_ALLOC						0x2
	SHF_EXECINSTR				0x4
	SHF_MERGE					0x10
	SHF_STRINGS					0x20
	SHF_INFO_LINK				0x40
	SHF_LINK_ORDER				0x80
	SHF_OS_NONCONFORMING	0x100
	SHF_GROUP					0x200
	SHF_TLS						0x400
	SHF_MASKOS					0x0ff00000
	SHF_MASKPROC				0xf0000000
	"
	flags := flags bitXor: 16r4
]

{ #category : #header }
P4ELFSection >> flags [
	"
	SHF_WRITE 					0x1
	SHF_ALLOC						0x2
	SHF_EXECINSTR				0x4
	SHF_MERGE					0x10
	SHF_STRINGS					0x20
	SHF_INFO_LINK				0x40
	SHF_LINK_ORDER				0x80
	SHF_OS_NONCONFORMING	0x100
	SHF_GROUP					0x200
	SHF_TLS						0x400
	SHF_MASKOS					0x0ff00000
	SHF_MASKPROC				0xf0000000
	"
	^ flags
]

{ #category : #testing }
P4ELFSection >> hasRelocationTable [
	^ false
]

{ #category : #accessing }
P4ELFSection >> headerIndex [
	^ headerIndex
]

{ #category : #accessing }
P4ELFSection >> headerIndex: anObject [
	headerIndex := anObject
]

{ #category : #header }
P4ELFSection >> info [
	" see link "
	^ 16r0
]

{ #category : #'initialize-release' }
P4ELFSection >> initialize [
	addrAlign := 0.
	flags := 0.
]

{ #category : #testing }
P4ELFSection >> isLocal [
	^ true
]

{ #category : #header }
P4ELFSection >> link [
	"
	if type is ... then link = section header index of...; info = 
	
	DYNAMIC string table used by entries; 0
	HASH symbol table to which hash tables applies; 0
	REL/RELA associated symbol table; section header index of the section to which the relocation applies
	SYMTAB/DYNSYM associated string table; symbol table index of last local symbol + 1
	
	other -> UNDEF; 0
	"
	^ 16r0
]

{ #category : #header }
P4ELFSection >> merge [
	"
	SHF_WRITE 					0x1
	SHF_ALLOC						0x2
	SHF_EXECINSTR				0x4
	SHF_MERGE					0x10
	SHF_STRINGS					0x20
	SHF_INFO_LINK				0x40
	SHF_LINK_ORDER				0x80
	SHF_OS_NONCONFORMING	0x100
	SHF_GROUP					0x200
	SHF_TLS						0x400
	SHF_MASKOS					0x0ff00000
	SHF_MASKPROC				0xf0000000
	"
	flags := flags bitXor: 16r10
]

{ #category : #accessing }
P4ELFSection >> offset [
	^ offset

]

{ #category : #accessing }
P4ELFSection >> offset: anObject [
	offset := anObject
]

{ #category : #header }
P4ELFSection >> other [
	^ 0
]

{ #category : #header }
P4ELFSection >> size: pointerSize [
	^ self sizeInPointers * pointerSize
]

{ #category : #header }
P4ELFSection >> sizeInPointers [
	^ 0
]

{ #category : #header }
P4ELFSection >> strings [
	"
	SHF_WRITE 					0x1
	SHF_ALLOC						0x2
	SHF_EXECINSTR				0x4
	SHF_MERGE					0x10
	SHF_STRINGS					0x20
	SHF_INFO_LINK				0x40
	SHF_LINK_ORDER				0x80
	SHF_OS_NONCONFORMING	0x100
	SHF_GROUP					0x200
	SHF_TLS						0x400
	SHF_MASKOS					0x0ff00000
	SHF_MASKPROC				0xf0000000
	"
	flags := flags bitXor: 16r20
]

{ #category : #header }
P4ELFSection >> symbolType [
	^ 16r3
]

{ #category : #header }
P4ELFSection >> type [
	"
	0 NULL Inactive header
	1 PROGBITS Format and meaning determined solely by the program
	2 SYMTAB Symbol table (single)
	3 STRTAB String table (multiple)
	4 RELA Relocation entries with explicit addends (multiple)
	5 HASH Symbol hash table (for dynamic linking, single)
	6 DYNAMIC Information for dynamic linking (single)
	7 NOTE File marking
	8 NOBITS Occupies no space in the file, otherwise similar to PROGBITS
	9 REL Relocation entries without explicit addents (multiple)
	10 SHLIB Unspecified semantics (not conform to ABI)
	11 DYNSYM 
	
	Region for processor-specific semantics: 
	0x70000000 LOPROC
	0x7FFFFFFF HIPROC
	
	Region can be used for application specific section types without conflicting with current/future system-defined types:
	0x80000000 LOUSER
	0x8FFFFFFF HIUSER
	
	"
	self subclassResponsibility
]

{ #category : #header }
P4ELFSection >> visibility [
	^ self isLocal
		ifTrue: [ 16r0 ]
		ifFalse: [ 16r1 ]
]

{ #category : #header }
P4ELFSection >> write [
	"
	SHF_WRITE 					0x1
	SHF_ALLOC						0x2
	SHF_EXECINSTR				0x4
	SHF_MERGE					0x10
	SHF_STRINGS					0x20
	SHF_INFO_LINK				0x40
	SHF_LINK_ORDER				0x80
	SHF_OS_NONCONFORMING	0x100
	SHF_GROUP					0x200
	SHF_TLS						0x400
	SHF_MASKOS					0x0ff00000
	SHF_MASKPROC				0xf0000000
	"
	flags := flags bitXor: 16r1
]

{ #category : #writing }
P4ELFSection >> writeHeaderOn: aStream [
	aStream wordPut: nameIndex.
	aStream wordPut: self type.
	
	aStream pointerPut: self flags.
	" For now we don't allow sections to force addresses "
	aStream pointerPut: 0.
	aStream pointerPut: self offset.
	aStream pointerPut: (self size: aStream pointerSize).
	
	aStream wordPut: self link.
	aStream wordPut: self info.
	
	aStream pointerPut: self addrAlign.
	aStream pointerPut: (self entrySize: aStream pointerSize).
]

{ #category : #writing }
P4ELFSection >> writeOn: aStream [
	offset := aStream position
]

{ #category : #writing }
P4ELFSection >> writeSymbolOn: aStream [
	aStream wordPut: 0.
	aStream nextPut: (self visibility bitShift: 4) + (self symbolType bitAnd: 16rF).
	aStream nextPut: self other.
	aStream halfWordPut: self headerIndex.
	aStream pointerPut: 0.
	aStream pointerPut: 0
]
