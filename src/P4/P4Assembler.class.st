Class {
	#name : #P4Assembler,
	#superclass : #P4Object,
	#instVars : [
		'stream',
		'linker',
		'installer',
		'forceShortJump'
	],
	#category : #'P4-SystemSpec'
}

{ #category : #building }
P4Assembler >> access: aRegister at: anOffset [
	^ P4ASMRegisterAccess new
		register: aRegister;
		offset: anOffset * self pointerSize
]

{ #category : #accessing }
P4Assembler >> basePointer [
	self subclassResponsibility
]

{ #category : #accessing }
P4Assembler >> callRegister: num of: argSize [
	num <= self callRegisterSize ifTrue: [ ^ self callRegisters at: num ].
	^ self stackPointer accessAt: (num - self callRegisterSize - 1) * self pointerSize
]

{ #category : #accessing }
P4Assembler >> callRegisterSize [
	^ self callRegisters size
]

{ #category : #accessing }
P4Assembler >> callRegisters [
	self subclassResponsibility
]

{ #category : #flushing }
P4Assembler >> code [
	^ stream
]

{ #category : #building }
P4Assembler >> constant: aValue [
	^ P4ASMConstant new
		constantValue: aValue
]

{ #category : #printing }
P4Assembler >> createStream [
	^ P4LittleEndianWriteStream new
		wordSize: self wordSize;
		pointerSize: self pointerSize
]

{ #category : #elf }
P4Assembler >> elfClass [
	"
	0 None
	1 32 bit
	2 64 bit
	"
	^ 16r01
]

{ #category : #elf }
P4Assembler >> elfDataEncoding [
	"
	0 NONE Invalid Data Encoding 
	1 DATA2LSB 2's complement Little Endian
	2 DATA2MSB 2's complement Big Endian
	"
	^ 16r01
]

{ #category : #elf }
P4Assembler >> elfHeaderSize [
	self subclassResponsibility
]

{ #category : #elf }
P4Assembler >> elfMachine [
	" A table can be found at: http://www.sco.com/developers/gabi/2003-12-17/ch4.eheader.html "
	self subclassResponsibility
]

{ #category : #relocating }
P4Assembler >> externalReference: label [
	^ P4ASMExternalReference new label: label
]

{ #category : #accessing }
P4Assembler >> extraRegisters [
	self subclassResponsibility
]

{ #category : #flushing }
P4Assembler >> finalize [
	linker danglingReferences keysAndValuesDo: [ :function :positions |
		self haltIf: function isSymbol not.
		positions do: [ :position | installer installFunction: function at: position ]].
	linker danglingReferences removeAll.
]

{ #category : #accessing }
P4Assembler >> flags [
	self subclassResponsibility
]

{ #category : #'initialize-release' }
P4Assembler >> forceShortJump [
	forceShortJump := true.
]

{ #category : #'initialize-release' }
P4Assembler >> initialize [
	linker := P4Linker new.
	stream := self createStream.
]

{ #category : #accessing }
P4Assembler >> installer: anInstaller [
	installer := anInstaller 
]

{ #category : #accessing }
P4Assembler >> intermediateRegisters [
	self subclassResponsibility
]

{ #category : #'initialize-release' }
P4Assembler >> isShortJump [
	^ forceShortJump
]

{ #category : #'initialize-release' }
P4Assembler >> isShortJump: offset [
	forceShortJump := false.
	^ (offset >= -128 and: [offset < 128]) 

]

{ #category : #calling }
P4Assembler >> label: aLabel [
	linker label: aLabel at: stream
]

{ #category : #accessing }
P4Assembler >> pointerSize [
	^ 4
]

{ #category : #relocating }
P4Assembler >> reference: label [
	^ P4ASMReference new target: (linker addressForLabel: label ifAbsent: [ 0 ]); label: label
]

{ #category : #'initialize-release' }
P4Assembler >> reset [
	stream reset
]

{ #category : #accessing }
P4Assembler >> resultVariable [
	self subclassResponsibility
]

{ #category : #accessing }
P4Assembler >> stackPointer [
	self subclassResponsibility
]

{ #category : #accessing }
P4Assembler >> stream [
	^ stream
]

{ #category : #installing }
P4Assembler >> tagClosure: aClosure [
	^  self label: aClosure
]

{ #category : #'initialize-release' }
P4Assembler >> tagMethod: aTacMethod [
	linker 
		putLabel: aTacMethod methodObject 
		at: 0 - stream pointerSize * (aTacMethod literals size + 1)
]

{ #category : #'initialize-release' }
P4Assembler >> unforceShortJump [
	forceShortJump := false.
]

{ #category : #accessing }
P4Assembler >> volatileRegisters [
	self subclassResponsibility
]

{ #category : #accessing }
P4Assembler >> wordSize [
	^ 4
]
