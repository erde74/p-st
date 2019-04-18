Class {
	#name : #P4BinaryWriteStream,
	#superclass : #P4Object,
	#instVars : [
		'stream'
	],
	#category : #'P4-Stream'
}

{ #category : #'instance creation' }
P4BinaryWriteStream class >> new [
	^ super new stream: (ReadWriteStream on: (ByteArray new: 1024)).
]

{ #category : #streaming }
P4BinaryWriteStream >> << data [
	data putOn: self
]

{ #category : #aligning }
P4BinaryWriteStream >> alignBy: bytes [
	self alignBy: bytes with: 16r00 
]

{ #category : #aligning }
P4BinaryWriteStream >> alignBy: bytes with: aByte [
	stream position \\ bytes = 0 ifTrue: [ ^ self ].
	(((stream position // bytes) + 1) * bytes - stream position) timesRepeat: [ self nextPut: aByte ]
]

{ #category : #aligning }
P4BinaryWriteStream >> alignByPointer [
	self alignBy: self pointerSize
]

{ #category : #accessing }
P4BinaryWriteStream >> back [
	^ stream back
]

{ #category : #accessing }
P4BinaryWriteStream >> contents [
	^ stream contents
]

{ #category : #aligning }
P4BinaryWriteStream >> fillTo: position with: aByte [
	( position - self position) timesRepeat: [ self nextPut: aByte ]
]

{ #category : #testing }
P4BinaryWriteStream >> isBinary [
	^ true
]

{ #category : #accessing }
P4BinaryWriteStream >> next [
	^ stream next
]

{ #category : #writing }
P4BinaryWriteStream >> nextPut: aValue [
	| value |
	value := aValue asInteger.
	(value < 0)  ifTrue: [ value := (value + 256) ].
	(value >= 0 and: [ value < 256]) ifFalse: [ self error: 'not a byte you dork'].
	stream nextPut: value.  
]

{ #category : #writing }
P4BinaryWriteStream >> nextPutAll: aCollection [
	(aCollection class == ByteArray)
		ifTrue: [ ^ stream nextPutAll: aCollection ].
	aCollection do: [ :c | self nextPut: c ]
]

{ #category : #accessing }
P4BinaryWriteStream >> position [
	^ stream position
]

{ #category : #accessing }
P4BinaryWriteStream >> position: aPosition [
	^ stream position: aPosition
]

{ #category : #printing }
P4BinaryWriteStream >> printOn: aStream [
	|collection|
	collection := stream contents.
	1 to: collection size do: [ :index |
		aStream << '\x'.
		aStream << ((collection at: index) asInteger printStringBase: 16) ]
]

{ #category : #printing }
P4BinaryWriteStream >> putOn: aStream [
	aStream nextPutAll: self contents
]

{ #category : #accessing }
P4BinaryWriteStream >> reset [
	stream resetToStart
]

{ #category : #accessing }
P4BinaryWriteStream >> size [
	^ stream size
]

{ #category : #accessing }
P4BinaryWriteStream >> stream: aStream [
	stream := aStream
]
