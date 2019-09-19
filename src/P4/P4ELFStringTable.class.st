Class {
	#name : #P4ELFStringTable,
	#superclass : #P4ELFTable,
	#category : #'P4-Exec-ELF'
}

{ #category : #header }
P4ELFStringTable >> addrAlign [ 
	^ 1
]

{ #category : #accessing }
P4ELFStringTable >> allocateString: aName [
	| ndx |
	aName = '' ifTrue: [ ^ 0 ].
	ndx := data position.
	" Encode as 0-terminated C-strings "
	data nextPutAll: aName asByteArray.
	data nextPut: 16r0.
	^ ndx
]

{ #category : #accessing }
P4ELFStringTable >> entrySize: pointerSize [
	^ 0
]

{ #category : #'initialize-release' }
P4ELFStringTable >> initialize [
	self flag: 'use the stream from the processor'.
	super initialize.
	data := P4BinaryWriteStream new.
	data nextPut: 16r0
]

{ #category : #accessing }
P4ELFStringTable >> size: pointerSize [
	self flag: 'should extract this to a "finalize" method'.
	^ data size + 1
]

{ #category : #header }
P4ELFStringTable >> type [
	" 16r3 STRTAB String table (multiple) "
	^ 16r3 
]

{ #category : #writing }
P4ELFStringTable >> writeOn: aStream [
	super writeOn: aStream.
	self flag: 'Optimize'.
	aStream nextPutAll: data contents.
	aStream nextPut: 16r0
]
