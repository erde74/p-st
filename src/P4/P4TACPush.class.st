Class {
	#name : #P4TACPush,
	#superclass : #P4TACInstruction,
	#instVars : [
		'variable',
		'register'
	],
	#classInstVars : [
		'register'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #visiting }
P4TACPush >> accept: aVisitor [
	^ aVisitor visitPush: self
]

{ #category : #printing }
P4TACPush >> printOn: aStream [
	aStream << 'push ' << register asString << Character cr.
]

{ #category : #accessing }
P4TACPush >> register [
	register ifNotNil: [ ^ register ].
	^ variable register
]

{ #category : #accessing }
P4TACPush >> register: aRegister [
	register := aRegister 
]

{ #category : #accessing }
P4TACPush >> variable: anObject [
	variable := anObject
]
