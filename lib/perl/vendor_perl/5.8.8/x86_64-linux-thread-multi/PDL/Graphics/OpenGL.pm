
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::Graphics::OpenGL;

@EXPORT_OK  = qw(  
		APIENTRY
		APIENTRYP
		Above
		AllTemporary
		AllocAll
		AllocNone
		AllowExposures
		AlreadyGrabbed
		Always
		AnyButton
		AnyKey
		AnyModifier
		AnyPropertyType
		ArcChord
		ArcPieSlice
		AsyncBoth
		AsyncKeyboard
		AsyncPointer
		AutoRepeatModeDefault
		AutoRepeatModeOff
		AutoRepeatModeOn
		BadAccess
		BadAlloc
		BadAtom
		BadColor
		BadCursor
		BadDrawable
		BadFont
		BadGC
		BadIDChoice
		BadImplementation
		BadLength
		BadMatch
		BadName
		BadPixmap
		BadRequest
		BadValue
		BadWindow
		Below
		BottomIf
		Button1
		Button1Mask
		Button1MotionMask
		Button2
		Button2Mask
		Button2MotionMask
		Button3
		Button3Mask
		Button3MotionMask
		Button4
		Button4Mask
		Button4MotionMask
		Button5
		Button5Mask
		Button5MotionMask
		ButtonMotionMask
		ButtonPress
		ButtonPressMask
		ButtonRelease
		ButtonReleaseMask
		CWBackPixel
		CWBackPixmap
		CWBackingPixel
		CWBackingPlanes
		CWBackingStore
		CWBitGravity
		CWBorderPixel
		CWBorderPixmap
		CWBorderWidth
		CWColormap
		CWCursor
		CWDontPropagate
		CWEventMask
		CWHeight
		CWOverrideRedirect
		CWSaveUnder
		CWSibling
		CWStackMode
		CWWidth
		CWWinGravity
		CWX
		CWY
		CapButt
		CapNotLast
		CapProjecting
		CapRound
		CenterGravity
		CirculateNotify
		CirculateRequest
		ClientMessage
		ClipByChildren
		ColormapChangeMask
		ColormapInstalled
		ColormapNotify
		ColormapUninstalled
		Complex
		ConfigureNotify
		ConfigureRequest
		ControlMapIndex
		ControlMask
		Convex
		CoordModeOrigin
		CoordModePrevious
		CopyFromParent
		CreateNotify
		CurrentTime
		CursorShape
		DefaultBlanking
		DefaultExposures
		DestroyAll
		DestroyNotify
		DirectColor
		DisableAccess
		DisableScreenInterval
		DisableScreenSaver
		DoBlue
		DoGreen
		DoRed
		DontAllowExposures
		DontPreferBlanking
		EastGravity
		EnableAccess
		EnterNotify
		EnterWindowMask
		EvenOddRule
		Expose
		ExposureMask
		FamilyChaos
		FamilyDECnet
		FamilyInternet
		FamilyInternet6
		FamilyServerInterpreted
		FillOpaqueStippled
		FillSolid
		FillStippled
		FillTiled
		FirstExtensionError
		FocusChangeMask
		FocusIn
		FocusOut
		FontChange
		FontLeftToRight
		FontRightToLeft
		ForgetGravity
		GCArcMode
		GCBackground
		GCCapStyle
		GCClipMask
		GCClipXOrigin
		GCClipYOrigin
		GCDashList
		GCDashOffset
		GCFillRule
		GCFillStyle
		GCFont
		GCForeground
		GCFunction
		GCGraphicsExposures
		GCJoinStyle
		GCLastBit
		GCLineStyle
		GCLineWidth
		GCPlaneMask
		GCStipple
		GCSubwindowMode
		GCTile
		GCTileStipXOrigin
		GCTileStipYOrigin
		GLAPI
		GLAPIENTRYP
		GLU_AUTO_LOAD_MATRIX
		GLU_BEGIN
		GLU_CCW
		GLU_CULLING
		GLU_CW
		GLU_DISPLAY_MODE
		GLU_DOMAIN_DISTANCE
		GLU_EDGE_FLAG
		GLU_END
		GLU_ERROR
		GLU_EXTENSIONS
		GLU_EXTERIOR
		GLU_EXT_nurbs_tessellator
		GLU_EXT_object_space_tess
		GLU_FALSE
		GLU_FILL
		GLU_FLAT
		GLU_INCOMPATIBLE_GL_VERSION
		GLU_INSIDE
		GLU_INTERIOR
		GLU_INVALID_ENUM
		GLU_INVALID_OPERATION
		GLU_INVALID_VALUE
		GLU_LINE
		GLU_MAP1_TRIM_2
		GLU_MAP1_TRIM_3
		GLU_NONE
		GLU_NURBS_BEGIN
		GLU_NURBS_BEGIN_DATA
		GLU_NURBS_BEGIN_DATA_EXT
		GLU_NURBS_BEGIN_EXT
		GLU_NURBS_COLOR
		GLU_NURBS_COLOR_DATA
		GLU_NURBS_COLOR_DATA_EXT
		GLU_NURBS_COLOR_EXT
		GLU_NURBS_END
		GLU_NURBS_END_DATA
		GLU_NURBS_END_DATA_EXT
		GLU_NURBS_END_EXT
		GLU_NURBS_ERROR
		GLU_NURBS_ERROR1
		GLU_NURBS_ERROR10
		GLU_NURBS_ERROR11
		GLU_NURBS_ERROR12
		GLU_NURBS_ERROR13
		GLU_NURBS_ERROR14
		GLU_NURBS_ERROR15
		GLU_NURBS_ERROR16
		GLU_NURBS_ERROR17
		GLU_NURBS_ERROR18
		GLU_NURBS_ERROR19
		GLU_NURBS_ERROR2
		GLU_NURBS_ERROR20
		GLU_NURBS_ERROR21
		GLU_NURBS_ERROR22
		GLU_NURBS_ERROR23
		GLU_NURBS_ERROR24
		GLU_NURBS_ERROR25
		GLU_NURBS_ERROR26
		GLU_NURBS_ERROR27
		GLU_NURBS_ERROR28
		GLU_NURBS_ERROR29
		GLU_NURBS_ERROR3
		GLU_NURBS_ERROR30
		GLU_NURBS_ERROR31
		GLU_NURBS_ERROR32
		GLU_NURBS_ERROR33
		GLU_NURBS_ERROR34
		GLU_NURBS_ERROR35
		GLU_NURBS_ERROR36
		GLU_NURBS_ERROR37
		GLU_NURBS_ERROR4
		GLU_NURBS_ERROR5
		GLU_NURBS_ERROR6
		GLU_NURBS_ERROR7
		GLU_NURBS_ERROR8
		GLU_NURBS_ERROR9
		GLU_NURBS_MODE
		GLU_NURBS_MODE_EXT
		GLU_NURBS_NORMAL
		GLU_NURBS_NORMAL_DATA
		GLU_NURBS_NORMAL_DATA_EXT
		GLU_NURBS_NORMAL_EXT
		GLU_NURBS_RENDERER
		GLU_NURBS_RENDERER_EXT
		GLU_NURBS_TESSELLATOR
		GLU_NURBS_TESSELLATOR_EXT
		GLU_NURBS_TEXTURE_COORD
		GLU_NURBS_TEXTURE_COORD_DATA
		GLU_NURBS_TEX_COORD_DATA_EXT
		GLU_NURBS_TEX_COORD_EXT
		GLU_NURBS_VERTEX
		GLU_NURBS_VERTEX_DATA
		GLU_NURBS_VERTEX_DATA_EXT
		GLU_NURBS_VERTEX_EXT
		GLU_OBJECT_PARAMETRIC_ERROR
		GLU_OBJECT_PARAMETRIC_ERROR_EXT
		GLU_OBJECT_PATH_LENGTH
		GLU_OBJECT_PATH_LENGTH_EXT
		GLU_OUTLINE_PATCH
		GLU_OUTLINE_POLYGON
		GLU_OUTSIDE
		GLU_OUT_OF_MEMORY
		GLU_PARAMETRIC_ERROR
		GLU_PARAMETRIC_TOLERANCE
		GLU_PATH_LENGTH
		GLU_POINT
		GLU_SAMPLING_METHOD
		GLU_SAMPLING_TOLERANCE
		GLU_SILHOUETTE
		GLU_SMOOTH
		GLU_TESS_BEGIN
		GLU_TESS_BEGIN_DATA
		GLU_TESS_BOUNDARY_ONLY
		GLU_TESS_COMBINE
		GLU_TESS_COMBINE_DATA
		GLU_TESS_COORD_TOO_LARGE
		GLU_TESS_EDGE_FLAG
		GLU_TESS_EDGE_FLAG_DATA
		GLU_TESS_END
		GLU_TESS_END_DATA
		GLU_TESS_ERROR
		GLU_TESS_ERROR1
		GLU_TESS_ERROR2
		GLU_TESS_ERROR3
		GLU_TESS_ERROR4
		GLU_TESS_ERROR5
		GLU_TESS_ERROR6
		GLU_TESS_ERROR7
		GLU_TESS_ERROR8
		GLU_TESS_ERROR_DATA
		GLU_TESS_MAX_COORD
		GLU_TESS_MISSING_BEGIN_CONTOUR
		GLU_TESS_MISSING_BEGIN_POLYGON
		GLU_TESS_MISSING_END_CONTOUR
		GLU_TESS_MISSING_END_POLYGON
		GLU_TESS_NEED_COMBINE_CALLBACK
		GLU_TESS_TOLERANCE
		GLU_TESS_VERTEX
		GLU_TESS_VERTEX_DATA
		GLU_TESS_WINDING_ABS_GEQ_TWO
		GLU_TESS_WINDING_NEGATIVE
		GLU_TESS_WINDING_NONZERO
		GLU_TESS_WINDING_ODD
		GLU_TESS_WINDING_POSITIVE
		GLU_TESS_WINDING_RULE
		GLU_TRUE
		GLU_UNKNOWN
		GLU_U_STEP
		GLU_VERSION
		GLU_VERSION_1_1
		GLU_VERSION_1_2
		GLU_VERSION_1_3
		GLU_VERTEX
		GLU_V_STEP
		GLX_ACCUM_ALPHA_SIZE
		GLX_ACCUM_BLUE_SIZE
		GLX_ACCUM_BUFFER_BIT
		GLX_ACCUM_GREEN_SIZE
		GLX_ACCUM_RED_SIZE
		GLX_ALPHA_SIZE
		GLX_ARB_get_proc_address
		GLX_ARB_render_texture
		GLX_AUX0_EXT
		GLX_AUX1_EXT
		GLX_AUX2_EXT
		GLX_AUX3_EXT
		GLX_AUX4_EXT
		GLX_AUX5_EXT
		GLX_AUX6_EXT
		GLX_AUX7_EXT
		GLX_AUX8_EXT
		GLX_AUX9_EXT
		GLX_AUX_BUFFERS
		GLX_AUX_BUFFERS_BIT
		GLX_BACK_EXT
		GLX_BACK_LEFT_BUFFER_BIT
		GLX_BACK_LEFT_EXT
		GLX_BACK_RIGHT_BUFFER_BIT
		GLX_BACK_RIGHT_EXT
		GLX_BAD_ATTRIBUTE
		GLX_BAD_CONTEXT
		GLX_BAD_ENUM
		GLX_BAD_SCREEN
		GLX_BAD_VALUE
		GLX_BAD_VISUAL
		GLX_BIND_TO_MIPMAP_TEXTURE_EXT
		GLX_BIND_TO_TEXTURE_RGBA_EXT
		GLX_BIND_TO_TEXTURE_RGB_EXT
		GLX_BIND_TO_TEXTURE_TARGETS_EXT
		GLX_BLUE_SIZE
		GLX_BUFFER_SIZE
		GLX_COLOR_INDEX_BIT
		GLX_COLOR_INDEX_TYPE
		GLX_CONFIG_CAVEAT
		GLX_DAMAGED
		GLX_DEPTH_BUFFER_BIT
		GLX_DEPTH_SIZE
		GLX_DIRECT_COLOR
		GLX_DIRECT_COLOR_EXT
		GLX_DONT_CARE
		GLX_DOUBLEBUFFER
		GLX_DRAWABLE_TYPE
		GLX_EVENT_MASK
		GLX_EXTENSIONS
		GLX_EXTENSION_NAME
		GLX_EXT_texture_from_pixmap
		GLX_FBCONFIG_ID
		GLX_FLOAT_COMPONENTS_NV
		GLX_FRONT_EXT
		GLX_FRONT_LEFT_BUFFER_BIT
		GLX_FRONT_LEFT_EXT
		GLX_FRONT_RIGHT_BUFFER_BIT
		GLX_FRONT_RIGHT_EXT
		GLX_GRAY_SCALE
		GLX_GRAY_SCALE_EXT
		GLX_GREEN_SIZE
		GLX_HEIGHT
		GLX_LARGEST_PBUFFER
		GLX_LEVEL
		GLX_MAX_PBUFFER_HEIGHT
		GLX_MAX_PBUFFER_PIXELS
		GLX_MAX_PBUFFER_WIDTH
		GLX_MESA_allocate_memory
		GLX_MESA_swap_control
		GLX_MESA_swap_frame_usage
		GLX_MIPMAP_TEXTURE_EXT
		GLX_NONE
		GLX_NONE_EXT
		GLX_NON_CONFORMANT_CONFIG
		GLX_NON_CONFORMANT_VISUAL_EXT
		GLX_NO_EXTENSION
		GLX_NV_float_buffer
		GLX_OPTIMAL_PBUFFER_HEIGHT_SGIX
		GLX_OPTIMAL_PBUFFER_WIDTH_SGIX
		GLX_PBUFFER
		GLX_PBUFFER_BIT
		GLX_PBUFFER_CLOBBER_MASK
		GLX_PBUFFER_HEIGHT
		GLX_PBUFFER_WIDTH
		GLX_PIXMAP_BIT
		GLX_PRESERVED_CONTENTS
		GLX_PSEUDO_COLOR
		GLX_PSEUDO_COLOR_EXT
		GLX_RED_SIZE
		GLX_RENDER_TYPE
		GLX_RGBA
		GLX_RGBA_BIT
		GLX_RGBA_TYPE
		GLX_SAMPLES
		GLX_SAMPLES_SGIS
		GLX_SAMPLE_BUFFERS
		GLX_SAMPLE_BUFFERS_SGIS
		GLX_SAVED
		GLX_SCREEN
		GLX_SCREEN_EXT
		GLX_SHARE_CONTEXT_EXT
		GLX_SLOW_CONFIG
		GLX_SLOW_VISUAL_EXT
		GLX_STATIC_COLOR
		GLX_STATIC_COLOR_EXT
		GLX_STATIC_GRAY
		GLX_STATIC_GRAY_EXT
		GLX_STENCIL_BUFFER_BIT
		GLX_STENCIL_SIZE
		GLX_STEREO
		GLX_SWAP_COPY_OML
		GLX_SWAP_EXCHANGE_OML
		GLX_SWAP_METHOD_OML
		GLX_SWAP_UNDEFINED_OML
		GLX_TEXTURE_1D_BIT_EXT
		GLX_TEXTURE_1D_EXT
		GLX_TEXTURE_2D_BIT_EXT
		GLX_TEXTURE_2D_EXT
		GLX_TEXTURE_FORMAT_EXT
		GLX_TEXTURE_FORMAT_NONE_EXT
		GLX_TEXTURE_FORMAT_RGBA_EXT
		GLX_TEXTURE_FORMAT_RGB_EXT
		GLX_TEXTURE_RECTANGLE_BIT_EXT
		GLX_TEXTURE_RECTANGLE_EXT
		GLX_TEXTURE_TARGET_EXT
		GLX_TRANSPARENT_ALPHA_VALUE
		GLX_TRANSPARENT_ALPHA_VALUE_EXT
		GLX_TRANSPARENT_BLUE_VALUE
		GLX_TRANSPARENT_BLUE_VALUE_EXT
		GLX_TRANSPARENT_GREEN_VALUE
		GLX_TRANSPARENT_GREEN_VALUE_EXT
		GLX_TRANSPARENT_INDEX
		GLX_TRANSPARENT_INDEX_EXT
		GLX_TRANSPARENT_INDEX_VALUE
		GLX_TRANSPARENT_INDEX_VALUE_EXT
		GLX_TRANSPARENT_RED_VALUE
		GLX_TRANSPARENT_RED_VALUE_EXT
		GLX_TRANSPARENT_RGB
		GLX_TRANSPARENT_RGB_EXT
		GLX_TRANSPARENT_TYPE
		GLX_TRANSPARENT_TYPE_EXT
		GLX_TRUE_COLOR
		GLX_TRUE_COLOR_EXT
		GLX_USE_GL
		GLX_VENDOR
		GLX_VERSION
		GLX_VERSION_1_1
		GLX_VERSION_1_2
		GLX_VERSION_1_3
		GLX_VERSION_1_4
		GLX_VISUAL_CAVEAT_EXT
		GLX_VISUAL_ID
		GLX_VISUAL_ID_EXT
		GLX_VISUAL_SELECT_GROUP_SGIX
		GLX_WIDTH
		GLX_WINDOW
		GLX_WINDOW_BIT
		GLX_X_RENDERABLE
		GLX_X_VISUAL_TYPE
		GLX_X_VISUAL_TYPE_EXT
		GLX_Y_INVERTED_EXT
		GL_2D
		GL_2_BYTES
		GL_3D
		GL_3D_COLOR
		GL_3D_COLOR_TEXTURE
		GL_3_BYTES
		GL_4D_COLOR_TEXTURE
		GL_4_BYTES
		GL_ACCUM
		GL_ACCUM_ALPHA_BITS
		GL_ACCUM_BLUE_BITS
		GL_ACCUM_BUFFER_BIT
		GL_ACCUM_CLEAR_VALUE
		GL_ACCUM_GREEN_BITS
		GL_ACCUM_RED_BITS
		GL_ACTIVE_TEXTURE
		GL_ACTIVE_TEXTURE_ARB
		GL_ADD
		GL_ADD_SIGNED
		GL_ALIASED_LINE_WIDTH_RANGE
		GL_ALIASED_POINT_SIZE_RANGE
		GL_ALL_ATTRIB_BITS
		GL_ALL_CLIENT_ATTRIB_BITS
		GL_ALPHA
		GL_ALPHA12
		GL_ALPHA16
		GL_ALPHA4
		GL_ALPHA8
		GL_ALPHA_BIAS
		GL_ALPHA_BITS
		GL_ALPHA_BLEND_EQUATION_ATI
		GL_ALPHA_SCALE
		GL_ALPHA_TEST
		GL_ALPHA_TEST_FUNC
		GL_ALPHA_TEST_REF
		GL_ALWAYS
		GL_AMBIENT
		GL_AMBIENT_AND_DIFFUSE
		GL_AND
		GL_AND_INVERTED
		GL_AND_REVERSE
		GL_ARB_imaging
		GL_ARB_multitexture
		GL_ATI_blend_equation_separate
		GL_ATTRIB_STACK_DEPTH
		GL_AUTO_NORMAL
		GL_AUX0
		GL_AUX1
		GL_AUX2
		GL_AUX3
		GL_AUX_BUFFERS
		GL_BACK
		GL_BACK_LEFT
		GL_BACK_RIGHT
		GL_BGR
		GL_BGRA
		GL_BITMAP
		GL_BITMAP_TOKEN
		GL_BLEND
		GL_BLEND_COLOR
		GL_BLEND_DST
		GL_BLEND_EQUATION
		GL_BLEND_SRC
		GL_BLUE
		GL_BLUE_BIAS
		GL_BLUE_BITS
		GL_BLUE_SCALE
		GL_BYTE
		GL_C3F_V3F
		GL_C4F_N3F_V3F
		GL_C4UB_V2F
		GL_C4UB_V3F
		GL_CCW
		GL_CLAMP
		GL_CLAMP_TO_BORDER
		GL_CLAMP_TO_EDGE
		GL_CLEAR
		GL_CLIENT_ACTIVE_TEXTURE
		GL_CLIENT_ACTIVE_TEXTURE_ARB
		GL_CLIENT_ALL_ATTRIB_BITS
		GL_CLIENT_ATTRIB_STACK_DEPTH
		GL_CLIENT_PIXEL_STORE_BIT
		GL_CLIENT_VERTEX_ARRAY_BIT
		GL_CLIP_PLANE0
		GL_CLIP_PLANE1
		GL_CLIP_PLANE2
		GL_CLIP_PLANE3
		GL_CLIP_PLANE4
		GL_CLIP_PLANE5
		GL_COEFF
		GL_COLOR
		GL_COLOR_ARRAY
		GL_COLOR_ARRAY_POINTER
		GL_COLOR_ARRAY_SIZE
		GL_COLOR_ARRAY_STRIDE
		GL_COLOR_ARRAY_TYPE
		GL_COLOR_BUFFER_BIT
		GL_COLOR_CLEAR_VALUE
		GL_COLOR_INDEX
		GL_COLOR_INDEXES
		GL_COLOR_LOGIC_OP
		GL_COLOR_MATERIAL
		GL_COLOR_MATERIAL_FACE
		GL_COLOR_MATERIAL_PARAMETER
		GL_COLOR_MATRIX
		GL_COLOR_MATRIX_STACK_DEPTH
		GL_COLOR_TABLE
		GL_COLOR_TABLE_ALPHA_SIZE
		GL_COLOR_TABLE_BIAS
		GL_COLOR_TABLE_BLUE_SIZE
		GL_COLOR_TABLE_FORMAT
		GL_COLOR_TABLE_GREEN_SIZE
		GL_COLOR_TABLE_INTENSITY_SIZE
		GL_COLOR_TABLE_LUMINANCE_SIZE
		GL_COLOR_TABLE_RED_SIZE
		GL_COLOR_TABLE_SCALE
		GL_COLOR_TABLE_WIDTH
		GL_COLOR_WRITEMASK
		GL_COMBINE
		GL_COMBINE_ALPHA
		GL_COMBINE_RGB
		GL_COMPILE
		GL_COMPILE_AND_EXECUTE
		GL_COMPRESSED_ALPHA
		GL_COMPRESSED_INTENSITY
		GL_COMPRESSED_LUMINANCE
		GL_COMPRESSED_LUMINANCE_ALPHA
		GL_COMPRESSED_RGB
		GL_COMPRESSED_RGBA
		GL_COMPRESSED_TEXTURE_FORMATS
		GL_CONSTANT
		GL_CONSTANT_ALPHA
		GL_CONSTANT_ATTENUATION
		GL_CONSTANT_BORDER
		GL_CONSTANT_COLOR
		GL_CONVOLUTION_1D
		GL_CONVOLUTION_2D
		GL_CONVOLUTION_BORDER_COLOR
		GL_CONVOLUTION_BORDER_MODE
		GL_CONVOLUTION_FILTER_BIAS
		GL_CONVOLUTION_FILTER_SCALE
		GL_CONVOLUTION_FORMAT
		GL_CONVOLUTION_HEIGHT
		GL_CONVOLUTION_WIDTH
		GL_COPY
		GL_COPY_INVERTED
		GL_COPY_PIXEL_TOKEN
		GL_CULL_FACE
		GL_CULL_FACE_MODE
		GL_CURRENT_BIT
		GL_CURRENT_COLOR
		GL_CURRENT_INDEX
		GL_CURRENT_NORMAL
		GL_CURRENT_RASTER_COLOR
		GL_CURRENT_RASTER_DISTANCE
		GL_CURRENT_RASTER_INDEX
		GL_CURRENT_RASTER_POSITION
		GL_CURRENT_RASTER_POSITION_VALID
		GL_CURRENT_RASTER_TEXTURE_COORDS
		GL_CURRENT_TEXTURE_COORDS
		GL_CW
		GL_DEBUG_ASSERT_MESA
		GL_DEBUG_OBJECT_MESA
		GL_DEBUG_PRINT_MESA
		GL_DECAL
		GL_DECR
		GL_DEPTH
		GL_DEPTH_BIAS
		GL_DEPTH_BITS
		GL_DEPTH_BUFFER_BIT
		GL_DEPTH_CLEAR_VALUE
		GL_DEPTH_COMPONENT
		GL_DEPTH_FUNC
		GL_DEPTH_RANGE
		GL_DEPTH_SCALE
		GL_DEPTH_STENCIL_MESA
		GL_DEPTH_TEST
		GL_DEPTH_WRITEMASK
		GL_DIFFUSE
		GL_DITHER
		GL_DOMAIN
		GL_DONT_CARE
		GL_DOT3_RGB
		GL_DOT3_RGBA
		GL_DOUBLE
		GL_DOUBLEBUFFER
		GL_DRAW_BUFFER
		GL_DRAW_PIXEL_TOKEN
		GL_DST_ALPHA
		GL_DST_COLOR
		GL_EDGE_FLAG
		GL_EDGE_FLAG_ARRAY
		GL_EDGE_FLAG_ARRAY_POINTER
		GL_EDGE_FLAG_ARRAY_STRIDE
		GL_EMISSION
		GL_ENABLE_BIT
		GL_EQUAL
		GL_EQUIV
		GL_EVAL_BIT
		GL_EXP
		GL_EXP2
		GL_EXTENSIONS
		GL_EYE_LINEAR
		GL_EYE_PLANE
		GL_FALSE
		GL_FASTEST
		GL_FEEDBACK
		GL_FEEDBACK_BUFFER_POINTER
		GL_FEEDBACK_BUFFER_SIZE
		GL_FEEDBACK_BUFFER_TYPE
		GL_FILL
		GL_FLAT
		GL_FLOAT
		GL_FOG
		GL_FOG_BIT
		GL_FOG_COLOR
		GL_FOG_DENSITY
		GL_FOG_END
		GL_FOG_HINT
		GL_FOG_INDEX
		GL_FOG_MODE
		GL_FOG_START
		GL_FRAGMENT_PROGRAM_CALLBACK_DATA_MESA
		GL_FRAGMENT_PROGRAM_CALLBACK_FUNC_MESA
		GL_FRAGMENT_PROGRAM_CALLBACK_MESA
		GL_FRAGMENT_PROGRAM_POSITION_MESA
		GL_FRONT
		GL_FRONT_AND_BACK
		GL_FRONT_FACE
		GL_FRONT_LEFT
		GL_FRONT_RIGHT
		GL_FUNC_ADD
		GL_FUNC_REVERSE_SUBTRACT
		GL_FUNC_SUBTRACT
		GL_GEQUAL
		GL_GREATER
		GL_GREEN
		GL_GREEN_BIAS
		GL_GREEN_BITS
		GL_GREEN_SCALE
		GL_HINT_BIT
		GL_HISTOGRAM
		GL_HISTOGRAM_ALPHA_SIZE
		GL_HISTOGRAM_BLUE_SIZE
		GL_HISTOGRAM_FORMAT
		GL_HISTOGRAM_GREEN_SIZE
		GL_HISTOGRAM_LUMINANCE_SIZE
		GL_HISTOGRAM_RED_SIZE
		GL_HISTOGRAM_SINK
		GL_HISTOGRAM_WIDTH
		GL_INCR
		GL_INDEX_ARRAY
		GL_INDEX_ARRAY_POINTER
		GL_INDEX_ARRAY_STRIDE
		GL_INDEX_ARRAY_TYPE
		GL_INDEX_BITS
		GL_INDEX_CLEAR_VALUE
		GL_INDEX_LOGIC_OP
		GL_INDEX_MODE
		GL_INDEX_OFFSET
		GL_INDEX_SHIFT
		GL_INDEX_WRITEMASK
		GL_INT
		GL_INTENSITY
		GL_INTENSITY12
		GL_INTENSITY16
		GL_INTENSITY4
		GL_INTENSITY8
		GL_INTERPOLATE
		GL_INVALID_ENUM
		GL_INVALID_OPERATION
		GL_INVALID_VALUE
		GL_INVERT
		GL_KEEP
		GL_LEFT
		GL_LEQUAL
		GL_LESS
		GL_LIGHT0
		GL_LIGHT1
		GL_LIGHT2
		GL_LIGHT3
		GL_LIGHT4
		GL_LIGHT5
		GL_LIGHT6
		GL_LIGHT7
		GL_LIGHTING
		GL_LIGHTING_BIT
		GL_LIGHT_MODEL_AMBIENT
		GL_LIGHT_MODEL_COLOR_CONTROL
		GL_LIGHT_MODEL_LOCAL_VIEWER
		GL_LIGHT_MODEL_TWO_SIDE
		GL_LINE
		GL_LINEAR
		GL_LINEAR_ATTENUATION
		GL_LINEAR_MIPMAP_LINEAR
		GL_LINEAR_MIPMAP_NEAREST
		GL_LINES
		GL_LINE_BIT
		GL_LINE_LOOP
		GL_LINE_RESET_TOKEN
		GL_LINE_SMOOTH
		GL_LINE_SMOOTH_HINT
		GL_LINE_STIPPLE
		GL_LINE_STIPPLE_PATTERN
		GL_LINE_STIPPLE_REPEAT
		GL_LINE_STRIP
		GL_LINE_TOKEN
		GL_LINE_WIDTH
		GL_LINE_WIDTH_GRANULARITY
		GL_LINE_WIDTH_RANGE
		GL_LIST_BASE
		GL_LIST_BIT
		GL_LIST_INDEX
		GL_LIST_MODE
		GL_LOAD
		GL_LOGIC_OP
		GL_LOGIC_OP_MODE
		GL_LUMINANCE
		GL_LUMINANCE12
		GL_LUMINANCE12_ALPHA12
		GL_LUMINANCE12_ALPHA4
		GL_LUMINANCE16
		GL_LUMINANCE16_ALPHA16
		GL_LUMINANCE4
		GL_LUMINANCE4_ALPHA4
		GL_LUMINANCE6_ALPHA2
		GL_LUMINANCE8
		GL_LUMINANCE8_ALPHA8
		GL_LUMINANCE_ALPHA
		GL_MAP1_COLOR_4
		GL_MAP1_GRID_DOMAIN
		GL_MAP1_GRID_SEGMENTS
		GL_MAP1_INDEX
		GL_MAP1_NORMAL
		GL_MAP1_TEXTURE_COORD_1
		GL_MAP1_TEXTURE_COORD_2
		GL_MAP1_TEXTURE_COORD_3
		GL_MAP1_TEXTURE_COORD_4
		GL_MAP1_VERTEX_3
		GL_MAP1_VERTEX_4
		GL_MAP2_COLOR_4
		GL_MAP2_GRID_DOMAIN
		GL_MAP2_GRID_SEGMENTS
		GL_MAP2_INDEX
		GL_MAP2_NORMAL
		GL_MAP2_TEXTURE_COORD_1
		GL_MAP2_TEXTURE_COORD_2
		GL_MAP2_TEXTURE_COORD_3
		GL_MAP2_TEXTURE_COORD_4
		GL_MAP2_VERTEX_3
		GL_MAP2_VERTEX_4
		GL_MAP_COLOR
		GL_MAP_STENCIL
		GL_MATRIX_MODE
		GL_MAX
		GL_MAX_3D_TEXTURE_SIZE
		GL_MAX_ATTRIB_STACK_DEPTH
		GL_MAX_CLIENT_ATTRIB_STACK_DEPTH
		GL_MAX_CLIP_PLANES
		GL_MAX_COLOR_MATRIX_STACK_DEPTH
		GL_MAX_CONVOLUTION_HEIGHT
		GL_MAX_CONVOLUTION_WIDTH
		GL_MAX_CUBE_MAP_TEXTURE_SIZE
		GL_MAX_ELEMENTS_INDICES
		GL_MAX_ELEMENTS_VERTICES
		GL_MAX_EVAL_ORDER
		GL_MAX_LIGHTS
		GL_MAX_LIST_NESTING
		GL_MAX_MODELVIEW_STACK_DEPTH
		GL_MAX_NAME_STACK_DEPTH
		GL_MAX_PIXEL_MAP_TABLE
		GL_MAX_PROJECTION_STACK_DEPTH
		GL_MAX_TEXTURE_SIZE
		GL_MAX_TEXTURE_STACK_DEPTH
		GL_MAX_TEXTURE_UNITS
		GL_MAX_TEXTURE_UNITS_ARB
		GL_MAX_VIEWPORT_DIMS
		GL_MESA_packed_depth_stencil
		GL_MESA_program_debug
		GL_MESA_shader_debug
		GL_MESA_trace
		GL_MIN
		GL_MINMAX
		GL_MINMAX_FORMAT
		GL_MINMAX_SINK
		GL_MODELVIEW
		GL_MODELVIEW_MATRIX
		GL_MODELVIEW_STACK_DEPTH
		GL_MODULATE
		GL_MULT
		GL_MULTISAMPLE
		GL_MULTISAMPLE_BIT
		GL_N3F_V3F
		GL_NAME_STACK_DEPTH
		GL_NAND
		GL_NEAREST
		GL_NEAREST_MIPMAP_LINEAR
		GL_NEAREST_MIPMAP_NEAREST
		GL_NEVER
		GL_NICEST
		GL_NONE
		GL_NOOP
		GL_NOR
		GL_NORMALIZE
		GL_NORMAL_ARRAY
		GL_NORMAL_ARRAY_POINTER
		GL_NORMAL_ARRAY_STRIDE
		GL_NORMAL_ARRAY_TYPE
		GL_NORMAL_MAP
		GL_NOTEQUAL
		GL_NO_ERROR
		GL_NUM_COMPRESSED_TEXTURE_FORMATS
		GL_OBJECT_LINEAR
		GL_OBJECT_PLANE
		GL_ONE
		GL_ONE_MINUS_CONSTANT_ALPHA
		GL_ONE_MINUS_CONSTANT_COLOR
		GL_ONE_MINUS_DST_ALPHA
		GL_ONE_MINUS_DST_COLOR
		GL_ONE_MINUS_SRC_ALPHA
		GL_ONE_MINUS_SRC_COLOR
		GL_OPERAND0_ALPHA
		GL_OPERAND0_RGB
		GL_OPERAND1_ALPHA
		GL_OPERAND1_RGB
		GL_OPERAND2_ALPHA
		GL_OPERAND2_RGB
		GL_OR
		GL_ORDER
		GL_OR_INVERTED
		GL_OR_REVERSE
		GL_OUT_OF_MEMORY
		GL_PACK_ALIGNMENT
		GL_PACK_IMAGE_HEIGHT
		GL_PACK_LSB_FIRST
		GL_PACK_ROW_LENGTH
		GL_PACK_SKIP_IMAGES
		GL_PACK_SKIP_PIXELS
		GL_PACK_SKIP_ROWS
		GL_PACK_SWAP_BYTES
		GL_PASS_THROUGH_TOKEN
		GL_PERSPECTIVE_CORRECTION_HINT
		GL_PIXEL_MAP_A_TO_A
		GL_PIXEL_MAP_A_TO_A_SIZE
		GL_PIXEL_MAP_B_TO_B
		GL_PIXEL_MAP_B_TO_B_SIZE
		GL_PIXEL_MAP_G_TO_G
		GL_PIXEL_MAP_G_TO_G_SIZE
		GL_PIXEL_MAP_I_TO_A
		GL_PIXEL_MAP_I_TO_A_SIZE
		GL_PIXEL_MAP_I_TO_B
		GL_PIXEL_MAP_I_TO_B_SIZE
		GL_PIXEL_MAP_I_TO_G
		GL_PIXEL_MAP_I_TO_G_SIZE
		GL_PIXEL_MAP_I_TO_I
		GL_PIXEL_MAP_I_TO_I_SIZE
		GL_PIXEL_MAP_I_TO_R
		GL_PIXEL_MAP_I_TO_R_SIZE
		GL_PIXEL_MAP_R_TO_R
		GL_PIXEL_MAP_R_TO_R_SIZE
		GL_PIXEL_MAP_S_TO_S
		GL_PIXEL_MAP_S_TO_S_SIZE
		GL_PIXEL_MODE_BIT
		GL_POINT
		GL_POINTS
		GL_POINT_BIT
		GL_POINT_SIZE
		GL_POINT_SIZE_GRANULARITY
		GL_POINT_SIZE_RANGE
		GL_POINT_SMOOTH
		GL_POINT_SMOOTH_HINT
		GL_POINT_TOKEN
		GL_POLYGON
		GL_POLYGON_BIT
		GL_POLYGON_MODE
		GL_POLYGON_OFFSET_FACTOR
		GL_POLYGON_OFFSET_FILL
		GL_POLYGON_OFFSET_LINE
		GL_POLYGON_OFFSET_POINT
		GL_POLYGON_OFFSET_UNITS
		GL_POLYGON_SMOOTH
		GL_POLYGON_SMOOTH_HINT
		GL_POLYGON_STIPPLE
		GL_POLYGON_STIPPLE_BIT
		GL_POLYGON_TOKEN
		GL_POSITION
		GL_POST_COLOR_MATRIX_ALPHA_BIAS
		GL_POST_COLOR_MATRIX_ALPHA_SCALE
		GL_POST_COLOR_MATRIX_BLUE_BIAS
		GL_POST_COLOR_MATRIX_BLUE_SCALE
		GL_POST_COLOR_MATRIX_COLOR_TABLE
		GL_POST_COLOR_MATRIX_GREEN_BIAS
		GL_POST_COLOR_MATRIX_GREEN_SCALE
		GL_POST_COLOR_MATRIX_RED_BIAS
		GL_POST_COLOR_MATRIX_RED_SCALE
		GL_POST_CONVOLUTION_ALPHA_BIAS
		GL_POST_CONVOLUTION_ALPHA_SCALE
		GL_POST_CONVOLUTION_BLUE_BIAS
		GL_POST_CONVOLUTION_BLUE_SCALE
		GL_POST_CONVOLUTION_COLOR_TABLE
		GL_POST_CONVOLUTION_GREEN_BIAS
		GL_POST_CONVOLUTION_GREEN_SCALE
		GL_POST_CONVOLUTION_RED_BIAS
		GL_POST_CONVOLUTION_RED_SCALE
		GL_PREVIOUS
		GL_PRIMARY_COLOR
		GL_PROJECTION
		GL_PROJECTION_MATRIX
		GL_PROJECTION_STACK_DEPTH
		GL_PROXY_COLOR_TABLE
		GL_PROXY_HISTOGRAM
		GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE
		GL_PROXY_POST_CONVOLUTION_COLOR_TABLE
		GL_PROXY_TEXTURE_1D
		GL_PROXY_TEXTURE_2D
		GL_PROXY_TEXTURE_3D
		GL_PROXY_TEXTURE_CUBE_MAP
		GL_Q
		GL_QUADRATIC_ATTENUATION
		GL_QUADS
		GL_QUAD_STRIP
		GL_R
		GL_R3_G3_B2
		GL_READ_BUFFER
		GL_RED
		GL_REDUCE
		GL_RED_BIAS
		GL_RED_BITS
		GL_RED_SCALE
		GL_REFLECTION_MAP
		GL_RENDER
		GL_RENDERER
		GL_RENDER_MODE
		GL_REPEAT
		GL_REPLACE
		GL_REPLICATE_BORDER
		GL_RESCALE_NORMAL
		GL_RETURN
		GL_RGB
		GL_RGB10
		GL_RGB10_A2
		GL_RGB12
		GL_RGB16
		GL_RGB4
		GL_RGB5
		GL_RGB5_A1
		GL_RGB8
		GL_RGBA
		GL_RGBA12
		GL_RGBA16
		GL_RGBA2
		GL_RGBA4
		GL_RGBA8
		GL_RGBA_MODE
		GL_RGB_SCALE
		GL_RIGHT
		GL_S
		GL_SAMPLES
		GL_SAMPLE_ALPHA_TO_COVERAGE
		GL_SAMPLE_ALPHA_TO_ONE
		GL_SAMPLE_BUFFERS
		GL_SAMPLE_COVERAGE
		GL_SAMPLE_COVERAGE_INVERT
		GL_SAMPLE_COVERAGE_VALUE
		GL_SCISSOR_BIT
		GL_SCISSOR_BOX
		GL_SCISSOR_TEST
		GL_SELECT
		GL_SELECTION_BUFFER_POINTER
		GL_SELECTION_BUFFER_SIZE
		GL_SEPARABLE_2D
		GL_SEPARATE_SPECULAR_COLOR
		GL_SET
		GL_SHADE_MODEL
		GL_SHININESS
		GL_SHORT
		GL_SINGLE_COLOR
		GL_SMOOTH
		GL_SMOOTH_LINE_WIDTH_GRANULARITY
		GL_SMOOTH_LINE_WIDTH_RANGE
		GL_SMOOTH_POINT_SIZE_GRANULARITY
		GL_SMOOTH_POINT_SIZE_RANGE
		GL_SOURCE0_ALPHA
		GL_SOURCE0_RGB
		GL_SOURCE1_ALPHA
		GL_SOURCE1_RGB
		GL_SOURCE2_ALPHA
		GL_SOURCE2_RGB
		GL_SPECULAR
		GL_SPHERE_MAP
		GL_SPOT_CUTOFF
		GL_SPOT_DIRECTION
		GL_SPOT_EXPONENT
		GL_SRC_ALPHA
		GL_SRC_ALPHA_SATURATE
		GL_SRC_COLOR
		GL_STACK_OVERFLOW
		GL_STACK_UNDERFLOW
		GL_STENCIL
		GL_STENCIL_BITS
		GL_STENCIL_BUFFER_BIT
		GL_STENCIL_CLEAR_VALUE
		GL_STENCIL_FAIL
		GL_STENCIL_FUNC
		GL_STENCIL_INDEX
		GL_STENCIL_PASS_DEPTH_FAIL
		GL_STENCIL_PASS_DEPTH_PASS
		GL_STENCIL_REF
		GL_STENCIL_TEST
		GL_STENCIL_VALUE_MASK
		GL_STENCIL_WRITEMASK
		GL_STEREO
		GL_SUBPIXEL_BITS
		GL_SUBTRACT
		GL_T
		GL_T2F_C3F_V3F
		GL_T2F_C4F_N3F_V3F
		GL_T2F_C4UB_V3F
		GL_T2F_N3F_V3F
		GL_T2F_V3F
		GL_T4F_C4F_N3F_V4F
		GL_T4F_V4F
		GL_TABLE_TOO_LARGE
		GL_TEXTURE
		GL_TEXTURE0
		GL_TEXTURE0_ARB
		GL_TEXTURE1
		GL_TEXTURE10
		GL_TEXTURE10_ARB
		GL_TEXTURE11
		GL_TEXTURE11_ARB
		GL_TEXTURE12
		GL_TEXTURE12_ARB
		GL_TEXTURE13
		GL_TEXTURE13_ARB
		GL_TEXTURE14
		GL_TEXTURE14_ARB
		GL_TEXTURE15
		GL_TEXTURE15_ARB
		GL_TEXTURE16
		GL_TEXTURE16_ARB
		GL_TEXTURE17
		GL_TEXTURE17_ARB
		GL_TEXTURE18
		GL_TEXTURE18_ARB
		GL_TEXTURE19
		GL_TEXTURE19_ARB
		GL_TEXTURE1_ARB
		GL_TEXTURE2
		GL_TEXTURE20
		GL_TEXTURE20_ARB
		GL_TEXTURE21
		GL_TEXTURE21_ARB
		GL_TEXTURE22
		GL_TEXTURE22_ARB
		GL_TEXTURE23
		GL_TEXTURE23_ARB
		GL_TEXTURE24
		GL_TEXTURE24_ARB
		GL_TEXTURE25
		GL_TEXTURE25_ARB
		GL_TEXTURE26
		GL_TEXTURE26_ARB
		GL_TEXTURE27
		GL_TEXTURE27_ARB
		GL_TEXTURE28
		GL_TEXTURE28_ARB
		GL_TEXTURE29
		GL_TEXTURE29_ARB
		GL_TEXTURE2_ARB
		GL_TEXTURE3
		GL_TEXTURE30
		GL_TEXTURE30_ARB
		GL_TEXTURE31
		GL_TEXTURE31_ARB
		GL_TEXTURE3_ARB
		GL_TEXTURE4
		GL_TEXTURE4_ARB
		GL_TEXTURE5
		GL_TEXTURE5_ARB
		GL_TEXTURE6
		GL_TEXTURE6_ARB
		GL_TEXTURE7
		GL_TEXTURE7_ARB
		GL_TEXTURE8
		GL_TEXTURE8_ARB
		GL_TEXTURE9
		GL_TEXTURE9_ARB
		GL_TEXTURE_1D
		GL_TEXTURE_2D
		GL_TEXTURE_3D
		GL_TEXTURE_ALPHA_SIZE
		GL_TEXTURE_BASE_LEVEL
		GL_TEXTURE_BINDING_1D
		GL_TEXTURE_BINDING_2D
		GL_TEXTURE_BINDING_3D
		GL_TEXTURE_BINDING_CUBE_MAP
		GL_TEXTURE_BIT
		GL_TEXTURE_BLUE_SIZE
		GL_TEXTURE_BORDER
		GL_TEXTURE_BORDER_COLOR
		GL_TEXTURE_COMPONENTS
		GL_TEXTURE_COMPRESSED
		GL_TEXTURE_COMPRESSED_IMAGE_SIZE
		GL_TEXTURE_COMPRESSION_HINT
		GL_TEXTURE_COORD_ARRAY
		GL_TEXTURE_COORD_ARRAY_POINTER
		GL_TEXTURE_COORD_ARRAY_SIZE
		GL_TEXTURE_COORD_ARRAY_STRIDE
		GL_TEXTURE_COORD_ARRAY_TYPE
		GL_TEXTURE_CUBE_MAP
		GL_TEXTURE_CUBE_MAP_NEGATIVE_X
		GL_TEXTURE_CUBE_MAP_NEGATIVE_Y
		GL_TEXTURE_CUBE_MAP_NEGATIVE_Z
		GL_TEXTURE_CUBE_MAP_POSITIVE_X
		GL_TEXTURE_CUBE_MAP_POSITIVE_Y
		GL_TEXTURE_CUBE_MAP_POSITIVE_Z
		GL_TEXTURE_DEPTH
		GL_TEXTURE_ENV
		GL_TEXTURE_ENV_COLOR
		GL_TEXTURE_ENV_MODE
		GL_TEXTURE_GEN_MODE
		GL_TEXTURE_GEN_Q
		GL_TEXTURE_GEN_R
		GL_TEXTURE_GEN_S
		GL_TEXTURE_GEN_T
		GL_TEXTURE_GREEN_SIZE
		GL_TEXTURE_HEIGHT
		GL_TEXTURE_INTENSITY_SIZE
		GL_TEXTURE_INTERNAL_FORMAT
		GL_TEXTURE_LUMINANCE_SIZE
		GL_TEXTURE_MAG_FILTER
		GL_TEXTURE_MATRIX
		GL_TEXTURE_MAX_LEVEL
		GL_TEXTURE_MAX_LOD
		GL_TEXTURE_MIN_FILTER
		GL_TEXTURE_MIN_LOD
		GL_TEXTURE_PRIORITY
		GL_TEXTURE_RED_SIZE
		GL_TEXTURE_RESIDENT
		GL_TEXTURE_STACK_DEPTH
		GL_TEXTURE_WIDTH
		GL_TEXTURE_WRAP_R
		GL_TEXTURE_WRAP_S
		GL_TEXTURE_WRAP_T
		GL_TRACE_ALL_BITS_MESA
		GL_TRACE_ARRAYS_BIT_MESA
		GL_TRACE_ERRORS_BIT_MESA
		GL_TRACE_MASK_MESA
		GL_TRACE_NAME_MESA
		GL_TRACE_OPERATIONS_BIT_MESA
		GL_TRACE_PIXELS_BIT_MESA
		GL_TRACE_PRIMITIVES_BIT_MESA
		GL_TRACE_TEXTURES_BIT_MESA
		GL_TRANSFORM_BIT
		GL_TRANSPOSE_COLOR_MATRIX
		GL_TRANSPOSE_MODELVIEW_MATRIX
		GL_TRANSPOSE_PROJECTION_MATRIX
		GL_TRANSPOSE_TEXTURE_MATRIX
		GL_TRIANGLES
		GL_TRIANGLE_FAN
		GL_TRIANGLE_STRIP
		GL_TRUE
		GL_UNPACK_ALIGNMENT
		GL_UNPACK_IMAGE_HEIGHT
		GL_UNPACK_LSB_FIRST
		GL_UNPACK_ROW_LENGTH
		GL_UNPACK_SKIP_IMAGES
		GL_UNPACK_SKIP_PIXELS
		GL_UNPACK_SKIP_ROWS
		GL_UNPACK_SWAP_BYTES
		GL_UNSIGNED_BYTE
		GL_UNSIGNED_BYTE_2_3_3_REV
		GL_UNSIGNED_BYTE_3_3_2
		GL_UNSIGNED_INT
		GL_UNSIGNED_INT_10_10_10_2
		GL_UNSIGNED_INT_24_8_MESA
		GL_UNSIGNED_INT_2_10_10_10_REV
		GL_UNSIGNED_INT_8_24_REV_MESA
		GL_UNSIGNED_INT_8_8_8_8
		GL_UNSIGNED_INT_8_8_8_8_REV
		GL_UNSIGNED_SHORT
		GL_UNSIGNED_SHORT_15_1_MESA
		GL_UNSIGNED_SHORT_1_15_REV_MESA
		GL_UNSIGNED_SHORT_1_5_5_5_REV
		GL_UNSIGNED_SHORT_4_4_4_4
		GL_UNSIGNED_SHORT_4_4_4_4_REV
		GL_UNSIGNED_SHORT_5_5_5_1
		GL_UNSIGNED_SHORT_5_6_5
		GL_UNSIGNED_SHORT_5_6_5_REV
		GL_V2F
		GL_V3F
		GL_VENDOR
		GL_VERSION
		GL_VERSION_1_1
		GL_VERSION_1_2
		GL_VERSION_1_3
		GL_VERTEX_ARRAY
		GL_VERTEX_ARRAY_POINTER
		GL_VERTEX_ARRAY_SIZE
		GL_VERTEX_ARRAY_STRIDE
		GL_VERTEX_ARRAY_TYPE
		GL_VERTEX_PROGRAM_CALLBACK_DATA_MESA
		GL_VERTEX_PROGRAM_CALLBACK_FUNC_MESA
		GL_VERTEX_PROGRAM_CALLBACK_MESA
		GL_VERTEX_PROGRAM_POSITION_MESA
		GL_VIEWPORT
		GL_VIEWPORT_BIT
		GL_XOR
		GL_ZERO
		GL_ZOOM_X
		GL_ZOOM_Y
		GXand
		GXandInverted
		GXandReverse
		GXclear
		GXcopy
		GXcopyInverted
		GXequiv
		GXinvert
		GXnand
		GXnoop
		GXnor
		GXor
		GXorInverted
		GXorReverse
		GXset
		GXxor
		GrabFrozen
		GrabInvalidTime
		GrabModeAsync
		GrabModeSync
		GrabNotViewable
		GrabSuccess
		GraphicsExpose
		GravityNotify
		GrayScale
		HostDelete
		HostInsert
		IncludeInferiors
		InputFocus
		InputOnly
		InputOutput
		IsUnmapped
		IsUnviewable
		IsViewable
		JoinBevel
		JoinMiter
		JoinRound
		KBAutoRepeatMode
		KBBellDuration
		KBBellPercent
		KBBellPitch
		KBKey
		KBKeyClickPercent
		KBLed
		KBLedMode
		KeyPress
		KeyPressMask
		KeyRelease
		KeyReleaseMask
		KeymapNotify
		KeymapStateMask
		LASTEvent
		LSBFirst
		LastExtensionError
		LeaveNotify
		LeaveWindowMask
		LedModeOff
		LedModeOn
		LineDoubleDash
		LineOnOffDash
		LineSolid
		LockMapIndex
		LockMask
		LowerHighest
		MSBFirst
		MapNotify
		MapRequest
		MappingBusy
		MappingFailed
		MappingKeyboard
		MappingModifier
		MappingNotify
		MappingPointer
		MappingSuccess
		Mod1MapIndex
		Mod1Mask
		Mod2MapIndex
		Mod2Mask
		Mod3MapIndex
		Mod3Mask
		Mod4MapIndex
		Mod4Mask
		Mod5MapIndex
		Mod5Mask
		MotionNotify
		NoEventMask
		NoExpose
		NoSymbol
		Nonconvex
		None
		NorthEastGravity
		NorthGravity
		NorthWestGravity
		NotUseful
		NotifyAncestor
		NotifyDetailNone
		NotifyGrab
		NotifyHint
		NotifyInferior
		NotifyNonlinear
		NotifyNonlinearVirtual
		NotifyNormal
		NotifyPointer
		NotifyPointerRoot
		NotifyUngrab
		NotifyVirtual
		NotifyWhileGrabbed
		Opposite
		OwnerGrabButtonMask
		ParentRelative
		PlaceOnBottom
		PlaceOnTop
		PointerMotionHintMask
		PointerMotionMask
		PointerRoot
		PointerWindow
		PreferBlanking
		PropModeAppend
		PropModePrepend
		PropModeReplace
		PropertyChangeMask
		PropertyDelete
		PropertyNewValue
		PropertyNotify
		PseudoColor
		RaiseLowest
		ReparentNotify
		ReplayKeyboard
		ReplayPointer
		ResizeRedirectMask
		ResizeRequest
		RetainPermanent
		RetainTemporary
		RevertToNone
		RevertToParent
		RevertToPointerRoot
		ScreenSaverActive
		ScreenSaverReset
		SelectionClear
		SelectionNotify
		SelectionRequest
		SetModeDelete
		SetModeInsert
		ShiftMapIndex
		ShiftMask
		SouthEastGravity
		SouthGravity
		SouthWestGravity
		StaticColor
		StaticGravity
		StaticGray
		StippleShape
		StructureNotifyMask
		SubstructureNotifyMask
		SubstructureRedirectMask
		Success
		SyncBoth
		SyncKeyboard
		SyncPointer
		TileShape
		TopIf
		TrueColor
		UnmapGravity
		UnmapNotify
		Unsorted
		VisibilityChangeMask
		VisibilityFullyObscured
		VisibilityNotify
		VisibilityPartiallyObscured
		VisibilityUnobscured
		WIN32_LEAN_AND_MEAN
		WestGravity
		WhenMapped
		WindingRule
		XYBitmap
		XYPixmap
		X_PROTOCOL
		X_PROTOCOL_REVISION
		YSorted
		YXBanded
		YXSorted
		ZPixmap
		glAccum
		glActiveTexture
		glActiveTextureARB
		glAlphaFunc
		glAreTexturesResident
		glArrayElement
		glBegin
		glBindTexture
		glBitmap
		glBlendColor
		glBlendEquation
		glBlendEquationSeparateATI
		glBlendFunc
		glCallList
		glCallLists
		glClear
		glClearAccum
		glClearColor
		glClearDebugLogMESA
		glClearDepth
		glClearIndex
		glClearStencil
		glClientActiveTexture
		glClientActiveTextureARB
		glClipPlane
		glColor3b
		glColor3bv
		glColor3d
		glColor3dv
		glColor3f
		glColor3fv
		glColor3i
		glColor3iv
		glColor3s
		glColor3sv
		glColor3ub
		glColor3ubv
		glColor3ui
		glColor3uiv
		glColor3us
		glColor3usv
		glColor4b
		glColor4bv
		glColor4d
		glColor4dv
		glColor4f
		glColor4fv
		glColor4i
		glColor4iv
		glColor4s
		glColor4sv
		glColor4ub
		glColor4ubv
		glColor4ui
		glColor4uiv
		glColor4us
		glColor4usv
		glColorMask
		glColorMaterial
		glColorPointer
		glColorSubTable
		glColorTable
		glColorTableParameterfv
		glColorTableParameteriv
		glCompressedTexImage1D
		glCompressedTexImage2D
		glCompressedTexImage3D
		glCompressedTexSubImage1D
		glCompressedTexSubImage2D
		glCompressedTexSubImage3D
		glConvolutionFilter1D
		glConvolutionFilter2D
		glConvolutionParameterf
		glConvolutionParameterfv
		glConvolutionParameteri
		glConvolutionParameteriv
		glCopyColorSubTable
		glCopyColorTable
		glCopyConvolutionFilter1D
		glCopyConvolutionFilter2D
		glCopyPixels
		glCopyTexImage1D
		glCopyTexImage2D
		glCopyTexSubImage1D
		glCopyTexSubImage2D
		glCopyTexSubImage3D
		glCreateDebugObjectMESA
		glCullFace
		glDeleteLists
		glDeleteTextures
		glDepthFunc
		glDepthMask
		glDepthRange
		glDisable
		glDisableClientState
		glDisableTraceMESA
		glDrawArrays
		glDrawBuffer
		glDrawElements
		glDrawPixels
		glDrawRangeElements
		glEdgeFlag
		glEdgeFlagPointer
		glEdgeFlagv
		glEnable
		glEnableClientState
		glEnableTraceMESA
		glEnd
		glEndList
		glEndTraceMESA
		glEvalCoord1d
		glEvalCoord1dv
		glEvalCoord1f
		glEvalCoord1fv
		glEvalCoord2d
		glEvalCoord2dv
		glEvalCoord2f
		glEvalCoord2fv
		glEvalMesh1
		glEvalMesh2
		glEvalPoint1
		glEvalPoint2
		glFeedbackBuffer
		glFinish
		glFlush
		glFogf
		glFogfv
		glFogi
		glFogiv
		glFrontFace
		glFrustum
		glGenLists
		glGenTextures
		glGetBooleanv
		glGetClipPlane
		glGetColorTable
		glGetColorTableParameterfv
		glGetColorTableParameteriv
		glGetCompressedTexImage
		glGetConvolutionFilter
		glGetConvolutionParameterfv
		glGetConvolutionParameteriv
		glGetDebugLogLengthMESA
		glGetDebugLogMESA
		glGetDoublev
		glGetError
		glGetFloatv
		glGetHistogram
		glGetHistogramParameterfv
		glGetHistogramParameteriv
		glGetIntegerv
		glGetLightfv
		glGetLightiv
		glGetMapdv
		glGetMapfv
		glGetMapiv
		glGetMaterialfv
		glGetMaterialiv
		glGetMinmax
		glGetMinmaxParameterfv
		glGetMinmaxParameteriv
		glGetPixelMapfv
		glGetPixelMapuiv
		glGetPixelMapusv
		glGetPointerv
		glGetPolygonStipple
		glGetSeparableFilter
		glGetTexEnvfv
		glGetTexEnviv
		glGetTexGendv
		glGetTexGenfv
		glGetTexGeniv
		glGetTexImage
		glGetTexLevelParameterfv
		glGetTexLevelParameteriv
		glGetTexParameterfv
		glGetTexParameteriv
		glHint
		glHistogram
		glIndexMask
		glIndexPointer
		glIndexd
		glIndexdv
		glIndexf
		glIndexfv
		glIndexi
		glIndexiv
		glIndexs
		glIndexsv
		glIndexub
		glIndexubv
		glInitNames
		glInterleavedArrays
		glIsEnabled
		glIsList
		glIsTexture
		glLightModelf
		glLightModelfv
		glLightModeli
		glLightModeliv
		glLightf
		glLightfv
		glLighti
		glLightiv
		glLineStipple
		glLineWidth
		glListBase
		glLoadIdentity
		glLoadMatrixd
		glLoadMatrixf
		glLoadName
		glLoadTransposeMatrixd
		glLoadTransposeMatrixf
		glLogicOp
		glMap1d
		glMap1f
		glMap2d
		glMap2f
		glMapGrid1d
		glMapGrid1f
		glMapGrid2d
		glMapGrid2f
		glMaterialf
		glMaterialfv
		glMateriali
		glMaterialiv
		glMatrixMode
		glMinmax
		glMultMatrixd
		glMultMatrixf
		glMultTransposeMatrixd
		glMultTransposeMatrixf
		glMultiTexCoord1d
		glMultiTexCoord1dARB
		glMultiTexCoord1dv
		glMultiTexCoord1dvARB
		glMultiTexCoord1f
		glMultiTexCoord1fARB
		glMultiTexCoord1fv
		glMultiTexCoord1fvARB
		glMultiTexCoord1i
		glMultiTexCoord1iARB
		glMultiTexCoord1iv
		glMultiTexCoord1ivARB
		glMultiTexCoord1s
		glMultiTexCoord1sARB
		glMultiTexCoord1sv
		glMultiTexCoord1svARB
		glMultiTexCoord2d
		glMultiTexCoord2dARB
		glMultiTexCoord2dv
		glMultiTexCoord2dvARB
		glMultiTexCoord2f
		glMultiTexCoord2fARB
		glMultiTexCoord2fv
		glMultiTexCoord2fvARB
		glMultiTexCoord2i
		glMultiTexCoord2iARB
		glMultiTexCoord2iv
		glMultiTexCoord2ivARB
		glMultiTexCoord2s
		glMultiTexCoord2sARB
		glMultiTexCoord2sv
		glMultiTexCoord2svARB
		glMultiTexCoord3d
		glMultiTexCoord3dARB
		glMultiTexCoord3dv
		glMultiTexCoord3dvARB
		glMultiTexCoord3f
		glMultiTexCoord3fARB
		glMultiTexCoord3fv
		glMultiTexCoord3fvARB
		glMultiTexCoord3i
		glMultiTexCoord3iARB
		glMultiTexCoord3iv
		glMultiTexCoord3ivARB
		glMultiTexCoord3s
		glMultiTexCoord3sARB
		glMultiTexCoord3sv
		glMultiTexCoord3svARB
		glMultiTexCoord4d
		glMultiTexCoord4dARB
		glMultiTexCoord4dv
		glMultiTexCoord4dvARB
		glMultiTexCoord4f
		glMultiTexCoord4fARB
		glMultiTexCoord4fv
		glMultiTexCoord4fvARB
		glMultiTexCoord4i
		glMultiTexCoord4iARB
		glMultiTexCoord4iv
		glMultiTexCoord4ivARB
		glMultiTexCoord4s
		glMultiTexCoord4sARB
		glMultiTexCoord4sv
		glMultiTexCoord4svARB
		glNewList
		glNewTraceMESA
		glNormal3b
		glNormal3bv
		glNormal3d
		glNormal3dv
		glNormal3f
		glNormal3fv
		glNormal3i
		glNormal3iv
		glNormal3s
		glNormal3sv
		glNormalPointer
		glOrtho
		glPassThrough
		glPixelMapfv
		glPixelMapuiv
		glPixelMapusv
		glPixelStoref
		glPixelStorei
		glPixelTransferf
		glPixelTransferi
		glPixelZoom
		glPointSize
		glPolygonMode
		glPolygonOffset
		glPolygonStipple
		glPopAttrib
		glPopClientAttrib
		glPopMatrix
		glPopName
		glPrioritizeTextures
		glPushAttrib
		glPushClientAttrib
		glPushMatrix
		glPushName
		glRasterPos2d
		glRasterPos2dv
		glRasterPos2f
		glRasterPos2fv
		glRasterPos2i
		glRasterPos2iv
		glRasterPos2s
		glRasterPos2sv
		glRasterPos3d
		glRasterPos3dv
		glRasterPos3f
		glRasterPos3fv
		glRasterPos3i
		glRasterPos3iv
		glRasterPos3s
		glRasterPos3sv
		glRasterPos4d
		glRasterPos4dv
		glRasterPos4f
		glRasterPos4fv
		glRasterPos4i
		glRasterPos4iv
		glRasterPos4s
		glRasterPos4sv
		glReadBuffer
		glReadPixels
		glRectd
		glRectdv
		glRectf
		glRectfv
		glRecti
		glRectiv
		glRects
		glRectsv
		glRenderMode
		glResetHistogram
		glResetMinmax
		glRotated
		glRotatef
		glSampleCoverage
		glScaled
		glScalef
		glScissor
		glSelectBuffer
		glSeparableFilter2D
		glShadeModel
		glStencilFunc
		glStencilMask
		glStencilOp
		glTexCoord1d
		glTexCoord1dv
		glTexCoord1f
		glTexCoord1fv
		glTexCoord1i
		glTexCoord1iv
		glTexCoord1s
		glTexCoord1sv
		glTexCoord2d
		glTexCoord2dv
		glTexCoord2f
		glTexCoord2fv
		glTexCoord2i
		glTexCoord2iv
		glTexCoord2s
		glTexCoord2sv
		glTexCoord3d
		glTexCoord3dv
		glTexCoord3f
		glTexCoord3fv
		glTexCoord3i
		glTexCoord3iv
		glTexCoord3s
		glTexCoord3sv
		glTexCoord4d
		glTexCoord4dv
		glTexCoord4f
		glTexCoord4fv
		glTexCoord4i
		glTexCoord4iv
		glTexCoord4s
		glTexCoord4sv
		glTexCoordPointer
		glTexEnvf
		glTexEnvfv
		glTexEnvi
		glTexEnviv
		glTexGend
		glTexGendv
		glTexGenf
		glTexGenfv
		glTexGeni
		glTexGeniv
		glTexImage1D
		glTexImage2D
		glTexImage3D
		glTexParameterf
		glTexParameterfv
		glTexParameteri
		glTexParameteriv
		glTexSubImage1D
		glTexSubImage2D
		glTexSubImage3D
		glTraceAssertAttribMESA
		glTraceCommentMESA
		glTraceListMESA
		glTracePointerMESA
		glTracePointerRangeMESA
		glTraceTextureMESA
		glTranslated
		glTranslatef
		glVertex2d
		glVertex2dv
		glVertex2f
		glVertex2fv
		glVertex2i
		glVertex2iv
		glVertex2s
		glVertex2sv
		glVertex3d
		glVertex3dv
		glVertex3f
		glVertex3fv
		glVertex3i
		glVertex3iv
		glVertex3s
		glVertex3sv
		glVertex4d
		glVertex4dv
		glVertex4f
		glVertex4fv
		glVertex4i
		glVertex4iv
		glVertex4s
		glVertex4sv
		glVertexPointer
		glViewport
		glXBeginFrameTrackingMESA
		glXBindTexImageARB
		glXBindTexImageEXT
		glXCopyContext
		glXCreateContext
		glXCreateGLXPixmap
		glXCreateNewContext
		glXCreatePbuffer
		glXCreatePixmap
		glXCreateWindow
		glXDestroyContext
		glXDestroyGLXPixmap
		glXDestroyPbuffer
		glXDestroyPixmap
		glXDestroyWindow
		glXDrawableAttribARB
		glXEndFrameTrackingMESA
		glXFreeMemoryMESA
		glXFreeMemoryNV
		glXGetConfig
		glXGetCurrentContext
		glXGetCurrentDrawable
		glXGetCurrentReadDrawable
		glXGetFBConfigAttrib
		glXGetFrameUsageMESA
		glXGetMemoryOffsetMESA
		glXGetSelectedEvent
		glXGetSwapIntervalMESA
		glXIsDirect
		glXMakeContextCurrent
		glXMakeCurrent
		glXQueryContext
		glXQueryDrawable
		glXQueryExtension
		glXQueryFrameTrackingMESA
		glXQueryVersion
		glXReleaseTexImageARB
		glXReleaseTexImageEXT
		glXSelectEvent
		glXSwapBuffers
		glXSwapIntervalMESA
		glXUseXFont
		glXWaitGL
		glXWaitX
		gluBeginCurve
		gluBeginPolygon
		gluBeginSurface
		gluBeginTrim
		gluBuild1DMipmapLevels
		gluBuild1DMipmaps
		gluBuild2DMipmapLevels
		gluBuild2DMipmaps
		gluBuild3DMipmapLevels
		gluBuild3DMipmaps
		gluCheckExtension
		gluCylinder
		gluDeleteNurbsRenderer
		gluDeleteQuadric
		gluDeleteTess
		gluDisk
		gluEndCurve
		gluEndPolygon
		gluEndSurface
		gluEndTrim
		gluGetNurbsProperty
		gluGetTessProperty
		gluLoadSamplingMatrices
		gluLookAt
		gluNextContour
		gluNurbsCallback
		gluNurbsCallbackData
		gluNurbsCallbackDataEXT
		gluNurbsCurve
		gluNurbsProperty
		gluNurbsSurface
		gluOrtho2D
		gluPartialDisk
		gluPerspective
		gluPickMatrix
		gluProject
		gluPwlCurve
		gluQuadricCallback
		gluQuadricDrawStyle
		gluQuadricNormals
		gluQuadricOrientation
		gluQuadricTexture
		gluScaleImage
		gluSphere
		gluTessBeginContour
		gluTessBeginPolygon
		gluTessCallback
		gluTessEndContour
		gluTessEndPolygon
		gluTessNormal
		gluTessProperty
		gluTessVertex
		gluUnProject
		gluUnProject4
 );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::Graphics::OpenGL ;








sub APIENTRY () {'GLAPIENTRY'}
sub APIENTRYP () {'APIENTRY'}
sub Above () {0}
sub AllTemporary () {0}
sub AllocAll () {1}
sub AllocNone () {0}
sub AllowExposures () {1}
sub AlreadyGrabbed () {1}
sub Always () {2}
sub AnyButton () {0}
sub AnyKey () {0}
sub AnyModifier () {(1<<15)}
sub AnyPropertyType () {0}
sub ArcChord () {0}
sub ArcPieSlice () {1}
sub AsyncBoth () {6}
sub AsyncKeyboard () {3}
sub AsyncPointer () {0}
sub AutoRepeatModeDefault () {2}
sub AutoRepeatModeOff () {0}
sub AutoRepeatModeOn () {1}
sub BadAccess () {10}
sub BadAlloc () {11}
sub BadAtom () {5}
sub BadColor () {12}
sub BadCursor () {6}
sub BadDrawable () {9}
sub BadFont () {7}
sub BadGC () {13}
sub BadIDChoice () {14}
sub BadImplementation () {17}
sub BadLength () {16}
sub BadMatch () {8}
sub BadName () {15}
sub BadPixmap () {4}
sub BadRequest () {1}
sub BadValue () {2}
sub BadWindow () {3}
sub Below () {1}
sub BottomIf () {3}
sub Button1 () {1}
sub Button1Mask () {(1<<8)}
sub Button1MotionMask () {(1<<8)}
sub Button2 () {2}
sub Button2Mask () {(1<<9)}
sub Button2MotionMask () {(1<<9)}
sub Button3 () {3}
sub Button3Mask () {(1<<10)}
sub Button3MotionMask () {(1<<10)}
sub Button4 () {4}
sub Button4Mask () {(1<<11)}
sub Button4MotionMask () {(1<<11)}
sub Button5 () {5}
sub Button5Mask () {(1<<12)}
sub Button5MotionMask () {(1<<12)}
sub ButtonMotionMask () {(1<<13)}
sub ButtonPress () {4}
sub ButtonPressMask () {(1<<2)}
sub ButtonRelease () {5}
sub ButtonReleaseMask () {(1<<3)}
sub CWBackPixel () {(1<<1)}
sub CWBackPixmap () {(1<<0)}
sub CWBackingPixel () {(1<<8)}
sub CWBackingPlanes () {(1<<7)}
sub CWBackingStore () {(1<<6)}
sub CWBitGravity () {(1<<4)}
sub CWBorderPixel () {(1<<3)}
sub CWBorderPixmap () {(1<<2)}
sub CWBorderWidth () {(1<<4)}
sub CWColormap () {(1<<13)}
sub CWCursor () {(1<<14)}
sub CWDontPropagate () {(1<<12)}
sub CWEventMask () {(1<<11)}
sub CWHeight () {(1<<3)}
sub CWOverrideRedirect () {(1<<9)}
sub CWSaveUnder () {(1<<10)}
sub CWSibling () {(1<<5)}
sub CWStackMode () {(1<<6)}
sub CWWidth () {(1<<2)}
sub CWWinGravity () {(1<<5)}
sub CWX () {(1<<0)}
sub CWY () {(1<<1)}
sub CapButt () {1}
sub CapNotLast () {0}
sub CapProjecting () {3}
sub CapRound () {2}
sub CenterGravity () {5}
sub CirculateNotify () {26}
sub CirculateRequest () {27}
sub ClientMessage () {33}
sub ClipByChildren () {0}
sub ColormapChangeMask () {(1<<23)}
sub ColormapInstalled () {1}
sub ColormapNotify () {32}
sub ColormapUninstalled () {0}
sub Complex () {0}
sub ConfigureNotify () {22}
sub ConfigureRequest () {23}
sub ControlMapIndex () {2}
sub ControlMask () {(1<<2)}
sub Convex () {2}
sub CoordModeOrigin () {0}
sub CoordModePrevious () {1}
sub CopyFromParent () {0}
sub CreateNotify () {16}
sub CurrentTime () {0}
sub CursorShape () {0}
sub DefaultBlanking () {2}
sub DefaultExposures () {2}
sub DestroyAll () {0}
sub DestroyNotify () {17}
sub DirectColor () {5}
sub DisableAccess () {0}
sub DisableScreenInterval () {0}
sub DisableScreenSaver () {0}
sub DoBlue () {(1<<2)}
sub DoGreen () {(1<<1)}
sub DoRed () {(1<<0)}
sub DontAllowExposures () {0}
sub DontPreferBlanking () {0}
sub EastGravity () {6}
sub EnableAccess () {1}
sub EnterNotify () {7}
sub EnterWindowMask () {(1<<4)}
sub EvenOddRule () {0}
sub Expose () {12}
sub ExposureMask () {(1<<15)}
sub FamilyChaos () {2}
sub FamilyDECnet () {1}
sub FamilyInternet () {0}
sub FamilyInternet6 () {6}
sub FamilyServerInterpreted () {5}
sub FillOpaqueStippled () {3}
sub FillSolid () {0}
sub FillStippled () {2}
sub FillTiled () {1}
sub FirstExtensionError () {128}
sub FocusChangeMask () {(1<<21)}
sub FocusIn () {9}
sub FocusOut () {10}
sub FontChange () {255}
sub FontLeftToRight () {0}
sub FontRightToLeft () {1}
sub ForgetGravity () {0}
sub GCArcMode () {(1<<22)}
sub GCBackground () {(1<<3)}
sub GCCapStyle () {(1<<6)}
sub GCClipMask () {(1<<19)}
sub GCClipXOrigin () {(1<<17)}
sub GCClipYOrigin () {(1<<18)}
sub GCDashList () {(1<<21)}
sub GCDashOffset () {(1<<20)}
sub GCFillRule () {(1<<9)}
sub GCFillStyle () {(1<<8)}
sub GCFont () {(1<<14)}
sub GCForeground () {(1<<2)}
sub GCFunction () {(1<<0)}
sub GCGraphicsExposures () {(1<<16)}
sub GCJoinStyle () {(1<<7)}
sub GCLastBit () {22}
sub GCLineStyle () {(1<<5)}
sub GCLineWidth () {(1<<4)}
sub GCPlaneMask () {(1<<1)}
sub GCStipple () {(1<<11)}
sub GCSubwindowMode () {(1<<15)}
sub GCTile () {(1<<10)}
sub GCTileStipXOrigin () {(1<<12)}
sub GCTileStipYOrigin () {(1<<13)}
sub GLAPI () {'extern'}
sub GLAPIENTRYP () {'GLAPIENTRY'}
sub GLU_AUTO_LOAD_MATRIX () {100200}
sub GLU_BEGIN () {100100}
sub GLU_CCW () {100121}
sub GLU_CULLING () {100201}
sub GLU_CW () {100120}
sub GLU_DISPLAY_MODE () {100204}
sub GLU_DOMAIN_DISTANCE () {100217}
sub GLU_EDGE_FLAG () {100104}
sub GLU_END () {100102}
sub GLU_ERROR () {100103}
sub GLU_EXTENSIONS () {100801}
sub GLU_EXTERIOR () {100123}
sub GLU_EXT_nurbs_tessellator () {1}
sub GLU_EXT_object_space_tess () {1}
sub GLU_FALSE () {0}
sub GLU_FILL () {100012}
sub GLU_FLAT () {100001}
sub GLU_INCOMPATIBLE_GL_VERSION () {100903}
sub GLU_INSIDE () {100021}
sub GLU_INTERIOR () {100122}
sub GLU_INVALID_ENUM () {100900}
sub GLU_INVALID_OPERATION () {100904}
sub GLU_INVALID_VALUE () {100901}
sub GLU_LINE () {100011}
sub GLU_MAP1_TRIM_2 () {100210}
sub GLU_MAP1_TRIM_3 () {100211}
sub GLU_NONE () {100002}
sub GLU_NURBS_BEGIN () {100164}
sub GLU_NURBS_BEGIN_DATA () {100170}
sub GLU_NURBS_BEGIN_DATA_EXT () {100170}
sub GLU_NURBS_BEGIN_EXT () {100164}
sub GLU_NURBS_COLOR () {100167}
sub GLU_NURBS_COLOR_DATA () {100173}
sub GLU_NURBS_COLOR_DATA_EXT () {100173}
sub GLU_NURBS_COLOR_EXT () {100167}
sub GLU_NURBS_END () {100169}
sub GLU_NURBS_END_DATA () {100175}
sub GLU_NURBS_END_DATA_EXT () {100175}
sub GLU_NURBS_END_EXT () {100169}
sub GLU_NURBS_ERROR () {100103}
sub GLU_NURBS_ERROR1 () {100251}
sub GLU_NURBS_ERROR10 () {100260}
sub GLU_NURBS_ERROR11 () {100261}
sub GLU_NURBS_ERROR12 () {100262}
sub GLU_NURBS_ERROR13 () {100263}
sub GLU_NURBS_ERROR14 () {100264}
sub GLU_NURBS_ERROR15 () {100265}
sub GLU_NURBS_ERROR16 () {100266}
sub GLU_NURBS_ERROR17 () {100267}
sub GLU_NURBS_ERROR18 () {100268}
sub GLU_NURBS_ERROR19 () {100269}
sub GLU_NURBS_ERROR2 () {100252}
sub GLU_NURBS_ERROR20 () {100270}
sub GLU_NURBS_ERROR21 () {100271}
sub GLU_NURBS_ERROR22 () {100272}
sub GLU_NURBS_ERROR23 () {100273}
sub GLU_NURBS_ERROR24 () {100274}
sub GLU_NURBS_ERROR25 () {100275}
sub GLU_NURBS_ERROR26 () {100276}
sub GLU_NURBS_ERROR27 () {100277}
sub GLU_NURBS_ERROR28 () {100278}
sub GLU_NURBS_ERROR29 () {100279}
sub GLU_NURBS_ERROR3 () {100253}
sub GLU_NURBS_ERROR30 () {100280}
sub GLU_NURBS_ERROR31 () {100281}
sub GLU_NURBS_ERROR32 () {100282}
sub GLU_NURBS_ERROR33 () {100283}
sub GLU_NURBS_ERROR34 () {100284}
sub GLU_NURBS_ERROR35 () {100285}
sub GLU_NURBS_ERROR36 () {100286}
sub GLU_NURBS_ERROR37 () {100287}
sub GLU_NURBS_ERROR4 () {100254}
sub GLU_NURBS_ERROR5 () {100255}
sub GLU_NURBS_ERROR6 () {100256}
sub GLU_NURBS_ERROR7 () {100257}
sub GLU_NURBS_ERROR8 () {100258}
sub GLU_NURBS_ERROR9 () {100259}
sub GLU_NURBS_MODE () {100160}
sub GLU_NURBS_MODE_EXT () {100160}
sub GLU_NURBS_NORMAL () {100166}
sub GLU_NURBS_NORMAL_DATA () {100172}
sub GLU_NURBS_NORMAL_DATA_EXT () {100172}
sub GLU_NURBS_NORMAL_EXT () {100166}
sub GLU_NURBS_RENDERER () {100162}
sub GLU_NURBS_RENDERER_EXT () {100162}
sub GLU_NURBS_TESSELLATOR () {100161}
sub GLU_NURBS_TESSELLATOR_EXT () {100161}
sub GLU_NURBS_TEXTURE_COORD () {100168}
sub GLU_NURBS_TEXTURE_COORD_DATA () {100174}
sub GLU_NURBS_TEX_COORD_DATA_EXT () {100174}
sub GLU_NURBS_TEX_COORD_EXT () {100168}
sub GLU_NURBS_VERTEX () {100165}
sub GLU_NURBS_VERTEX_DATA () {100171}
sub GLU_NURBS_VERTEX_DATA_EXT () {100171}
sub GLU_NURBS_VERTEX_EXT () {100165}
sub GLU_OBJECT_PARAMETRIC_ERROR () {100208}
sub GLU_OBJECT_PARAMETRIC_ERROR_EXT () {100208}
sub GLU_OBJECT_PATH_LENGTH () {100209}
sub GLU_OBJECT_PATH_LENGTH_EXT () {100209}
sub GLU_OUTLINE_PATCH () {100241}
sub GLU_OUTLINE_POLYGON () {100240}
sub GLU_OUTSIDE () {100020}
sub GLU_OUT_OF_MEMORY () {100902}
sub GLU_PARAMETRIC_ERROR () {100216}
sub GLU_PARAMETRIC_TOLERANCE () {100202}
sub GLU_PATH_LENGTH () {100215}
sub GLU_POINT () {100010}
sub GLU_SAMPLING_METHOD () {100205}
sub GLU_SAMPLING_TOLERANCE () {100203}
sub GLU_SILHOUETTE () {100013}
sub GLU_SMOOTH () {100000}
sub GLU_TESS_BEGIN () {100100}
sub GLU_TESS_BEGIN_DATA () {100106}
sub GLU_TESS_BOUNDARY_ONLY () {100141}
sub GLU_TESS_COMBINE () {100105}
sub GLU_TESS_COMBINE_DATA () {100111}
sub GLU_TESS_COORD_TOO_LARGE () {100155}
sub GLU_TESS_EDGE_FLAG () {100104}
sub GLU_TESS_EDGE_FLAG_DATA () {100110}
sub GLU_TESS_END () {100102}
sub GLU_TESS_END_DATA () {100108}
sub GLU_TESS_ERROR () {100103}
sub GLU_TESS_ERROR1 () {100151}
sub GLU_TESS_ERROR2 () {100152}
sub GLU_TESS_ERROR3 () {100153}
sub GLU_TESS_ERROR4 () {100154}
sub GLU_TESS_ERROR5 () {100155}
sub GLU_TESS_ERROR6 () {100156}
sub GLU_TESS_ERROR7 () {100157}
sub GLU_TESS_ERROR8 () {100158}
sub GLU_TESS_ERROR_DATA () {100109}
sub GLU_TESS_MAX_COORD () {1.0e150}
sub GLU_TESS_MISSING_BEGIN_CONTOUR () {100152}
sub GLU_TESS_MISSING_BEGIN_POLYGON () {100151}
sub GLU_TESS_MISSING_END_CONTOUR () {100154}
sub GLU_TESS_MISSING_END_POLYGON () {100153}
sub GLU_TESS_NEED_COMBINE_CALLBACK () {100156}
sub GLU_TESS_TOLERANCE () {100142}
sub GLU_TESS_VERTEX () {100101}
sub GLU_TESS_VERTEX_DATA () {100107}
sub GLU_TESS_WINDING_ABS_GEQ_TWO () {100134}
sub GLU_TESS_WINDING_NEGATIVE () {100133}
sub GLU_TESS_WINDING_NONZERO () {100131}
sub GLU_TESS_WINDING_ODD () {100130}
sub GLU_TESS_WINDING_POSITIVE () {100132}
sub GLU_TESS_WINDING_RULE () {100140}
sub GLU_TRUE () {1}
sub GLU_UNKNOWN () {100124}
sub GLU_U_STEP () {100206}
sub GLU_VERSION () {100800}
sub GLU_VERSION_1_1 () {1}
sub GLU_VERSION_1_2 () {1}
sub GLU_VERSION_1_3 () {1}
sub GLU_VERTEX () {100101}
sub GLU_V_STEP () {100207}
sub GLX_ACCUM_ALPHA_SIZE () {17}
sub GLX_ACCUM_BLUE_SIZE () {16}
sub GLX_ACCUM_BUFFER_BIT () {0x00000080}
sub GLX_ACCUM_GREEN_SIZE () {15}
sub GLX_ACCUM_RED_SIZE () {14}
sub GLX_ALPHA_SIZE () {11}
sub GLX_ARB_get_proc_address () {1}
sub GLX_ARB_render_texture () {1}
sub GLX_AUX0_EXT () {0x20E2}
sub GLX_AUX1_EXT () {0x20E3}
sub GLX_AUX2_EXT () {0x20E4}
sub GLX_AUX3_EXT () {0x20E5}
sub GLX_AUX4_EXT () {0x20E6}
sub GLX_AUX5_EXT () {0x20E7}
sub GLX_AUX6_EXT () {0x20E8}
sub GLX_AUX7_EXT () {0x20E9}
sub GLX_AUX8_EXT () {0x20EA}
sub GLX_AUX9_EXT () {0x20EB}
sub GLX_AUX_BUFFERS () {7}
sub GLX_AUX_BUFFERS_BIT () {0x00000010}
sub GLX_BACK_EXT () {'GLX_BACK_LEFT_EXT'}
sub GLX_BACK_LEFT_BUFFER_BIT () {0x00000004}
sub GLX_BACK_LEFT_EXT () {0x20E0}
sub GLX_BACK_RIGHT_BUFFER_BIT () {0x00000008}
sub GLX_BACK_RIGHT_EXT () {0x20E1}
sub GLX_BAD_ATTRIBUTE () {2}
sub GLX_BAD_CONTEXT () {5}
sub GLX_BAD_ENUM () {7}
sub GLX_BAD_SCREEN () {1}
sub GLX_BAD_VALUE () {6}
sub GLX_BAD_VISUAL () {4}
sub GLX_BIND_TO_MIPMAP_TEXTURE_EXT () {0x20D2}
sub GLX_BIND_TO_TEXTURE_RGBA_EXT () {0x20D1}
sub GLX_BIND_TO_TEXTURE_RGB_EXT () {0x20D0}
sub GLX_BIND_TO_TEXTURE_TARGETS_EXT () {0x20D3}
sub GLX_BLUE_SIZE () {10}
sub GLX_BUFFER_SIZE () {2}
sub GLX_COLOR_INDEX_BIT () {0x00000002}
sub GLX_COLOR_INDEX_TYPE () {0x8015}
sub GLX_CONFIG_CAVEAT () {0x20}
sub GLX_DAMAGED () {0x8020}
sub GLX_DEPTH_BUFFER_BIT () {0x00000020}
sub GLX_DEPTH_SIZE () {12}
sub GLX_DIRECT_COLOR () {0x8003}
sub GLX_DIRECT_COLOR_EXT () {0x8003}
sub GLX_DONT_CARE () {0xFFFFFFFF}
sub GLX_DOUBLEBUFFER () {5}
sub GLX_DRAWABLE_TYPE () {0x8010}
sub GLX_EVENT_MASK () {0x801F}
sub GLX_EXTENSIONS () {0x3}
sub GLX_EXTENSION_NAME () {'"GLX"'}
sub GLX_EXT_texture_from_pixmap () {1}
sub GLX_FBCONFIG_ID () {0x8013}
sub GLX_FLOAT_COMPONENTS_NV () {0x20B0}
sub GLX_FRONT_EXT () {'GLX_FRONT_LEFT_EXT'}
sub GLX_FRONT_LEFT_BUFFER_BIT () {0x00000001}
sub GLX_FRONT_LEFT_EXT () {0x20DE}
sub GLX_FRONT_RIGHT_BUFFER_BIT () {0x00000002}
sub GLX_FRONT_RIGHT_EXT () {0x20DF}
sub GLX_GRAY_SCALE () {0x8006}
sub GLX_GRAY_SCALE_EXT () {0x8006}
sub GLX_GREEN_SIZE () {9}
sub GLX_HEIGHT () {0x801E}
sub GLX_LARGEST_PBUFFER () {0x801C}
sub GLX_LEVEL () {3}
sub GLX_MAX_PBUFFER_HEIGHT () {0x8017}
sub GLX_MAX_PBUFFER_PIXELS () {0x8018}
sub GLX_MAX_PBUFFER_WIDTH () {0x8016}
sub GLX_MESA_allocate_memory () {1}
sub GLX_MESA_swap_control () {1}
sub GLX_MESA_swap_frame_usage () {1}
sub GLX_MIPMAP_TEXTURE_EXT () {0x20D7}
sub GLX_NONE () {0x8000}
sub GLX_NONE_EXT () {0x8000}
sub GLX_NON_CONFORMANT_CONFIG () {0x800D}
sub GLX_NON_CONFORMANT_VISUAL_EXT () {0x800D}
sub GLX_NO_EXTENSION () {3}
sub GLX_NV_float_buffer () {1}
sub GLX_OPTIMAL_PBUFFER_HEIGHT_SGIX () {0x801A}
sub GLX_OPTIMAL_PBUFFER_WIDTH_SGIX () {0x8019}
sub GLX_PBUFFER () {0x8023}
sub GLX_PBUFFER_BIT () {0x00000004}
sub GLX_PBUFFER_CLOBBER_MASK () {0x08000000}
sub GLX_PBUFFER_HEIGHT () {0x8040}
sub GLX_PBUFFER_WIDTH () {0x8041}
sub GLX_PIXMAP_BIT () {0x00000002}
sub GLX_PRESERVED_CONTENTS () {0x801B}
sub GLX_PSEUDO_COLOR () {0x8004}
sub GLX_PSEUDO_COLOR_EXT () {0x8004}
sub GLX_RED_SIZE () {8}
sub GLX_RENDER_TYPE () {0x8011}
sub GLX_RGBA () {4}
sub GLX_RGBA_BIT () {0x00000001}
sub GLX_RGBA_TYPE () {0x8014}
sub GLX_SAMPLES () {0x186a1}
sub GLX_SAMPLES_SGIS () {100001}
sub GLX_SAMPLE_BUFFERS () {0x186a0}
sub GLX_SAMPLE_BUFFERS_SGIS () {100000}
sub GLX_SAVED () {0x8021}
sub GLX_SCREEN () {0x800C}
sub GLX_SCREEN_EXT () {0x800C}
sub GLX_SHARE_CONTEXT_EXT () {0x800A}
sub GLX_SLOW_CONFIG () {0x8001}
sub GLX_SLOW_VISUAL_EXT () {0x8001}
sub GLX_STATIC_COLOR () {0x8005}
sub GLX_STATIC_COLOR_EXT () {0x8005}
sub GLX_STATIC_GRAY () {0x8007}
sub GLX_STATIC_GRAY_EXT () {0x8007}
sub GLX_STENCIL_BUFFER_BIT () {0x00000040}
sub GLX_STENCIL_SIZE () {13}
sub GLX_STEREO () {6}
sub GLX_SWAP_COPY_OML () {0x8062}
sub GLX_SWAP_EXCHANGE_OML () {0x8061}
sub GLX_SWAP_METHOD_OML () {0x8060}
sub GLX_SWAP_UNDEFINED_OML () {0x8063}
sub GLX_TEXTURE_1D_BIT_EXT () {0x00000001}
sub GLX_TEXTURE_1D_EXT () {0x20DB}
sub GLX_TEXTURE_2D_BIT_EXT () {0x00000002}
sub GLX_TEXTURE_2D_EXT () {0x20DC}
sub GLX_TEXTURE_FORMAT_EXT () {0x20D5}
sub GLX_TEXTURE_FORMAT_NONE_EXT () {0x20D8}
sub GLX_TEXTURE_FORMAT_RGBA_EXT () {0x20DA}
sub GLX_TEXTURE_FORMAT_RGB_EXT () {0x20D9}
sub GLX_TEXTURE_RECTANGLE_BIT_EXT () {0x00000004}
sub GLX_TEXTURE_RECTANGLE_EXT () {0x20DD}
sub GLX_TEXTURE_TARGET_EXT () {0x20D6}
sub GLX_TRANSPARENT_ALPHA_VALUE () {0x28}
sub GLX_TRANSPARENT_ALPHA_VALUE_EXT () {0x28}
sub GLX_TRANSPARENT_BLUE_VALUE () {0x27}
sub GLX_TRANSPARENT_BLUE_VALUE_EXT () {0x27}
sub GLX_TRANSPARENT_GREEN_VALUE () {0x26}
sub GLX_TRANSPARENT_GREEN_VALUE_EXT () {0x26}
sub GLX_TRANSPARENT_INDEX () {0x8009}
sub GLX_TRANSPARENT_INDEX_EXT () {0x8009}
sub GLX_TRANSPARENT_INDEX_VALUE () {0x24}
sub GLX_TRANSPARENT_INDEX_VALUE_EXT () {0x24}
sub GLX_TRANSPARENT_RED_VALUE () {0x25}
sub GLX_TRANSPARENT_RED_VALUE_EXT () {0x25}
sub GLX_TRANSPARENT_RGB () {0x8008}
sub GLX_TRANSPARENT_RGB_EXT () {0x8008}
sub GLX_TRANSPARENT_TYPE () {0x23}
sub GLX_TRANSPARENT_TYPE_EXT () {0x23}
sub GLX_TRUE_COLOR () {0x8002}
sub GLX_TRUE_COLOR_EXT () {0x8002}
sub GLX_USE_GL () {1}
sub GLX_VENDOR () {0x1}
sub GLX_VERSION () {0x2}
sub GLX_VERSION_1_1 () {1}
sub GLX_VERSION_1_2 () {1}
sub GLX_VERSION_1_3 () {1}
sub GLX_VERSION_1_4 () {1}
sub GLX_VISUAL_CAVEAT_EXT () {0x20}
sub GLX_VISUAL_ID () {0x800B}
sub GLX_VISUAL_ID_EXT () {0x800B}
sub GLX_VISUAL_SELECT_GROUP_SGIX () {0x8028}
sub GLX_WIDTH () {0x801D}
sub GLX_WINDOW () {0x8022}
sub GLX_WINDOW_BIT () {0x00000001}
sub GLX_X_RENDERABLE () {0x8012}
sub GLX_X_VISUAL_TYPE () {0x22}
sub GLX_X_VISUAL_TYPE_EXT () {0x22}
sub GLX_Y_INVERTED_EXT () {0x20D4}
sub GL_2D () {0x0600}
sub GL_2_BYTES () {0x1407}
sub GL_3D () {0x0601}
sub GL_3D_COLOR () {0x0602}
sub GL_3D_COLOR_TEXTURE () {0x0603}
sub GL_3_BYTES () {0x1408}
sub GL_4D_COLOR_TEXTURE () {0x0604}
sub GL_4_BYTES () {0x1409}
sub GL_ACCUM () {0x0100}
sub GL_ACCUM_ALPHA_BITS () {0x0D5B}
sub GL_ACCUM_BLUE_BITS () {0x0D5A}
sub GL_ACCUM_BUFFER_BIT () {0x00000200}
sub GL_ACCUM_CLEAR_VALUE () {0x0B80}
sub GL_ACCUM_GREEN_BITS () {0x0D59}
sub GL_ACCUM_RED_BITS () {0x0D58}
sub GL_ACTIVE_TEXTURE () {0x84E0}
sub GL_ACTIVE_TEXTURE_ARB () {0x84E0}
sub GL_ADD () {0x0104}
sub GL_ADD_SIGNED () {0x8574}
sub GL_ALIASED_LINE_WIDTH_RANGE () {0x846E}
sub GL_ALIASED_POINT_SIZE_RANGE () {0x846D}
sub GL_ALL_ATTRIB_BITS () {0x000FFFFF}
sub GL_ALL_CLIENT_ATTRIB_BITS () {0xFFFFFFFF}
sub GL_ALPHA () {0x1906}
sub GL_ALPHA12 () {0x803D}
sub GL_ALPHA16 () {0x803E}
sub GL_ALPHA4 () {0x803B}
sub GL_ALPHA8 () {0x803C}
sub GL_ALPHA_BIAS () {0x0D1D}
sub GL_ALPHA_BITS () {0x0D55}
sub GL_ALPHA_BLEND_EQUATION_ATI () {0x883D}
sub GL_ALPHA_SCALE () {0x0D1C}
sub GL_ALPHA_TEST () {0x0BC0}
sub GL_ALPHA_TEST_FUNC () {0x0BC1}
sub GL_ALPHA_TEST_REF () {0x0BC2}
sub GL_ALWAYS () {0x0207}
sub GL_AMBIENT () {0x1200}
sub GL_AMBIENT_AND_DIFFUSE () {0x1602}
sub GL_AND () {0x1501}
sub GL_AND_INVERTED () {0x1504}
sub GL_AND_REVERSE () {0x1502}
sub GL_ARB_imaging () {1}
sub GL_ARB_multitexture () {1}
sub GL_ATI_blend_equation_separate () {1}
sub GL_ATTRIB_STACK_DEPTH () {0x0BB0}
sub GL_AUTO_NORMAL () {0x0D80}
sub GL_AUX0 () {0x0409}
sub GL_AUX1 () {0x040A}
sub GL_AUX2 () {0x040B}
sub GL_AUX3 () {0x040C}
sub GL_AUX_BUFFERS () {0x0C00}
sub GL_BACK () {0x0405}
sub GL_BACK_LEFT () {0x0402}
sub GL_BACK_RIGHT () {0x0403}
sub GL_BGR () {0x80E0}
sub GL_BGRA () {0x80E1}
sub GL_BITMAP () {0x1A00}
sub GL_BITMAP_TOKEN () {0x0704}
sub GL_BLEND () {0x0BE2}
sub GL_BLEND_COLOR () {0x8005}
sub GL_BLEND_DST () {0x0BE0}
sub GL_BLEND_EQUATION () {0x8009}
sub GL_BLEND_SRC () {0x0BE1}
sub GL_BLUE () {0x1905}
sub GL_BLUE_BIAS () {0x0D1B}
sub GL_BLUE_BITS () {0x0D54}
sub GL_BLUE_SCALE () {0x0D1A}
sub GL_BYTE () {0x1400}
sub GL_C3F_V3F () {0x2A24}
sub GL_C4F_N3F_V3F () {0x2A26}
sub GL_C4UB_V2F () {0x2A22}
sub GL_C4UB_V3F () {0x2A23}
sub GL_CCW () {0x0901}
sub GL_CLAMP () {0x2900}
sub GL_CLAMP_TO_BORDER () {0x812D}
sub GL_CLAMP_TO_EDGE () {0x812F}
sub GL_CLEAR () {0x1500}
sub GL_CLIENT_ACTIVE_TEXTURE () {0x84E1}
sub GL_CLIENT_ACTIVE_TEXTURE_ARB () {0x84E1}
sub GL_CLIENT_ALL_ATTRIB_BITS () {0xFFFFFFFF}
sub GL_CLIENT_ATTRIB_STACK_DEPTH () {0x0BB1}
sub GL_CLIENT_PIXEL_STORE_BIT () {0x00000001}
sub GL_CLIENT_VERTEX_ARRAY_BIT () {0x00000002}
sub GL_CLIP_PLANE0 () {0x3000}
sub GL_CLIP_PLANE1 () {0x3001}
sub GL_CLIP_PLANE2 () {0x3002}
sub GL_CLIP_PLANE3 () {0x3003}
sub GL_CLIP_PLANE4 () {0x3004}
sub GL_CLIP_PLANE5 () {0x3005}
sub GL_COEFF () {0x0A00}
sub GL_COLOR () {0x1800}
sub GL_COLOR_ARRAY () {0x8076}
sub GL_COLOR_ARRAY_POINTER () {0x8090}
sub GL_COLOR_ARRAY_SIZE () {0x8081}
sub GL_COLOR_ARRAY_STRIDE () {0x8083}
sub GL_COLOR_ARRAY_TYPE () {0x8082}
sub GL_COLOR_BUFFER_BIT () {0x00004000}
sub GL_COLOR_CLEAR_VALUE () {0x0C22}
sub GL_COLOR_INDEX () {0x1900}
sub GL_COLOR_INDEXES () {0x1603}
sub GL_COLOR_LOGIC_OP () {0x0BF2}
sub GL_COLOR_MATERIAL () {0x0B57}
sub GL_COLOR_MATERIAL_FACE () {0x0B55}
sub GL_COLOR_MATERIAL_PARAMETER () {0x0B56}
sub GL_COLOR_MATRIX () {0x80B1}
sub GL_COLOR_MATRIX_STACK_DEPTH () {0x80B2}
sub GL_COLOR_TABLE () {0x80D0}
sub GL_COLOR_TABLE_ALPHA_SIZE () {0x80DD}
sub GL_COLOR_TABLE_BIAS () {0x80D7}
sub GL_COLOR_TABLE_BLUE_SIZE () {0x80DC}
sub GL_COLOR_TABLE_FORMAT () {0x80D8}
sub GL_COLOR_TABLE_GREEN_SIZE () {0x80DB}
sub GL_COLOR_TABLE_INTENSITY_SIZE () {0x80DF}
sub GL_COLOR_TABLE_LUMINANCE_SIZE () {0x80DE}
sub GL_COLOR_TABLE_RED_SIZE () {0x80DA}
sub GL_COLOR_TABLE_SCALE () {0x80D6}
sub GL_COLOR_TABLE_WIDTH () {0x80D9}
sub GL_COLOR_WRITEMASK () {0x0C23}
sub GL_COMBINE () {0x8570}
sub GL_COMBINE_ALPHA () {0x8572}
sub GL_COMBINE_RGB () {0x8571}
sub GL_COMPILE () {0x1300}
sub GL_COMPILE_AND_EXECUTE () {0x1301}
sub GL_COMPRESSED_ALPHA () {0x84E9}
sub GL_COMPRESSED_INTENSITY () {0x84EC}
sub GL_COMPRESSED_LUMINANCE () {0x84EA}
sub GL_COMPRESSED_LUMINANCE_ALPHA () {0x84EB}
sub GL_COMPRESSED_RGB () {0x84ED}
sub GL_COMPRESSED_RGBA () {0x84EE}
sub GL_COMPRESSED_TEXTURE_FORMATS () {0x86A3}
sub GL_CONSTANT () {0x8576}
sub GL_CONSTANT_ALPHA () {0x8003}
sub GL_CONSTANT_ATTENUATION () {0x1207}
sub GL_CONSTANT_BORDER () {0x8151}
sub GL_CONSTANT_COLOR () {0x8001}
sub GL_CONVOLUTION_1D () {0x8010}
sub GL_CONVOLUTION_2D () {0x8011}
sub GL_CONVOLUTION_BORDER_COLOR () {0x8154}
sub GL_CONVOLUTION_BORDER_MODE () {0x8013}
sub GL_CONVOLUTION_FILTER_BIAS () {0x8015}
sub GL_CONVOLUTION_FILTER_SCALE () {0x8014}
sub GL_CONVOLUTION_FORMAT () {0x8017}
sub GL_CONVOLUTION_HEIGHT () {0x8019}
sub GL_CONVOLUTION_WIDTH () {0x8018}
sub GL_COPY () {0x1503}
sub GL_COPY_INVERTED () {0x150C}
sub GL_COPY_PIXEL_TOKEN () {0x0706}
sub GL_CULL_FACE () {0x0B44}
sub GL_CULL_FACE_MODE () {0x0B45}
sub GL_CURRENT_BIT () {0x00000001}
sub GL_CURRENT_COLOR () {0x0B00}
sub GL_CURRENT_INDEX () {0x0B01}
sub GL_CURRENT_NORMAL () {0x0B02}
sub GL_CURRENT_RASTER_COLOR () {0x0B04}
sub GL_CURRENT_RASTER_DISTANCE () {0x0B09}
sub GL_CURRENT_RASTER_INDEX () {0x0B05}
sub GL_CURRENT_RASTER_POSITION () {0x0B07}
sub GL_CURRENT_RASTER_POSITION_VALID () {0x0B08}
sub GL_CURRENT_RASTER_TEXTURE_COORDS () {0x0B06}
sub GL_CURRENT_TEXTURE_COORDS () {0x0B03}
sub GL_CW () {0x0900}
sub GL_DEBUG_ASSERT_MESA () {0x875B}
sub GL_DEBUG_OBJECT_MESA () {0x8759}
sub GL_DEBUG_PRINT_MESA () {0x875A}
sub GL_DECAL () {0x2101}
sub GL_DECR () {0x1E03}
sub GL_DEPTH () {0x1801}
sub GL_DEPTH_BIAS () {0x0D1F}
sub GL_DEPTH_BITS () {0x0D56}
sub GL_DEPTH_BUFFER_BIT () {0x00000100}
sub GL_DEPTH_CLEAR_VALUE () {0x0B73}
sub GL_DEPTH_COMPONENT () {0x1902}
sub GL_DEPTH_FUNC () {0x0B74}
sub GL_DEPTH_RANGE () {0x0B70}
sub GL_DEPTH_SCALE () {0x0D1E}
sub GL_DEPTH_STENCIL_MESA () {0x8750}
sub GL_DEPTH_TEST () {0x0B71}
sub GL_DEPTH_WRITEMASK () {0x0B72}
sub GL_DIFFUSE () {0x1201}
sub GL_DITHER () {0x0BD0}
sub GL_DOMAIN () {0x0A02}
sub GL_DONT_CARE () {0x1100}
sub GL_DOT3_RGB () {0x86AE}
sub GL_DOT3_RGBA () {0x86AF}
sub GL_DOUBLE () {0x140A}
sub GL_DOUBLEBUFFER () {0x0C32}
sub GL_DRAW_BUFFER () {0x0C01}
sub GL_DRAW_PIXEL_TOKEN () {0x0705}
sub GL_DST_ALPHA () {0x0304}
sub GL_DST_COLOR () {0x0306}
sub GL_EDGE_FLAG () {0x0B43}
sub GL_EDGE_FLAG_ARRAY () {0x8079}
sub GL_EDGE_FLAG_ARRAY_POINTER () {0x8093}
sub GL_EDGE_FLAG_ARRAY_STRIDE () {0x808C}
sub GL_EMISSION () {0x1600}
sub GL_ENABLE_BIT () {0x00002000}
sub GL_EQUAL () {0x0202}
sub GL_EQUIV () {0x1509}
sub GL_EVAL_BIT () {0x00010000}
sub GL_EXP () {0x0800}
sub GL_EXP2 () {0x0801}
sub GL_EXTENSIONS () {0x1F03}
sub GL_EYE_LINEAR () {0x2400}
sub GL_EYE_PLANE () {0x2502}
sub GL_FALSE () {0x0}
sub GL_FASTEST () {0x1101}
sub GL_FEEDBACK () {0x1C01}
sub GL_FEEDBACK_BUFFER_POINTER () {0x0DF0}
sub GL_FEEDBACK_BUFFER_SIZE () {0x0DF1}
sub GL_FEEDBACK_BUFFER_TYPE () {0x0DF2}
sub GL_FILL () {0x1B02}
sub GL_FLAT () {0x1D00}
sub GL_FLOAT () {0x1406}
sub GL_FOG () {0x0B60}
sub GL_FOG_BIT () {0x00000080}
sub GL_FOG_COLOR () {0x0B66}
sub GL_FOG_DENSITY () {0x0B62}
sub GL_FOG_END () {0x0B64}
sub GL_FOG_HINT () {0x0C54}
sub GL_FOG_INDEX () {0x0B61}
sub GL_FOG_MODE () {0x0B65}
sub GL_FOG_START () {0x0B63}
sub GL_FRAGMENT_PROGRAM_CALLBACK_DATA_MESA () {0x8bb3}
sub GL_FRAGMENT_PROGRAM_CALLBACK_FUNC_MESA () {0x8bb2}
sub GL_FRAGMENT_PROGRAM_CALLBACK_MESA () {0x8bb1}
sub GL_FRAGMENT_PROGRAM_POSITION_MESA () {0x8bb0}
sub GL_FRONT () {0x0404}
sub GL_FRONT_AND_BACK () {0x0408}
sub GL_FRONT_FACE () {0x0B46}
sub GL_FRONT_LEFT () {0x0400}
sub GL_FRONT_RIGHT () {0x0401}
sub GL_FUNC_ADD () {0x8006}
sub GL_FUNC_REVERSE_SUBTRACT () {0x800B}
sub GL_FUNC_SUBTRACT () {0x800A}
sub GL_GEQUAL () {0x0206}
sub GL_GREATER () {0x0204}
sub GL_GREEN () {0x1904}
sub GL_GREEN_BIAS () {0x0D19}
sub GL_GREEN_BITS () {0x0D53}
sub GL_GREEN_SCALE () {0x0D18}
sub GL_HINT_BIT () {0x00008000}
sub GL_HISTOGRAM () {0x8024}
sub GL_HISTOGRAM_ALPHA_SIZE () {0x802B}
sub GL_HISTOGRAM_BLUE_SIZE () {0x802A}
sub GL_HISTOGRAM_FORMAT () {0x8027}
sub GL_HISTOGRAM_GREEN_SIZE () {0x8029}
sub GL_HISTOGRAM_LUMINANCE_SIZE () {0x802C}
sub GL_HISTOGRAM_RED_SIZE () {0x8028}
sub GL_HISTOGRAM_SINK () {0x802D}
sub GL_HISTOGRAM_WIDTH () {0x8026}
sub GL_INCR () {0x1E02}
sub GL_INDEX_ARRAY () {0x8077}
sub GL_INDEX_ARRAY_POINTER () {0x8091}
sub GL_INDEX_ARRAY_STRIDE () {0x8086}
sub GL_INDEX_ARRAY_TYPE () {0x8085}
sub GL_INDEX_BITS () {0x0D51}
sub GL_INDEX_CLEAR_VALUE () {0x0C20}
sub GL_INDEX_LOGIC_OP () {0x0BF1}
sub GL_INDEX_MODE () {0x0C30}
sub GL_INDEX_OFFSET () {0x0D13}
sub GL_INDEX_SHIFT () {0x0D12}
sub GL_INDEX_WRITEMASK () {0x0C21}
sub GL_INT () {0x1404}
sub GL_INTENSITY () {0x8049}
sub GL_INTENSITY12 () {0x804C}
sub GL_INTENSITY16 () {0x804D}
sub GL_INTENSITY4 () {0x804A}
sub GL_INTENSITY8 () {0x804B}
sub GL_INTERPOLATE () {0x8575}
sub GL_INVALID_ENUM () {0x0500}
sub GL_INVALID_OPERATION () {0x0502}
sub GL_INVALID_VALUE () {0x0501}
sub GL_INVERT () {0x150A}
sub GL_KEEP () {0x1E00}
sub GL_LEFT () {0x0406}
sub GL_LEQUAL () {0x0203}
sub GL_LESS () {0x0201}
sub GL_LIGHT0 () {0x4000}
sub GL_LIGHT1 () {0x4001}
sub GL_LIGHT2 () {0x4002}
sub GL_LIGHT3 () {0x4003}
sub GL_LIGHT4 () {0x4004}
sub GL_LIGHT5 () {0x4005}
sub GL_LIGHT6 () {0x4006}
sub GL_LIGHT7 () {0x4007}
sub GL_LIGHTING () {0x0B50}
sub GL_LIGHTING_BIT () {0x00000040}
sub GL_LIGHT_MODEL_AMBIENT () {0x0B53}
sub GL_LIGHT_MODEL_COLOR_CONTROL () {0x81F8}
sub GL_LIGHT_MODEL_LOCAL_VIEWER () {0x0B51}
sub GL_LIGHT_MODEL_TWO_SIDE () {0x0B52}
sub GL_LINE () {0x1B01}
sub GL_LINEAR () {0x2601}
sub GL_LINEAR_ATTENUATION () {0x1208}
sub GL_LINEAR_MIPMAP_LINEAR () {0x2703}
sub GL_LINEAR_MIPMAP_NEAREST () {0x2701}
sub GL_LINES () {0x0001}
sub GL_LINE_BIT () {0x00000004}
sub GL_LINE_LOOP () {0x0002}
sub GL_LINE_RESET_TOKEN () {0x0707}
sub GL_LINE_SMOOTH () {0x0B20}
sub GL_LINE_SMOOTH_HINT () {0x0C52}
sub GL_LINE_STIPPLE () {0x0B24}
sub GL_LINE_STIPPLE_PATTERN () {0x0B25}
sub GL_LINE_STIPPLE_REPEAT () {0x0B26}
sub GL_LINE_STRIP () {0x0003}
sub GL_LINE_TOKEN () {0x0702}
sub GL_LINE_WIDTH () {0x0B21}
sub GL_LINE_WIDTH_GRANULARITY () {0x0B23}
sub GL_LINE_WIDTH_RANGE () {0x0B22}
sub GL_LIST_BASE () {0x0B32}
sub GL_LIST_BIT () {0x00020000}
sub GL_LIST_INDEX () {0x0B33}
sub GL_LIST_MODE () {0x0B30}
sub GL_LOAD () {0x0101}
sub GL_LOGIC_OP () {0x0BF1}
sub GL_LOGIC_OP_MODE () {0x0BF0}
sub GL_LUMINANCE () {0x1909}
sub GL_LUMINANCE12 () {0x8041}
sub GL_LUMINANCE12_ALPHA12 () {0x8047}
sub GL_LUMINANCE12_ALPHA4 () {0x8046}
sub GL_LUMINANCE16 () {0x8042}
sub GL_LUMINANCE16_ALPHA16 () {0x8048}
sub GL_LUMINANCE4 () {0x803F}
sub GL_LUMINANCE4_ALPHA4 () {0x8043}
sub GL_LUMINANCE6_ALPHA2 () {0x8044}
sub GL_LUMINANCE8 () {0x8040}
sub GL_LUMINANCE8_ALPHA8 () {0x8045}
sub GL_LUMINANCE_ALPHA () {0x190A}
sub GL_MAP1_COLOR_4 () {0x0D90}
sub GL_MAP1_GRID_DOMAIN () {0x0DD0}
sub GL_MAP1_GRID_SEGMENTS () {0x0DD1}
sub GL_MAP1_INDEX () {0x0D91}
sub GL_MAP1_NORMAL () {0x0D92}
sub GL_MAP1_TEXTURE_COORD_1 () {0x0D93}
sub GL_MAP1_TEXTURE_COORD_2 () {0x0D94}
sub GL_MAP1_TEXTURE_COORD_3 () {0x0D95}
sub GL_MAP1_TEXTURE_COORD_4 () {0x0D96}
sub GL_MAP1_VERTEX_3 () {0x0D97}
sub GL_MAP1_VERTEX_4 () {0x0D98}
sub GL_MAP2_COLOR_4 () {0x0DB0}
sub GL_MAP2_GRID_DOMAIN () {0x0DD2}
sub GL_MAP2_GRID_SEGMENTS () {0x0DD3}
sub GL_MAP2_INDEX () {0x0DB1}
sub GL_MAP2_NORMAL () {0x0DB2}
sub GL_MAP2_TEXTURE_COORD_1 () {0x0DB3}
sub GL_MAP2_TEXTURE_COORD_2 () {0x0DB4}
sub GL_MAP2_TEXTURE_COORD_3 () {0x0DB5}
sub GL_MAP2_TEXTURE_COORD_4 () {0x0DB6}
sub GL_MAP2_VERTEX_3 () {0x0DB7}
sub GL_MAP2_VERTEX_4 () {0x0DB8}
sub GL_MAP_COLOR () {0x0D10}
sub GL_MAP_STENCIL () {0x0D11}
sub GL_MATRIX_MODE () {0x0BA0}
sub GL_MAX () {0x8008}
sub GL_MAX_3D_TEXTURE_SIZE () {0x8073}
sub GL_MAX_ATTRIB_STACK_DEPTH () {0x0D35}
sub GL_MAX_CLIENT_ATTRIB_STACK_DEPTH () {0x0D3B}
sub GL_MAX_CLIP_PLANES () {0x0D32}
sub GL_MAX_COLOR_MATRIX_STACK_DEPTH () {0x80B3}
sub GL_MAX_CONVOLUTION_HEIGHT () {0x801B}
sub GL_MAX_CONVOLUTION_WIDTH () {0x801A}
sub GL_MAX_CUBE_MAP_TEXTURE_SIZE () {0x851C}
sub GL_MAX_ELEMENTS_INDICES () {0x80E9}
sub GL_MAX_ELEMENTS_VERTICES () {0x80E8}
sub GL_MAX_EVAL_ORDER () {0x0D30}
sub GL_MAX_LIGHTS () {0x0D31}
sub GL_MAX_LIST_NESTING () {0x0B31}
sub GL_MAX_MODELVIEW_STACK_DEPTH () {0x0D36}
sub GL_MAX_NAME_STACK_DEPTH () {0x0D37}
sub GL_MAX_PIXEL_MAP_TABLE () {0x0D34}
sub GL_MAX_PROJECTION_STACK_DEPTH () {0x0D38}
sub GL_MAX_TEXTURE_SIZE () {0x0D33}
sub GL_MAX_TEXTURE_STACK_DEPTH () {0x0D39}
sub GL_MAX_TEXTURE_UNITS () {0x84E2}
sub GL_MAX_TEXTURE_UNITS_ARB () {0x84E2}
sub GL_MAX_VIEWPORT_DIMS () {0x0D3A}
sub GL_MESA_packed_depth_stencil () {1}
sub GL_MESA_program_debug () {1}
sub GL_MESA_shader_debug () {1}
sub GL_MESA_trace () {1}
sub GL_MIN () {0x8007}
sub GL_MINMAX () {0x802E}
sub GL_MINMAX_FORMAT () {0x802F}
sub GL_MINMAX_SINK () {0x8030}
sub GL_MODELVIEW () {0x1700}
sub GL_MODELVIEW_MATRIX () {0x0BA6}
sub GL_MODELVIEW_STACK_DEPTH () {0x0BA3}
sub GL_MODULATE () {0x2100}
sub GL_MULT () {0x0103}
sub GL_MULTISAMPLE () {0x809D}
sub GL_MULTISAMPLE_BIT () {0x20000000}
sub GL_N3F_V3F () {0x2A25}
sub GL_NAME_STACK_DEPTH () {0x0D70}
sub GL_NAND () {0x150E}
sub GL_NEAREST () {0x2600}
sub GL_NEAREST_MIPMAP_LINEAR () {0x2702}
sub GL_NEAREST_MIPMAP_NEAREST () {0x2700}
sub GL_NEVER () {0x0200}
sub GL_NICEST () {0x1102}
sub GL_NONE () {0x0}
sub GL_NOOP () {0x1505}
sub GL_NOR () {0x1508}
sub GL_NORMALIZE () {0x0BA1}
sub GL_NORMAL_ARRAY () {0x8075}
sub GL_NORMAL_ARRAY_POINTER () {0x808F}
sub GL_NORMAL_ARRAY_STRIDE () {0x807F}
sub GL_NORMAL_ARRAY_TYPE () {0x807E}
sub GL_NORMAL_MAP () {0x8511}
sub GL_NOTEQUAL () {0x0205}
sub GL_NO_ERROR () {0x0}
sub GL_NUM_COMPRESSED_TEXTURE_FORMATS () {0x86A2}
sub GL_OBJECT_LINEAR () {0x2401}
sub GL_OBJECT_PLANE () {0x2501}
sub GL_ONE () {0x1}
sub GL_ONE_MINUS_CONSTANT_ALPHA () {0x8004}
sub GL_ONE_MINUS_CONSTANT_COLOR () {0x8002}
sub GL_ONE_MINUS_DST_ALPHA () {0x0305}
sub GL_ONE_MINUS_DST_COLOR () {0x0307}
sub GL_ONE_MINUS_SRC_ALPHA () {0x0303}
sub GL_ONE_MINUS_SRC_COLOR () {0x0301}
sub GL_OPERAND0_ALPHA () {0x8598}
sub GL_OPERAND0_RGB () {0x8590}
sub GL_OPERAND1_ALPHA () {0x8599}
sub GL_OPERAND1_RGB () {0x8591}
sub GL_OPERAND2_ALPHA () {0x859A}
sub GL_OPERAND2_RGB () {0x8592}
sub GL_OR () {0x1507}
sub GL_ORDER () {0x0A01}
sub GL_OR_INVERTED () {0x150D}
sub GL_OR_REVERSE () {0x150B}
sub GL_OUT_OF_MEMORY () {0x0505}
sub GL_PACK_ALIGNMENT () {0x0D05}
sub GL_PACK_IMAGE_HEIGHT () {0x806C}
sub GL_PACK_LSB_FIRST () {0x0D01}
sub GL_PACK_ROW_LENGTH () {0x0D02}
sub GL_PACK_SKIP_IMAGES () {0x806B}
sub GL_PACK_SKIP_PIXELS () {0x0D04}
sub GL_PACK_SKIP_ROWS () {0x0D03}
sub GL_PACK_SWAP_BYTES () {0x0D00}
sub GL_PASS_THROUGH_TOKEN () {0x0700}
sub GL_PERSPECTIVE_CORRECTION_HINT () {0x0C50}
sub GL_PIXEL_MAP_A_TO_A () {0x0C79}
sub GL_PIXEL_MAP_A_TO_A_SIZE () {0x0CB9}
sub GL_PIXEL_MAP_B_TO_B () {0x0C78}
sub GL_PIXEL_MAP_B_TO_B_SIZE () {0x0CB8}
sub GL_PIXEL_MAP_G_TO_G () {0x0C77}
sub GL_PIXEL_MAP_G_TO_G_SIZE () {0x0CB7}
sub GL_PIXEL_MAP_I_TO_A () {0x0C75}
sub GL_PIXEL_MAP_I_TO_A_SIZE () {0x0CB5}
sub GL_PIXEL_MAP_I_TO_B () {0x0C74}
sub GL_PIXEL_MAP_I_TO_B_SIZE () {0x0CB4}
sub GL_PIXEL_MAP_I_TO_G () {0x0C73}
sub GL_PIXEL_MAP_I_TO_G_SIZE () {0x0CB3}
sub GL_PIXEL_MAP_I_TO_I () {0x0C70}
sub GL_PIXEL_MAP_I_TO_I_SIZE () {0x0CB0}
sub GL_PIXEL_MAP_I_TO_R () {0x0C72}
sub GL_PIXEL_MAP_I_TO_R_SIZE () {0x0CB2}
sub GL_PIXEL_MAP_R_TO_R () {0x0C76}
sub GL_PIXEL_MAP_R_TO_R_SIZE () {0x0CB6}
sub GL_PIXEL_MAP_S_TO_S () {0x0C71}
sub GL_PIXEL_MAP_S_TO_S_SIZE () {0x0CB1}
sub GL_PIXEL_MODE_BIT () {0x00000020}
sub GL_POINT () {0x1B00}
sub GL_POINTS () {0x0000}
sub GL_POINT_BIT () {0x00000002}
sub GL_POINT_SIZE () {0x0B11}
sub GL_POINT_SIZE_GRANULARITY () {0x0B13}
sub GL_POINT_SIZE_RANGE () {0x0B12}
sub GL_POINT_SMOOTH () {0x0B10}
sub GL_POINT_SMOOTH_HINT () {0x0C51}
sub GL_POINT_TOKEN () {0x0701}
sub GL_POLYGON () {0x0009}
sub GL_POLYGON_BIT () {0x00000008}
sub GL_POLYGON_MODE () {0x0B40}
sub GL_POLYGON_OFFSET_FACTOR () {0x8038}
sub GL_POLYGON_OFFSET_FILL () {0x8037}
sub GL_POLYGON_OFFSET_LINE () {0x2A02}
sub GL_POLYGON_OFFSET_POINT () {0x2A01}
sub GL_POLYGON_OFFSET_UNITS () {0x2A00}
sub GL_POLYGON_SMOOTH () {0x0B41}
sub GL_POLYGON_SMOOTH_HINT () {0x0C53}
sub GL_POLYGON_STIPPLE () {0x0B42}
sub GL_POLYGON_STIPPLE_BIT () {0x00000010}
sub GL_POLYGON_TOKEN () {0x0703}
sub GL_POSITION () {0x1203}
sub GL_POST_COLOR_MATRIX_ALPHA_BIAS () {0x80BB}
sub GL_POST_COLOR_MATRIX_ALPHA_SCALE () {0x80B7}
sub GL_POST_COLOR_MATRIX_BLUE_BIAS () {0x80BA}
sub GL_POST_COLOR_MATRIX_BLUE_SCALE () {0x80B6}
sub GL_POST_COLOR_MATRIX_COLOR_TABLE () {0x80D2}
sub GL_POST_COLOR_MATRIX_GREEN_BIAS () {0x80B9}
sub GL_POST_COLOR_MATRIX_GREEN_SCALE () {0x80B5}
sub GL_POST_COLOR_MATRIX_RED_BIAS () {0x80B8}
sub GL_POST_COLOR_MATRIX_RED_SCALE () {0x80B4}
sub GL_POST_CONVOLUTION_ALPHA_BIAS () {0x8023}
sub GL_POST_CONVOLUTION_ALPHA_SCALE () {0x801F}
sub GL_POST_CONVOLUTION_BLUE_BIAS () {0x8022}
sub GL_POST_CONVOLUTION_BLUE_SCALE () {0x801E}
sub GL_POST_CONVOLUTION_COLOR_TABLE () {0x80D1}
sub GL_POST_CONVOLUTION_GREEN_BIAS () {0x8021}
sub GL_POST_CONVOLUTION_GREEN_SCALE () {0x801D}
sub GL_POST_CONVOLUTION_RED_BIAS () {0x8020}
sub GL_POST_CONVOLUTION_RED_SCALE () {0x801C}
sub GL_PREVIOUS () {0x8578}
sub GL_PRIMARY_COLOR () {0x8577}
sub GL_PROJECTION () {0x1701}
sub GL_PROJECTION_MATRIX () {0x0BA7}
sub GL_PROJECTION_STACK_DEPTH () {0x0BA4}
sub GL_PROXY_COLOR_TABLE () {0x80D3}
sub GL_PROXY_HISTOGRAM () {0x8025}
sub GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE () {0x80D5}
sub GL_PROXY_POST_CONVOLUTION_COLOR_TABLE () {0x80D4}
sub GL_PROXY_TEXTURE_1D () {0x8063}
sub GL_PROXY_TEXTURE_2D () {0x8064}
sub GL_PROXY_TEXTURE_3D () {0x8070}
sub GL_PROXY_TEXTURE_CUBE_MAP () {0x851B}
sub GL_Q () {0x2003}
sub GL_QUADRATIC_ATTENUATION () {0x1209}
sub GL_QUADS () {0x0007}
sub GL_QUAD_STRIP () {0x0008}
sub GL_R () {0x2002}
sub GL_R3_G3_B2 () {0x2A10}
sub GL_READ_BUFFER () {0x0C02}
sub GL_RED () {0x1903}
sub GL_REDUCE () {0x8016}
sub GL_RED_BIAS () {0x0D15}
sub GL_RED_BITS () {0x0D52}
sub GL_RED_SCALE () {0x0D14}
sub GL_REFLECTION_MAP () {0x8512}
sub GL_RENDER () {0x1C00}
sub GL_RENDERER () {0x1F01}
sub GL_RENDER_MODE () {0x0C40}
sub GL_REPEAT () {0x2901}
sub GL_REPLACE () {0x1E01}
sub GL_REPLICATE_BORDER () {0x8153}
sub GL_RESCALE_NORMAL () {0x803A}
sub GL_RETURN () {0x0102}
sub GL_RGB () {0x1907}
sub GL_RGB10 () {0x8052}
sub GL_RGB10_A2 () {0x8059}
sub GL_RGB12 () {0x8053}
sub GL_RGB16 () {0x8054}
sub GL_RGB4 () {0x804F}
sub GL_RGB5 () {0x8050}
sub GL_RGB5_A1 () {0x8057}
sub GL_RGB8 () {0x8051}
sub GL_RGBA () {0x1908}
sub GL_RGBA12 () {0x805A}
sub GL_RGBA16 () {0x805B}
sub GL_RGBA2 () {0x8055}
sub GL_RGBA4 () {0x8056}
sub GL_RGBA8 () {0x8058}
sub GL_RGBA_MODE () {0x0C31}
sub GL_RGB_SCALE () {0x8573}
sub GL_RIGHT () {0x0407}
sub GL_S () {0x2000}
sub GL_SAMPLES () {0x80A9}
sub GL_SAMPLE_ALPHA_TO_COVERAGE () {0x809E}
sub GL_SAMPLE_ALPHA_TO_ONE () {0x809F}
sub GL_SAMPLE_BUFFERS () {0x80A8}
sub GL_SAMPLE_COVERAGE () {0x80A0}
sub GL_SAMPLE_COVERAGE_INVERT () {0x80AB}
sub GL_SAMPLE_COVERAGE_VALUE () {0x80AA}
sub GL_SCISSOR_BIT () {0x00080000}
sub GL_SCISSOR_BOX () {0x0C10}
sub GL_SCISSOR_TEST () {0x0C11}
sub GL_SELECT () {0x1C02}
sub GL_SELECTION_BUFFER_POINTER () {0x0DF3}
sub GL_SELECTION_BUFFER_SIZE () {0x0DF4}
sub GL_SEPARABLE_2D () {0x8012}
sub GL_SEPARATE_SPECULAR_COLOR () {0x81FA}
sub GL_SET () {0x150F}
sub GL_SHADE_MODEL () {0x0B54}
sub GL_SHININESS () {0x1601}
sub GL_SHORT () {0x1402}
sub GL_SINGLE_COLOR () {0x81F9}
sub GL_SMOOTH () {0x1D01}
sub GL_SMOOTH_LINE_WIDTH_GRANULARITY () {0x0B23}
sub GL_SMOOTH_LINE_WIDTH_RANGE () {0x0B22}
sub GL_SMOOTH_POINT_SIZE_GRANULARITY () {0x0B13}
sub GL_SMOOTH_POINT_SIZE_RANGE () {0x0B12}
sub GL_SOURCE0_ALPHA () {0x8588}
sub GL_SOURCE0_RGB () {0x8580}
sub GL_SOURCE1_ALPHA () {0x8589}
sub GL_SOURCE1_RGB () {0x8581}
sub GL_SOURCE2_ALPHA () {0x858A}
sub GL_SOURCE2_RGB () {0x8582}
sub GL_SPECULAR () {0x1202}
sub GL_SPHERE_MAP () {0x2402}
sub GL_SPOT_CUTOFF () {0x1206}
sub GL_SPOT_DIRECTION () {0x1204}
sub GL_SPOT_EXPONENT () {0x1205}
sub GL_SRC_ALPHA () {0x0302}
sub GL_SRC_ALPHA_SATURATE () {0x0308}
sub GL_SRC_COLOR () {0x0300}
sub GL_STACK_OVERFLOW () {0x0503}
sub GL_STACK_UNDERFLOW () {0x0504}
sub GL_STENCIL () {0x1802}
sub GL_STENCIL_BITS () {0x0D57}
sub GL_STENCIL_BUFFER_BIT () {0x00000400}
sub GL_STENCIL_CLEAR_VALUE () {0x0B91}
sub GL_STENCIL_FAIL () {0x0B94}
sub GL_STENCIL_FUNC () {0x0B92}
sub GL_STENCIL_INDEX () {0x1901}
sub GL_STENCIL_PASS_DEPTH_FAIL () {0x0B95}
sub GL_STENCIL_PASS_DEPTH_PASS () {0x0B96}
sub GL_STENCIL_REF () {0x0B97}
sub GL_STENCIL_TEST () {0x0B90}
sub GL_STENCIL_VALUE_MASK () {0x0B93}
sub GL_STENCIL_WRITEMASK () {0x0B98}
sub GL_STEREO () {0x0C33}
sub GL_SUBPIXEL_BITS () {0x0D50}
sub GL_SUBTRACT () {0x84E7}
sub GL_T () {0x2001}
sub GL_T2F_C3F_V3F () {0x2A2A}
sub GL_T2F_C4F_N3F_V3F () {0x2A2C}
sub GL_T2F_C4UB_V3F () {0x2A29}
sub GL_T2F_N3F_V3F () {0x2A2B}
sub GL_T2F_V3F () {0x2A27}
sub GL_T4F_C4F_N3F_V4F () {0x2A2D}
sub GL_T4F_V4F () {0x2A28}
sub GL_TABLE_TOO_LARGE () {0x8031}
sub GL_TEXTURE () {0x1702}
sub GL_TEXTURE0 () {0x84C0}
sub GL_TEXTURE0_ARB () {0x84C0}
sub GL_TEXTURE1 () {0x84C1}
sub GL_TEXTURE10 () {0x84CA}
sub GL_TEXTURE10_ARB () {0x84CA}
sub GL_TEXTURE11 () {0x84CB}
sub GL_TEXTURE11_ARB () {0x84CB}
sub GL_TEXTURE12 () {0x84CC}
sub GL_TEXTURE12_ARB () {0x84CC}
sub GL_TEXTURE13 () {0x84CD}
sub GL_TEXTURE13_ARB () {0x84CD}
sub GL_TEXTURE14 () {0x84CE}
sub GL_TEXTURE14_ARB () {0x84CE}
sub GL_TEXTURE15 () {0x84CF}
sub GL_TEXTURE15_ARB () {0x84CF}
sub GL_TEXTURE16 () {0x84D0}
sub GL_TEXTURE16_ARB () {0x84D0}
sub GL_TEXTURE17 () {0x84D1}
sub GL_TEXTURE17_ARB () {0x84D1}
sub GL_TEXTURE18 () {0x84D2}
sub GL_TEXTURE18_ARB () {0x84D2}
sub GL_TEXTURE19 () {0x84D3}
sub GL_TEXTURE19_ARB () {0x84D3}
sub GL_TEXTURE1_ARB () {0x84C1}
sub GL_TEXTURE2 () {0x84C2}
sub GL_TEXTURE20 () {0x84D4}
sub GL_TEXTURE20_ARB () {0x84D4}
sub GL_TEXTURE21 () {0x84D5}
sub GL_TEXTURE21_ARB () {0x84D5}
sub GL_TEXTURE22 () {0x84D6}
sub GL_TEXTURE22_ARB () {0x84D6}
sub GL_TEXTURE23 () {0x84D7}
sub GL_TEXTURE23_ARB () {0x84D7}
sub GL_TEXTURE24 () {0x84D8}
sub GL_TEXTURE24_ARB () {0x84D8}
sub GL_TEXTURE25 () {0x84D9}
sub GL_TEXTURE25_ARB () {0x84D9}
sub GL_TEXTURE26 () {0x84DA}
sub GL_TEXTURE26_ARB () {0x84DA}
sub GL_TEXTURE27 () {0x84DB}
sub GL_TEXTURE27_ARB () {0x84DB}
sub GL_TEXTURE28 () {0x84DC}
sub GL_TEXTURE28_ARB () {0x84DC}
sub GL_TEXTURE29 () {0x84DD}
sub GL_TEXTURE29_ARB () {0x84DD}
sub GL_TEXTURE2_ARB () {0x84C2}
sub GL_TEXTURE3 () {0x84C3}
sub GL_TEXTURE30 () {0x84DE}
sub GL_TEXTURE30_ARB () {0x84DE}
sub GL_TEXTURE31 () {0x84DF}
sub GL_TEXTURE31_ARB () {0x84DF}
sub GL_TEXTURE3_ARB () {0x84C3}
sub GL_TEXTURE4 () {0x84C4}
sub GL_TEXTURE4_ARB () {0x84C4}
sub GL_TEXTURE5 () {0x84C5}
sub GL_TEXTURE5_ARB () {0x84C5}
sub GL_TEXTURE6 () {0x84C6}
sub GL_TEXTURE6_ARB () {0x84C6}
sub GL_TEXTURE7 () {0x84C7}
sub GL_TEXTURE7_ARB () {0x84C7}
sub GL_TEXTURE8 () {0x84C8}
sub GL_TEXTURE8_ARB () {0x84C8}
sub GL_TEXTURE9 () {0x84C9}
sub GL_TEXTURE9_ARB () {0x84C9}
sub GL_TEXTURE_1D () {0x0DE0}
sub GL_TEXTURE_2D () {0x0DE1}
sub GL_TEXTURE_3D () {0x806F}
sub GL_TEXTURE_ALPHA_SIZE () {0x805F}
sub GL_TEXTURE_BASE_LEVEL () {0x813C}
sub GL_TEXTURE_BINDING_1D () {0x8068}
sub GL_TEXTURE_BINDING_2D () {0x8069}
sub GL_TEXTURE_BINDING_3D () {0x806A}
sub GL_TEXTURE_BINDING_CUBE_MAP () {0x8514}
sub GL_TEXTURE_BIT () {0x00040000}
sub GL_TEXTURE_BLUE_SIZE () {0x805E}
sub GL_TEXTURE_BORDER () {0x1005}
sub GL_TEXTURE_BORDER_COLOR () {0x1004}
sub GL_TEXTURE_COMPONENTS () {0x1003}
sub GL_TEXTURE_COMPRESSED () {0x86A1}
sub GL_TEXTURE_COMPRESSED_IMAGE_SIZE () {0x86A0}
sub GL_TEXTURE_COMPRESSION_HINT () {0x84EF}
sub GL_TEXTURE_COORD_ARRAY () {0x8078}
sub GL_TEXTURE_COORD_ARRAY_POINTER () {0x8092}
sub GL_TEXTURE_COORD_ARRAY_SIZE () {0x8088}
sub GL_TEXTURE_COORD_ARRAY_STRIDE () {0x808A}
sub GL_TEXTURE_COORD_ARRAY_TYPE () {0x8089}
sub GL_TEXTURE_CUBE_MAP () {0x8513}
sub GL_TEXTURE_CUBE_MAP_NEGATIVE_X () {0x8516}
sub GL_TEXTURE_CUBE_MAP_NEGATIVE_Y () {0x8518}
sub GL_TEXTURE_CUBE_MAP_NEGATIVE_Z () {0x851A}
sub GL_TEXTURE_CUBE_MAP_POSITIVE_X () {0x8515}
sub GL_TEXTURE_CUBE_MAP_POSITIVE_Y () {0x8517}
sub GL_TEXTURE_CUBE_MAP_POSITIVE_Z () {0x8519}
sub GL_TEXTURE_DEPTH () {0x8071}
sub GL_TEXTURE_ENV () {0x2300}
sub GL_TEXTURE_ENV_COLOR () {0x2201}
sub GL_TEXTURE_ENV_MODE () {0x2200}
sub GL_TEXTURE_GEN_MODE () {0x2500}
sub GL_TEXTURE_GEN_Q () {0x0C63}
sub GL_TEXTURE_GEN_R () {0x0C62}
sub GL_TEXTURE_GEN_S () {0x0C60}
sub GL_TEXTURE_GEN_T () {0x0C61}
sub GL_TEXTURE_GREEN_SIZE () {0x805D}
sub GL_TEXTURE_HEIGHT () {0x1001}
sub GL_TEXTURE_INTENSITY_SIZE () {0x8061}
sub GL_TEXTURE_INTERNAL_FORMAT () {0x1003}
sub GL_TEXTURE_LUMINANCE_SIZE () {0x8060}
sub GL_TEXTURE_MAG_FILTER () {0x2800}
sub GL_TEXTURE_MATRIX () {0x0BA8}
sub GL_TEXTURE_MAX_LEVEL () {0x813D}
sub GL_TEXTURE_MAX_LOD () {0x813B}
sub GL_TEXTURE_MIN_FILTER () {0x2801}
sub GL_TEXTURE_MIN_LOD () {0x813A}
sub GL_TEXTURE_PRIORITY () {0x8066}
sub GL_TEXTURE_RED_SIZE () {0x805C}
sub GL_TEXTURE_RESIDENT () {0x8067}
sub GL_TEXTURE_STACK_DEPTH () {0x0BA5}
sub GL_TEXTURE_WIDTH () {0x1000}
sub GL_TEXTURE_WRAP_R () {0x8072}
sub GL_TEXTURE_WRAP_S () {0x2802}
sub GL_TEXTURE_WRAP_T () {0x2803}
sub GL_TRACE_ALL_BITS_MESA () {0xFFFF}
sub GL_TRACE_ARRAYS_BIT_MESA () {0x0004}
sub GL_TRACE_ERRORS_BIT_MESA () {0x0020}
sub GL_TRACE_MASK_MESA () {0x8755}
sub GL_TRACE_NAME_MESA () {0x8756}
sub GL_TRACE_OPERATIONS_BIT_MESA () {0x0001}
sub GL_TRACE_PIXELS_BIT_MESA () {0x0010}
sub GL_TRACE_PRIMITIVES_BIT_MESA () {0x0002}
sub GL_TRACE_TEXTURES_BIT_MESA () {0x0008}
sub GL_TRANSFORM_BIT () {0x00001000}
sub GL_TRANSPOSE_COLOR_MATRIX () {0x84E6}
sub GL_TRANSPOSE_MODELVIEW_MATRIX () {0x84E3}
sub GL_TRANSPOSE_PROJECTION_MATRIX () {0x84E4}
sub GL_TRANSPOSE_TEXTURE_MATRIX () {0x84E5}
sub GL_TRIANGLES () {0x0004}
sub GL_TRIANGLE_FAN () {0x0006}
sub GL_TRIANGLE_STRIP () {0x0005}
sub GL_TRUE () {0x1}
sub GL_UNPACK_ALIGNMENT () {0x0CF5}
sub GL_UNPACK_IMAGE_HEIGHT () {0x806E}
sub GL_UNPACK_LSB_FIRST () {0x0CF1}
sub GL_UNPACK_ROW_LENGTH () {0x0CF2}
sub GL_UNPACK_SKIP_IMAGES () {0x806D}
sub GL_UNPACK_SKIP_PIXELS () {0x0CF4}
sub GL_UNPACK_SKIP_ROWS () {0x0CF3}
sub GL_UNPACK_SWAP_BYTES () {0x0CF0}
sub GL_UNSIGNED_BYTE () {0x1401}
sub GL_UNSIGNED_BYTE_2_3_3_REV () {0x8362}
sub GL_UNSIGNED_BYTE_3_3_2 () {0x8032}
sub GL_UNSIGNED_INT () {0x1405}
sub GL_UNSIGNED_INT_10_10_10_2 () {0x8036}
sub GL_UNSIGNED_INT_24_8_MESA () {0x8751}
sub GL_UNSIGNED_INT_2_10_10_10_REV () {0x8368}
sub GL_UNSIGNED_INT_8_24_REV_MESA () {0x8752}
sub GL_UNSIGNED_INT_8_8_8_8 () {0x8035}
sub GL_UNSIGNED_INT_8_8_8_8_REV () {0x8367}
sub GL_UNSIGNED_SHORT () {0x1403}
sub GL_UNSIGNED_SHORT_15_1_MESA () {0x8753}
sub GL_UNSIGNED_SHORT_1_15_REV_MESA () {0x8754}
sub GL_UNSIGNED_SHORT_1_5_5_5_REV () {0x8366}
sub GL_UNSIGNED_SHORT_4_4_4_4 () {0x8033}
sub GL_UNSIGNED_SHORT_4_4_4_4_REV () {0x8365}
sub GL_UNSIGNED_SHORT_5_5_5_1 () {0x8034}
sub GL_UNSIGNED_SHORT_5_6_5 () {0x8363}
sub GL_UNSIGNED_SHORT_5_6_5_REV () {0x8364}
sub GL_V2F () {0x2A20}
sub GL_V3F () {0x2A21}
sub GL_VENDOR () {0x1F00}
sub GL_VERSION () {0x1F02}
sub GL_VERSION_1_1 () {1}
sub GL_VERSION_1_2 () {1}
sub GL_VERSION_1_3 () {1}
sub GL_VERTEX_ARRAY () {0x8074}
sub GL_VERTEX_ARRAY_POINTER () {0x808E}
sub GL_VERTEX_ARRAY_SIZE () {0x807A}
sub GL_VERTEX_ARRAY_STRIDE () {0x807C}
sub GL_VERTEX_ARRAY_TYPE () {0x807B}
sub GL_VERTEX_PROGRAM_CALLBACK_DATA_MESA () {0x8bb7}
sub GL_VERTEX_PROGRAM_CALLBACK_FUNC_MESA () {0x8bb6}
sub GL_VERTEX_PROGRAM_CALLBACK_MESA () {0x8bb5}
sub GL_VERTEX_PROGRAM_POSITION_MESA () {0x8bb4}
sub GL_VIEWPORT () {0x0BA2}
sub GL_VIEWPORT_BIT () {0x00000800}
sub GL_XOR () {0x1506}
sub GL_ZERO () {0x0}
sub GL_ZOOM_X () {0x0D16}
sub GL_ZOOM_Y () {0x0D17}
sub GXand () {0x1}
sub GXandInverted () {0x4}
sub GXandReverse () {0x2}
sub GXclear () {0x0}
sub GXcopy () {0x3}
sub GXcopyInverted () {0xc}
sub GXequiv () {0x9}
sub GXinvert () {0xa}
sub GXnand () {0xe}
sub GXnoop () {0x5}
sub GXnor () {0x8}
sub GXor () {0x7}
sub GXorInverted () {0xd}
sub GXorReverse () {0xb}
sub GXset () {0xf}
sub GXxor () {0x6}
sub GrabFrozen () {4}
sub GrabInvalidTime () {2}
sub GrabModeAsync () {1}
sub GrabModeSync () {0}
sub GrabNotViewable () {3}
sub GrabSuccess () {0}
sub GraphicsExpose () {13}
sub GravityNotify () {24}
sub GrayScale () {1}
sub HostDelete () {1}
sub HostInsert () {0}
sub IncludeInferiors () {1}
sub InputFocus () {1}
sub InputOnly () {2}
sub InputOutput () {1}
sub IsUnmapped () {0}
sub IsUnviewable () {1}
sub IsViewable () {2}
sub JoinBevel () {2}
sub JoinMiter () {0}
sub JoinRound () {1}
sub KBAutoRepeatMode () {(1<<7)}
sub KBBellDuration () {(1<<3)}
sub KBBellPercent () {(1<<1)}
sub KBBellPitch () {(1<<2)}
sub KBKey () {(1<<6)}
sub KBKeyClickPercent () {(1<<0)}
sub KBLed () {(1<<4)}
sub KBLedMode () {(1<<5)}
sub KeyPress () {2}
sub KeyPressMask () {(1<<0)}
sub KeyRelease () {3}
sub KeyReleaseMask () {(1<<1)}
sub KeymapNotify () {11}
sub KeymapStateMask () {(1<<14)}
sub LASTEvent () {35}
sub LSBFirst () {0}
sub LastExtensionError () {255}
sub LeaveNotify () {8}
sub LeaveWindowMask () {(1<<5)}
sub LedModeOff () {0}
sub LedModeOn () {1}
sub LineDoubleDash () {2}
sub LineOnOffDash () {1}
sub LineSolid () {0}
sub LockMapIndex () {1}
sub LockMask () {(1<<1)}
sub LowerHighest () {1}
sub MSBFirst () {1}
sub MapNotify () {19}
sub MapRequest () {20}
sub MappingBusy () {1}
sub MappingFailed () {2}
sub MappingKeyboard () {1}
sub MappingModifier () {0}
sub MappingNotify () {34}
sub MappingPointer () {2}
sub MappingSuccess () {0}
sub Mod1MapIndex () {3}
sub Mod1Mask () {(1<<3)}
sub Mod2MapIndex () {4}
sub Mod2Mask () {(1<<4)}
sub Mod3MapIndex () {5}
sub Mod3Mask () {(1<<5)}
sub Mod4MapIndex () {6}
sub Mod4Mask () {(1<<6)}
sub Mod5MapIndex () {7}
sub Mod5Mask () {(1<<7)}
sub MotionNotify () {6}
sub NoEventMask () {0}
sub NoExpose () {14}
sub NoSymbol () {0}
sub Nonconvex () {1}
sub None () {0}
sub NorthEastGravity () {3}
sub NorthGravity () {2}
sub NorthWestGravity () {1}
sub NotUseful () {0}
sub NotifyAncestor () {0}
sub NotifyDetailNone () {7}
sub NotifyGrab () {1}
sub NotifyHint () {1}
sub NotifyInferior () {2}
sub NotifyNonlinear () {3}
sub NotifyNonlinearVirtual () {4}
sub NotifyNormal () {0}
sub NotifyPointer () {5}
sub NotifyPointerRoot () {6}
sub NotifyUngrab () {2}
sub NotifyVirtual () {1}
sub NotifyWhileGrabbed () {3}
sub Opposite () {4}
sub OwnerGrabButtonMask () {(1<<24)}
sub ParentRelative () {1}
sub PlaceOnBottom () {1}
sub PlaceOnTop () {0}
sub PointerMotionHintMask () {(1<<7)}
sub PointerMotionMask () {(1<<6)}
sub PointerRoot () {1}
sub PointerWindow () {0}
sub PreferBlanking () {1}
sub PropModeAppend () {2}
sub PropModePrepend () {1}
sub PropModeReplace () {0}
sub PropertyChangeMask () {(1<<22)}
sub PropertyDelete () {1}
sub PropertyNewValue () {0}
sub PropertyNotify () {28}
sub PseudoColor () {3}
sub RaiseLowest () {0}
sub ReparentNotify () {21}
sub ReplayKeyboard () {5}
sub ReplayPointer () {2}
sub ResizeRedirectMask () {(1<<18)}
sub ResizeRequest () {25}
sub RetainPermanent () {1}
sub RetainTemporary () {2}
sub RevertToNone () {'None'}
sub RevertToParent () {2}
sub RevertToPointerRoot () {'PointerRoot'}
sub ScreenSaverActive () {1}
sub ScreenSaverReset () {0}
sub SelectionClear () {29}
sub SelectionNotify () {31}
sub SelectionRequest () {30}
sub SetModeDelete () {1}
sub SetModeInsert () {0}
sub ShiftMapIndex () {0}
sub ShiftMask () {(1<<0)}
sub SouthEastGravity () {9}
sub SouthGravity () {8}
sub SouthWestGravity () {7}
sub StaticColor () {2}
sub StaticGravity () {10}
sub StaticGray () {0}
sub StippleShape () {2}
sub StructureNotifyMask () {(1<<17)}
sub SubstructureNotifyMask () {(1<<19)}
sub SubstructureRedirectMask () {(1<<20)}
sub Success () {0}
sub SyncBoth () {7}
sub SyncKeyboard () {4}
sub SyncPointer () {1}
sub TileShape () {1}
sub TopIf () {2}
sub TrueColor () {4}
sub UnmapGravity () {0}
sub UnmapNotify () {18}
sub Unsorted () {0}
sub VisibilityChangeMask () {(1<<16)}
sub VisibilityFullyObscured () {2}
sub VisibilityNotify () {15}
sub VisibilityPartiallyObscured () {1}
sub VisibilityUnobscured () {0}
sub WIN32_LEAN_AND_MEAN () {1}
sub WestGravity () {4}
sub WhenMapped () {1}
sub WindingRule () {1}
sub XYBitmap () {0}
sub XYPixmap () {1}
sub X_PROTOCOL () {11}
sub X_PROTOCOL_REVISION () {0}
sub YSorted () {1}
sub YXBanded () {3}
sub YXSorted () {2}
sub ZPixmap () {2}


=head1 NAME

PDL::Graphics::OpenGL -- a PDL interface to the OpenGL graphics library.
PDL::Graphics::OpenGLOO - an Object Oriented interface to the interface.

=head1 DESCRIPTION

This package implements an interface to various OpenGL or OpenGL
emulator libraries.  Most of the interface is generated at PDL compile
time by the script opengl.pd which runs the c preprocessor on various
OpenGL include files to determine the correct C prototypes for each
configuration.  The object oriented interface defines an Object which
contains the Display, Window and Context properties of the defined
OpenGL device.  Any OpenGL function called from the OO interface will
recieve these fields from the object, they should not be passed explicitly.

This package is primarily intended for internal use by the
PDL::Graphics::TriD package, but should also be usable in its own right.

=head1 FUNCTIONS

=cut

package PDL::Graphics::OpenGL::OO;
use PDL::Options;
use strict;
my $debug;
#
# This is a list of all the fields of the opengl object and one could create a 
# psuedo hash style object but I want to use multiple inheritence with Tk...
#
#use fields qw/Display Window Context Options GL_Vendor GL_Version GL_Renderer/;

=head2 new($class,$options)

Returns a new OpenGL object with attributes specified in the options
field.  These attributes are:

=for ref

  x,y - the position of the upper left corner of the window (0,0)
  width,height - the width and height of the window in pixels (500,500)
  parent - the parent under which the new window should be opened (root)
  mask - the user interface mask (StructureNotifyMask)
  attributes - attributes to pass to glXChooseVisual

=cut

sub new {
  my($class_or_hash,$options) = @_;

  my $isref = ref($class_or_hash);  
  my $p;
#  PDL::Graphics::OpenGL::glpSetDebug(1);

  if($isref and defined $class_or_hash->{Options}){
    $p = $class_or_hash->{Options};
  }else{
    my $opt = new PDL::Options(default_options());
    $opt->incremental(1);
    $opt->options($options) if(defined $options);
    $p = $opt->options;
  }

  my $self =  PDL::Graphics::OpenGL::glpcOpenWindow(
                         $p->{x},$p->{y},$p->{width},$p->{height},
										  $p->{parent},$p->{mask},
										  @{$p->{attributes}});

	if(ref($self) ne 'HASH'){
	  die "Could not create OpenGL window";
   }

#  psuedo-hash style see note above  
#  no strict 'refs';
#  my $self = bless [ \%{"$class\::FIELDS"}], $class;
#
  $self->{Options} = $p;
  if($isref){
     if(defined($class_or_hash->{Options})){
       return bless $self,ref($class_or_hash);
     }else{
       foreach(keys %$self){
         $class_or_hash->{$_} = $self->{$_};
       }
       return $class_or_hash;
     }
  }
  bless $self,$class_or_hash;
}

=head2 default_options

default options for object oriented methods

=cut
#'
sub default_options{
  	{'x'     => 0,
	 'y'     => 0,
	 'width' => 500,
	 'height'=> 500,
	 'parent'=> 0,
	 'mask'  => &PDL::Graphics::OpenGL::StructureNotifyMask,
	 'attributes'=> [&PDL::Graphics::OpenGL::GLX_RGBA,
                    &PDL::Graphics::OpenGL::GLX_RED_SIZE,1,
                    &PDL::Graphics::OpenGL::GLX_GREEN_SIZE,1,
                    &PDL::Graphics::OpenGL::GLX_BLUE_SIZE,1,
                    &PDL::Graphics::OpenGL::GLX_DOUBLEBUFFER
                   ]
	 }	
}
	 
=head2 XPending()

OO interface to XPending

=cut

sub XPending {
	my($self) = @_;
   PDL::Graphics::OpenGL::XPending($self->{Display});
}

=head2 XResizeWindow(x,y)

OO interface to XResizeWindow

=cut

sub XResizeWindow {
  my($self,$x,$y) = @_;
  PDL::Graphics::OpenGL::XResizeWindow($self->{Display},$self->{Window},$x,$y);
}

=head2 glpXNextEvent()

OO interface to glpXNextEvent

=cut


sub glpXNextEvent {
	my($self) = @_;
   PDL::Graphics::OpenGL::glpXNextEvent($self->{Display});
}

=head2 glpRasterFont()

OO interface to the glpRasterFont function

=cut

sub glpRasterFont{
	my($this,@args) = @_;
   PDL::Graphics::OpenGL::glpRasterFont($args[0],$args[1],$args[2],$this->{Display});
}


=head2 AUTOLOAD

If the function is not prototyped in OO we assume there is
no explicit mention of the three identifying parameters (Display, Window, Context)
and try to load the OpenGL function.

=cut

sub AUTOLOAD {
  my($self,@args) = @_;
  use vars qw($AUTOLOAD);
  my $sub = $AUTOLOAD; 
  return if($sub =~ /DESTROY/);
  $sub =~ s/.*:://;
  $sub = "PDL::Graphics::OpenGL::$sub";
  if(defined $debug){
    print "In AUTOLOAD: $sub at ",__FILE__," line ",__LINE__,".\n";
  }
  no strict 'refs';
  return(&{$sub}(@args));
}





=head2 glXCreateContext

OO interface to the glXCreateContext function

=cut

sub glXCreateContext {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXCreateContext($this->{Display},$args[0],$this->{Context},$args[1]);
}

=head2 glXDestroyContext

OO interface to the glXDestroyContext function

=cut

sub glXDestroyContext {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXDestroyContext($this->{Display},$this->{Context});
}

=head2 glXMakeCurrent

OO interface to the glXMakeCurrent function

=cut

sub glXMakeCurrent {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXMakeCurrent($this->{Display},$this->{Window},$this->{Context});
}

=head2 glXCopyContext

OO interface to the glXCopyContext function

=cut

sub glXCopyContext {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXCopyContext($this->{Display},$this->{Context},$this->{Context},$args[0]);
}

=head2 glXSwapBuffers

OO interface to the glXSwapBuffers function

=cut

sub glXSwapBuffers {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXSwapBuffers($this->{Display},$this->{Window});
}

=head2 glXCreateGLXPixmap

OO interface to the glXCreateGLXPixmap function

=cut

sub glXCreateGLXPixmap {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXCreateGLXPixmap($this->{Display},$args[0],$args[1]);
}

=head2 glXDestroyGLXPixmap

OO interface to the glXDestroyGLXPixmap function

=cut

sub glXDestroyGLXPixmap {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXDestroyGLXPixmap($this->{Display},$args[0]);
}

=head2 glXQueryExtension

OO interface to the glXQueryExtension function

=cut

sub glXQueryExtension {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXQueryExtension($this->{Display},$args[0],$args[1]);
}

=head2 glXQueryVersion

OO interface to the glXQueryVersion function

=cut

sub glXQueryVersion {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXQueryVersion($this->{Display},$args[0],$args[1]);
}

=head2 glXIsDirect

OO interface to the glXIsDirect function

=cut

sub glXIsDirect {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXIsDirect($this->{Display},$this->{Context});
}

=head2 glXGetConfig

OO interface to the glXGetConfig function

=cut

sub glXGetConfig {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXGetConfig($this->{Display},$args[0],$args[1],$args[2]);
}

=head2 glXGetFBConfigAttrib

OO interface to the glXGetFBConfigAttrib function

=cut

sub glXGetFBConfigAttrib {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXGetFBConfigAttrib($this->{Display},$args[0],$args[1],$args[2]);
}

=head2 glXCreateWindow

OO interface to the glXCreateWindow function

=cut

sub glXCreateWindow {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXCreateWindow($this->{Display},$args[0],$args[1],$args[2]);
}

=head2 glXDestroyWindow

OO interface to the glXDestroyWindow function

=cut

sub glXDestroyWindow {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXDestroyWindow($this->{Display},$args[0]);
}

=head2 glXCreatePixmap

OO interface to the glXCreatePixmap function

=cut

sub glXCreatePixmap {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXCreatePixmap($this->{Display},$args[0],$args[1],$args[2]);
}

=head2 glXDestroyPixmap

OO interface to the glXDestroyPixmap function

=cut

sub glXDestroyPixmap {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXDestroyPixmap($this->{Display},$args[0]);
}

=head2 glXCreatePbuffer

OO interface to the glXCreatePbuffer function

=cut

sub glXCreatePbuffer {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXCreatePbuffer($this->{Display},$args[0],$args[1]);
}

=head2 glXDestroyPbuffer

OO interface to the glXDestroyPbuffer function

=cut

sub glXDestroyPbuffer {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXDestroyPbuffer($this->{Display},$args[0]);
}

=head2 glXQueryDrawable

OO interface to the glXQueryDrawable function

=cut

sub glXQueryDrawable {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXQueryDrawable($this->{Display},$this->{Window},$args[0],$args[1]);
}

=head2 glXCreateNewContext

OO interface to the glXCreateNewContext function

=cut

sub glXCreateNewContext {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXCreateNewContext($this->{Display},$args[0],$args[1],$this->{Context},$args[2]);
}

=head2 glXMakeContextCurrent

OO interface to the glXMakeContextCurrent function

=cut

sub glXMakeContextCurrent {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXMakeContextCurrent($this->{Display},$this->{Window},$this->{Window},$this->{Context});
}

=head2 glXQueryContext

OO interface to the glXQueryContext function

=cut

sub glXQueryContext {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXQueryContext($this->{Display},$this->{Context},$args[0],$args[1]);
}

=head2 glXSelectEvent

OO interface to the glXSelectEvent function

=cut

sub glXSelectEvent {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXSelectEvent($this->{Display},$this->{Window},$args[0]);
}

=head2 glXGetSelectedEvent

OO interface to the glXGetSelectedEvent function

=cut

sub glXGetSelectedEvent {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXGetSelectedEvent($this->{Display},$this->{Window},$args[0]);
}

=head2 glXFreeMemoryMESA

OO interface to the glXFreeMemoryMESA function

=cut

sub glXFreeMemoryMESA {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXFreeMemoryMESA($this->{Display},$args[0],$args[1]);
}

=head2 glXGetMemoryOffsetMESA

OO interface to the glXGetMemoryOffsetMESA function

=cut

sub glXGetMemoryOffsetMESA {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXGetMemoryOffsetMESA($this->{Display},$args[0],$args[1]);
}

=head2 glXBindTexImageARB

OO interface to the glXBindTexImageARB function

=cut

sub glXBindTexImageARB {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXBindTexImageARB($this->{Display},$args[0],$args[1]);
}

=head2 glXReleaseTexImageARB

OO interface to the glXReleaseTexImageARB function

=cut

sub glXReleaseTexImageARB {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXReleaseTexImageARB($this->{Display},$args[0],$args[1]);
}

=head2 glXDrawableAttribARB

OO interface to the glXDrawableAttribARB function

=cut

sub glXDrawableAttribARB {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXDrawableAttribARB($this->{Display},$this->{Window},$args[0]);
}

=head2 glXGetFrameUsageMESA

OO interface to the glXGetFrameUsageMESA function

=cut

sub glXGetFrameUsageMESA {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXGetFrameUsageMESA($this->{Display},$this->{Window},$args[0]);
}

=head2 glXBeginFrameTrackingMESA

OO interface to the glXBeginFrameTrackingMESA function

=cut

sub glXBeginFrameTrackingMESA {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXBeginFrameTrackingMESA($this->{Display},$this->{Window});
}

=head2 glXEndFrameTrackingMESA

OO interface to the glXEndFrameTrackingMESA function

=cut

sub glXEndFrameTrackingMESA {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXEndFrameTrackingMESA($this->{Display},$this->{Window});
}

=head2 glXQueryFrameTrackingMESA

OO interface to the glXQueryFrameTrackingMESA function

=cut

sub glXQueryFrameTrackingMESA {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXQueryFrameTrackingMESA($this->{Display},$this->{Window},$args[0],$args[1],$args[2]);
}

=head2 glXBindTexImageEXT

OO interface to the glXBindTexImageEXT function

=cut

sub glXBindTexImageEXT {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXBindTexImageEXT($this->{Display},$this->{Window},$args[0],$args[1]);
}

=head2 glXReleaseTexImageEXT

OO interface to the glXReleaseTexImageEXT function

=cut

sub glXReleaseTexImageEXT {
	my($this,@args) = @_;
	&PDL::Graphics::OpenGL::glXReleaseTexImageEXT($this->{Display},$this->{Window},$args[0]);
}




=head2 OpenGL Interface Functions

=over 4

The following is a list of OpenGL functions for which an interface was created.  Please refer to the OpenGL documentation for descriptions.

=item * 

glClearIndex

=item * 

glClearColor

=item * 

glClear

=item * 

glIndexMask

=item * 

glColorMask

=item * 

glAlphaFunc

=item * 

glBlendFunc

=item * 

glLogicOp

=item * 

glCullFace

=item * 

glFrontFace

=item * 

glPointSize

=item * 

glLineWidth

=item * 

glLineStipple

=item * 

glPolygonMode

=item * 

glPolygonOffset

=item * 

glPolygonStipple

=item * 

glGetPolygonStipple

=item * 

glEdgeFlag

=item * 

glEdgeFlagv

=item * 

glScissor

=item * 

glClipPlane

=item * 

glGetClipPlane

=item * 

glDrawBuffer

=item * 

glReadBuffer

=item * 

glEnable

=item * 

glDisable

=item * 

glIsEnabled

=item * 

glEnableClientState

=item * 

glDisableClientState

=item * 

glGetBooleanv

=item * 

glGetDoublev

=item * 

glGetFloatv

=item * 

glGetIntegerv

=item * 

glPushAttrib

=item * 

glPopAttrib

=item * 

glPushClientAttrib

=item * 

glPopClientAttrib

=item * 

glRenderMode

=item * 

glGetError

=item * 

glFinish

=item * 

glFlush

=item * 

glHint

=item * 

glClearDepth

=item * 

glDepthFunc

=item * 

glDepthMask

=item * 

glDepthRange

=item * 

glClearAccum

=item * 

glAccum

=item * 

glMatrixMode

=item * 

glOrtho

=item * 

glFrustum

=item * 

glViewport

=item * 

glPushMatrix

=item * 

glPopMatrix

=item * 

glLoadIdentity

=item * 

glLoadMatrixd

=item * 

glLoadMatrixf

=item * 

glMultMatrixd

=item * 

glMultMatrixf

=item * 

glRotated

=item * 

glRotatef

=item * 

glScaled

=item * 

glScalef

=item * 

glTranslated

=item * 

glTranslatef

=item * 

glIsList

=item * 

glDeleteLists

=item * 

glGenLists

=item * 

glNewList

=item * 

glEndList

=item * 

glCallList

=item * 

glCallLists

=item * 

glListBase

=item * 

glBegin

=item * 

glEnd

=item * 

glVertex2d

=item * 

glVertex2f

=item * 

glVertex2i

=item * 

glVertex2s

=item * 

glVertex3d

=item * 

glVertex3f

=item * 

glVertex3i

=item * 

glVertex3s

=item * 

glVertex4d

=item * 

glVertex4f

=item * 

glVertex4i

=item * 

glVertex4s

=item * 

glVertex2dv

=item * 

glVertex2fv

=item * 

glVertex2iv

=item * 

glVertex2sv

=item * 

glVertex3dv

=item * 

glVertex3fv

=item * 

glVertex3iv

=item * 

glVertex3sv

=item * 

glVertex4dv

=item * 

glVertex4fv

=item * 

glVertex4iv

=item * 

glVertex4sv

=item * 

glNormal3b

=item * 

glNormal3d

=item * 

glNormal3f

=item * 

glNormal3i

=item * 

glNormal3s

=item * 

glNormal3bv

=item * 

glNormal3dv

=item * 

glNormal3fv

=item * 

glNormal3iv

=item * 

glNormal3sv

=item * 

glIndexd

=item * 

glIndexf

=item * 

glIndexi

=item * 

glIndexs

=item * 

glIndexub

=item * 

glIndexdv

=item * 

glIndexfv

=item * 

glIndexiv

=item * 

glIndexsv

=item * 

glIndexubv

=item * 

glColor3b

=item * 

glColor3d

=item * 

glColor3f

=item * 

glColor3i

=item * 

glColor3s

=item * 

glColor3ub

=item * 

glColor3ui

=item * 

glColor3us

=item * 

glColor4b

=item * 

glColor4d

=item * 

glColor4f

=item * 

glColor4i

=item * 

glColor4s

=item * 

glColor4ub

=item * 

glColor4ui

=item * 

glColor4us

=item * 

glColor3bv

=item * 

glColor3dv

=item * 

glColor3fv

=item * 

glColor3iv

=item * 

glColor3sv

=item * 

glColor3ubv

=item * 

glColor3uiv

=item * 

glColor3usv

=item * 

glColor4bv

=item * 

glColor4dv

=item * 

glColor4fv

=item * 

glColor4iv

=item * 

glColor4sv

=item * 

glColor4ubv

=item * 

glColor4uiv

=item * 

glColor4usv

=item * 

glTexCoord1d

=item * 

glTexCoord1f

=item * 

glTexCoord1i

=item * 

glTexCoord1s

=item * 

glTexCoord2d

=item * 

glTexCoord2f

=item * 

glTexCoord2i

=item * 

glTexCoord2s

=item * 

glTexCoord3d

=item * 

glTexCoord3f

=item * 

glTexCoord3i

=item * 

glTexCoord3s

=item * 

glTexCoord4d

=item * 

glTexCoord4f

=item * 

glTexCoord4i

=item * 

glTexCoord4s

=item * 

glTexCoord1dv

=item * 

glTexCoord1fv

=item * 

glTexCoord1iv

=item * 

glTexCoord1sv

=item * 

glTexCoord2dv

=item * 

glTexCoord2fv

=item * 

glTexCoord2iv

=item * 

glTexCoord2sv

=item * 

glTexCoord3dv

=item * 

glTexCoord3fv

=item * 

glTexCoord3iv

=item * 

glTexCoord3sv

=item * 

glTexCoord4dv

=item * 

glTexCoord4fv

=item * 

glTexCoord4iv

=item * 

glTexCoord4sv

=item * 

glRasterPos2d

=item * 

glRasterPos2f

=item * 

glRasterPos2i

=item * 

glRasterPos2s

=item * 

glRasterPos3d

=item * 

glRasterPos3f

=item * 

glRasterPos3i

=item * 

glRasterPos3s

=item * 

glRasterPos4d

=item * 

glRasterPos4f

=item * 

glRasterPos4i

=item * 

glRasterPos4s

=item * 

glRasterPos2dv

=item * 

glRasterPos2fv

=item * 

glRasterPos2iv

=item * 

glRasterPos2sv

=item * 

glRasterPos3dv

=item * 

glRasterPos3fv

=item * 

glRasterPos3iv

=item * 

glRasterPos3sv

=item * 

glRasterPos4dv

=item * 

glRasterPos4fv

=item * 

glRasterPos4iv

=item * 

glRasterPos4sv

=item * 

glRectd

=item * 

glRectf

=item * 

glRecti

=item * 

glRects

=item * 

glRectdv

=item * 

glRectfv

=item * 

glRectiv

=item * 

glRectsv

=item * 

glVertexPointer

=item * 

glNormalPointer

=item * 

glColorPointer

=item * 

glIndexPointer

=item * 

glTexCoordPointer

=item * 

glEdgeFlagPointer

=item * 

glGetPointerv

=item * 

glArrayElement

=item * 

glDrawArrays

=item * 

glDrawElements

=item * 

glInterleavedArrays

=item * 

glShadeModel

=item * 

glLightf

=item * 

glLighti

=item * 

glLightfv

=item * 

glLightiv

=item * 

glGetLightfv

=item * 

glGetLightiv

=item * 

glLightModelf

=item * 

glLightModeli

=item * 

glLightModelfv

=item * 

glLightModeliv

=item * 

glMaterialf

=item * 

glMateriali

=item * 

glMaterialfv

=item * 

glMaterialiv

=item * 

glGetMaterialfv

=item * 

glGetMaterialiv

=item * 

glColorMaterial

=item * 

glPixelZoom

=item * 

glPixelStoref

=item * 

glPixelStorei

=item * 

glPixelTransferf

=item * 

glPixelTransferi

=item * 

glPixelMapfv

=item * 

glPixelMapuiv

=item * 

glPixelMapusv

=item * 

glGetPixelMapfv

=item * 

glGetPixelMapuiv

=item * 

glGetPixelMapusv

=item * 

glBitmap

=item * 

glReadPixels

=item * 

glDrawPixels

=item * 

glCopyPixels

=item * 

glStencilFunc

=item * 

glStencilMask

=item * 

glStencilOp

=item * 

glClearStencil

=item * 

glTexGend

=item * 

glTexGenf

=item * 

glTexGeni

=item * 

glTexGendv

=item * 

glTexGenfv

=item * 

glTexGeniv

=item * 

glGetTexGendv

=item * 

glGetTexGenfv

=item * 

glGetTexGeniv

=item * 

glTexEnvf

=item * 

glTexEnvi

=item * 

glTexEnvfv

=item * 

glTexEnviv

=item * 

glGetTexEnvfv

=item * 

glGetTexEnviv

=item * 

glTexParameterf

=item * 

glTexParameteri

=item * 

glTexParameterfv

=item * 

glTexParameteriv

=item * 

glGetTexParameterfv

=item * 

glGetTexParameteriv

=item * 

glGetTexLevelParameterfv

=item * 

glGetTexLevelParameteriv

=item * 

glTexImage1D

=item * 

glTexImage2D

=item * 

glGetTexImage

=item * 

glGenTextures

=item * 

glDeleteTextures

=item * 

glBindTexture

=item * 

glPrioritizeTextures

=item * 

glAreTexturesResident

=item * 

glIsTexture

=item * 

glTexSubImage1D

=item * 

glTexSubImage2D

=item * 

glCopyTexImage1D

=item * 

glCopyTexImage2D

=item * 

glCopyTexSubImage1D

=item * 

glCopyTexSubImage2D

=item * 

glMap1d

=item * 

glMap1f

=item * 

glMap2d

=item * 

glMap2f

=item * 

glGetMapdv

=item * 

glGetMapfv

=item * 

glGetMapiv

=item * 

glEvalCoord1d

=item * 

glEvalCoord1f

=item * 

glEvalCoord1dv

=item * 

glEvalCoord1fv

=item * 

glEvalCoord2d

=item * 

glEvalCoord2f

=item * 

glEvalCoord2dv

=item * 

glEvalCoord2fv

=item * 

glMapGrid1d

=item * 

glMapGrid1f

=item * 

glMapGrid2d

=item * 

glMapGrid2f

=item * 

glEvalPoint1

=item * 

glEvalPoint2

=item * 

glEvalMesh1

=item * 

glEvalMesh2

=item * 

glFogf

=item * 

glFogi

=item * 

glFogfv

=item * 

glFogiv

=item * 

glFeedbackBuffer

=item * 

glPassThrough

=item * 

glSelectBuffer

=item * 

glInitNames

=item * 

glLoadName

=item * 

glPushName

=item * 

glPopName

=item * 

glDrawRangeElements

=item * 

glTexImage3D

=item * 

glTexSubImage3D

=item * 

glCopyTexSubImage3D

=item * 

glColorTable

=item * 

glColorSubTable

=item * 

glColorTableParameteriv

=item * 

glColorTableParameterfv

=item * 

glCopyColorSubTable

=item * 

glCopyColorTable

=item * 

glGetColorTable

=item * 

glGetColorTableParameterfv

=item * 

glGetColorTableParameteriv

=item * 

glBlendEquation

=item * 

glBlendColor

=item * 

glHistogram

=item * 

glResetHistogram

=item * 

glGetHistogram

=item * 

glGetHistogramParameterfv

=item * 

glGetHistogramParameteriv

=item * 

glMinmax

=item * 

glResetMinmax

=item * 

glGetMinmax

=item * 

glGetMinmaxParameterfv

=item * 

glGetMinmaxParameteriv

=item * 

glConvolutionFilter1D

=item * 

glConvolutionFilter2D

=item * 

glConvolutionParameterf

=item * 

glConvolutionParameterfv

=item * 

glConvolutionParameteri

=item * 

glConvolutionParameteriv

=item * 

glCopyConvolutionFilter1D

=item * 

glCopyConvolutionFilter2D

=item * 

glGetConvolutionFilter

=item * 

glGetConvolutionParameterfv

=item * 

glGetConvolutionParameteriv

=item * 

glSeparableFilter2D

=item * 

glGetSeparableFilter

=item * 

glActiveTexture

=item * 

glClientActiveTexture

=item * 

glCompressedTexImage1D

=item * 

glCompressedTexImage2D

=item * 

glCompressedTexImage3D

=item * 

glCompressedTexSubImage1D

=item * 

glCompressedTexSubImage2D

=item * 

glCompressedTexSubImage3D

=item * 

glGetCompressedTexImage

=item * 

glMultiTexCoord1d

=item * 

glMultiTexCoord1dv

=item * 

glMultiTexCoord1f

=item * 

glMultiTexCoord1fv

=item * 

glMultiTexCoord1i

=item * 

glMultiTexCoord1iv

=item * 

glMultiTexCoord1s

=item * 

glMultiTexCoord1sv

=item * 

glMultiTexCoord2d

=item * 

glMultiTexCoord2dv

=item * 

glMultiTexCoord2f

=item * 

glMultiTexCoord2fv

=item * 

glMultiTexCoord2i

=item * 

glMultiTexCoord2iv

=item * 

glMultiTexCoord2s

=item * 

glMultiTexCoord2sv

=item * 

glMultiTexCoord3d

=item * 

glMultiTexCoord3dv

=item * 

glMultiTexCoord3f

=item * 

glMultiTexCoord3fv

=item * 

glMultiTexCoord3i

=item * 

glMultiTexCoord3iv

=item * 

glMultiTexCoord3s

=item * 

glMultiTexCoord3sv

=item * 

glMultiTexCoord4d

=item * 

glMultiTexCoord4dv

=item * 

glMultiTexCoord4f

=item * 

glMultiTexCoord4fv

=item * 

glMultiTexCoord4i

=item * 

glMultiTexCoord4iv

=item * 

glMultiTexCoord4s

=item * 

glMultiTexCoord4sv

=item * 

glLoadTransposeMatrixd

=item * 

glLoadTransposeMatrixf

=item * 

glMultTransposeMatrixd

=item * 

glMultTransposeMatrixf

=item * 

glSampleCoverage

=item * 

glActiveTextureARB

=item * 

glClientActiveTextureARB

=item * 

glMultiTexCoord1dARB

=item * 

glMultiTexCoord1dvARB

=item * 

glMultiTexCoord1fARB

=item * 

glMultiTexCoord1fvARB

=item * 

glMultiTexCoord1iARB

=item * 

glMultiTexCoord1ivARB

=item * 

glMultiTexCoord1sARB

=item * 

glMultiTexCoord1svARB

=item * 

glMultiTexCoord2dARB

=item * 

glMultiTexCoord2dvARB

=item * 

glMultiTexCoord2fARB

=item * 

glMultiTexCoord2fvARB

=item * 

glMultiTexCoord2iARB

=item * 

glMultiTexCoord2ivARB

=item * 

glMultiTexCoord2sARB

=item * 

glMultiTexCoord2svARB

=item * 

glMultiTexCoord3dARB

=item * 

glMultiTexCoord3dvARB

=item * 

glMultiTexCoord3fARB

=item * 

glMultiTexCoord3fvARB

=item * 

glMultiTexCoord3iARB

=item * 

glMultiTexCoord3ivARB

=item * 

glMultiTexCoord3sARB

=item * 

glMultiTexCoord3svARB

=item * 

glMultiTexCoord4dARB

=item * 

glMultiTexCoord4dvARB

=item * 

glMultiTexCoord4fARB

=item * 

glMultiTexCoord4fvARB

=item * 

glMultiTexCoord4iARB

=item * 

glMultiTexCoord4ivARB

=item * 

glMultiTexCoord4sARB

=item * 

glMultiTexCoord4svARB

=item * 

glCreateDebugObjectMESA

=item * 

glClearDebugLogMESA

=item * 

glGetDebugLogMESA

=item * 

glGetDebugLogLengthMESA

=item * 

glEnableTraceMESA

=item * 

glDisableTraceMESA

=item * 

glNewTraceMESA

=item * 

glEndTraceMESA

=item * 

glTraceAssertAttribMESA

=item * 

glTraceCommentMESA

=item * 

glTraceTextureMESA

=item * 

glTraceListMESA

=item * 

glTracePointerMESA

=item * 

glTracePointerRangeMESA

=item * 

glBlendEquationSeparateATI

=item * 

glXCreateContext

=item * 

glXDestroyContext

=item * 

glXMakeCurrent

=item * 

glXCopyContext

=item * 

glXSwapBuffers

=item * 

glXCreateGLXPixmap

=item * 

glXDestroyGLXPixmap

=item * 

glXQueryExtension

=item * 

glXQueryVersion

=item * 

glXIsDirect

=item * 

glXGetConfig

=item * 

glXGetCurrentContext

=item * 

glXGetCurrentDrawable

=item * 

glXWaitGL

=item * 

glXWaitX

=item * 

glXUseXFont

=item * 

glXGetFBConfigAttrib

=item * 

glXCreateWindow

=item * 

glXDestroyWindow

=item * 

glXCreatePixmap

=item * 

glXDestroyPixmap

=item * 

glXCreatePbuffer

=item * 

glXDestroyPbuffer

=item * 

glXQueryDrawable

=item * 

glXCreateNewContext

=item * 

glXMakeContextCurrent

=item * 

glXGetCurrentReadDrawable

=item * 

glXQueryContext

=item * 

glXSelectEvent

=item * 

glXGetSelectedEvent

=item * 

glXFreeMemoryNV

=item * 

glXFreeMemoryMESA

=item * 

glXGetMemoryOffsetMESA

=item * 

glXBindTexImageARB

=item * 

glXReleaseTexImageARB

=item * 

glXDrawableAttribARB

=item * 

glXGetFrameUsageMESA

=item * 

glXBeginFrameTrackingMESA

=item * 

glXEndFrameTrackingMESA

=item * 

glXQueryFrameTrackingMESA

=item * 

glXSwapIntervalMESA

=item * 

glXGetSwapIntervalMESA

=item * 

glXBindTexImageEXT

=item * 

glXReleaseTexImageEXT

=item * 

gluBeginCurve

=item * 

gluBeginPolygon

=item * 

gluBeginSurface

=item * 

gluBeginTrim

=item * 

gluBuild1DMipmapLevels

=item * 

gluBuild1DMipmaps

=item * 

gluBuild2DMipmapLevels

=item * 

gluBuild2DMipmaps

=item * 

gluBuild3DMipmapLevels

=item * 

gluBuild3DMipmaps

=item * 

gluCheckExtension

=item * 

gluCylinder

=item * 

gluDeleteNurbsRenderer

=item * 

gluDeleteQuadric

=item * 

gluDeleteTess

=item * 

gluDisk

=item * 

gluEndCurve

=item * 

gluEndPolygon

=item * 

gluEndSurface

=item * 

gluEndTrim

=item * 

gluGetNurbsProperty

=item * 

gluGetTessProperty

=item * 

gluLoadSamplingMatrices

=item * 

gluLookAt

=item * 

gluNextContour

=item * 

gluNurbsCallback

=item * 

gluNurbsCallbackData

=item * 

gluNurbsCallbackDataEXT

=item * 

gluNurbsCurve

=item * 

gluNurbsProperty

=item * 

gluNurbsSurface

=item * 

gluOrtho2D

=item * 

gluPartialDisk

=item * 

gluPerspective

=item * 

gluPickMatrix

=item * 

gluProject

=item * 

gluPwlCurve

=item * 

gluQuadricCallback

=item * 

gluQuadricDrawStyle

=item * 

gluQuadricNormals

=item * 

gluQuadricOrientation

=item * 

gluQuadricTexture

=item * 

gluScaleImage

=item * 

gluSphere

=item * 

gluTessBeginContour

=item * 

gluTessBeginPolygon

=item * 

gluTessCallback

=item * 

gluTessEndContour

=item * 

gluTessEndPolygon

=item * 

gluTessNormal

=item * 

gluTessProperty

=item * 

gluTessVertex

=item * 

gluUnProject

=item * 

gluUnProject4

=back

=cut



;



# Exit with OK status

1;

		   