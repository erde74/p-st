Class {
	#name : #P4TACCall,
	#superclass : #P4TACInstruction,
	#instVars : [
		'method',
		'offset'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'instance creation' }
P4TACCall class >> to: aMethod [
	^ self new method: aMethod
]

{ #category : #visiting }
P4TACCall >> accept: aVisitor [
	^ aVisitor visitCall: self
]

{ #category : #accessing }
P4TACCall >> initialize [ 
	super initialize .
	offset := 0
]

{ #category : #accessing }
P4TACCall >> method [
	^ method
]

{ #category : #accessing }
P4TACCall >> method: anObject [
	method := anObject
]

{ #category : #accessing }
P4TACCall >> offset [
	^ offset
]

{ #category : #accessing }
P4TACCall >> offset: anObject [
	offset := anObject
]

{ #category : #'as yet unclassified' }
P4TACCall >> printOn: stream [
	self printLineNumberOn: stream.  
	stream << '[%rax] := call ' << method asString << Character cr.
]
