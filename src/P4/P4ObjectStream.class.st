Class {
	#name : #P4ObjectStream,
	#superclass : #P4TACCodeBlock,
	#instVars : [
		'instructions',
		'currentPosition',
		'substreams'
	],
	#category : #'P4-Stream'
}

{ #category : #accessing }
P4ObjectStream >> << anObject [
	^ anObject putObjectOn: self
]

{ #category : #accessing }
P4ObjectStream >> do: aBlock [
	instructions do: [ :instr |
		instr do: aBlock ].
]

{ #category : #private }
P4ObjectStream >> doSubstreams: aBlock [
	^ substreams do: aBlock
]

{ #category : #accessing }
P4ObjectStream >> firstElement [
	self do: [ :instr |^ instr ]
]

{ #category : #private }
P4ObjectStream >> hasSubstreams [
	^ substreams isEmpty not
]

{ #category : #'initialize-release' }
P4ObjectStream >> initialize [ 
	currentPosition := self.
	instructions := OrderedCollection new.
	substreams := OrderedCollection new.
]

{ #category : #accessing }
P4ObjectStream >> isEmpty [ 
	^ instructions isEmpty 
]

{ #category : #accessing }
P4ObjectStream >> lastElement [
	self reverseDo: [ :instr | ^ instr ]
]

{ #category : #private }
P4ObjectStream >> newSubstream [
	^ self newSubstream: P4ObjectStream new.
]

{ #category : #private }
P4ObjectStream >> newSubstream: aStream [
	^ substreams add: aStream 
]

{ #category : #accessing }
P4ObjectStream >> nextPut: aTacIR [
	(currentPosition == self) ifTrue: [ ^ instructions add: aTacIR ].
	^ currentPosition nextPut: aTacIR
]

{ #category : #accessing }
P4ObjectStream >> nextPutStream: aStream [
	self newSubstream: aStream.
	^ currentPosition nextPut: aStream
]

{ #category : #accessing }
P4ObjectStream >> overridePosition: anInstruction [
	| index |
	index := instructions indexOf: anInstruction ifAbsent: [
		self hasSubstreams 
			ifTrue: [  
				self doSubstreams: [ :stream |
					(stream overridePosition: anInstruction) ifNotNil: [ 
						currentPosition := stream. 
						^self ]]].
			^nil].
	currentPosition := self newSubstream..
	instructions at: index put: currentPosition.
	^ self.
]

{ #category : #accessing }
P4ObjectStream >> position: anInstruction [
	^ (self overridePosition: anInstruction)
		ifNotNil: [ 
			self << anInstruction.
			^ self ]
]

{ #category : #accessing }
P4ObjectStream >> position: anInstruction ifAbsent: aBlock [
	(self position: anInstruction) ifNil: aBlock
]

{ #category : #accessing }
P4ObjectStream >> positionAtBeginning [
	currentPosition := instructions addFirst: self newSubstream.
]

{ #category : #accessing }
P4ObjectStream >> positionAtEnd [
	currentPosition := self
]

{ #category : #accessing }
P4ObjectStream >> printOn: aStream [
	self do: [ :instr | 
		aStream tab.
		instr printOn: aStream. ]
]

{ #category : #accessing }
P4ObjectStream >> putObjectOn: anInstructionStream [
	^ anInstructionStream nextPutStream: self
]

{ #category : #accessing }
P4ObjectStream >> remove: anInstruction [
	| index |
	index := instructions indexOf: anInstruction ifAbsent: [
		self hasSubstreams 
			ifTrue: [  
				self doSubstreams: [ :stream |
					(stream remove: anInstruction) ifNotNil: [ :instr | ^ instr ]]].
			^nil].
	instructions at: index put: P4EmptyStreamObject instance.
	^ anInstruction.
]

{ #category : #accessing }
P4ObjectStream >> reverseDo: aBlock [
	instructions reverseDo: [ :instr |
		instr do: aBlock ].
]
