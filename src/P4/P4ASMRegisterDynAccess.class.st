Class {
	#name : #P4ASMRegisterDynAccess,
	#superclass : #P4ASMRegisterAccess,
	#instVars : [
		'offsetRegister'
	],
	#category : #'P4-ASM-Values'
}

{ #category : #accessing }
P4ASMRegisterDynAccess >> offsetRegister [
	^ offsetRegister
]

{ #category : #accessing }
P4ASMRegisterDynAccess >> offsetRegister: anObject [
	offsetRegister := anObject
]
