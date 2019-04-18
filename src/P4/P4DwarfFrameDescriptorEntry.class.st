Class {
	#name : #P4DwarfFrameDescriptorEntry,
	#superclass : #P4Object,
	#instVars : [
		'ciePointer',
		'initialLocation',
		'addressRange',
		'callFrameInstructions'
	],
	#category : #'P4-Exec-ELF-Dwarf'
}

{ #category : #accessing }
P4DwarfFrameDescriptorEntry >> addressRange [
	"Size of the function code corresponding to this FDE.
	 If 'R' is missing from the CIE Augmentation String, the field is an 8-byte unsigned number. [...]".
	^ addressRange
]

{ #category : #accessing }
P4DwarfFrameDescriptorEntry >> addressRange: anObject [
	addressRange := anObject
]

{ #category : #accessing }
P4DwarfFrameDescriptorEntry >> callFrameInstructions [
	^ callFrameInstructions
]

{ #category : #accessing }
P4DwarfFrameDescriptorEntry >> callFrameInstructions: anObject [
	callFrameInstructions := anObject
]

{ #category : #accessing }
P4DwarfFrameDescriptorEntry >> ciePointer [
	"Distance from this field to the nearest preceding CIE (the value is subtracted from the current address). This value
         can never be zero and thus can be used to distinguish CIE's and FDE's when scanning the .eh_frame section"
	^ ciePointer
]

{ #category : #accessing }
P4DwarfFrameDescriptorEntry >> ciePointer: anObject [
	ciePointer := anObject
]

{ #category : #accessing }
P4DwarfFrameDescriptorEntry >> initialLocation [
	"Reference to the function code corresponding to this FDE.
         If 'R' is missing from the CIE Augmentation String, the field is an 8-byte absolute pointer. [...]"
	^ initialLocation
]

{ #category : #accessing }
P4DwarfFrameDescriptorEntry >> initialLocation: anObject [
	initialLocation := anObject
]

{ #category : #'as yet unclassified' }
P4DwarfFrameDescriptorEntry >> length [
	^ 24 + callFrameInstructions length
]

{ #category : #'as yet unclassified' }
P4DwarfFrameDescriptorEntry >> putOn: stream [
	stream putUnsigned: self length bytes: 4.
	stream put: self ciePointer bytes: 4.
	stream put: self initialLocation bytes: 8.
	stream put: self addressRange bytes: 8.
	self putCallFrameInstructionsOn: stream.
	
]
