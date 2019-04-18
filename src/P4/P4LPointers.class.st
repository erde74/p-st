Class {
	#name : #P4LPointers,
	#superclass : #P4LSized,
	#category : #'P4-Kernel-Structure'
}

{ #category : #allocation }
P4LPointers >> allocate: memoryManager [
	^ memoryManager allocatePointers: size
]
