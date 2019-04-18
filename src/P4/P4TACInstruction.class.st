Class {
	#name : #P4TACInstruction,
	#superclass : #P4TACCodePoint,
	#instVars : [
		'flowNumber'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #visiting }
P4TACInstruction >> accept: aVisitor [
	^ aVisitor visitInstruction: self
]

{ #category : #visiting }
P4TACInstruction >> acceptCaptureClosure: aVisitor [
	

]

{ #category : #accessing }
P4TACInstruction >> acceptRegisterSwapper: aVisitor [

]

{ #category : #'instruction-stream' }
P4TACInstruction >> do: aBlock [
	aBlock value: self
]

{ #category : #accessing }
P4TACInstruction >> flowNumber [
	^ flowNumber
]

{ #category : #accessing }
P4TACInstruction >> flowNumber: anObject [
	flowNumber := anObject
]

{ #category : #accessing }
P4TACInstruction >> isAssignment [
	^false
]

{ #category : #accessing }
P4TACInstruction >> printLineNumberOn: stream [
	flowNumber isNil ifFalse: [ stream << flowNumber << ': ' ]
]

{ #category : #'instruction-stream' }
P4TACInstruction >> putObjectOn: anInstructionStream [
	^ anInstructionStream nextPut: self
]
