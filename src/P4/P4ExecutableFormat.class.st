Class {
	#name : #P4ExecutableFormat,
	#superclass : #P4Object,
	#instVars : [
		'processor',
		'currentStream',
		'globals',
		'symbolTable',
		'currentSection'
	],
	#category : #'P4-Exec'
}

{ #category : #accessing }
P4ExecutableFormat >> alignObject [
	currentStream alignByPointer
]

{ #category : #public }
P4ExecutableFormat >> allocate: size named: aName [
	| reference |
	reference := aName
		ifNotNil: [
			P4ExportedObjectReference new
				target: (self objectNamed: aName);
				offset: 0 ]
		ifNil: [
			P4ExportedSectionReference new
				target: currentSection;
				offset: currentStream position ].
		
	1 to: size do: [ :i | currentStream pointerPut: 0 ].
	^ reference 
]

{ #category : #printing }
P4ExecutableFormat >> allocatePointer [
	self pointerPut: 0
]

{ #category : #public }
P4ExecutableFormat >> createReference: aName [ 
	aName isSymbol ifFalse: [ self error: 'can only refer to symbols' ].
	
	^ globals at: aName ifAbsentPut: [ 
		P4ExternalObjectReference new
			target: (symbolTable ensureReference: aName on: currentSection);
			offset: 0. ]
]

{ #category : #public }
P4ExecutableFormat >> functionFor: anObject [
	self subclassResponsibility
]

{ #category : #public }
P4ExecutableFormat >> global: aSymbol [
	^ self createReference: aSymbol
]

{ #category : #public }
P4ExecutableFormat >> halfWordPut: halfWord [
	currentStream halfWordPut: halfWord
]

{ #category : #binpacking }
P4ExecutableFormat >> header [
	self subclassResponsibility
]

{ #category : #accessing }
P4ExecutableFormat >> initialize [
	globals := IdentityDictionary new.
]

{ #category : #public }
P4ExecutableFormat >> nextPut: object [
	currentStream nextPut: object
]

{ #category : #printing }
P4ExecutableFormat >> objectNamed: aName [
	^ symbolTable objectNamed: aName on: currentSection
]

{ #category : #binpacking }
P4ExecutableFormat >> pack [
	self
		header;
		programHeaderTable;
		sections;
		sectionHeaderTable.
]

{ #category : #binpacking }
P4ExecutableFormat >> pack: filename [
	currentStream := processor createStream.
	self pack.
	(StandardFileStream forceNewFileNamed: filename, self staticLibraryExtension)
		binary;
		nextPutAll: currentStream contents;
		close.
	currentStream := nil.
]

{ #category : #public }
P4ExecutableFormat >> pointerPut: object [
	currentStream pointerPut: object 
]

{ #category : #public }
P4ExecutableFormat >> pointerPut: object at: aPosition pointerOffset: pointerOffset [
	| currentPos |
	currentPos := currentStream position.
	currentStream position: aPosition + (pointerOffset * currentStream pointerSize).
	currentStream pointerPut: object.
	currentStream position: currentPos.
]

{ #category : #accessing }
P4ExecutableFormat >> processor [
	^ processor
]

{ #category : #accessing }
P4ExecutableFormat >> processor: aProcessor [
	processor := aProcessor
]

{ #category : #binpacking }
P4ExecutableFormat >> programHeaderTable [
	self subclassResponsibility
]

{ #category : #configuration }
P4ExecutableFormat >> programSection [
	self subclassResponsibility
]

{ #category : #public }
P4ExecutableFormat >> readWriteExec [ 
	self subclassResponsibility
]

{ #category : #public }
P4ExecutableFormat >> referTo: aReference at: aSymbol pointerOffset: anOffset [
	aSymbol relocationTable
		absoluteRelocate: aReference
		at: aSymbol sectionOffset + (anOffset * processor pointerSize).
]

{ #category : #public }
P4ExecutableFormat >> referTo: aReference at: aSymbol pointerOffset: aPointerOffset byteOffset: anOffset [
	self haltIf: aReference offset ~= 0.
	aSymbol relocationTable
		absoluteRelocate: aReference
		at: aSymbol sectionOffset + anOffset + ( processor pointerSize * aPointerOffset ).
]

{ #category : #public }
P4ExecutableFormat >> relativeReferTo: aReference at: aSymbol pointerOffset: aPointerOffset byteOffset: anOffset [
	self haltIf: aReference offset ~= 0.
	aSymbol relocationTable
		relocate: aReference
		at: aSymbol sectionOffset + anOffset + ( processor pointerSize * aPointerOffset )
]

{ #category : #configuration }
P4ExecutableFormat >> relocationTable [
	self subclassResponsibility
]

{ #category : #binpacking }
P4ExecutableFormat >> sectionHeaderTable [
	self subclassResponsibility
]

{ #category : #binpacking }
P4ExecutableFormat >> sections [
	self subclassResponsibility
]

{ #category : #accessing }
P4ExecutableFormat >> sourceExtension [
	^ '.st'
]

{ #category : #accessing }
P4ExecutableFormat >> staticLibraryExtension [
	self subclassResponsibility
]

{ #category : #configuration }
P4ExecutableFormat >> symbolTable [
	self subclassResponsibility
]

{ #category : #public }
P4ExecutableFormat >> wordPut: word [
	currentStream wordPut: word
]
