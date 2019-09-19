Class {
	#name : #P4TACFixedVariable,
	#superclass : #P4TACAbstractVariable,
	#instVars : [
		'register'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #'instance creation' }
P4TACFixedVariable class >> withRegister: aRegister [
	^ (self new) initRegister: aRegister
]

{ #category : #accessing }
P4TACFixedVariable >> asAsm [ 
	register ifNil: [ self error: 'this variable is not assigned to a register. is it live?' ].
	^ self register
]

{ #category : #accessing }
P4TACFixedVariable >> hasRegisterAssigned [ 
	^true
]

{ #category : #accessing }
P4TACFixedVariable >> initRegister: aRegister [
	register ifNotNil: [ self error: 'register already assigned' ].
	register := aRegister  
]

{ #category : #accessing }
P4TACFixedVariable >> register [ 
	^ register
]
