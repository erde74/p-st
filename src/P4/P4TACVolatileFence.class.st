Class {
	#name : #P4TACVolatileFence,
	#superclass : #P4TACInstruction,
	#category : #'P4-TAC-IR'
}

{ #category : #'as yet unclassified' }
P4TACVolatileFence >> accept: visitor [
	visitor visitVolatileFence: self
]

{ #category : #'as yet unclassified' }
P4TACVolatileFence >> printOn: stream [
	stream << '--volatile fence--' << Character cr
]
