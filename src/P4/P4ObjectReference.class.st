Class {
	#name : #P4ObjectReference,
	#superclass : #P4RawCell,
	#category : #'P4-Kernel-Memory'
}

{ #category : #gc }
P4ObjectReference >> markNext [
	| header |
	header := self read.
	(header isMarked not and: [ header hasPointer ])
		ifTrue: [ ^ self swapAndDive ].
	^ self swapContinue
]

{ #category : #gc }
P4ObjectReference >> nextUnresolvedPointer [
	| next |
	next := self.
	[ [ next notInSpace ] whileTrue: [ next := next - 1 ].
	next isMarked ] whileTrue: [ next := next read ].
	^ next
]

{ #category : #gc }
P4ObjectReference >> restoreReferences [
	| current next |
	current := self read.
	[ current unmark.
	   next := current read.
	  current hasPointer ]
		whileFalse: [
			current write: self.
			current := next ].
	self write: next.
	current write: self.
]

{ #category : #gc }
P4ObjectReference >> swapAndDive [
	| header next |
	header := self read.
	next := header next.
	next := next - next headerSize.
	self write: header.
	header write: self.
	^ next
]

{ #category : #gc }
P4ObjectReference >> swapContinue [
	| header |
	header := self read.
	self write: header.
	header write: self.
	^ self - 1
]
