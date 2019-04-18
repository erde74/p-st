Class {
	#name : #P4Console,
	#superclass : #P4Object,
	#category : #'P4-Kernel-IO'
}

{ #category : #'as yet unclassified' }
P4Console class >> print: msg [
	<pprimitive: #print>
	self pHalt.
]
