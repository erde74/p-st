Class {
	#name : #P4TACHalt,
	#superclass : #P4TACInstruction,
	#category : #'P4-TAC-IR'
}

{ #category : #'as yet unclassified' }
P4TACHalt >> accept: aVisitor [
	^ aVisitor visitHalt: self.
]

{ #category : #'as yet unclassified' }
P4TACHalt >> asValue [ 
	^ nil
]

{ #category : #'as yet unclassified' }
P4TACHalt >> printOn: stream [
	self printLineNumberOn: stream.
	stream << 'halt' << Character cr.
]
