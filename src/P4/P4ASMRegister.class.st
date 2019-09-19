Class {
	#name : #P4ASMRegister,
	#superclass : #P4ASMValue,
	#instVars : [
		'name',
		'index',
		'combination'
	],
	#category : #'P4-ASM-Values'
}

{ #category : #'instance creation' }
P4ASMRegister class >> named: aName [
	^ self new name: aName
]

{ #category : #converting }
P4ASMRegister >> accessAt: offset [
	^ P4ASMRegisterAccess new
		register: self;
		offset: offset
]

{ #category : #converting }
P4ASMRegister >> asRegister [
]

{ #category : #accessing }
P4ASMRegister >> combination [
	^ combination
]

{ #category : #accessing }
P4ASMRegister >> combination: anObject [
	combination := anObject
]

{ #category : #accessing }
P4ASMRegister >> index [
	^ index
]

{ #category : #accessing }
P4ASMRegister >> index: anObject [
	index := anObject
]

{ #category : #accessing }
P4ASMRegister >> name [
	^ name
]

{ #category : #accessing }
P4ASMRegister >> name: anObject [
	name := anObject
]

{ #category : #'instruction-creation' }
P4ASMRegister >> pop [
	^ P4TACPop new register: self
]

{ #category : #printing }
P4ASMRegister >> printOn: stream [
	stream << '%' << name
]

{ #category : #printing }
P4ASMRegister >> printString [ 
	^ '%',name
]

{ #category : #'instruction-creation' }
P4ASMRegister >> push [
	^ P4TACPush new register: self
]
