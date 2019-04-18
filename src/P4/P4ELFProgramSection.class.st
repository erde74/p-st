Class {
	#name : #P4ELFProgramSection,
	#superclass : #P4ELFSectionWithData,
	#instVars : [
		'relocation'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #'instance creation' }
P4ELFProgramSection class >> newFor: aSectionTable [
	^ self new
		relocation: aSectionTable createRelocationTable
]

{ #category : #header }
P4ELFProgramSection >> entrySize: wordSize [
	^ 1
]

{ #category : #testing }
P4ELFProgramSection >> hasRelocationTable [
	^ relocation isEmpty not
]

{ #category : #header }
P4ELFProgramSection >> infoLink [
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
	flags := flags bitXor: 16r40
]

{ #category : #'initialize-release' }
P4ELFProgramSection >> initialize [
	super initialize.
	flags := 0.
	data := #().
]

{ #category : #header }
P4ELFProgramSection >> linkOrder [
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
	flags := flags bitXor: 16r80
]

{ #category : #accessing }
P4ELFProgramSection >> relocation: aRelocationTable [
	relocation := aRelocationTable.
	relocation target: self
]

{ #category : #accessing }
P4ELFProgramSection >> relocationTable [
	^ relocation
]

{ #category : #header }
P4ELFProgramSection >> size: words [
	^ data size
]

{ #category : #header }
P4ELFProgramSection >> type [
	" 1 PROGBITS Format and meaning determined solely by the program "
	^ 16r1
]

{ #category : #writing }
P4ELFProgramSection >> writeOn: aStream [
	super writeOn: aStream.
	aStream << data.
]
