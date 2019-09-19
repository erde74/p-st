Class {
	#name : #P4Set,
	#superclass : #P4HashedCollection,
	#category : #'P4-Kernel-Collection'
}

{ #category : #adding }
P4Set >> add: value [
	| bucketIndex bucket |
	linear ifTrue: [ ^ self addInFirstBucket: value ].
	
	bucketIndex := (value pHash \\ buckets size) + 1.
	bucket := buckets at: bucketIndex.
	bucket ifNil: [
		bucket := self newBucketAt: bucketIndex.
		bucket addNew: value.
		self checkGrow.
		^ value ].
	(bucket includes: value) ifTrue: [ ^ value ].
	bucket isFull ifTrue: [ bucket := self growBucketAt: bucketIndex ].
	bucket addNew: value.
	self checkGrow.
	^ value
	
]

{ #category : #adding }
P4Set >> addAll: values [
	values do: [ :v | self add: v ]
]

{ #category : #private }
P4Set >> addInFirstBucket: value [
	| bucket |
	bucket := buckets at: 1.
	(bucket includes: value) ifTrue: [ ^ value ].
	bucket isFull ifTrue: [
		size < maxLinear ifFalse: [
			linear := false.
			buckets := Array new: 32.
			self reAddBucket: bucket at: 1.
			^ self add: value ].
		bucket := self growBucketAt: 1 ].
	bucket addNew: value.
	size := size + 1.
	^ value
]

{ #category : #iterating }
P4Set >> do: aBlock [
	self bucketsDo: [ :bucket | bucket do: aBlock ]
]

{ #category : #testing }
P4Set >> includes: anObject [
	linear ifTrue: [ ^ (buckets at: 1) includes: anObject ].
	^ (buckets at: anObject pHash \\ buckets size + 1)
		ifNil: [ false ]
		ifNotNil: [ :bucket | bucket includes: anObject ]
]

{ #category : #inspecting }
P4Set >> inspectChildrenOn: inspector [
	| index |
	index := 0.
	self do: [ :value |
		inspector
			child: (index := index + 1)
			value: [ value ]]
]

{ #category : #testing }
P4Set >> isEmpty [
	^ self size == 0
]

{ #category : #private }
P4Set >> newBucket: sizeRequested [
	<preventExport>
	self flag: 'ne'.
	^ P4SetBucket new: sizeRequested
]

{ #category : #private }
P4Set >> reAddBucket: bucket at: index [
	| c item bucketIndex |
	buckets at: index put: bucket.
	c := 1.
	[ c <= bucket bucketSize ] whileTrue: [ 
		item := bucket at: c.
		bucketIndex := item pHash \\ buckets size + 1.
		bucketIndex = index
			ifTrue: [ c := c + 1 ]
			ifFalse: [
				(self bucketWithRoomAt: bucketIndex) addNew: item.
				bucket removeAt: c ]]
]

{ #category : #removing }
P4Set >> remove: anObject [
	^ self remove: anObject ifAbsent: [ self valueNotFound: anObject ].
]

{ #category : #removing }
P4Set >> remove: anObject ifAbsent: aBlock [
	| bucket value |
	linear ifTrue: [ bucket := buckets at: 1 ]
		ifFalse: [
			bucket := buckets at: anObject pHash \\ buckets size + 1.
			bucket ifNil: [ ^ aBlock value ]].
	value := bucket remove: anObject ifAbsent: [ ^ aBlock value ].
	self checkShrink.
	^ value
]
