Class {
	#name : #P4ASMReference,
	#superclass : #P4ASMValue,
	#instVars : [
		'target',
		'label'
	],
	#category : #'P4-ASM-Values'
}

{ #category : #testing }
P4ASMReference >> isAccess [
	^ true
]

{ #category : #testing }
P4ASMReference >> isRelative [ 
	^ true
]

{ #category : #accessing }
P4ASMReference >> label [
	^ label
]

{ #category : #accessing }
P4ASMReference >> label: anObject [
	label := anObject
]

{ #category : #accessing }
P4ASMReference >> offset [
	^0
]

{ #category : #accessing }
P4ASMReference >> target [
	^ target
]

{ #category : #accessing }
P4ASMReference >> target: anObject [
	target := anObject
]
