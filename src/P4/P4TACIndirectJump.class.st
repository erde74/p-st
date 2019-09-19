Class {
	#name : #P4TACIndirectJump,
	#superclass : #P4TACInstruction,
	#instVars : [
		'register'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'instance creation' }
P4TACIndirectJump class >> to: aTarget [
	^ self new register: aTarget 
]

{ #category : #visiting }
P4TACIndirectJump >> accept: aVisitor [
	^ aVisitor visitIndirectJump: self
]

{ #category : #'as yet unclassified' }
P4TACIndirectJump >> printOn: stream [
	self printLineNumberOn: stream.  
	stream << 'jump: *'.
	register printRegisterOn: stream.
	stream << Character cr.
]

{ #category : #accessing }
P4TACIndirectJump >> register [
	^ register
]

{ #category : #'as yet unclassified' }
P4TACIndirectJump >> register: aRegister [
	register := aRegister
]
