Class {
	#name : #P4Dictionary,
	#superclass : #P4HashedCollection,
	#category : #'P4-Kernel-Collection'
}

{ #category : #staticTyping }
P4Dictionary class >> pExportedName [ 
	^ self == P4Dictionary
		ifTrue: [ #Dictionary ]
		ifFalse: [ super pExportedName ]
]

{ #category : #staticTyping }
P4Dictionary class >> typeHints [
	<preventExport>
	^ super typeHints addAll: {
		#self -> #'Kernel.Collection.Dictionary'
	} asDictionary 
]

{ #category : #adding }
P4Dictionary >> addAll: aDictionary [
	aDictionary == self ifTrue: [ ^ self ].
	aDictionary keysAndValuesDo: [:key :value | self at: key put: value].
	^ aDictionary.
]

{ #category : #accessing }
P4Dictionary >> at: key [
	^ self at: key ifAbsent: [ self errorKeyNotFound: key ]
]

{ #category : #accessing }
P4Dictionary >> at: key ifAbsent: aBlock [
	<pprimitive: #at:ifAbsent: plugin: #'Collection.Dictionary'>
	linear ifTrue: [ ^ (buckets at: 1) at: key ifAbsent: aBlock ].
	^ (buckets at: key pHash \\ buckets size + 1)
		ifNil: [ aBlock value ]
		ifNotNil: [ :bucket | bucket at: key ifAbsent: aBlock ]
]

{ #category : #accessing }
P4Dictionary >> at: key ifAbsentPut: aBlock [
	^ self at: key ifAbsent: [ self at: key put: aBlock value ]
]

{ #category : #accessing }
P4Dictionary >> at: key ifPresent: aBlock [
	"Lookup the given key in the receiver.
	If it is present, answer the value of evaluating the given block with the value associated with the key.
	Otherwise, answer nil."
	^ aBlock value: (self at: key ifAbsent: [ ^ nil ])
]

{ #category : #accessing }
P4Dictionary >> at: key put: anObject [
	| bucketIndex bucket |
	linear ifTrue: [ ^ self inFirstBucketAt: key put: anObject ].
		
	bucketIndex := key pHash \\ buckets size + 1.
	bucket := buckets at: bucketIndex.
	bucket ifNil: [
		(self newBucketAt: bucketIndex) newKey: key value: anObject.
		self checkGrow.
		^ anObject ].
	(bucket assign: key to: anObject) ifTrue: [ ^ anObject ].
	bucket isFull ifTrue: [ bucket := self growBucketAt: bucketIndex ].
	bucket newKey: key value: anObject.
	self checkGrow.
	^ anObject
]

{ #category : #inspecting }
P4Dictionary >> collect: aBlock displayingProgress: aString [
	<preventExport>
	"Evaluate aBlock with each of my values as the argument.  Collect the
	resulting values into a collection that is like me. Answer with the new
	collection."
	| newCollection |
	newCollection := Dictionary new.
	(self keysAndValuesDo:[:key :value |
		newCollection at: key put: (aBlock value: value).
	]).
	^newCollection
]

{ #category : #'error handling' }
P4Dictionary >> errorKeyNotFound: aKey [
	^ P4KeyNotFound new
		key: aKey;
		dictionary: self;
		signal
]

{ #category : #private }
P4Dictionary >> inFirstBucketAt: key ifAbsentPut: aBlock [
	^ (buckets at: 1) at: key ifAbsent: [
		^ self inFirstBucketAtNew: key put: aBlock value ]
]

{ #category : #private }
P4Dictionary >> inFirstBucketAt: key put: anObject [
	^ ((buckets at: 1) assign: key to: anObject)
		ifTrue: [ anObject ]
		ifFalse: [ self inFirstBucketAtNew: key put: anObject ]
]

{ #category : #private }
P4Dictionary >> inFirstBucketAtNew: key put: value [
	| bucket |
	bucket := buckets at: 1.
	bucket isFull ifTrue: [
		(bucket size < maxLinear)
			ifFalse: [
				linear := false.
				buckets := Array new: 32.
				self reAddBucket: bucket at: 1.
				^ self at: key put: value ].
		bucket := self growBucketAt: 1 ].
	bucket newKey: key value: value.
	size := size + 1.
	^ value
]

{ #category : #testing }
P4Dictionary >> includes: anObject [
	self bucketsDo: [ :bucket | (bucket includes: anObject) ifTrue: [ ^ true ]].
	^ false
]

{ #category : #testing }
P4Dictionary >> includesKey: key [
	<pprimitive: #includesKey: plugin: #'Collection.Dictionary'>
	linear ifTrue: [ ^ (buckets at: 1) includesKey: key ].
	^ (buckets at: key pHash \\ buckets size + 1)
		ifNil: [ false ]
		ifNotNil: [ :bucket | bucket includesKey: key ]
]

{ #category : #inspecting }
P4Dictionary >> inspectChildrenOn: inspector [
	self keysAndValuesDo: [ :key :value |
		inspector child: key value: [ value ]]
]

{ #category : #accessing }
P4Dictionary >> keys [
	| keys index |
	keys := Array new: size.
	index := 0.
	self keysDo: [ :key | keys at: (index := index + 1) put: key ].
	^ keys
]

{ #category : #enumerating }
P4Dictionary >> keysAndValuesDo: aBlock [
	self bucketsDo: [ :bucket | bucket keysAndValuesDo: aBlock ]
	
]

{ #category : #enumerating }
P4Dictionary >> keysDo: aBlock [
	self bucketsDo: [ :bucket | bucket keysDo: aBlock ]
	
]

{ #category : #private }
P4Dictionary >> newBucket: sizeRequested [
	^ P4DictBucket new: sizeRequested
]

{ #category : #adding }
P4Dictionary >> printOn: stream [
	stream << 'a Dictionary {'.
	stream cr.
	self keysAndValuesDo: [ :k :v |
		k printOn: stream.
		stream << ' -> '.
		v printOn: stream.
		stream cr ] .
	stream << '}'
]

{ #category : #private }
P4Dictionary >> reAddBucket: bucket at: index [
	| c key bucketIndex |
	c := 1.
	buckets at: index put: bucket.
	[ c <= bucket bucketSize ] whileTrue: [ 
			key := bucket at: c.
			bucketIndex := key pHash \\ buckets size + 1.
			bucketIndex = index
				ifTrue: [ c := c + 2 ]
				ifFalse: [ 
					(self bucketWithRoomAt: bucketIndex) newKey: key value: (bucket at: c + 1).
					bucket removeAt: c ] ]
]

{ #category : #removing }
P4Dictionary >> remove: anObject ifAbsent: aBlock [
	self shouldNotCall
]

{ #category : #removing }
P4Dictionary >> removeKey: key [
	"Remove key from the receiver.
	If key is not in the receiver, notify an error."

	^ self removeKey: key ifAbsent: [ self errorKeyNotFound: key ]
]

{ #category : #removing }
P4Dictionary >> removeKey: key ifAbsent: aBlock [
	| value bucket |
	linear ifTrue: [
		value := (buckets at: 1) remove: key ifAbsent: [ ^ aBlock value ].
		self checkShrink.
		^ value ].
	bucket := buckets at: key pHash \\ buckets size + 1.
	bucket ifNil: [ ^ aBlock value ].
	value := bucket remove: key ifAbsent: [ ^ aBlock value ].
	self checkShrink.
	^ value
]

{ #category : #selecting }
P4Dictionary >> select: aBlock [ 
	"Evaluate aBlock with each of my values as the argument. Collect into a new dictionary, only those associations for which aBlock evaluates to true."

	| newCollection |
	newCollection := self copyEmpty.
	self keysAndValuesDo: [ :key :value |
		(aBlock value: value) ifTrue: [
			newCollection at: key put: value ] ].
	^newCollection
]

{ #category : #accessing }
P4Dictionary >> values [
	| values index |
	values := Array new: size.
	index := 0.
	self do: [ :value | values at: (index := index + 1) put: value ].
	^ values
]

{ #category : #enumerating }
P4Dictionary >> valuesDo: aBlock [
	self bucketsDo: [ :bucket | bucket do: aBlock ]
	
]
