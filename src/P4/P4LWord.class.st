Class {
	#name : #P4LWord,
	#superclass : #P4Layout,
	#category : #'P4-Kernel-Structure'
}

{ #category : #allocation }
P4LWord >> allocate: memoryManager [
	^ memoryManager allocateWord
]
