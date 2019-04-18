Class {
	#name : #P4TACBasicBlock,
	#superclass : #P4ObjectStream,
	#instVars : [
		'nextBlock',
		'number'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'instance creation' }
P4TACBasicBlock class >> number: aNum [
	^ self new number: aNum  
]

{ #category : #'visitor accepting' }
P4TACBasicBlock >> accept: aVisitor [
	^ aVisitor visitBasicBlock: self
]

{ #category : #testing }
P4TACBasicBlock >> atEnd [
	^ false
]

{ #category : #testing }
P4TACBasicBlock >> firstElement [ 
	self isEmpty ifTrue: [ ^ nextBlock firstElement ].
	^ super firstElement
]

{ #category : #accessing }
P4TACBasicBlock >> nextBlock [
	^ nextBlock
]

{ #category : #accessing }
P4TACBasicBlock >> nextBlock: aBlock [
	nextBlock := aBlock.
	nextBlock number: number + 1.
	^aBlock 
]

{ #category : #accessing }
P4TACBasicBlock >> number [
	^ number
]

{ #category : #accessing }
P4TACBasicBlock >> number: aNumber [
	number := aNumber
]

{ #category : #printing }
P4TACBasicBlock >> printOn: stream [
	stream << 'block ' << number << ':' << Character cr.
	super printOn: stream.  
	stream << Character cr.
	nextBlock printOn: stream.
]

{ #category : #printing }
P4TACBasicBlock >> printString [
	^ 'basicBlock-', number asString 
]
