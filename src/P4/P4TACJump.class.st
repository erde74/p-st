Class {
	#name : #P4TACJump,
	#superclass : #P4TACInstruction,
	#instVars : [
		'target',
		'zero',
		'carry',
		'short'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'instance creation' }
P4TACJump class >> to: aTarget [
	^ self new target: aTarget 
]

{ #category : #visiting }
P4TACJump >> accept: aVisitor [
	(carry isNil and: [ zero isNil ]) ifTrue: [ ^ aVisitor visitJump: self ].
	^ aVisitor visitConditionalJump: self.
]

{ #category : #'as yet unclassified' }
P4TACJump >> carry [
	carry := true
]

{ #category : #'as yet unclassified' }
P4TACJump >> equals [
	self zero
]

{ #category : #'as yet unclassified' }
P4TACJump >> ifCarrySet: aBlock else: anotherBlock [
	carry ifTrue: [ ^ aBlock value ].
	carry ifFalse: [ ^ anotherBlock value ].

]

{ #category : #'as yet unclassified' }
P4TACJump >> ifCarryTest: aBlock else: anotherBlock [
	carry ifNil: [ ^ anotherBlock value ].
	^ aBlock value
]

{ #category : #'as yet unclassified' }
P4TACJump >> ifEqualsSet: aBlock else: anotherBlock [
	zero 
		ifTrue: [ ^ aBlock value ]
		ifFalse: [ ^ anotherBlock value ].
]

{ #category : #'as yet unclassified' }
P4TACJump >> ifEqualsTest: aBlock else: anotherBlock [
	zero ifNil: [ ^ anotherBlock value ].
	^ aBlock value
]

{ #category : #'as yet unclassified' }
P4TACJump >> isShort [
	^ short isNil not and: [ short ]
]

{ #category : #'as yet unclassified' }
P4TACJump >> noCarry [
	carry := false
]

{ #category : #'as yet unclassified' }
P4TACJump >> notEquals [
	self notZero
]

{ #category : #'as yet unclassified' }
P4TACJump >> notZero [
	zero := false
]

{ #category : #'as yet unclassified' }
P4TACJump >> printOn: stream [
	self printLineNumberOn: stream.
	stream << 'jump'.
	self ifEqualsTest: [ self ifEqualsSet: [] else: [stream << 'Not']. stream << 'Equals'  ] else: [].
	self ifCarryTest: [ self ifCarrySet: [] else: [stream << 'No']. stream << 'Carry'  ] else: [].
	stream << ' ' << target printString << Character cr.

]

{ #category : #'as yet unclassified' }
P4TACJump >> short [
	short := true.
]

{ #category : #accessing }
P4TACJump >> target [
	^ target
]

{ #category : #'as yet unclassified' }
P4TACJump >> target: aTarget [
	target := aTarget
]

{ #category : #'as yet unclassified' }
P4TACJump >> zero [
	zero := true
]
