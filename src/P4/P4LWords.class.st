Class {
	#name : #P4LWords,
	#superclass : #P4LSized,
	#category : #'P4-Kernel-Structure'
}

{ #category : #allocation }
P4LWords >> allocate: memoryManager [
	^ memoryManager allocateWords: size
]
