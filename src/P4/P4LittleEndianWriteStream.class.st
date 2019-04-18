Class {
	#name : #P4LittleEndianWriteStream,
	#superclass : #P4BinaryWriteStream,
	#instVars : [
		'wordSize',
		'pointerSize'
	],
	#category : #'P4-Stream'
}

{ #category : #streaming }
P4LittleEndianWriteStream >> halfWordPut: aValue [
	| todo |
	todo := aValue.
	1 to: wordSize // 2 do: [ :i |
		self nextPut: (todo bitAnd: 16rFF).
		todo := todo bitShift: -8 ]
]

{ #category : #streaming }
P4LittleEndianWriteStream >> pointerPut: aValue [
	| todo |
	todo := aValue.
	1 to: pointerSize do: [ :i |
		self nextPut: (todo bitAnd: 16rFF).
		todo := todo bitShift: -8 ]
]

{ #category : #accessing }
P4LittleEndianWriteStream >> pointerSize [
	^ pointerSize
]

{ #category : #accessing }
P4LittleEndianWriteStream >> pointerSize: aPointerSize [
	pointerSize := aPointerSize
]

{ #category : #streaming }
P4LittleEndianWriteStream >> put: aValue bytes: n [
	| todo |
	todo := aValue.
	1 to: n do: [ :i |
		self nextPut: (todo bitAnd: 16rFF).
		todo := todo bitShift: -8 ]
]

{ #category : #streaming }
P4LittleEndianWriteStream >> putUnsigned: aValue bytes: n [
	| todo |
	(aValue asInteger < 0) ifTrue: [ self error: 'not an unsigned integer' ].
	todo := aValue.
	1 to: n do: [ :i |
		self nextPut: (todo bitAnd: 16rFF).
		todo := todo bitShift: -8 ]
]

{ #category : #streaming }
P4LittleEndianWriteStream >> wordPut: aValue [
	| todo |
	todo := aValue.
	1 to: wordSize do: [ :i |
		self nextPut: (todo bitAnd: 16rFF).
		todo := todo bitShift: -8 ]
]

{ #category : #accessing }
P4LittleEndianWriteStream >> wordSize [
	^ wordSize
]

{ #category : #accessing }
P4LittleEndianWriteStream >> wordSize: aWordSize [
	wordSize := aWordSize.
]
