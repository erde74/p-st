Class {
	#name : #P4False,
	#superclass : #P4Boolean,
	#category : #'P4-Kernel-Boolean'
}

{ #category : #spec }
P4False >> ifFalse: aBlock [
	^ aBlock value  
]

{ #category : #spec }
P4False >> ifFalse: aFalseBlock ifTrue: aBlock [
	^aFalseBlock value
]

{ #category : #spec }
P4False >> ifTrue: aBlock [  
]

{ #category : #spec }
P4False >> ifTrue: aBlock  ifFalse: aFalseBlock [
	^aFalseBlock value
]

{ #category : #spec }
P4False >> not [
	^ true
]

{ #category : #spec }
P4False >> xor: aBoolean [
	^aBoolean value
]
