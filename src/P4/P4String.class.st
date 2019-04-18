Class {
	#name : #P4String,
	#superclass : #P4Object,
	#type : #bytes,
	#category : #'P4-Kernel-String'
}

{ #category : #'as yet unclassified' }
P4String >> print [
	<pprimitive: #print>
	self pHalt.
]
