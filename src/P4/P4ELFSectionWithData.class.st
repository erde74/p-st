Class {
	#name : #P4ELFSectionWithData,
	#superclass : #P4ELFSection,
	#instVars : [
		'data',
		'elfSymbol'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #accessing }
P4ELFSectionWithData >> asElfSymbol [ 
	elfSymbol ifNotNil: [ ^ elfSymbol ].
	elfSymbol := P4ELFObjectSymbol new
		section: self;
		value: 0;
		size: 0;
		nameIndex: ( symbolTable stringTable allocateString: self name).
	symbolTable add: elfSymbol.
	^elfSymbol
]

{ #category : #accessing }
P4ELFSectionWithData >> data [
	^ data
]

{ #category : #accessing }
P4ELFSectionWithData >> data: anObject [
	data := anObject
]
