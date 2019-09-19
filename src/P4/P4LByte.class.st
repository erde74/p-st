Class {
	#name : #P4LByte,
	#superclass : #P4Layout,
	#category : #'P4-Kernel-Structure'
}

{ #category : #allocation }
P4LByte >> allocate: memoryManager [ 
	^ memoryManager allocateByte
]
