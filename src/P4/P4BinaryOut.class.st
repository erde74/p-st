Class {
	#name : #P4BinaryOut,
	#superclass : #P4Object,
	#instVars : [
		'executableFormat',
		'symbolTable',
		'dumped',
		'todo',
		'done',
		'processor',
		'os'
	],
	#category : #'P4-Exec'
}

{ #category : #'initialize-release' }
P4BinaryOut >> addClassReference: class for: allocated [
	| classReference |
	classReference := self localDump: class theBehavior.
	self referTo: classReference at: allocated pointerOffset: -2.	
]

{ #category : #'initialize-release' }
P4BinaryOut >> addPharoClasses: pharoClasses [ 
	pharoClasses do: [ :pclass | todo add: (P4Package loadClass: pclass) ]
]

{ #category : #'initialize-release' }
P4BinaryOut >> alignObject [
	executableFormat alignObject.
]

{ #category : #'initialize-release' }
P4BinaryOut >> allocate: anObject [
	| allocated |
	anObject pclass pIsVariableOrBytes ifTrue: [
		executableFormat pointerPut: anObject pVariableSizeHeader ].
	executableFormat allocatePointer.
	executableFormat pointerPut: anObject pHeader.
	allocated := dumped at: anObject 
		put: ( executableFormat allocate: anObject pVariableSize + anObject pclass pInstSize named: anObject pExportedName ).

	anObject pByteName ifNotNil: [ executableFormat functionFor: anObject ].
	1 to: anObject pByteSize do: [ :i |
		executableFormat nextPut: (anObject pByteAt: i) ].
	self alignObject.
	anObject pByteName ifNotNil: [ :name | executableFormat allocate: 0 named: ('__eo-',name asString,'__') ].
	
	self addClassReference: anObject pclass for: allocated.
	
	^allocated
]

{ #category : #'initialize-release' }
P4BinaryOut >> dump: anObject [
	anObject dumpGlobalOn: self.
]

{ #category : #'initialize-release' }
P4BinaryOut >> dumpCoreObjects [
	^ P4BinarySymbolOut new 
		processor: processor os: os;
		dump: true; dump: false; dump: nil; into: 'core';
		flushOut 
]

{ #category : #'initialize-release' }
P4BinaryOut >> dumpPackages [
	P4RootPackage instance packagesDo: [ :package | 
		package dumpGlobalOn: self ].
	self into: 'packages';
	flushOut 
]

{ #category : #'initialize-release' }
P4BinaryOut >> dumpSymbolTable [ 
	^ P4BinarySymbolOut new 
		processor: processor os: os;
		dump: symbolTable; into: 'symbols';
		flushOut 
]

{ #category : #'initialize-release' }
P4BinaryOut >> flushOut [
	executableFormat := os executableFormat.  
	executableFormat processor: processor. 
	executableFormat readWriteExec.
	dumped removeAll.
]

{ #category : #'initialize-release' }
P4BinaryOut >> initialize [
	todo := OrderedCollection new.
	done := Set new.
	dumped := P4IdentityDictionary new.
	symbolTable := P4SymbolTable new.
]

{ #category : #'initialize-release' }
P4BinaryOut >> into: aName [
	executableFormat pack: aName.
	self flushOut 
]

{ #category : #'initialize-release' }
P4BinaryOut >> localDump: anObject [
	self haltIf: (anObject isKindOf: P4Class).
	dumped at: anObject ifPresent: [ :aReference | ^ aReference ].
	^ anObject dumpLocalOn: self.
]

{ #category : #'initialize-release' }
P4BinaryOut >> nextPut: object [
	executableFormat nextPut: object 
]

{ #category : #'initialize-release' }
P4BinaryOut >> pointerPut: object [
	executableFormat pointerPut: object 
]

{ #category : #'initialize-release' }
P4BinaryOut >> pointerPut: object at: aReference pointerOffset: anOffset [
	executableFormat pointerPut: object at: aReference sectionOffset pointerOffset: anOffset
]

{ #category : #'initialize-release' }
P4BinaryOut >> postpone: anObject [
	self todo: anObject.
	^ dumped at: anObject put: (executableFormat global: anObject pExportedName )
]

{ #category : #'initialize-release' }
P4BinaryOut >> processor: aProcessor os: anOs [
	processor := aProcessor.
	os := anOs.
	self flushOut.
]

{ #category : #'initialize-release' }
P4BinaryOut >> readOnly [
	executableFormat readOnly
]

{ #category : #'initialize-release' }
P4BinaryOut >> readWrite [
	executableFormat readWrite
]

{ #category : #'initialize-release' }
P4BinaryOut >> readWriteExec [
	executableFormat readWriteExec
]

{ #category : #'initialize-release' }
P4BinaryOut >> referTo: aReference at: aSymbol pointerOffset: anOffset [
	^ executableFormat referTo: aReference at: aSymbol pointerOffset: anOffset
]

{ #category : #'initialize-release' }
P4BinaryOut >> resolveReferences: method reference: methodRef [
	| ref codeOffset |
	codeOffset := method class pInstSize + method pVariableSize.
	method usedGlobals keysAndValuesDo: [ :pos :global |
		ref := executableFormat createReference: global pExportedName .  
		executableFormat referTo: ref at: methodRef pointerOffset: codeOffset byteOffset: pos ].
	method usedReferences keysAndValuesDo: [ :pos :reference |
		ref := executableFormat createReference: reference.
		executableFormat relativeReferTo: ref at: methodRef pointerOffset: codeOffset byteOffset: pos ]

]

{ #category : #'initialize-release' }
P4BinaryOut >> symbol: aSymbol [
	symbolTable add: aSymbol.
	^ dumped at: aSymbol put: (executableFormat global: aSymbol pExportedName )
]

{ #category : #'initialize-release' }
P4BinaryOut >> todo [
	^todo 
]

{ #category : #'initialize-release' }
P4BinaryOut >> todo: aTodo [
	| superclass |
	(done includes: aTodo) ifTrue: [ ^ self ].
	(aTodo isKindOf: P4PharoClass) ifTrue: [
		done add: aTodo.
		^ todo add: aTodo ].
	(aTodo isKindOf: P4SmalltalkBehavior) ifTrue: [ 
		^ self todo: aTodo superclass].
	(aTodo isKindOf: P4PharoMetaclass) ifTrue: [ ^ self ].
	(aTodo isKindOf: P4AbstractPackage) ifTrue: [ ^ self ].
	"Classes can occur in type hints. the user is responsible for compiling the referenced types"
	(aTodo isKindOf: P4Object class) ifTrue: [ ^ self ].
	aTodo == true ifTrue: [ ^ self ].
	aTodo == false ifTrue: [ ^ self ].
	aTodo == nil ifTrue: [ ^ self ].
	self error: 'Unsupported global object detected'.  
	
]
