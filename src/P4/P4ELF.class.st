Class {
	#name : #P4ELF,
	#superclass : #P4ExecutableFormat,
	#instVars : [
		'os',
		'programs',
		'sectionTable',
		'sectionTablePointerOffset'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #accessing }
P4ELF >> createRelocationTable [
	processor elfClass = 1 ifTrue: [ ^ P4ELFRelocationTableImplicitAddends new ].
	processor elfClass = 2 ifTrue: [ ^ P4ELFRelocationTableExplicitAddends new ].
	self error: 'Invalid processor class'
]

{ #category : #header }
P4ELF >> entry [
	" This member gives the virtual address to which the system first transfers control, thus
	starting the process. If the file has no associated entry point, this member holds zero "
	^ 0
]

{ #category : #flushing }
P4ELF >> flushCache [
	self flag: 'install self as method installer target'.
	"voodoo ahead:"
	self processor: processor.
]

{ #category : #printing }
P4ELF >> functionFor: anObject [
	^sectionTable functionFor: anObject on: currentSection  
]

{ #category : #header }
P4ELF >> header [
	currentStream nextPutAll: self magicIdent.

	currentStream halfWordPut: self type.
	currentStream halfWordPut: self machine.
	currentStream wordPut: self version.
	
	currentStream pointerPut: self entry.
	
	currentStream pointerPut: self programHeaderOffset.
	
	" Keep position so that we can fill it in after writing the sections "
	sectionTablePointerOffset := currentStream position.
	currentStream pointerPut: self sectionHeaderOffset.
	
	currentStream wordPut: processor flags.
	currentStream halfWordPut: processor elfHeaderSize.
	currentStream halfWordPut: (programs entrySize: currentStream).
	
	currentStream halfWordPut: programs entryCount.
	currentStream halfWordPut: (sectionTable entrySize: currentStream).
	currentStream halfWordPut: sectionTable entryCount.
	currentStream halfWordPut:sectionTable sectionHeaderStringTableIndex.
]

{ #category : #header }
P4ELF >> machine [
	^ processor elfMachine
]

{ #category : #header }
P4ELF >> magicIdent [
	^ { 16r7f. $E. $L. $F.
		processor elfClass.
		processor elfDataEncoding.
		self version.
		os elfABI.
		os elfABIVersion.
		16r00. 16r00. 16r00. 16r00. 16r00. 16r00. 16r00. }
]

{ #category : #accessing }
P4ELF >> nextPut: object [
	currentStream nextPut: object 
]

{ #category : #accessing }
P4ELF >> os: anObject [
	os := anObject
]

{ #category : #'file writing' }
P4ELF >> pack: filename [
	" Add source filename to the symbol table "
	sectionTable filename: (filename, self sourceExtension).
	super pack: filename
]

{ #category : #accessing }
P4ELF >> processor: aProcessor [
	super processor: aProcessor.
	sectionTable := P4ELFSectionTable newFor: self.
	symbolTable := sectionTable symbolTable.
	programs := P4ELFProgramTable new.
]

{ #category : #'program header' }
P4ELF >> programHeader [
]

{ #category : #header }
P4ELF >> programHeaderOffset [
	" This member holds the program header table's file offset in bytes. If the file has no program header table, this member holds zero "
	^ 0
]

{ #category : #'file writing' }
P4ELF >> programHeaderTable [
	programs writeHeaderOn: currentStream
]

{ #category : #accessing }
P4ELF >> readWriteExec [
	currentSection := sectionTable code.
	currentStream := currentSection data.
]

{ #category : #header }
P4ELF >> sectionHeaderOffset [
	" This member holds the section header table's file offset in bytes. If the file has no section header table, this member holds zero "
	" TODO we'll need a section header :-) "
	^ 0
]

{ #category : #'file writing' }
P4ELF >> sectionHeaderTable [
	| sectionHeaderTablePosition offset |
	sectionHeaderTablePosition := currentStream position.
	currentStream position: sectionTablePointerOffset.
	currentStream pointerPut: sectionHeaderTablePosition.
	currentStream position: sectionHeaderTablePosition.
	sectionTable writeHeaderOn: currentStream.
]

{ #category : #'file writing' }
P4ELF >> sections [
	sectionTable writeOn: currentStream
]

{ #category : #accessing }
P4ELF >> staticLibraryExtension [
	^ '.o'
]

{ #category : #printing }
P4ELF >> target [
	^sectionTable
]

{ #category : #header }
P4ELF >> type [
	"
	0 NONE none 
	1 REL relocatable 
	2 EXEC executable 
	3 DYN shared 
	4 CORE core 
	0xFF00 LOPROC processor specific
	0xFFFF HIPROC processor specific
	
	Current we'll only generate relocatable files, letting LD link them
	"
	^ 16r0001
]

{ #category : #header }
P4ELF >> version [
	" 
	0 NONE Invalid version
	1 CURRENT Current version
	"
	^ 1
]
