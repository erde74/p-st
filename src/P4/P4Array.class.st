Class {
	#name : #P4Array,
	#superclass : #P4Object,
	#type : #variable,
	#category : #'P4-Kernel-Collection'
}

{ #category : #'as yet unclassified' }
P4Array class >> isIndexed [ 
	^true
]

{ #category : #'as yet unclassified' }
P4Array class >> with: stuff [
	| array |
	array := self basicNew: 1.
	array basicAt: 1 put: stuff.
	^array
]

{ #category : #'as yet unclassified' }
P4Array >> do: aBlock [
	| size |
	size := self size.
	1 to: size do: [ :element |
		aBlock value: (self at: element) ]
]

{ #category : #'as yet unclassified' }
P4Array >> pInspect [ 
	'an Array' print.
	self do: [ :e | e printObj ]
]

{ #category : #'as yet unclassified' }
P4Array >> printOn: aStream [
	aStream << '{'.
	1 to: self size do: [ :i |
		(self pVariableAt: i) printOn: aStream.
		aStream << '. '  ].
	aStream << '}'.
]
