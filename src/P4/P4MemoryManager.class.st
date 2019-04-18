Class {
	#name : #P4MemoryManager,
	#superclass : #P4Object,
	#instVars : [
		'memory',
		'position',
		'limit',
		'root'
	],
	#category : #'P4-Kernel-Memory'
}

{ #category : #private }
P4MemoryManager >> align: p [
	" Align by 2 bytes to keep the last bit free "
	^ (p + 1) bitAnd: -2
]

{ #category : #private }
P4MemoryManager >> allocate: byteSize [
	| result |
	limit - position < byteSize ifTrue: [
		self garbageCollect.
		limit - position < byteSize ifTrue: [
			self extendMemory.
			limit - position < byteSize ifTrue: [
				self outOfMemory ]]].
	result := position.
	position := self align: position + byteSize.
	^ result
]

{ #category : #allocation }
P4MemoryManager >> allocateBytes: size [
	| result |
	result := self allocate: size + self headerSize.
	" no pointer, no mark "
	result write: (size << 2 + 2r00).
	^ result + self headerSize
]

{ #category : #allocation }
P4MemoryManager >> allocateClass: aClass [
	^ aClass layout allocate: self
]

{ #category : #allocation }
P4MemoryManager >> allocatePointers: size [
	| result |
	result := self allocate: size * self pointerSize + self headerSize.
	" pointer, no mark "
	result write: (size << 2 + 2r10).
	^ result + self headerSize
]

{ #category : #private }
P4MemoryManager >> extendMemory [
	<pNative>
]

{ #category : #'garbage collection' }
P4MemoryManager >> garbageCollect [
	self mark.
	self sweep.
]

{ #category : #'garbage collection' }
P4MemoryManager >> mark [
	| current start |
	current := root.
	[ current == start ] whileFalse: [
		current := current markNext nextUnresolvedPointer ]
]

{ #category : #'garbage collection' }
P4MemoryManager >> sweep [
	| current next |
	current := memory.
	position := memory.
	[ current == limit ] whileFalse: [
		current isMarked
			ifTrue: [
				current == position ifFalse: [ current move: position ].
				position restoreReferences.
				current := current + position size.
				position := position + position size ]
			ifFalse: [ current := current next ]]
]
