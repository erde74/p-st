Class {
	#name : #P4ELFRelocationTableExplicitAddends,
	#superclass : #P4ELFSectionWithData,
	#instVars : [
		'target'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #accessing }
P4ELFRelocationTableExplicitAddends >> absoluteRelocate: aSymbol at: position [
	data add: (P4ELF64RelocationEntryWithAddend new
				absolute;
				symbol: aSymbol target;
				offset: position)
]

{ #category : #header }
P4ELFRelocationTableExplicitAddends >> addrAlign [ 
	^ 8
]

{ #category : #header }
P4ELFRelocationTableExplicitAddends >> entrySizeInPointers [
	^ 3
]

{ #category : #header }
P4ELFRelocationTableExplicitAddends >> info [
	^ target headerIndex
]

{ #category : #'initialize-release' }
P4ELFRelocationTableExplicitAddends >> initialize [
	super initialize.
	data := OrderedCollection new
]

{ #category : #testing }
P4ELFRelocationTableExplicitAddends >> isEmpty [
	^ data isEmpty
]

{ #category : #header }
P4ELFRelocationTableExplicitAddends >> link [
	^ symbolTable headerIndex
]

{ #category : #accessing }
P4ELFRelocationTableExplicitAddends >> name [
	^ name ifNil: [ name := ('.rela', target name) asSymbol ]
]

{ #category : #accessing }
P4ELFRelocationTableExplicitAddends >> relocate: aSymbol at: position [
	data add: (P4ELF64RelocationEntryWithAddend new
				relative;
				symbol: aSymbol target;
				offset: position)
]

{ #category : #'initialize-release' }
P4ELFRelocationTableExplicitAddends >> sizeInPointers [
	" address + symbol identifier + addend "
	^ data size * 3
]

{ #category : #accessing }
P4ELFRelocationTableExplicitAddends >> target: anObject [
	target := anObject
]

{ #category : #header }
P4ELFRelocationTableExplicitAddends >> type [
	" 4 RELA Relocation entries with explicit addends (multiple) "
	^ 16r4
]

{ #category : #writing }
P4ELFRelocationTableExplicitAddends >> writeOn: aStream [
	super writeOn: aStream.
	data do: [ :aRelocation | aRelocation writeOn: aStream ].
]
