Class {
	#name : #P4DictBucket,
	#superclass : #P4AbstractBucket,
	#type : #variable,
	#category : #'P4-Kernel-Collection'
}

{ #category : #'instance creation' }
P4DictBucket class >> new: sizeRequested [
	^ super new: sizeRequested * 2
]

{ #category : #'instance creation' }
P4DictBucket class >> typeHints [ 
	<preventExport>
	^ {
		#self-> #'Kernel.Collection.DictBucket'
	} asDictionary
]

{ #category : #accessing }
P4DictBucket >> assign: key to: value [
	1 to: bucketSize by: 2 do: [ :index |
		(self at: index) = key
			ifTrue: [ self at: index + 1 put: value. ^ true ]].
	^ false
]

{ #category : #accessing }
P4DictBucket >> at: aKey ifAbsent: aBlock [
	1 to: bucketSize by: 2 do: [ :index | 
		(self at: index) = aKey ifTrue: [ ^ self at: index + 1 ]].
	^ aBlock value
]

{ #category : #enumeration }
P4DictBucket >> do: aBlock [
	2 to: bucketSize by: 2 do: [ :index | aBlock value: (self at: index) ]
]

{ #category : #testing }
P4DictBucket >> includes: anObject [
	2 to: bucketSize by: 2 do: [ :index | 
		(self at: index) = anObject ifTrue: [ ^ true ]].
	^ false
]

{ #category : #testing }
P4DictBucket >> includesKey: aKey [
	1 to: bucketSize by: 2 do: [ :index | 
		(self at: index) = aKey ifTrue: [ ^ true ]].
	^ false
]

{ #category : #enumeration }
P4DictBucket >> keysAndValuesDo: aBlock [
	1 to: bucketSize by: 2 do: [ :index | 
			"value: key v value: value value: index"
		aBlock value: (self at: index) value: (self at: index + 1) ]
]

{ #category : #enumeration }
P4DictBucket >> keysDo: aBlock [
	1 to: bucketSize by: 2 do: [ :index | aBlock value: (self at: index) ]
]

{ #category : #adding }
P4DictBucket >> newKey: aKey value: anObject [
	self at: bucketSize + 1 put: aKey.
	self at: bucketSize + 2 put: anObject.
	bucketSize := bucketSize + 2
]

{ #category : #removing }
P4DictBucket >> remove: aKey ifAbsent: aBlock [
	| value |
	1 to: bucketSize by: 2 do: [ :index | 
		(self at: index) = aKey
			ifTrue: [
				value := self at: index + 1.
				self removeAt: index.
				^ value ]].
	^ aBlock value
]

{ #category : #removing }
P4DictBucket >> removeAt: index [
	self at: index put: (self at: bucketSize - 1).
	self at: index + 1 put: (self at: bucketSize).
	bucketSize := bucketSize - 2.
	self at: bucketSize + 1 put: nil.
	self at: bucketSize + 2 put: nil
]

{ #category : #accessing }
P4DictBucket >> scanFor: aKey [
	1 to: bucketSize by: 2 do: [ :index | 
		(self at: index) = aKey ifTrue: [ ^ index ]].
	^ 0
]
