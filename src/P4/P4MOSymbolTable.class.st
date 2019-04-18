Class {
	#name : #P4MOSymbolTable,
	#superclass : #P4MOCommand,
	#instVars : [
		'stringTable',
		'symbols',
		'symbolDict',
		'fileOffset'
	],
	#category : #'P4-Exec-MachO'
}

{ #category : #allocation }
P4MOSymbolTable >> add: symbol [
	symbol index: self nextSymbolIndex.
	symbolDict at: symbol name put: symbol.
	^ symbols add: symbol
]

{ #category : #'as yet unclassified' }
P4MOSymbolTable >> commandSize [
	"sizeof(struct symtab_command) = 6 * 4 Bytes = 24 Bytes"
	^  24
]

{ #category : #'as yet unclassified' }
P4MOSymbolTable >> createReference: aName on: aSection [
	^ self add: (P4MOExternalObjectSymbol new
						"that's the tentative size"
						value: 0;
						nameIndex: (stringTable allocateString: aName);
						name: aName;
						section: aSection;
						global)
]

{ #category : #'as yet unclassified' }
P4MOSymbolTable >> ensureReference: aName on: aSection [
	^ symbolDict at: aName ifAbsent: [ self createReference: aName on: aSection]
]

{ #category : #'as yet unclassified' }
P4MOSymbolTable >> fileOffset [
	^ fileOffset
]

{ #category : #'as yet unclassified' }
P4MOSymbolTable >> fileOffset: offset [
	"just align it on 16bytes, we're lazy..."
	fileOffset := (offset / 16) ceiling * 16.
	^ stringTable fileOffset: fileOffset + self fileSize.
]

{ #category : #'as yet unclassified' }
P4MOSymbolTable >> fileSize [
	"sizeof(struct nlist) = 2 * sizeof(pointer) = 16 bytes"
	^  (symbols size * 16)
]

{ #category : #allocation }
P4MOSymbolTable >> filename: filename [
	^ self add:
		(P4MOFileSymbol new
			name: filename;
			nameIndex: (stringTable allocateString: filename);
			index: self nextSymbolIndex)
]

{ #category : #allocation }
P4MOSymbolTable >> functionFor: anObject on: aSection [
	| symbol |
	symbol := P4MOFunctionSymbol new
					value: aSection data position;
					nameIndex: (stringTable allocateString: anObject pByteName);
					name: anObject pByteName;
					size: anObject pByteSize;
					section: aSection;
					global.
	^ self add: symbol.
]

{ #category : #'as yet unclassified' }
P4MOSymbolTable >> initialize [
	super initialize.
	symbolDict := Dictionary new.
	symbols := OrderedCollection new.
	stringTable := P4MOStringTable new.
]

{ #category : #allocation }
P4MOSymbolTable >> nextSymbolIndex [
	^ symbols size
]

{ #category : #allocation }
P4MOSymbolTable >> objectNamed: aName on: aSection [
	| symbol |
	symbol := P4MOObjectSymbol new
					value: aSection data position;
					nameIndex: (stringTable allocateString: aName);
					name: aName;
					section: aSection;
					global.
	^ self add: symbol.
]

{ #category : #'as yet unclassified' }
P4MOSymbolTable >> type [
	"LC_SYMTAB"
	^  16r02
]

{ #category : #'as yet unclassified' }
P4MOSymbolTable >> writeCommandOn: aStream [
	super writeCommandOn: aStream.
	aStream wordPut: self fileOffset.
	aStream wordPut: symbols size.
	aStream wordPut: stringTable fileOffset.
	aStream wordPut: stringTable fileSize.
	
]

{ #category : #'as yet unclassified' }
P4MOSymbolTable >> writeOn: aStream [
	aStream fillTo: fileOffset with: 16r00.
	self writeSymbolsOn: aStream.
	stringTable writeOn: aStream.
]

{ #category : #'as yet unclassified' }
P4MOSymbolTable >> writeSymbolsOn: aStream [
	|sorted|
	sorted := Array new: symbols size.
	symbols do: [ :symbol| 	sorted at: symbol index + 1 put: symbol].
	sorted do: [ :symbol| symbol writeOn: aStream].
]
