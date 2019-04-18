Class {
	#name : #P4Linker,
	#superclass : #P4Object,
	#instVars : [
		'danglingReferences',
		'labels'
	],
	#category : #'P4-SystemSpec'
}

{ #category : #private }
P4Linker >> add: value to: dict at: index [
	(dict
		at: index
		ifAbsentPut: [ OrderedCollection new ])
			add: value
	
]

{ #category : #'constant pool' }
P4Linker >> addressForLabel: label ifAbsent: aBlock [
	^ labels at: label ifAbsent: aBlock
]

{ #category : #'constant pool' }
P4Linker >> addressForLabel: label ifPresent: aBlock [
	^ labels at: label ifPresent: aBlock
]

{ #category : #relocating }
P4Linker >> dangling: function at: address [
	function ifNil: [ self error: 'nil is not a valid target' ].
	self add: address to: danglingReferences at: function
]

{ #category : #accessing }
P4Linker >> danglingReferences [
	^ danglingReferences
]

{ #category : #'initialize-release' }
P4Linker >> initialize [
	danglingReferences := IdentityDictionary new.
	labels := IdentityDictionary new.
]

{ #category : #'constant pool' }
P4Linker >> label: aLabel at: aStream [
	| address |
	address := aStream position.
	labels at: aLabel put: address.
	(danglingReferences removeKey: aLabel ifAbsent: [ {} ])
		do: [ :aReference | 
			aStream position: aReference.
			self referTo: address at: aStream addend: 0-aStream wordSize ].
	aStream position: address
]

{ #category : #'constant pool' }
P4Linker >> putLabel: aLabel at: position [
	labels at: aLabel put: position.

]

{ #category : #'constant pool' }
P4Linker >> referTo: anAddress at: aStream addend: anAddend [
	| relative |
	relative := anAddress - aStream position.
	(aStream next asInteger == 1) 
		ifTrue: [ aStream back; nextPut: relative - 1 ] 
		ifFalse: [ aStream back; wordPut: relative + anAddend ]

]
