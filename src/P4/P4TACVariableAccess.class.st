Class {
	#name : #P4TACVariableAccess,
	#superclass : #P4TACAbstractVariable,
	#instVars : [
		'index',
		'variable',
		'cachedRegister'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #accessing }
P4TACVariableAccess >> accept: aVisitor [
	^ aVisitor visitVariableAccess: self  
]

{ #category : #accessing }
P4TACVariableAccess >> asAsm [ 
	^ cachedRegister ifNil: [ cachedRegister := variable asAsm accessAt: index ] 
]

{ #category : #liveness }
P4TACVariableAccess >> assignedAt: number [
	" when you assign to a variable[], then you actually use the variable "
	variable usedAt: number
]

{ #category : #testing }
P4TACVariableAccess >> hasRegisterAssigned [ 
	^ variable hasRegisterAssigned 
]

{ #category : #accessing }
P4TACVariableAccess >> index [
	^ index
]

{ #category : #accessing }
P4TACVariableAccess >> index: anObject [
	index := anObject
]

{ #category : #testing }
P4TACVariableAccess >> isAccess [
	^ true
]

{ #category : #testing }
P4TACVariableAccess >> isDoubleAccess [
	^ variable isAccess 
]

{ #category : #liveness }
P4TACVariableAccess >> isUnused [ 
	^variable isUnused
]

{ #category : #accessing }
P4TACVariableAccess >> name [
	^ variable name
]

{ #category : #accessing }
P4TACVariableAccess >> printOn: stream [
	variable printOn: stream.
	stream <<  '->' << index.
]

{ #category : #accessing }
P4TACVariableAccess >> register [
	^ variable register 
]

{ #category : #liveness }
P4TACVariableAccess >> usedAt: number [
	variable usedAt: number  
]

{ #category : #accessing }
P4TACVariableAccess >> variable [
	^ variable 
]

{ #category : #accessing }
P4TACVariableAccess >> variable: anObject [
	variable := anObject
]
