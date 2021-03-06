/* Copyright (c) 2016 Baidu, Inc. All Rights Reserve.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. */
ifdef(`proto3', `syntax = "proto2";')

package paddle;

sinclude(`DataConfigExt.proto.m4')
message FileGroupConf {
  optional uint32 queue_capacity = 1 [default = 1];
  // how many files to load for a load file thread
  optional int32 load_file_count = 2 [default = 1];
  // how many threads to load files
  // Setting to be 5~10 is appropriate when loading files by hadoop vfs
  optional int32 load_thread_num = 3 [default = 1];
};

message DataConfig {
sinclude(`DataConfigInter.proto.m4')
  required string type = 1;

  // name of a text file which contains a list of file names at each line
  optional string files = 3;

  optional int32 feat_dim = 4;//feature dimension of one frame
  repeated int32 slot_dims = 5;//feature slot dims
  optional int32 context_len = 6;//max neibour frame numbers
  optional uint64 buffer_capacity = 7;//the number of samples

  //part of data used in training
  //if not -1, part of train data is used in training
  optional int64 train_sample_num = 8 [default = -1];

  //The number of documents processed once
  optional int32  file_load_num = 9 [default = -1];
  optional bool  async_load_data = 12 [default = false];
  /// Note the field number 10, 11 and 13 have been deprecated.
  optional bool for_test = 14 [default = false];  // whether this data is for test
  optional FileGroupConf file_group_conf = 15;
  repeated int32 float_slot_dims = 16;

  /// Note the field number 17, 18 and 19 have been deprecated.

  // a list of values which will be used to create additional one dimensional real
  // values slots. These one dimensional slots can be used as the weight input
  // for cost layers.
  // Currently this is only supported by ProtoDataProvider.
  repeated real constant_slots = 20;

  // for PyDataProvider.
  // Specify the load data script module name, object name and user args
  optional string load_data_module = 21;
  optional string load_data_object = 22;
  optional string load_data_args = 23;

  // for MultiDataProvider
  repeated DataConfig sub_data_configs = 24; // sub dataproviders
  /*
   * the ratio of each sub dataproviders:
   * e.g. sub dataprovider A's ratio is 1, B's ratio is 9, batch_size is 100,
   * then each mini-batch is combined by 10 instance from A and 90 instances
   * from B.
   */
  optional int32 data_ratio = 25;
  /*
   * if one of the sub dataproviders is running out of data, then
   * (1) it is "main data", then finish current pass.
   * (2) it is not "main data", then reset it, and try getNextBatch again.
   */
  optional bool is_main_data = 26 [default = true];

  // the usage ratio of instances. Setting to 1.0 means the use of all instances.
  optional real usage_ratio = 27 [default = 1.0];
};

