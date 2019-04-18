Class {
	#name : #P4MachO,
	#superclass : #P4ExecutableFormat,
	#instVars : [
		'commands',
		'segments'
	],
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MachO >> commands [
	commands do: [ :command|
		command writeCommandOn: currentStream]
]

{ #category : #'as yet unclassified' }
P4MachO >> cpuSubType [
	^ processor machOCPUSubType
]

{ #category : #'as yet unclassified' }
P4MachO >> cpuType [
	^ processor machOCPUType
]

{ #category : #'as yet unclassified' }
P4MachO >> filetype [
	"
	MH_OBJECT   0x1     /* relocatable object file */
	MH_EXECUTE  0x2     /* demand paged executable file */
	MH_FVMLIB   0x3     /* fixed VM shared library file */
	MH_CORE     0x4     /* core file */
	MH_PRELOAD  0x5     /* preloaded executable file */
	MH_DYLIB    0x6     /* dynamically bound shared library */
	MH_DYLINKER 0x7     /* dynamic link editor */
	MH_BUNDLE   0x8     /* dynamically bound bundle file */
	H_DYLIB_STUB   0x9     /* shared library stub for static */
                      /*  linking only, no section contents */
	MH_DSYM     0xa     /* companion file with only debug */
	
	We are creating a relocatable file:
	"
	^ 16r1
]

{ #category : #'as yet unclassified' }
P4MachO >> finalize [
	self finalizeOffsets.
	self finalizeSections.
	
]

{ #category : #'as yet unclassified' }
P4MachO >> finalizeOffsets [
	| offset |
	offset := commands inject: self headerSize into: [ :sum :command| 
					sum + command commandSize].
	commands do: [ :command| 
		offset := command fileOffset: offset]
]

{ #category : #'as yet unclassified' }
P4MachO >> finalizeSections [
	|index|
	index := 0.
	segments do: [ :segment|
		segment sectionsDo: [ :section|
			section index: (index := index + 1)]]
	
]

{ #category : #'as yet unclassified' }
P4MachO >> flags [
	"MH_NOUNDEFS 0x1     /* the object file has no undefined references */
	MH_INCRLINK 0x2     /* the object file is the output of an incremental link against a base file and can't be link edited again */
	MH_DYLDLINK 0x4     /* the object file is input for the dynamic linker and can't be staticly link edited again */
	MH_BINDATLOAD   0x8     /* the object file's undefined references are bound by the dynamic linker when loaded. */
	MH_PREBOUND 0x10        /* the file has its dynamic undefined references prebound. */
	MH_SPLIT_SEGS   0x20        /* the file has its read-only and read-write segments split */
	MH_LAZY_INIT    0x40        /* the shared library init routine is to be run lazily via catching memory faults to its writeable segments (obsolete) */
	MH_TWOLEVEL 0x80        /* the image is using two-level name space bindings */
	MH_FORCE_FLAT   0x100       /* the executable is forcing all images to use flat name space bindings */
	MH_NOMULTIDEFS  0x200       /* this umbrella guarantees no multiple defintions of symbols in its sub-images so the two-level namespace hints can always be used. */
	MH_NOFIXPREBINDING 0x400    /* do not have dyld notify the prebinding agent about this executable */
	MH_PREBINDABLE  0x800           /* the binary is not prebound but can have its prebinding redone. only used when MH_PREBOUND is not set. */
	MH_ALLMODSBOUND 0x1000      /* indicates that this binary binds to all two-level namespace modules of its dependent libraries. only used when MH_PREBINDABLE and MH_TWOLEVEL are both set. */ 
	MH_SUBSECTIONS_VIA_SYMBOLS 0x2000/* safe to divide up the sections into sub-sections via symbols for dead code stripping */
	MH_CANONICAL    0x4000      /* the binary has been canonicalized via the unprebind operation */
	MH_WEAK_DEFINES 0x8000      /* the final linked image contains external weak symbols */
	MH_BINDS_TO_WEAK 0x10000    /* the final linked image uses weak symbols */
	MH_ALLOW_STACK_EXECUTION 0x20000/* When this bit is set, all stacks  in the task will be given stack execution privilege.  Only used in MH_EXECUTE filetypes. */
	MH_ROOT_SAFE 0x40000           /* When this bit is set, the binary  declares it is safe for use in processes with uid zero */
	MH_SETUID_SAFE 0x80000         /* When this bit is set, the binary  declares it is safe for use in processes when issetugid() is true */
	MH_NO_REEXPORTED_DYLIBS 0x100000 /* When this bit is set on a dylib, the static linker does not need to examine dependent dylibs to see if any are re-exported */
	MH_PIE 0x200000         /* When this bit is set, the OS will load the main executable at a random address.  Only used in
 MH_EXECUTE filetypes. */
	MH_DEAD_STRIPPABLE_DYLIB 0x400000 /* Only for use on dylibs.  When linking against a dylib that has this bit set, the static linker will automatically not create a
   LC_LOAD_DYLIB load command to the dylib if no symbols are being referenced from the dylib. */
	MH_HAS_TLV_DESCRIPTORS 0x800000 /* Contains a section of type S_THREAD_LOCAL_VARIABLES */
	MH_NO_HEAP_EXECUTION 0x1000000  /* When this bit is set, the OS will run the main executable with a non-executable heap even on platforms (e.g. i386) that don't require it. Only used in MH_EXECUTE filetypes. */
"
	^ 16r2000
]

{ #category : #'as yet unclassified' }
P4MachO >> functionFor: anObject [
	^ symbolTable functionFor: anObject on: currentSection.
]

{ #category : #'as yet unclassified' }
P4MachO >> header [
	currentStream wordPut: self magicIdent.
	currentStream wordPut: self cpuType.
	
	currentStream wordPut: self cpuSubType.
	currentStream wordPut: self filetype.
	
	currentStream wordPut: commands size.
	currentStream wordPut: self sizeOfCommands.
	
	currentStream wordPut: self flags.
	currentStream wordPut: self reserved.
]

{ #category : #'as yet unclassified' }
P4MachO >> headerSize [
	^ 32
]

{ #category : #'as yet unclassified' }
P4MachO >> initialize [
	super initialize.
	commands := OrderedCollection new.
	segments := IdentityDictionary new.
]

{ #category : #'as yet unclassified' }
P4MachO >> initializeCommands [
	symbolTable := P4MOSymbolTable new.
	commands add: symbolTable.
	
	
]

{ #category : #'as yet unclassified' }
P4MachO >> initializeSegments [
	|segment|
	segment := P4MOSegment named: self mainSegmentName.
	segment add: ((P4MOProgramSection named: #'__pinocchio') data: self processor createStream).
	segments at: segment name put: segment.
	commands add: segment.
	
]

{ #category : #'as yet unclassified' }
P4MachO >> magicIdent [
	^ processor machOMagic
]

{ #category : #'as yet unclassified' }
P4MachO >> mainSegmentName [
	^ #'__PINOCCHIO'
]

{ #category : #'as yet unclassified' }
P4MachO >> pack [
	self finalize.
	self header
		commands
		segments
		symbolTable
]

{ #category : #'as yet unclassified' }
P4MachO >> processor: aProcessor [
	super processor: aProcessor.
	self initializeSegments.
	self initializeCommands.
]

{ #category : #'as yet unclassified' }
P4MachO >> readWriteExec [
	currentSection := (segments at: self mainSegmentName) sectionAt: #'__pinocchio'.
	currentStream := currentSection data.
]

{ #category : #'as yet unclassified' }
P4MachO >> reserved [
	^ 0
]

{ #category : #'as yet unclassified' }
P4MachO >> segments [
	segments do: [ :segment|
		segment writeOn: currentStream]
]

{ #category : #'as yet unclassified' }
P4MachO >> sizeOfCommands [
	^ commands inject: 0 into: [ :sum :command| sum + command commandSize]
]

{ #category : #'as yet unclassified' }
P4MachO >> staticLibraryExtension [
	^ '.o'
]

{ #category : #'as yet unclassified' }
P4MachO >> symbolTable [
	symbolTable writeOn: currentStream.
]
