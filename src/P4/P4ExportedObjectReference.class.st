Class {
	#name : #P4ExportedObjectReference,
	#superclass : #P4ExportedReference,
	#category : #'P4-Exec'
}

{ #category : #accessing }
P4ExportedObjectReference >> printOn: stream [
	stream << 'a local Reference'
]

{ #category : #accessing }
P4ExportedObjectReference >> relocationTable [
	^ target section relocationTable
]

{ #category : #accessing }
P4ExportedObjectReference >> sectionOffset [
	^ target sectionOffset + offset
]
