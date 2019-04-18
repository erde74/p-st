Class {
	#name : #P4ASMValue,
	#superclass : #P4Object,
	#category : #'P4-ASM-Values'
}

{ #category : #accessing }
P4ASMValue >> combination [
	^ 0
]

{ #category : #testing }
P4ASMValue >> isAccess [
	^ false
]

{ #category : #testing }
P4ASMValue >> isConstant [
	^ false
]

{ #category : #testing }
P4ASMValue >> isExternal [
	^false
]

{ #category : #testing }
P4ASMValue >> isRelative [
	^ false
]
