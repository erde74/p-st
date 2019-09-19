Class {
	#name : #P4TACIndirectCall,
	#superclass : #P4TACInstruction,
	#instVars : [
		'register'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'as yet unclassified' }
P4TACIndirectCall class >> to: aTarget [
	^ self new register: aTarget 
]

{ #category : #'as yet unclassified' }
P4TACIndirectCall >> accept: aVisitor [
	^ aVisitor visitIndirectCall: self
]

{ #category : #'as yet unclassified' }
P4TACIndirectCall >> printOn: stream [
	self printLineNumberOn: stream.  
	stream << 'call: *'.
	register printRegisterOn: stream.
	stream << Character cr.
]

{ #category : #accessing }
P4TACIndirectCall >> register [
	^ register
]

{ #category : #accessing }
P4TACIndirectCall >> register: anObject [
	register := anObject
]
