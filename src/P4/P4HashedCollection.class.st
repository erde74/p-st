Class {
	#name : #P4HashedCollection,
	#superclass : #P4Object,
	#instVars : [
		'size',
		'maxLinear',
		'ratio',
		'buckets',
		'linear'
	],
	#category : #'P4-Kernel-Collection'
}

{ #category : #'initialize-release' }
P4HashedCollection class >> new: preferredSize [
	^ super new initialize: preferredSize
]

{ #category : #'initialize-release' }
P4HashedCollection class >> newFrom: aCollection [
	"Answer an instance of me containing the same elements as aCollection."
	| newCollection |
	newCollection := self new: aCollection size.
	newCollection addAll: aCollection.
	^ newCollection
]

{ #category : #'initialize-release' }
P4HashedCollection class >> typeHints [
	<preventExport>
	^ {
		#size -> #'Kernel.Number.SmallInteger'.
		#maxLinear -> #'Kernel.Number.SmallInteger'.
		#ratio -> #'Kernel.Number.SmallInteger'.
		#buckets -> #'Kernel.Collection.Array'.
		#linear -> #'Kernel.Boolean.Boolean'.
	} asDictionary 
]

{ #category : #conversion }
P4HashedCollection >> asArray [
	^ Array new: self size streamContents: [ :s|
		self do: [ :element|
			s nextPut: element ]].
]

{ #category : #private }
P4HashedCollection >> bucketWithRoomAt: index [
	^ (buckets at: index)
		ifNil: [ self newBucketAt: index ]
		ifNotNil: [ :bucket |
			bucket isFull ifTrue: [ ^ self growBucketAt: index ].
			bucket ]
]

{ #category : #enumerating }
P4HashedCollection >> bucketsDo: aBlock [
	1 to: buckets size do: [ :index |
		(buckets at: index) ifNotNil: [ :bucket | aBlock value: bucket ] ]
]

{ #category : #private }
P4HashedCollection >> checkGrow [
	size := size + 1.
	(size * 100 // buckets size > ratio) ifTrue: [ self grow ]
]

{ #category : #private }
P4HashedCollection >> checkShrink [
	size := size - 1.
	" TODO test if should shrink. ifTrue: [ self shrink ]"
]

{ #category : #copying }
P4HashedCollection >> copyEmpty [
	"Answer an empty copy of this collection"
	^self species new: self size
]

{ #category : #enumerating }
P4HashedCollection >> do: aBlock [
	^ self bucketsDo: [ :bucket | bucket do: aBlock ]
]

{ #category : #private }
P4HashedCollection >> grow [
	| oldBuckets |
	oldBuckets := buckets.
	buckets := Array new: oldBuckets size * 2.
	1 to: oldBuckets size do: [ :index |
		(oldBuckets at: index) ifNotNil: [ :bucket |
			self reAddBucket: bucket at: index]].
]

{ #category : #private }
P4HashedCollection >> growBucketAt: index [
	| oldBucket newBucket |
	oldBucket := buckets at: index.
	newBucket := self newBucket: oldBucket size * 2.
	newBucket copyFrom: oldBucket.
	buckets at: index put: newBucket.
	^ newBucket
]

{ #category : #initialization }
P4HashedCollection >> initialize [
	self initialize: 20
]

{ #category : #initialization }
P4HashedCollection >> initialize: preferredSize [
	size := 0.
	ratio := 500.
	maxLinear := 20.
	(linear := preferredSize <= maxLinear)
		ifTrue: [ buckets := Array with: (self newBucket: preferredSize) ]
		ifFalse: [ "TODO calculate proper size here"
			buckets := Array new: 32 ]
]

{ #category : #private }
P4HashedCollection >> isLinear [
	^ linear
]

{ #category : #accessing }
P4HashedCollection >> maxLinear: anInteger [
	maxLinear := anInteger
]

{ #category : #private }
P4HashedCollection >> newBucketAt: bucketIndex [
	^ buckets at: bucketIndex put: (self newBucket: 4)
]

{ #category : #accessing }
P4HashedCollection >> ratio: aFloat [
	<preventExport>
	ratio := (aFloat * 100) ceiling
]

{ #category : #removing }
P4HashedCollection >> removeAll [
	size := 0.
	self bucketsDo: [:bucket| bucket removeAll ].
]

{ #category : #private }
P4HashedCollection >> shrink [
	"TODO"

	
]

{ #category : #accessing }
P4HashedCollection >> size [
	^ size
]
