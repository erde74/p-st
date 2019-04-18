Class {
	#name : #P4TACReturn,
	#superclass : #P4TACInstruction,
	#instVars : [
		'teardown'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #visiting }
P4TACReturn >> accept: aVisitor [
	^ aVisitor visitReturn: self
]

{ #category : #'as yet unclassified' }
P4TACReturn >> initialize [ 
	teardown := true
]

{ #category : #'as yet unclassified' }
P4TACReturn >> noTeardown [
	teardown := false
]

{ #category : #'as yet unclassified' }
P4TACReturn >> printOn: stream [
	self printLineNumberOn: stream.  
	stream << 'return' << Character cr
]

{ #category : #'as yet unclassified' }
P4TACReturn >> tearDown [ 
	^teardown
]
