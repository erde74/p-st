Class {
	#name : #P4LBytes,
	#superclass : #P4LSized,
	#category : #'P4-Kernel-Structure'
}

{ #category : #allocation }
P4LBytes >> allocate: memoryManager [
	^ memoryManager allocateBytes: size
]
