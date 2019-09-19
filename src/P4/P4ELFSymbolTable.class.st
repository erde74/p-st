Class {
	#name : #P4ELFSymbolTable,
	#superclass : #P4ELFTable,
	#instVars : [
		'locals',
		'stringTable',
		'symbols'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #accessing }
P4ELFSymbolTable >> add: aSymbol [
	aSymbol name ifNil: [ self halt ]. 
	
	aSymbol symbolTable: self.
	aSymbol isLocal 
		ifTrue: [ locals addLast: aSymbol ]
		ifFalse: [ data addLast: aSymbol ].
	symbols at: aSymbol name put: aSymbol.
	^ aSymbol 

]

{ #category : #header }
P4ELFSymbolTable >> addrAlign [ 
	^ 8
]

{ #category : #'as yet unclassified' }
P4ELFSymbolTable >> createReference: aName on: aSection [
	^ self add: (P4ELFNoTypeSymbol new
						nameIndex: (stringTable allocateString: aName);
						name: aName;
						global)
]

{ #category : #accessing }
P4ELFSymbolTable >> data [
	^ self shouldNotCall
]

{ #category : #'as yet unclassified' }
P4ELFSymbolTable >> ensureReference: aName on: aSection [
	^ symbols at: aName ifAbsent: [ self createReference: aName on: aSection]
]

{ #category : #accessing }
P4ELFSymbolTable >> entrySizeInPointers [
	^ 3
]

{ #category : #accessing }
P4ELFSymbolTable >> finalize [
	data addAllFirst: locals.
	data withIndexDo: [ :aSymbol :anIndex |
		aSymbol symbolTableIndex: anIndex ]
]

{ #category : #header }
P4ELFSymbolTable >> info [
	^ locals size + 1
]

{ #category : #'initialize-release' }
P4ELFSymbolTable >> initialize [
	super initialize.
	data := OrderedCollection new.
	locals := OrderedCollection new.
	symbols := P4IdentityDictionary new.
]

{ #category : #header }
P4ELFSymbolTable >> link [
	^ stringTable headerIndex
]

{ #category : #'as yet unclassified' }
P4ELFSymbolTable >> objectNamed: aName on: aSection [
	| sym |
	sym := P4ELFObjectSymbol new
				value: aSection data position;
				nameIndex: (stringTable allocateString: aName);
				name: aName;
				section: aSection;
				global.
	^ self add: sym.
]

{ #category : #accessing }
P4ELFSymbolTable >> sizeInPointers [
	^ 3 * (data size + 1)
]

{ #category : #accessing }
P4ELFSymbolTable >> stringTable [
	^ stringTable
]

{ #category : #accessing }
P4ELFSymbolTable >> stringTable: anObject [
	stringTable := anObject
]

{ #category : #header }
P4ELFSymbolTable >> type [
	" 16r2 SYMTAB Symbol table (single) "
	^ 16r2
]

{ #category : #header }
P4ELFSymbolTable >> writeOn: aStream [
	super writeOn: aStream.
	P4ELFNoTypeSymbol new writeSymbolOn: aStream.
	data do: [ :aSymbol | aSymbol writeSymbolOn: aStream ]
]
