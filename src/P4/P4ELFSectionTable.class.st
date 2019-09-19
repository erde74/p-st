Class {
	#name : #P4ELFSectionTable,
	#superclass : #P4Object,
	#instVars : [
		'sections',
		'symbolTable',
		'stringTable',
		'sectionHeaderStringTable',
		'elf',
		'markerSection',
		'globals',
		'methodTag'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #'instance-creation' }
P4ELFSectionTable class >> newFor: anELF [
	^ self new
		elf: anELF;
		initializeStandardSections
]

{ #category : #'instance-creation' }
P4ELFSectionTable class >> pname [
	<preventExport>
	^ pname ifNil: [ pname := (self name copyFrom: 'P4ELF' size + 1 to: self name size) asSymbol ]
]

{ #category : #accessing }
P4ELFSectionTable >> addSection: aSection [
	sections at: aSection name ifPresent: [ :section |
		self error: 'Duplicate section ', aSection name ].

	aSection nameIndex: (sectionHeaderStringTable allocateString: aSection name).
	sections at: aSection name put: aSection.
	symbolTable add: aSection.
]

{ #category : #building }
P4ELFSectionTable >> allSectionsDo: aBlock [
	sections do: [ :aSection |
		aBlock value: aSection.
		aSection hasRelocationTable
			ifTrue: [ aBlock value: aSection relocationTable ]].
	
	aBlock value: symbolTable.
	aBlock value: stringTable.
	aBlock value: sectionHeaderStringTable. 
]

{ #category : #symbols }
P4ELFSectionTable >> allocateString: aString [
	^ stringTable allocateString: aString
]

{ #category : #accessing }
P4ELFSectionTable >> code [
	^ sections at: #'.pinocchio'
]

{ #category : #installing }
P4ELFSectionTable >> code: code [
	self code data: code
]

{ #category : #accessing }
P4ELFSectionTable >> codeStream [
	^ self code data
]

{ #category : #accessing }
P4ELFSectionTable >> constant [
	^ sections at: #'.bss'
]

{ #category : #accessing }
P4ELFSectionTable >> createRelocationTable [
	^ elf createRelocationTable
		symbolTable: symbolTable
]

{ #category : #accessing }
P4ELFSectionTable >> elf: anELF [
	elf := anELF
]

{ #category : #header }
P4ELFSectionTable >> entryCount [
	^ sections inject: 4 into: [ :aValue :aSection |
		aSection hasRelocationTable
			ifTrue: [ aValue + 2 ]
			ifFalse: [ aValue + 1 ]]
]

{ #category : #header }
P4ELFSectionTable >> entrySize: aStream [
	^ (4 * aStream wordSize) + (6 * aStream pointerSize)
]

{ #category : #accessing }
P4ELFSectionTable >> filename: filename [
	| name |
	name := filename.
	symbolTable add:
		(P4ELFFileSymbol new
			name: name;
			nameIndex: (self allocateString: name))
]

{ #category : #accessing }
P4ELFSectionTable >> functionFor: anObject on: aSection [
	| sym |
	sym := P4ELFFuncSymbol new
					value: aSection data position;
					nameIndex: (self allocateString: anObject pByteName);
					name: anObject pByteName;
					size: anObject pByteSize;
					section: aSection;
					global.
	symbolTable add: sym.
	^sym
]

{ #category : #'initialize-release' }
P4ELFSectionTable >> initialize [
	
	" contains the names of sections "
	sectionHeaderStringTable := P4ELFStringTable new name: #'.shstrtab'.
	
	" contains constant strings used in the runtime "
	stringTable := P4ELFStringTable new name: #'.strtab'.
	
	" contains function and section names for linking "
	symbolTable := (P4ELFSymbolTable new name: #'.symtab')
						stringTable: stringTable.
	
	
	" marker section in case we have a too large program table "
	markerSection := P4ELFMarkerSection new.
	
	sections := IdentityDictionary new.
]

{ #category : #'initialize-release' }
P4ELFSectionTable >> initializeStandardSections [
	" Program code "
	self addSection: ((P4ELFProgramSection newFor: self) name: #'.pinocchio'; write; alloc; exec; data: elf processor createStream).
	" Uninitialized Data "
	self addSection: ((P4ELFSectionWithoutData newFor: self code) name: #'.bss'; alloc; write).
	" Exception handling "
	self addSection: ((P4ELFProgramSection newFor: self) name: #'.eh_frame'; alloc).
	" Read-write data "
	self addSection: ((P4ELFProgramSection newFor: self) name: #'.data'; write; alloc).
	" DWARF debugging data "
	self addSection: ((P4ELFProgramSection newFor: self) name: #'.stab').
	" Metadata (loadable) "
	self addSection: ((P4ELFProgramSection newFor: self) name: #'.note').
	" Metadata (non-loadable) "
	self addSection: ((P4ELFProgramSection newFor: self) name: #'.comment'; merge; strings).
	
	" Hint to the GNU linker that no executable stack is required "
	self addSection: ((P4ELFProgramSection newFor: self) name: #'.note.GNU-stack').
]

{ #category : #accessing }
P4ELFSectionTable >> readOnly [
	^ sections at: #'.pinocchio_rodata'
]

{ #category : #header }
P4ELFSectionTable >> sectionHeaderStringTableIndex [
	^ self entryCount - 1
]

{ #category : #symbols }
P4ELFSectionTable >> symbolTable [
	^ symbolTable
]

{ #category : #writing }
P4ELFSectionTable >> writeHeaderOn: aStream [
	markerSection writeHeaderOn: aStream.
	self allSectionsDo: [ :aSection |
		aSection writeHeaderOn: aStream ]
]

{ #category : #writing }
P4ELFSectionTable >> writeOn: aStream [
	" self collectSectionNames. "
	| index |
	index := 0.
	symbolTable finalize.
	self allSectionsDo: [ :aSection |
		aSection nameIndex: (sectionHeaderStringTable allocateString: aSection name).
		aSection headerIndex: (index := index + 1).
		aSection writeOn: aStream ]
]
