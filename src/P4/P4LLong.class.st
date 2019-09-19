Class {
	#name : #P4LLong,
	#superclass : #P4Layout,
	#category : #'P4-Kernel-Structure'
}

{ #category : #testing }
P4LLong class >> isAbstractClass [
	self shouldBeImplemented
]

{ #category : #allocation }
P4LLong >> allocate: memoryManager [
	^ memoryManager allocateLong
]
