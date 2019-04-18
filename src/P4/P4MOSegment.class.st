Class {
	#name : #P4MOSegment,
	#superclass : #P4MOCommand,
	#instVars : [
		'name',
		'sections',
		'initialProtection',
		'maxProtection',
		'fileOffset'
	],
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MOSegment class >> named: aName [
	^ self new
		name: aName;
		yourself
]

{ #category : #'as yet unclassified' }
P4MOSegment >> add: aSection [
	aSection segment: self.
	^ sections at: aSection name put: aSection
]

{ #category : #'as yet unclassified' }
P4MOSegment >> commandSize [
	"sizeof(segment_command_64) = 72"
	^ sections inject: 72 into: [:sum :section| sum + section commandSize]
]

{ #category : #accessing }
P4MOSegment >> fileOffset [
	sections do: [ :section| ^ section fileOffset]
]

{ #category : #accessing }
P4MOSegment >> fileOffset: offset [
	fileOffset := offset.
	^ sections inject: offset into: [ :result :section | 
			section fileOffset: result ]
]

{ #category : #'as yet unclassified' }
P4MOSegment >> fileSize [
	^ sections inject: 0 into: [:sum :section | sum + section fileSize ]
]

{ #category : #'as yet unclassified' }
P4MOSegment >> flags [
	^ 16r00
]

{ #category : #'as yet unclassified' }
P4MOSegment >> initialProtection [
	"
	VM_PROT_NONE    ((vm_prot_t) 0x00) 
	VM_PROT_READ    ((vm_prot_t) 0x01)  /* read permission */
	VM_PROT_WRITE   ((vm_prot_t) 0x02)  /* write permission */
	VM_PROT_EXECUTE ((vm_prot_t) 0x04)  /* execute permission */
	"
	^ 2r111
]

{ #category : #'as yet unclassified' }
P4MOSegment >> initialize [
	super initialize.
	sections := Dictionary new.
]

{ #category : #'as yet unclassified' }
P4MOSegment >> maxProtection [
	"
	VM_PROT_NONE    ((vm_prot_t) 0x00) 
	VM_PROT_READ    ((vm_prot_t) 0x01)  /* read permission */
	VM_PROT_WRITE   ((vm_prot_t) 0x02)  /* write permission */
	VM_PROT_EXECUTE ((vm_prot_t) 0x04)  /* execute permission */
	"
	^ 2r111
]

{ #category : #'as yet unclassified' }
P4MOSegment >> name [
	^ name
]

{ #category : #'as yet unclassified' }
P4MOSegment >> name: aString [
	"The names of segments and sections in them are mostly meaningless to the
	link-editor.  But there are few things to support traditional UNIX
	executables that require the link-editor and assembler to use some names
	agreed upon by convention.
	The initial protection of the __TEXT segment has write protection turned
	off (not writeable).
	The link-editor will allocate common symbols at the end of the __common
	section in the __DATA segment.  It will create the section and segment
	if needed.
	
	The currently known segment names and the section names in those segments
	
	SEG_PAGEZERO	__PAGEZERO	/* the pagezero segment which has n protections and catches NULL references for MH_EXECUTE files */
	SEG_TEXT	__TEXT	/* the tradition UNIX text segment */
	SEG_DATA	__DATA	/* the tradition UNIX data segment */
	SEG_OBJC	__OBJC	/* objective-C runtime segment */
	SEG_ICON	 __ICON	/* the icon segment */
	SEG_LINKEDIT	__LINKEDIT	/* the segment containing all structs created and maintained by the link editor.  Created with -seglinkedit option to ld(1) for MH_EXECUTE and FVMLIB file types only */
	SEG_UNIXSTACK	__UNIXSTACK	/* the unix stack segment */
	SEG_IMPORT	__IMPORT	/* the segment for the self (dyld)  modifing code stubs that has read, write and execute permissions */"
	aString size > 16 
		ifTrue: [ Error signal: ('Segment name "', name, '" has to be less than 16 characters long') ].
	name := aString
]

{ #category : #'as yet unclassified' }
P4MOSegment >> sectionAt: aName [
	^ sections at: aName
]

{ #category : #'as yet unclassified' }
P4MOSegment >> sectionsDo: aBlock [
	^ sections do: aBlock
]

{ #category : #'as yet unclassified' }
P4MOSegment >> type [
	"LC_SEGMENT_64"
	^ 16r19
]

{ #category : #'as yet unclassified' }
P4MOSegment >> virtualMemoryAddress [
	^ 16r0
]

{ #category : #'as yet unclassified' }
P4MOSegment >> virtualMemorySize [
	^ sections inject: 0 into: [:sum :section | sum + section virtualMemorySize ]
]

{ #category : #'as yet unclassified' }
P4MOSegment >> writeCommandOn: aStream [
	super writeCommandOn: aStream.
	aStream << ((name truncateTo: 16) padded: #right to: 16 with: 0 asCharacter). "128bit two pointers"
	"from here on we're off by 16bytes..."
	aStream pointerPut: self virtualMemoryAddress.
	
	aStream pointerPut: self virtualMemorySize.
	aStream pointerPut: self fileOffset.
	
	aStream pointerPut: self fileSize.
	aStream wordPut: self maxProtection.
	aStream wordPut: self initialProtection.
	
	aStream wordPut: sections size.
	aStream wordPut: self flags.
	
	sections do: [ :section | section writeCommandOn: aStream ]
	
]

{ #category : #'as yet unclassified' }
P4MOSegment >> writeOn: aStream [
	sections do: [ :section | section writeOn: aStream ]
]
