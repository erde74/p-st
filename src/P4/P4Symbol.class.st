Class {
	#name : #P4Symbol,
	#superclass : #P4String,
	#type : #bytes,
	#category : #'P4-Kernel-String'
}

{ #category : #exporting }
P4Symbol class >> pExportedName [ 
	^ self == P4Symbol
		ifTrue: [ #Symbol ]
		ifFalse: [ super pExportedName ]
]

{ #category : #'as yet unclassified' }
P4Symbol >> countArgs [
	<pprimitive: #'count_args'>
	self pHalt
]
