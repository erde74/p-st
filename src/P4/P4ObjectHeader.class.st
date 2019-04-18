Class {
	#name : #P4ObjectHeader,
	#superclass : #P4RawCell,
	#category : #'P4-Kernel-Memory'
}

{ #category : #testing }
P4ObjectHeader >> hasPointer [
	^ (self read bitAnd: 2) = 2
]

{ #category : #testing }
P4ObjectHeader >> lastPointer [
	^ self + self size
]

{ #category : #accessing }
P4ObjectHeader >> mark [
	self write: (self read bitOr: 1)
]

{ #category : #accessing }
P4ObjectHeader >> size [
	^ self read >> 2
]

{ #category : #accessing }
P4ObjectHeader >> unmark [
	self write: (self read bitXor: 1)
]
