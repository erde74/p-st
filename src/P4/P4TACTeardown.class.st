Class {
	#name : #P4TACTeardown,
	#superclass : #P4TACInstruction,
	#instVars : [
		'teardown',
		'keepArguments'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'as yet unclassified' }
P4TACTeardown >> accept: aVisitor [
	^ aVisitor visitTeardown: self
]

{ #category : #'as yet unclassified' }
P4TACTeardown >> initialize [ 
	super initialize .
	keepArguments := false
]

{ #category : #'as yet unclassified' }
P4TACTeardown >> keepArguments [ 
	keepArguments := true
]

{ #category : #'as yet unclassified' }
P4TACTeardown >> printOn: stream [
	self printLineNumberOn: stream.  
	stream << '--teardown Frame' << Character cr
]

{ #category : #'as yet unclassified' }
P4TACTeardown >> shouldKeepArguments [
	^ keepArguments
]
