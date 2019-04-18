Class {
	#name : #P4TACCaptureClosure,
	#superclass : #P4TACInstruction,
	#instVars : [
		'closure',
		'capturedAt',
		'resultVariable'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #visiting }
P4TACCaptureClosure >> accept: visitor [
	^ visitor visitCaptureClosure: self
]

{ #category : #visiting }
P4TACCaptureClosure >> acceptCaptureClosure: visitor [
	^ visitor visitCaptureClosure: self
]

{ #category : #accessing }
P4TACCaptureClosure >> capturedAt [
	^ capturedAt
]

{ #category : #accessing }
P4TACCaptureClosure >> capturedAt: aBasicBlock [
	capturedAt := aBasicBlock 
]

{ #category : #accessing }
P4TACCaptureClosure >> closure [
	^ closure
]

{ #category : #accessing }
P4TACCaptureClosure >> closure: anObject [
	closure := anObject
]

{ #category : #accessing }
P4TACCaptureClosure >> containsReturn [ 
	^ closure code containsReturn
]

{ #category : #visiting }
P4TACCaptureClosure >> printOn: stream [
	self printLineNumberOn: stream.
	stream << '['.
	closure printOn: stream.
	stream << ']'<< Character cr.  
]

{ #category : #accessing }
P4TACCaptureClosure >> resultVariable [
	^ resultVariable
]

{ #category : #accessing }
P4TACCaptureClosure >> resultVariable: anObject [
	resultVariable := anObject
]
