Class {
	#name : #P4TACSelf,
	#superclass : #P4TACVariable,
	#category : #'P4-TAC-Values'
}

{ #category : #testing }
P4TACSelf >> firstAssign [ 
	^ 1
]

{ #category : #testing }
P4TACSelf >> isConstant [
	^ true
]

{ #category : #testing }
P4TACSelf >> isSelf [
	^true
]

{ #category : #testing }
P4TACSelf >> shouldBeRemote [ 
	^false
]
