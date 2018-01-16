// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: google/rpc/status.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/Any.pbobjc.h>
#else
 #import "google/protobuf/Any.pbobjc.h"
#endif

 #import "google/rpc/Status.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - StatusRoot

@implementation StatusRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - StatusRoot_FileDescriptor

static GPBFileDescriptor *StatusRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"google.rpc"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - Status

@implementation Status

@dynamic code;
@dynamic message;
@dynamic detailsArray, detailsArray_Count;

typedef struct Status__storage_ {
  uint32_t _has_storage_[1];
  int32_t code;
  NSString *message;
  NSMutableArray *detailsArray;
} Status__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "code",
        .dataTypeSpecific.className = NULL,
        .number = Status_FieldNumber_Code,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(Status__storage_, code),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "message",
        .dataTypeSpecific.className = NULL,
        .number = Status_FieldNumber_Message,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(Status__storage_, message),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "detailsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(GPBAny),
        .number = Status_FieldNumber_DetailsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(Status__storage_, detailsArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[Status class]
                                     rootClass:[StatusRoot class]
                                          file:StatusRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(Status__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)