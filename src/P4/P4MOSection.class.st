Class {
	#name : #P4MOSection,
	#superclass : #P4Object,
	#instVars : [
		'name',
		'segment',
		'fileOffset',
		'byteAlignment',
		'relocationTable',
		'index'
	],
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MOSection class >> named: aName [
	^ self new
		name: aName;
		yourself
]

{ #category : #'as yet unclassified' }
P4MOSection >> attributes [
	"
	Constants for the section attributes part of the flags field of a section structure.
	SECTION_ATTRIBUTES_USR	    0xff000000	/* User setable attributes */
			
	S_ATTR_PURE_INSTRUCTIONS   0x80000000	/* section contains only true machine instructions */
	S_ATTR_NO_TOC    	       0x40000000	/* section contains coalesced symbols that are not to be in a ranlib table of contents */
	S_ATTR_STRIP_STATIC_SYMS   0x20000000	/* ok to strip static symbols in this section in files with the MH_DYLDLINK flag */
	S_ATTR_NO_DEAD_STRIP       0x10000000	/* no dead stripping */
	S_ATTR_LIVE_SUPPORT	       0x08000000	/* blocks are live if they reference live blocks */
	S_ATTR_SELF_MODIFYING_CODE 0x04000000	/* Used with i386 code stubs written on by dyld */
		
	If a segment contains any sections marked with S_ATTR_DEBUG then all
	sections in that segment must have this attribute.  No section other than
	a section marked with this attribute may reference the contents of this
	section.  A section with this attribute may contain no symbols and must have
	a section type S_REGULAR.  The static linker will not copy section contents
	from sections with this attribute into its output file.  These sections
	generally contain DWARF debugging info.
	S_ATTR_DEBUG		         0x02000000	/* a debug section */
				
	SECTION_ATTRIBUTES_SYS   0x00ffff00	/* system setable attributes */
	S_ATTR_SOME_INSTRUCTIONS 0x00000400	/* section contains some machine instructions */
	S_ATTR_EXT_RELOC	        0x00000200	/* section has external relocation entries */
	S_ATTR_LOC_RELOC	        0x00000100	/* section has local relocation entries */"
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
P4MOSection >> byteAlignment [
	"section alignment (power of 2)"
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
P4MOSection >> commandSize [
	"sizeof(section_64) = 10 * sizeof(pointer) = 80"
	^ 80
]

{ #category : #accessing }
P4MOSection >> fileOffset [
	^ fileOffset
]

{ #category : #accessing }
P4MOSection >> fileOffset: offset [
	"make sure the offset is properly aligned"
	| alignment |
	alignment := 2 raisedTo: self byteAlignment.
	fileOffset := (offset / alignment) ceiling * alignment.
	^ relocationTable fileOffset: (fileOffset + self fileSize)
]

{ #category : #accessing }
P4MOSection >> fileSize [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
P4MOSection >> flags [
	 "The flags field of a section structure is separated into two parts a section
	 type and section attributes.  The section types are mutually exclusive (it
	 can only have one type) but the section attributes are not (it may have more
	 than one attribute).
	#define SECTION_TYPE		 0x000000ff	/* 256 section types */
	#define SECTION_ATTRIBUTES	 0xffffff00	/*  24 section attributes */"
			
	^ (self type bitAnd: 16r000000ff) bitOr: (self attributes bitAnd: 16rffffff00)
]

{ #category : #'as yet unclassified' }
P4MOSection >> index [
	^ index
]

{ #category : #'as yet unclassified' }
P4MOSection >> index: aNumber [
	index := aNumber
]

{ #category : #'as yet unclassified' }
P4MOSection >> initialize [
	relocationTable := P4MORelocationTable new.
]

{ #category : #'as yet unclassified' }
P4MOSection >> name [
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
	
	SEG_TEXT	__TEXT	/* the tradition UNIX text segment */
	SECT_TEXT	__text	/* the real text part of the text section no headers, and no padding */
	SECT_FVMLIB_INIT0 __fvmlib_init0	/* the fvmlib initialization */
					/*  section */
	SECT_FVMLIB_INIT1 __fvmlib_init1	/* the section following the  fvmlib initialization section */
	SECT_DATA	__data	/* the real initialized data section  no padding, no bss overlap */
	SECT_BSS	__bss		/* the real uninitialized data section no padding */
	SECT_COMMON	__common	/* the section common symbols are allocated in by the link editor */
	SECT_OBJC_SYMBOLS __symbol_table	/* symbol table */
	SECT_OBJC_MODULES __module_info	/* module information */
	SECT_OBJC_STRINGS __selector_strs	/* string table */
	SECT_OBJC_REFS __selector_refs	/* string table */
	SECT_ICON_HEADER __header	/* the icon headers */
	SECT_ICON_TIFF   __tiff	/* the icons in tiff format */
	SEG_UNIXSTACK	__UNIXSTACK	/* the unix stack segment */"
	
	^ name
]

{ #category : #'as yet unclassified' }
P4MOSection >> name: aName [
	name := aName.
]

{ #category : #'as yet unclassified' }
P4MOSection >> numberOfRelocationEntries [ 
	^ relocationTable size
]

{ #category : #'as yet unclassified' }
P4MOSection >> relocationTable [
	^ relocationTable
]

{ #category : #'as yet unclassified' }
P4MOSection >> relocationTableOffset [
	^ relocationTable fileOffset
]

{ #category : #'as yet unclassified' }
P4MOSection >> reserved1 [
	"An integer reserved for use with certain section types. For symbol pointer sections and symbol stubs sections that refer to indirect symbol table entries, this is the index into the indirect table for this section’s entries. The number of entries is based on the section size divided by the size of the symbol pointer or stub. Otherwise, this field is set to 0."
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
P4MOSection >> reserved2 [
	"For sections of type S_SYMBOL_STUBS, an integer specifying the size (in bytes) of the symbol stub entries contained in the section. Otherwise, this field is reserved for future use and should be set to 0."
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
P4MOSection >> reserved3 [
	"only used on 64bit machines"
	^ 0
]

{ #category : #'as yet unclassified' }
P4MOSection >> segment: aSegment [
	segment := aSegment.
]

{ #category : #'as yet unclassified' }
P4MOSection >> type [
    "S_REGULAR            0x00    /* regular section */
    S_ZEROFILL            0x01    /* zero fill on demand section */
    S_CSTRING_LITERALS    0x02    /* section with only literal C strings*/
    S_4BYTE_LITERALS      0x03    /* section with only 4 byte literals */
    S_8BYTE_LITERALS      0x04    /* section with only 8 byte literals */
    S_LITERAL_POINTERS    0x05    /* section with only pointers to */
    
	For the two types of symbol pointers sections and the symbol stubs section
	they have indirect symbol table entries.  For each of the entries in the
	section the indirect symbol table entries, in corresponding order in the
	indirect symbol table, start at the index stored in the reserved1 field
	of the section structure.  Since the indirect symbol table entries
	correspond to the entries in the section the number of indirect symbol table
	entries is inferred from the size of the section divided by the size of the
	entries in the section. For symbol pointers sections the size of the entries
	in the section is 4 bytes and for symbol stubs sections the byte size of the
	stubs is stored in the reserved2 field of the section structure.    
	    
	S_NON_LAZY_SYMBOL_POINTERS    0x06   /* section with only non-lazy symbol pointers */
	S_LAZY_SYMBOL_POINTERS        0x07   /* section with only lazy symbol pointers */
	S_SYMBOL_STUBS                0x08   /* section with only symbol stubs, byte size of stub in the reserved2 field */
	S_MOD_INIT_FUNC_POINTERS      0x09   /* section with only function pointers for initialization*/
	S_MOD_TERM_FUNC_POINTERS      0x0a   /* section with only function pointers for termination */
	S_COALESCED                   0x0b   /* section contains symbols that are to be coalesced */
	S_GB_ZEROFILL                 0x0c   /* zero fill on demand section (that can be larger than 4 gigabytes) */
	S_INTERPOSING                 0x0d   /* section with only pairs of function pointers for interposing */
	S_16BYTE_LITERALS             0x0e   /* section with only 16 byte literals */
	S_DTRACE_DOF                  0x0f   /* section contains DTrace Object Format */
	S_LAZY_DYLIB_SYMBOL_POINTERS  0x10   /* section with only lazy symbol pointers to lazy loaded dylibs */
	        
	Section types to support thread local variables

	S_THREAD_LOCAL_REGULAR                   0x11  /* template of initial values for TLVs */
	S_THREAD_LOCAL_ZEROFILL                  0x12  /* template of initial values for TLVs */
	S_THREAD_LOCAL_VARIABLES                 0x13  /* TLV descriptors */
	S_THREAD_LOCAL_VARIABLE_POINTERS         0x14  /* pointers to TLV descriptors */
	S_THREAD_LOCAL_INIT_FUNCTION_POINTERS    0x15  /* functions to call to initialize TLV values */
    "
    
    self subclassResponsibility 

]

{ #category : #'as yet unclassified' }
P4MOSection >> virtualMemoryAddress [
	^ 16r0
]

{ #category : #'as yet unclassified' }
P4MOSection >> virtualMemorySize [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
P4MOSection >> writeCommandOn: stream [
	stream << ((name truncateTo: 16) padded: #right to: 16 with: 0 asCharacter).
	stream << ((segment name truncateTo: 16) padded: #right to: 16 with: 0 asCharacter).
	stream pointerPut: self virtualMemoryAddress.
	stream pointerPut: self virtualMemorySize.
	stream wordPut: self fileOffset.
	stream wordPut: self byteAlignment.
	stream wordPut: self relocationTableOffset.
	stream wordPut: self numberOfRelocationEntries.
	stream wordPut: self flags.
	stream wordPut: self reserved1.
	stream wordPut: self reserved2.
	stream wordPut: self reserved3.
]

{ #category : #'as yet unclassified' }
P4MOSection >> writeOn: stream [
	stream fillTo: fileOffset with: 16r00.
	relocationTable writeOn: stream
	
]
