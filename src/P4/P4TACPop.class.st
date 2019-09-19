Class {
	#name : #P4TACPop,
	#superclass : #P4TACInstruction,
	#instVars : [
		'register'
	],
	#classInstVars : [
		'register'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'visitor accepting' }
P4TACPop >> accept: aVisitor [
	^ aVisitor visitPop: self
]

{ #category : #printing }
P4TACPop >> printOn: aStream [
	aStream << 'pop ' << register asString << Character cr.
]

{ #category : #accessing }
P4TACPop >> register [
	^ register
]

{ #category : #accessing }
P4TACPop >> register: anObject [
	register := anObject
]
