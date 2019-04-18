Class {
	#name : #P4ASMConstant,
	#superclass : #P4ASMValue,
	#instVars : [
		'constantValue'
	],
	#category : #'P4-ASM-Values'
}

{ #category : #accessing }
P4ASMConstant >> constantValue [
	^ constantValue
]

{ #category : #accessing }
P4ASMConstant >> constantValue: anObject [
	constantValue := anObject
]

{ #category : #testing }
P4ASMConstant >> isAccess [
	^ false
]

{ #category : #'as yet unclassified' }
P4ASMConstant >> isConstant [ 
	^ true
]
