Class {
	#name : #P4ASMRegisterAccess,
	#superclass : #P4ASMValue,
	#instVars : [
		'register',
		'offset'
	],
	#category : #'P4-ASM-Values'
}

{ #category : #converting }
P4ASMRegisterAccess >> asRegister [
	^ register
]

{ #category : #accessing }
P4ASMRegisterAccess >> combination [
	^ register combination
]

{ #category : #accessing }
P4ASMRegisterAccess >> index [
	^ register index
]

{ #category : #testing }
P4ASMRegisterAccess >> isAccess [
	^ true
]

{ #category : #accessing }
P4ASMRegisterAccess >> isDirect [
	^ false
]

{ #category : #accessing }
P4ASMRegisterAccess >> offset [
	^ offset
]

{ #category : #accessing }
P4ASMRegisterAccess >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
P4ASMRegisterAccess >> printOn: stream [
	register printOn: stream .
	stream << '[' << offset asString << ']'  
]

{ #category : #accessing }
P4ASMRegisterAccess >> register [
	^ register
]

{ #category : #accessing }
P4ASMRegisterAccess >> register: anObject [
	register := anObject
]
