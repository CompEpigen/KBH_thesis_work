[
    {
        "aggregation": "segment",
        "analysis_id": "5f809176-8b0a-4419-959e-6638bfa895b6",
        "basecall_1d": {
            "exit_status_dist": {
                "pass": 26
            },
            "qscore_dist_temp": [
                {
                    "count": 3,
                    "mean_qscore": 7.5
                },
                {
                    "count": 1,
                    "mean_qscore": 8.0
                },
                {
                    "count": 3,
                    "mean_qscore": 8.5
                },
                {
                    "count": 5,
                    "mean_qscore": 9.5
                },
                {
                    "count": 3,
                    "mean_qscore": 10.0
                },
                {
                    "count": 6,
                    "mean_qscore": 10.5
                },
                {
                    "count": 1,
                    "mean_qscore": 11.0
                },
                {
                    "count": 4,
                    "mean_qscore": 11.5
                }
            ],
            "qscore_sum_temp": {
                "count": 26,
                "mean": 9.97485446929932,
                "sum": 259.346221923828
            },
            "read_len_events_sum_temp": 325190,
            "seq_len_bases_dist_temp": [
                {
                    "count": 26,
                    "length": 0.0
                }
            ],
            "seq_len_bases_sum_temp": 26,
            "seq_len_events_dist_temp": [
                {
                    "count": 1,
                    "length": 1000.0
                },
                {
                    "count": 1,
                    "length": 2000.0
                },
                {
                    "count": 1,
                    "length": 4000.0
                },
                {
                    "count": 2,
                    "length": 6000.0
                },
                {
                    "count": 2,
                    "length": 7000.0
                },
                {
                    "count": 2,
                    "length": 8000.0
                },
                {
                    "count": 2,
                    "length": 9000.0
                },
                {
                    "count": 2,
                    "length": 10000.0
                },
                {
                    "count": 2,
                    "length": 12000.0
                },
                {
                    "count": 3,
                    "length": 13000.0
                },
                {
                    "count": 3,
                    "length": 14000.0
                },
                {
                    "count": 1,
                    "length": 17000.0
                },
                {
                    "count": 1,
                    "length": 23000.0
                },
                {
                    "count": 2,
                    "length": 26000.0
                },
                {
                    "count": 1,
                    "length": 27000.0
                }
            ],
            "speed_bases_per_second_dist_temp": [
                {
                    "count": 26,
                    "speed": 1.0
                }
            ],
            "strand_median_pa": {
                "count": 26,
                "mean": 84.9175491333008,
                "sum": 2207.85620117188
            },
            "strand_sd_pa": {
                "count": 26,
                "mean": 9.50387191772461,
                "sum": 247.100677490234
            }
        },
        "channel_count": 25,
        "context_tags": {
            "experiment_kit": "genomic_dna",
            "filename": "odw_genlab4209_20161213_fn_mn16303_sequencing_run_sample_id_32395",
            "sample_frequency": "4000",
            "user_filename_input": "sample_id"
        },
        "latest_run_time": 3498.67016601562,
        "levels_sums": {
            "count": 26,
            "mean": 211.244567871094,
            "open_pore_level_sum": 5492.35888671875
        },
        "opts": {
            "adapter_pt_range_scale": "5.200000",
            "align_ref": "",
            "allow_inferior_barcodes": "0",
            "arrangements_files": "",
            "as_cpu_threads_per_scaler": "2",
            "as_gpu_runners_per_device": "2",
            "as_model_file": "adapter_scaling_dna_r9.4.1_min.jsn",
            "as_num_scalers": "1",
            "as_reads_per_runner": "32",
            "barcode_kits": "",
            "barcoding_config_file": "configuration.cfg",
            "bed_file": "",
            "builtin_scripts": "1",
            "calib_detect": "0",
            "calib_max_sequence_length": "3800",
            "calib_min_coverage": "0.600000",
            "calib_min_sequence_length": "3000",
            "calib_reference": "lambda_3.6kb.fasta",
            "chunk_size": "2000",
            "chunks_per_caller": "10000",
            "chunks_per_runner": "160",
            "client_id": "-1",
            "compress_fastq": "0",
            "cpu_threads_per_caller": "4",
            "detect_mid_strand_barcodes": "0",
            "device": "auto",
            "disable_events": "0",
            "disable_pings": "0",
            "dmean_threshold": "1.000000",
            "dmean_win_size": "2",
            "end_gap1": "40",
            "end_gap2": "40",
            "extend_gap1": "40",
            "extend_gap2": "160",
            "fast5_out": "0",
            "flowcell": "",
            "front_window_size": "150",
            "gpu_runners_per_device": "8",
            "high_priority_threshold": "10",
            "input_file_list": "",
            "jump_threshold": "1.000000",
            "kernel_path": "",
            "kit": "",
            "log_speed_frequency": "0",
            "max_block_size": "50000",
            "max_queued_reads": "2000",
            "max_search_len": "1000",
            "medium_priority_threshold": "4",
            "min_qscore": "7.000000",
            "min_score": "60.000000",
            "min_score_mid_barcodes": "60.000000",
            "min_score_rear_override": "60.000000",
            "model_file": "template_r9.4.1_450bps_fast.jsn",
            "nested_output_folder": "0",
            "num_alignment_threads": "4",
            "num_barcode_threads": "4",
            "num_barcoding_buffers": "96",
            "num_callers": "5",
            "num_extra_bases_trim": "0",
            "open_gap1": "40",
            "open_gap2": "160",
            "overlap": "50",
            "override_scaling": "0",
            "ping_segment_duration": "60",
            "ping_url": "https://ping.oxfordnanoportal.com/basecall",
            "port": "",
            "post_out": "0",
            "print_workflows": "0",
            "progress_stats_frequency": "-1.000000",
            "pt_median_offset": "2.500000",
            "pt_minimum_read_start_index": "30",
            "pt_required_adapter_drop": "30.000000",
            "pt_scaling": "0",
            "qscore_filtering": "0",
            "qscore_offset": "-0.130000",
            "qscore_scale": "0.905000",
            "quiet": "0",
            "read_batch_size": "4000",
            "read_id_list": "",
            "rear_window_size": "150",
            "records_per_fastq": "4000",
            "recursive": "0",
            "require_barcodes_both_ends": "0",
            "resume": "0",
            "reverse_sequence": "0",
            "scaling_mad": "1.000000",
            "scaling_med": "0.000000",
            "score_matrix_filename": "",
            "server_file_load_timeout": "30",
            "start_gap1": "40",
            "start_gap2": "40",
            "stay_penalty": "1.000000",
            "temp_bias": "1.000000",
            "temp_weight": "1.000000",
            "trace_categories_logs": "",
            "trace_domains_config": "",
            "trace_domains_log": "",
            "trim_barcodes": "0",
            "trim_min_events": "3",
            "trim_strategy": "dna",
            "trim_threshold": "2.500000",
            "u_substitution": "0",
            "verbose_logs": "0"
        },
        "read_count": 26,
        "reads_per_channel_dist": [
            {
                "channel": 43,
                "count": 1
            },
            {
                "channel": 47,
                "count": 2
            },
            {
                "channel": 84,
                "count": 1
            },
            {
                "channel": 85,
                "count": 1
            },
            {
                "channel": 95,
                "count": 1
            },
            {
                "channel": 118,
                "count": 1
            },
            {
                "channel": 123,
                "count": 1
            },
            {
                "channel": 144,
                "count": 1
            },
            {
                "channel": 179,
                "count": 1
            },
            {
                "channel": 250,
                "count": 1
            },
            {
                "channel": 280,
                "count": 1
            },
            {
                "channel": 350,
                "count": 1
            },
            {
                "channel": 361,
                "count": 1
            },
            {
                "channel": 378,
                "count": 1
            },
            {
                "channel": 420,
                "count": 1
            },
            {
                "channel": 432,
                "count": 1
            },
            {
                "channel": 467,
                "count": 1
            },
            {
                "channel": 471,
                "count": 1
            },
            {
                "channel": 477,
                "count": 1
            },
            {
                "channel": 481,
                "count": 1
            },
            {
                "channel": 482,
                "count": 1
            },
            {
                "channel": 483,
                "count": 1
            },
            {
                "channel": 485,
                "count": 1
            },
            {
                "channel": 501,
                "count": 1
            },
            {
                "channel": 506,
                "count": 1
            }
        ],
        "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
        "segment_duration": 60,
        "segment_number": 1,
        "segment_type": "guppy-acquisition",
        "software": {
            "analysis": "1d_basecalling",
            "name": "guppy-basecalling",
            "version": "4.0.15+5694074"
        },
        "tracking_id": {
            "asic_id": "420170566",
            "asic_id_eeprom": "2043896",
            "asic_temp": "30.1846237",
            "auto_update": "1",
            "auto_update_source": "https://mirror.oxfordnanoportal.com/software/MinKNOW/",
            "bream_core_version": "1.1.21.1",
            "bream_is_standard": "1",
            "bream_map_version": "1.1.21.1",
            "bream_ont_version": "1.1.21.1",
            "bream_prod_version": "1.1.21.1",
            "bream_rnd_version": "0.1.1",
            "device_id": "MN16303",
            "exp_script_name": "NC_48Hr_Sequencing_Run_FLO-MIN106_SQK-LSK108.py",
            "exp_script_purpose": "sequencing_run",
            "exp_start_time": "1481657610",
            "flow_cell_id": "",
            "heatsink_temp": "33.9765625",
            "hostname": "odw-genlab4209",
            "installation_type": "map",
            "local_firmware_file": "0",
            "msg_id": "22660ae5-336a-41c5-a38e-d32a987b7a63",
            "operating_system": "Windows 6.1",
            "protocol_run_id": "3eecebf6-325f-4ac5-b896-a7588f2b2324",
            "protocols_version": "1.1.21",
            "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
            "time_stamp": "2020-09-30T16:38:16Z",
            "usb_config": "1.0.11_ONT#MinION_fpga_1.0.1#ctrl#Auto",
            "version": "1.1.21"
        }
    },
    {
        "aggregation": "segment",
        "analysis_id": "5f809176-8b0a-4419-959e-6638bfa895b6",
        "basecall_1d": {
            "exit_status_dist": {
                "fail:qscore_filter": 1,
                "pass": 16
            },
            "qscore_dist_temp": [
                {
                    "count": 1,
                    "mean_qscore": 5.5
                },
                {
                    "count": 1,
                    "mean_qscore": 7.5
                },
                {
                    "count": 1,
                    "mean_qscore": 8.0
                },
                {
                    "count": 1,
                    "mean_qscore": 8.5
                },
                {
                    "count": 1,
                    "mean_qscore": 9.0
                },
                {
                    "count": 3,
                    "mean_qscore": 9.5
                },
                {
                    "count": 7,
                    "mean_qscore": 10.0
                },
                {
                    "count": 2,
                    "mean_qscore": 11.0
                }
            ],
            "qscore_sum_temp": {
                "count": 17,
                "mean": 9.59516143798828,
                "sum": 163.117736816406
            },
            "read_len_events_sum_temp": 186823,
            "seq_len_bases_dist_temp": [
                {
                    "count": 17,
                    "length": 0.0
                }
            ],
            "seq_len_bases_sum_temp": 17,
            "seq_len_events_dist_temp": [
                {
                    "count": 3,
                    "length": 3000.0
                },
                {
                    "count": 1,
                    "length": 4000.0
                },
                {
                    "count": 1,
                    "length": 6000.0
                },
                {
                    "count": 1,
                    "length": 9000.0
                },
                {
                    "count": 2,
                    "length": 10000.0
                },
                {
                    "count": 3,
                    "length": 11000.0
                },
                {
                    "count": 1,
                    "length": 12000.0
                },
                {
                    "count": 1,
                    "length": 13000.0
                },
                {
                    "count": 1,
                    "length": 15000.0
                },
                {
                    "count": 1,
                    "length": 16000.0
                },
                {
                    "count": 1,
                    "length": 17000.0
                },
                {
                    "count": 1,
                    "length": 23000.0
                }
            ],
            "speed_bases_per_second_dist_temp": [
                {
                    "count": 17,
                    "speed": 1.0
                }
            ],
            "strand_median_pa": {
                "count": 17,
                "mean": 90.4386291503906,
                "sum": 1537.45666503906
            },
            "strand_sd_pa": {
                "count": 17,
                "mean": 9.46197319030762,
                "sum": 160.853546142578
            }
        },
        "channel_count": 17,
        "context_tags": {
            "experiment_kit": "genomic_dna",
            "filename": "odw_genlab4209_20161213_fn_mn16303_sequencing_run_sample_id_32395",
            "sample_frequency": "4000",
            "user_filename_input": "sample_id"
        },
        "latest_run_time": 6528.97607421875,
        "levels_sums": {
            "count": 17,
            "mean": 221.931701660156,
            "open_pore_level_sum": 3772.8388671875
        },
        "opts": {
            "adapter_pt_range_scale": "5.200000",
            "align_ref": "",
            "allow_inferior_barcodes": "0",
            "arrangements_files": "",
            "as_cpu_threads_per_scaler": "2",
            "as_gpu_runners_per_device": "2",
            "as_model_file": "adapter_scaling_dna_r9.4.1_min.jsn",
            "as_num_scalers": "1",
            "as_reads_per_runner": "32",
            "barcode_kits": "",
            "barcoding_config_file": "configuration.cfg",
            "bed_file": "",
            "builtin_scripts": "1",
            "calib_detect": "0",
            "calib_max_sequence_length": "3800",
            "calib_min_coverage": "0.600000",
            "calib_min_sequence_length": "3000",
            "calib_reference": "lambda_3.6kb.fasta",
            "chunk_size": "2000",
            "chunks_per_caller": "10000",
            "chunks_per_runner": "160",
            "client_id": "-1",
            "compress_fastq": "0",
            "cpu_threads_per_caller": "4",
            "detect_mid_strand_barcodes": "0",
            "device": "auto",
            "disable_events": "0",
            "disable_pings": "0",
            "dmean_threshold": "1.000000",
            "dmean_win_size": "2",
            "end_gap1": "40",
            "end_gap2": "40",
            "extend_gap1": "40",
            "extend_gap2": "160",
            "fast5_out": "0",
            "flowcell": "",
            "front_window_size": "150",
            "gpu_runners_per_device": "8",
            "high_priority_threshold": "10",
            "input_file_list": "",
            "jump_threshold": "1.000000",
            "kernel_path": "",
            "kit": "",
            "log_speed_frequency": "0",
            "max_block_size": "50000",
            "max_queued_reads": "2000",
            "max_search_len": "1000",
            "medium_priority_threshold": "4",
            "min_qscore": "7.000000",
            "min_score": "60.000000",
            "min_score_mid_barcodes": "60.000000",
            "min_score_rear_override": "60.000000",
            "model_file": "template_r9.4.1_450bps_fast.jsn",
            "nested_output_folder": "0",
            "num_alignment_threads": "4",
            "num_barcode_threads": "4",
            "num_barcoding_buffers": "96",
            "num_callers": "5",
            "num_extra_bases_trim": "0",
            "open_gap1": "40",
            "open_gap2": "160",
            "overlap": "50",
            "override_scaling": "0",
            "ping_segment_duration": "60",
            "ping_url": "https://ping.oxfordnanoportal.com/basecall",
            "port": "",
            "post_out": "0",
            "print_workflows": "0",
            "progress_stats_frequency": "-1.000000",
            "pt_median_offset": "2.500000",
            "pt_minimum_read_start_index": "30",
            "pt_required_adapter_drop": "30.000000",
            "pt_scaling": "0",
            "qscore_filtering": "0",
            "qscore_offset": "-0.130000",
            "qscore_scale": "0.905000",
            "quiet": "0",
            "read_batch_size": "4000",
            "read_id_list": "",
            "rear_window_size": "150",
            "records_per_fastq": "4000",
            "recursive": "0",
            "require_barcodes_both_ends": "0",
            "resume": "0",
            "reverse_sequence": "0",
            "scaling_mad": "1.000000",
            "scaling_med": "0.000000",
            "score_matrix_filename": "",
            "server_file_load_timeout": "30",
            "start_gap1": "40",
            "start_gap2": "40",
            "stay_penalty": "1.000000",
            "temp_bias": "1.000000",
            "temp_weight": "1.000000",
            "trace_categories_logs": "",
            "trace_domains_config": "",
            "trace_domains_log": "",
            "trim_barcodes": "0",
            "trim_min_events": "3",
            "trim_strategy": "dna",
            "trim_threshold": "2.500000",
            "u_substitution": "0",
            "verbose_logs": "0"
        },
        "read_count": 17,
        "reads_per_channel_dist": [
            {
                "channel": 21,
                "count": 1
            },
            {
                "channel": 28,
                "count": 1
            },
            {
                "channel": 57,
                "count": 1
            },
            {
                "channel": 64,
                "count": 1
            },
            {
                "channel": 69,
                "count": 1
            },
            {
                "channel": 80,
                "count": 1
            },
            {
                "channel": 290,
                "count": 1
            },
            {
                "channel": 292,
                "count": 1
            },
            {
                "channel": 294,
                "count": 1
            },
            {
                "channel": 302,
                "count": 1
            },
            {
                "channel": 353,
                "count": 1
            },
            {
                "channel": 427,
                "count": 1
            },
            {
                "channel": 433,
                "count": 1
            },
            {
                "channel": 442,
                "count": 1
            },
            {
                "channel": 481,
                "count": 1
            },
            {
                "channel": 483,
                "count": 1
            },
            {
                "channel": 490,
                "count": 1
            }
        ],
        "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
        "segment_duration": 60,
        "segment_number": 2,
        "segment_type": "guppy-acquisition",
        "software": {
            "analysis": "1d_basecalling",
            "name": "guppy-basecalling",
            "version": "4.0.15+5694074"
        },
        "tracking_id": {
            "asic_id": "420170566",
            "asic_id_eeprom": "2043896",
            "asic_temp": "30.1846237",
            "auto_update": "1",
            "auto_update_source": "https://mirror.oxfordnanoportal.com/software/MinKNOW/",
            "bream_core_version": "1.1.21.1",
            "bream_is_standard": "1",
            "bream_map_version": "1.1.21.1",
            "bream_ont_version": "1.1.21.1",
            "bream_prod_version": "1.1.21.1",
            "bream_rnd_version": "0.1.1",
            "device_id": "MN16303",
            "exp_script_name": "NC_48Hr_Sequencing_Run_FLO-MIN106_SQK-LSK108.py",
            "exp_script_purpose": "sequencing_run",
            "exp_start_time": "1481657610",
            "flow_cell_id": "",
            "heatsink_temp": "33.9765625",
            "hostname": "odw-genlab4209",
            "installation_type": "map",
            "local_firmware_file": "0",
            "msg_id": "ef409edb-b712-46ff-80fa-fec45e94eb95",
            "operating_system": "Windows 6.1",
            "protocol_run_id": "3eecebf6-325f-4ac5-b896-a7588f2b2324",
            "protocols_version": "1.1.21",
            "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
            "time_stamp": "2020-09-30T16:38:16Z",
            "usb_config": "1.0.11_ONT#MinION_fpga_1.0.1#ctrl#Auto",
            "version": "1.1.21"
        }
    },
    {
        "aggregation": "segment",
        "analysis_id": "5f809176-8b0a-4419-959e-6638bfa895b6",
        "basecall_1d": {
            "exit_status_dist": {
                "fail:qscore_filter": 1,
                "pass": 24
            },
            "qscore_dist_temp": [
                {
                    "count": 1,
                    "mean_qscore": 6.5
                },
                {
                    "count": 1,
                    "mean_qscore": 7.0
                },
                {
                    "count": 1,
                    "mean_qscore": 7.5
                },
                {
                    "count": 2,
                    "mean_qscore": 8.5
                },
                {
                    "count": 2,
                    "mean_qscore": 9.0
                },
                {
                    "count": 3,
                    "mean_qscore": 9.5
                },
                {
                    "count": 3,
                    "mean_qscore": 10.0
                },
                {
                    "count": 8,
                    "mean_qscore": 10.5
                },
                {
                    "count": 3,
                    "mean_qscore": 11.0
                },
                {
                    "count": 1,
                    "mean_qscore": 11.5
                }
            ],
            "qscore_sum_temp": {
                "count": 25,
                "mean": 9.95819854736328,
                "sum": 248.954971313477
            },
            "read_len_events_sum_temp": 288514,
            "seq_len_bases_dist_temp": [
                {
                    "count": 25,
                    "length": 0.0
                }
            ],
            "seq_len_bases_sum_temp": 25,
            "seq_len_events_dist_temp": [
                {
                    "count": 3,
                    "length": 4000.0
                },
                {
                    "count": 3,
                    "length": 5000.0
                },
                {
                    "count": 1,
                    "length": 6000.0
                },
                {
                    "count": 1,
                    "length": 8000.0
                },
                {
                    "count": 3,
                    "length": 9000.0
                },
                {
                    "count": 4,
                    "length": 11000.0
                },
                {
                    "count": 1,
                    "length": 12000.0
                },
                {
                    "count": 1,
                    "length": 13000.0
                },
                {
                    "count": 1,
                    "length": 14000.0
                },
                {
                    "count": 3,
                    "length": 15000.0
                },
                {
                    "count": 1,
                    "length": 17000.0
                },
                {
                    "count": 2,
                    "length": 18000.0
                },
                {
                    "count": 1,
                    "length": 27000.0
                }
            ],
            "speed_bases_per_second_dist_temp": [
                {
                    "count": 25,
                    "speed": 1.0
                }
            ],
            "strand_median_pa": {
                "count": 25,
                "mean": 104.131500244141,
                "sum": 2603.28759765625
            },
            "strand_sd_pa": {
                "count": 25,
                "mean": 9.77820205688477,
                "sum": 244.455062866211
            }
        },
        "channel_count": 22,
        "context_tags": {
            "experiment_kit": "genomic_dna",
            "filename": "odw_genlab4209_20161213_fn_mn16303_sequencing_run_sample_id_32395",
            "sample_frequency": "4000",
            "user_filename_input": "sample_id"
        },
        "latest_run_time": 10348.9326171875,
        "levels_sums": {
            "count": 25,
            "mean": 236.169357299805,
            "open_pore_level_sum": 5904.23388671875
        },
        "opts": {
            "adapter_pt_range_scale": "5.200000",
            "align_ref": "",
            "allow_inferior_barcodes": "0",
            "arrangements_files": "",
            "as_cpu_threads_per_scaler": "2",
            "as_gpu_runners_per_device": "2",
            "as_model_file": "adapter_scaling_dna_r9.4.1_min.jsn",
            "as_num_scalers": "1",
            "as_reads_per_runner": "32",
            "barcode_kits": "",
            "barcoding_config_file": "configuration.cfg",
            "bed_file": "",
            "builtin_scripts": "1",
            "calib_detect": "0",
            "calib_max_sequence_length": "3800",
            "calib_min_coverage": "0.600000",
            "calib_min_sequence_length": "3000",
            "calib_reference": "lambda_3.6kb.fasta",
            "chunk_size": "2000",
            "chunks_per_caller": "10000",
            "chunks_per_runner": "160",
            "client_id": "-1",
            "compress_fastq": "0",
            "cpu_threads_per_caller": "4",
            "detect_mid_strand_barcodes": "0",
            "device": "auto",
            "disable_events": "0",
            "disable_pings": "0",
            "dmean_threshold": "1.000000",
            "dmean_win_size": "2",
            "end_gap1": "40",
            "end_gap2": "40",
            "extend_gap1": "40",
            "extend_gap2": "160",
            "fast5_out": "0",
            "flowcell": "",
            "front_window_size": "150",
            "gpu_runners_per_device": "8",
            "high_priority_threshold": "10",
            "input_file_list": "",
            "jump_threshold": "1.000000",
            "kernel_path": "",
            "kit": "",
            "log_speed_frequency": "0",
            "max_block_size": "50000",
            "max_queued_reads": "2000",
            "max_search_len": "1000",
            "medium_priority_threshold": "4",
            "min_qscore": "7.000000",
            "min_score": "60.000000",
            "min_score_mid_barcodes": "60.000000",
            "min_score_rear_override": "60.000000",
            "model_file": "template_r9.4.1_450bps_fast.jsn",
            "nested_output_folder": "0",
            "num_alignment_threads": "4",
            "num_barcode_threads": "4",
            "num_barcoding_buffers": "96",
            "num_callers": "5",
            "num_extra_bases_trim": "0",
            "open_gap1": "40",
            "open_gap2": "160",
            "overlap": "50",
            "override_scaling": "0",
            "ping_segment_duration": "60",
            "ping_url": "https://ping.oxfordnanoportal.com/basecall",
            "port": "",
            "post_out": "0",
            "print_workflows": "0",
            "progress_stats_frequency": "-1.000000",
            "pt_median_offset": "2.500000",
            "pt_minimum_read_start_index": "30",
            "pt_required_adapter_drop": "30.000000",
            "pt_scaling": "0",
            "qscore_filtering": "0",
            "qscore_offset": "-0.130000",
            "qscore_scale": "0.905000",
            "quiet": "0",
            "read_batch_size": "4000",
            "read_id_list": "",
            "rear_window_size": "150",
            "records_per_fastq": "4000",
            "recursive": "0",
            "require_barcodes_both_ends": "0",
            "resume": "0",
            "reverse_sequence": "0",
            "scaling_mad": "1.000000",
            "scaling_med": "0.000000",
            "score_matrix_filename": "",
            "server_file_load_timeout": "30",
            "start_gap1": "40",
            "start_gap2": "40",
            "stay_penalty": "1.000000",
            "temp_bias": "1.000000",
            "temp_weight": "1.000000",
            "trace_categories_logs": "",
            "trace_domains_config": "",
            "trace_domains_log": "",
            "trim_barcodes": "0",
            "trim_min_events": "3",
            "trim_strategy": "dna",
            "trim_threshold": "2.500000",
            "u_substitution": "0",
            "verbose_logs": "0"
        },
        "read_count": 25,
        "reads_per_channel_dist": [
            {
                "channel": 8,
                "count": 1
            },
            {
                "channel": 24,
                "count": 1
            },
            {
                "channel": 43,
                "count": 2
            },
            {
                "channel": 85,
                "count": 1
            },
            {
                "channel": 91,
                "count": 1
            },
            {
                "channel": 98,
                "count": 2
            },
            {
                "channel": 109,
                "count": 1
            },
            {
                "channel": 111,
                "count": 1
            },
            {
                "channel": 123,
                "count": 1
            },
            {
                "channel": 174,
                "count": 1
            },
            {
                "channel": 177,
                "count": 1
            },
            {
                "channel": 196,
                "count": 1
            },
            {
                "channel": 280,
                "count": 1
            },
            {
                "channel": 289,
                "count": 2
            },
            {
                "channel": 290,
                "count": 1
            },
            {
                "channel": 342,
                "count": 1
            },
            {
                "channel": 355,
                "count": 1
            },
            {
                "channel": 391,
                "count": 1
            },
            {
                "channel": 418,
                "count": 1
            },
            {
                "channel": 481,
                "count": 1
            },
            {
                "channel": 493,
                "count": 1
            },
            {
                "channel": 505,
                "count": 1
            }
        ],
        "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
        "segment_duration": 60,
        "segment_number": 3,
        "segment_type": "guppy-acquisition",
        "software": {
            "analysis": "1d_basecalling",
            "name": "guppy-basecalling",
            "version": "4.0.15+5694074"
        },
        "tracking_id": {
            "asic_id": "420170566",
            "asic_id_eeprom": "2043896",
            "asic_temp": "30.1846237",
            "auto_update": "1",
            "auto_update_source": "https://mirror.oxfordnanoportal.com/software/MinKNOW/",
            "bream_core_version": "1.1.21.1",
            "bream_is_standard": "1",
            "bream_map_version": "1.1.21.1",
            "bream_ont_version": "1.1.21.1",
            "bream_prod_version": "1.1.21.1",
            "bream_rnd_version": "0.1.1",
            "device_id": "MN16303",
            "exp_script_name": "NC_48Hr_Sequencing_Run_FLO-MIN106_SQK-LSK108.py",
            "exp_script_purpose": "sequencing_run",
            "exp_start_time": "1481657610",
            "flow_cell_id": "",
            "heatsink_temp": "33.9765625",
            "hostname": "odw-genlab4209",
            "installation_type": "map",
            "local_firmware_file": "0",
            "msg_id": "dac8236a-9dde-4052-a1eb-1d461cd7f6f6",
            "operating_system": "Windows 6.1",
            "protocol_run_id": "3eecebf6-325f-4ac5-b896-a7588f2b2324",
            "protocols_version": "1.1.21",
            "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
            "time_stamp": "2020-09-30T16:38:16Z",
            "usb_config": "1.0.11_ONT#MinION_fpga_1.0.1#ctrl#Auto",
            "version": "1.1.21"
        }
    },
    {
        "aggregation": "segment",
        "analysis_id": "5f809176-8b0a-4419-959e-6638bfa895b6",
        "basecall_1d": {
            "exit_status_dist": {
                "pass": 8
            },
            "qscore_dist_temp": [
                {
                    "count": 1,
                    "mean_qscore": 9.5
                },
                {
                    "count": 1,
                    "mean_qscore": 10.0
                },
                {
                    "count": 1,
                    "mean_qscore": 10.5
                },
                {
                    "count": 5,
                    "mean_qscore": 11.0
                }
            ],
            "qscore_sum_temp": {
                "count": 8,
                "mean": 10.8662509918213,
                "sum": 86.9300079345703
            },
            "read_len_events_sum_temp": 113755,
            "seq_len_bases_dist_temp": [
                {
                    "count": 8,
                    "length": 0.0
                }
            ],
            "seq_len_bases_sum_temp": 8,
            "seq_len_events_dist_temp": [
                {
                    "count": 1,
                    "length": 3000.0
                },
                {
                    "count": 1,
                    "length": 9000.0
                },
                {
                    "count": 1,
                    "length": 12000.0
                },
                {
                    "count": 1,
                    "length": 13000.0
                },
                {
                    "count": 1,
                    "length": 15000.0
                },
                {
                    "count": 2,
                    "length": 18000.0
                },
                {
                    "count": 1,
                    "length": 22000.0
                }
            ],
            "speed_bases_per_second_dist_temp": [
                {
                    "count": 8,
                    "speed": 1.0
                }
            ],
            "strand_median_pa": {
                "count": 8,
                "mean": 96.4107208251953,
                "sum": 771.285766601562
            },
            "strand_sd_pa": {
                "count": 8,
                "mean": 9.59036445617676,
                "sum": 76.7229156494141
            }
        },
        "channel_count": 7,
        "context_tags": {
            "experiment_kit": "genomic_dna",
            "filename": "odw_genlab4209_20161213_fn_mn16303_sequencing_run_sample_id_32395",
            "sample_frequency": "4000",
            "user_filename_input": "sample_id"
        },
        "latest_run_time": 14301.6181640625,
        "levels_sums": {
            "count": 8,
            "mean": 227.004364013672,
            "open_pore_level_sum": 1816.03491210938
        },
        "opts": {
            "adapter_pt_range_scale": "5.200000",
            "align_ref": "",
            "allow_inferior_barcodes": "0",
            "arrangements_files": "",
            "as_cpu_threads_per_scaler": "2",
            "as_gpu_runners_per_device": "2",
            "as_model_file": "adapter_scaling_dna_r9.4.1_min.jsn",
            "as_num_scalers": "1",
            "as_reads_per_runner": "32",
            "barcode_kits": "",
            "barcoding_config_file": "configuration.cfg",
            "bed_file": "",
            "builtin_scripts": "1",
            "calib_detect": "0",
            "calib_max_sequence_length": "3800",
            "calib_min_coverage": "0.600000",
            "calib_min_sequence_length": "3000",
            "calib_reference": "lambda_3.6kb.fasta",
            "chunk_size": "2000",
            "chunks_per_caller": "10000",
            "chunks_per_runner": "160",
            "client_id": "-1",
            "compress_fastq": "0",
            "cpu_threads_per_caller": "4",
            "detect_mid_strand_barcodes": "0",
            "device": "auto",
            "disable_events": "0",
            "disable_pings": "0",
            "dmean_threshold": "1.000000",
            "dmean_win_size": "2",
            "end_gap1": "40",
            "end_gap2": "40",
            "extend_gap1": "40",
            "extend_gap2": "160",
            "fast5_out": "0",
            "flowcell": "",
            "front_window_size": "150",
            "gpu_runners_per_device": "8",
            "high_priority_threshold": "10",
            "input_file_list": "",
            "jump_threshold": "1.000000",
            "kernel_path": "",
            "kit": "",
            "log_speed_frequency": "0",
            "max_block_size": "50000",
            "max_queued_reads": "2000",
            "max_search_len": "1000",
            "medium_priority_threshold": "4",
            "min_qscore": "7.000000",
            "min_score": "60.000000",
            "min_score_mid_barcodes": "60.000000",
            "min_score_rear_override": "60.000000",
            "model_file": "template_r9.4.1_450bps_fast.jsn",
            "nested_output_folder": "0",
            "num_alignment_threads": "4",
            "num_barcode_threads": "4",
            "num_barcoding_buffers": "96",
            "num_callers": "5",
            "num_extra_bases_trim": "0",
            "open_gap1": "40",
            "open_gap2": "160",
            "overlap": "50",
            "override_scaling": "0",
            "ping_segment_duration": "60",
            "ping_url": "https://ping.oxfordnanoportal.com/basecall",
            "port": "",
            "post_out": "0",
            "print_workflows": "0",
            "progress_stats_frequency": "-1.000000",
            "pt_median_offset": "2.500000",
            "pt_minimum_read_start_index": "30",
            "pt_required_adapter_drop": "30.000000",
            "pt_scaling": "0",
            "qscore_filtering": "0",
            "qscore_offset": "-0.130000",
            "qscore_scale": "0.905000",
            "quiet": "0",
            "read_batch_size": "4000",
            "read_id_list": "",
            "rear_window_size": "150",
            "records_per_fastq": "4000",
            "recursive": "0",
            "require_barcodes_both_ends": "0",
            "resume": "0",
            "reverse_sequence": "0",
            "scaling_mad": "1.000000",
            "scaling_med": "0.000000",
            "score_matrix_filename": "",
            "server_file_load_timeout": "30",
            "start_gap1": "40",
            "start_gap2": "40",
            "stay_penalty": "1.000000",
            "temp_bias": "1.000000",
            "temp_weight": "1.000000",
            "trace_categories_logs": "",
            "trace_domains_config": "",
            "trace_domains_log": "",
            "trim_barcodes": "0",
            "trim_min_events": "3",
            "trim_strategy": "dna",
            "trim_threshold": "2.500000",
            "u_substitution": "0",
            "verbose_logs": "0"
        },
        "read_count": 8,
        "reads_per_channel_dist": [
            {
                "channel": 7,
                "count": 1
            },
            {
                "channel": 43,
                "count": 1
            },
            {
                "channel": 391,
                "count": 1
            },
            {
                "channel": 407,
                "count": 1
            },
            {
                "channel": 460,
                "count": 2
            },
            {
                "channel": 486,
                "count": 1
            },
            {
                "channel": 505,
                "count": 1
            }
        ],
        "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
        "segment_duration": 60,
        "segment_number": 4,
        "segment_type": "guppy-acquisition",
        "software": {
            "analysis": "1d_basecalling",
            "name": "guppy-basecalling",
            "version": "4.0.15+5694074"
        },
        "tracking_id": {
            "asic_id": "420170566",
            "asic_id_eeprom": "2043896",
            "asic_temp": "30.1846237",
            "auto_update": "1",
            "auto_update_source": "https://mirror.oxfordnanoportal.com/software/MinKNOW/",
            "bream_core_version": "1.1.21.1",
            "bream_is_standard": "1",
            "bream_map_version": "1.1.21.1",
            "bream_ont_version": "1.1.21.1",
            "bream_prod_version": "1.1.21.1",
            "bream_rnd_version": "0.1.1",
            "device_id": "MN16303",
            "exp_script_name": "NC_48Hr_Sequencing_Run_FLO-MIN106_SQK-LSK108.py",
            "exp_script_purpose": "sequencing_run",
            "exp_start_time": "1481657610",
            "flow_cell_id": "",
            "heatsink_temp": "33.9765625",
            "hostname": "odw-genlab4209",
            "installation_type": "map",
            "local_firmware_file": "0",
            "msg_id": "b206503d-4218-43b4-9acc-5ee2b8f2ae83",
            "operating_system": "Windows 6.1",
            "protocol_run_id": "3eecebf6-325f-4ac5-b896-a7588f2b2324",
            "protocols_version": "1.1.21",
            "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
            "time_stamp": "2020-09-30T16:38:16Z",
            "usb_config": "1.0.11_ONT#MinION_fpga_1.0.1#ctrl#Auto",
            "version": "1.1.21"
        }
    },
    {
        "aggregation": "segment",
        "analysis_id": "5f809176-8b0a-4419-959e-6638bfa895b6",
        "basecall_1d": {
            "exit_status_dist": {
                "fail:qscore_filter": 4,
                "pass": 10
            },
            "qscore_dist_temp": [
                {
                    "count": 3,
                    "mean_qscore": 6.0
                },
                {
                    "count": 1,
                    "mean_qscore": 6.5
                },
                {
                    "count": 1,
                    "mean_qscore": 7.0
                },
                {
                    "count": 1,
                    "mean_qscore": 7.5
                },
                {
                    "count": 3,
                    "mean_qscore": 9.0
                },
                {
                    "count": 1,
                    "mean_qscore": 9.5
                },
                {
                    "count": 1,
                    "mean_qscore": 10.0
                },
                {
                    "count": 1,
                    "mean_qscore": 10.5
                },
                {
                    "count": 1,
                    "mean_qscore": 11.0
                },
                {
                    "count": 1,
                    "mean_qscore": 11.5
                }
            ],
            "qscore_sum_temp": {
                "count": 14,
                "mean": 8.71355724334717,
                "sum": 121.989807128906
            },
            "read_len_events_sum_temp": 183801,
            "seq_len_bases_dist_temp": [
                {
                    "count": 14,
                    "length": 0.0
                }
            ],
            "seq_len_bases_sum_temp": 14,
            "seq_len_events_dist_temp": [
                {
                    "count": 2,
                    "length": 4000.0
                },
                {
                    "count": 1,
                    "length": 6000.0
                },
                {
                    "count": 1,
                    "length": 7000.0
                },
                {
                    "count": 1,
                    "length": 8000.0
                },
                {
                    "count": 1,
                    "length": 10000.0
                },
                {
                    "count": 1,
                    "length": 13000.0
                },
                {
                    "count": 2,
                    "length": 15000.0
                },
                {
                    "count": 1,
                    "length": 16000.0
                },
                {
                    "count": 1,
                    "length": 17000.0
                },
                {
                    "count": 1,
                    "length": 18000.0
                },
                {
                    "count": 1,
                    "length": 20000.0
                },
                {
                    "count": 1,
                    "length": 24000.0
                }
            ],
            "speed_bases_per_second_dist_temp": [
                {
                    "count": 14,
                    "speed": 1.0
                }
            ],
            "strand_median_pa": {
                "count": 14,
                "mean": 90.2911529541016,
                "sum": 1264.076171875
            },
            "strand_sd_pa": {
                "count": 14,
                "mean": 9.56201839447021,
                "sum": 133.868255615234
            }
        },
        "channel_count": 11,
        "context_tags": {
            "experiment_kit": "genomic_dna",
            "filename": "odw_genlab4209_20161213_fn_mn16303_sequencing_run_sample_id_32395",
            "sample_frequency": "4000",
            "user_filename_input": "sample_id"
        },
        "latest_run_time": 17479.8828125,
        "levels_sums": {
            "count": 14,
            "mean": 224.018020629883,
            "open_pore_level_sum": 3136.25219726562
        },
        "opts": {
            "adapter_pt_range_scale": "5.200000",
            "align_ref": "",
            "allow_inferior_barcodes": "0",
            "arrangements_files": "",
            "as_cpu_threads_per_scaler": "2",
            "as_gpu_runners_per_device": "2",
            "as_model_file": "adapter_scaling_dna_r9.4.1_min.jsn",
            "as_num_scalers": "1",
            "as_reads_per_runner": "32",
            "barcode_kits": "",
            "barcoding_config_file": "configuration.cfg",
            "bed_file": "",
            "builtin_scripts": "1",
            "calib_detect": "0",
            "calib_max_sequence_length": "3800",
            "calib_min_coverage": "0.600000",
            "calib_min_sequence_length": "3000",
            "calib_reference": "lambda_3.6kb.fasta",
            "chunk_size": "2000",
            "chunks_per_caller": "10000",
            "chunks_per_runner": "160",
            "client_id": "-1",
            "compress_fastq": "0",
            "cpu_threads_per_caller": "4",
            "detect_mid_strand_barcodes": "0",
            "device": "auto",
            "disable_events": "0",
            "disable_pings": "0",
            "dmean_threshold": "1.000000",
            "dmean_win_size": "2",
            "end_gap1": "40",
            "end_gap2": "40",
            "extend_gap1": "40",
            "extend_gap2": "160",
            "fast5_out": "0",
            "flowcell": "",
            "front_window_size": "150",
            "gpu_runners_per_device": "8",
            "high_priority_threshold": "10",
            "input_file_list": "",
            "jump_threshold": "1.000000",
            "kernel_path": "",
            "kit": "",
            "log_speed_frequency": "0",
            "max_block_size": "50000",
            "max_queued_reads": "2000",
            "max_search_len": "1000",
            "medium_priority_threshold": "4",
            "min_qscore": "7.000000",
            "min_score": "60.000000",
            "min_score_mid_barcodes": "60.000000",
            "min_score_rear_override": "60.000000",
            "model_file": "template_r9.4.1_450bps_fast.jsn",
            "nested_output_folder": "0",
            "num_alignment_threads": "4",
            "num_barcode_threads": "4",
            "num_barcoding_buffers": "96",
            "num_callers": "5",
            "num_extra_bases_trim": "0",
            "open_gap1": "40",
            "open_gap2": "160",
            "overlap": "50",
            "override_scaling": "0",
            "ping_segment_duration": "60",
            "ping_url": "https://ping.oxfordnanoportal.com/basecall",
            "port": "",
            "post_out": "0",
            "print_workflows": "0",
            "progress_stats_frequency": "-1.000000",
            "pt_median_offset": "2.500000",
            "pt_minimum_read_start_index": "30",
            "pt_required_adapter_drop": "30.000000",
            "pt_scaling": "0",
            "qscore_filtering": "0",
            "qscore_offset": "-0.130000",
            "qscore_scale": "0.905000",
            "quiet": "0",
            "read_batch_size": "4000",
            "read_id_list": "",
            "rear_window_size": "150",
            "records_per_fastq": "4000",
            "recursive": "0",
            "require_barcodes_both_ends": "0",
            "resume": "0",
            "reverse_sequence": "0",
            "scaling_mad": "1.000000",
            "scaling_med": "0.000000",
            "score_matrix_filename": "",
            "server_file_load_timeout": "30",
            "start_gap1": "40",
            "start_gap2": "40",
            "stay_penalty": "1.000000",
            "temp_bias": "1.000000",
            "temp_weight": "1.000000",
            "trace_categories_logs": "",
            "trace_domains_config": "",
            "trace_domains_log": "",
            "trim_barcodes": "0",
            "trim_min_events": "3",
            "trim_strategy": "dna",
            "trim_threshold": "2.500000",
            "u_substitution": "0",
            "verbose_logs": "0"
        },
        "read_count": 14,
        "reads_per_channel_dist": [
            {
                "channel": 40,
                "count": 1
            },
            {
                "channel": 41,
                "count": 1
            },
            {
                "channel": 54,
                "count": 1
            },
            {
                "channel": 57,
                "count": 1
            },
            {
                "channel": 84,
                "count": 1
            },
            {
                "channel": 95,
                "count": 1
            },
            {
                "channel": 316,
                "count": 2
            },
            {
                "channel": 361,
                "count": 1
            },
            {
                "channel": 378,
                "count": 3
            },
            {
                "channel": 491,
                "count": 1
            },
            {
                "channel": 497,
                "count": 1
            }
        ],
        "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
        "segment_duration": 60,
        "segment_number": 5,
        "segment_type": "guppy-acquisition",
        "software": {
            "analysis": "1d_basecalling",
            "name": "guppy-basecalling",
            "version": "4.0.15+5694074"
        },
        "tracking_id": {
            "asic_id": "420170566",
            "asic_id_eeprom": "2043896",
            "asic_temp": "30.1846237",
            "auto_update": "1",
            "auto_update_source": "https://mirror.oxfordnanoportal.com/software/MinKNOW/",
            "bream_core_version": "1.1.21.1",
            "bream_is_standard": "1",
            "bream_map_version": "1.1.21.1",
            "bream_ont_version": "1.1.21.1",
            "bream_prod_version": "1.1.21.1",
            "bream_rnd_version": "0.1.1",
            "device_id": "MN16303",
            "exp_script_name": "NC_48Hr_Sequencing_Run_FLO-MIN106_SQK-LSK108.py",
            "exp_script_purpose": "sequencing_run",
            "exp_start_time": "1481657610",
            "flow_cell_id": "",
            "heatsink_temp": "33.9765625",
            "hostname": "odw-genlab4209",
            "installation_type": "map",
            "local_firmware_file": "0",
            "msg_id": "9fcb2df5-14f7-47cc-92ff-38509cfaff28",
            "operating_system": "Windows 6.1",
            "protocol_run_id": "3eecebf6-325f-4ac5-b896-a7588f2b2324",
            "protocols_version": "1.1.21",
            "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
            "time_stamp": "2020-09-30T16:38:16Z",
            "usb_config": "1.0.11_ONT#MinION_fpga_1.0.1#ctrl#Auto",
            "version": "1.1.21"
        }
    },
    {
        "aggregation": "segment",
        "analysis_id": "5f809176-8b0a-4419-959e-6638bfa895b6",
        "basecall_1d": {
            "exit_status_dist": {
                "fail:qscore_filter": 1,
                "pass": 21
            },
            "qscore_dist_temp": [
                {
                    "count": 1,
                    "mean_qscore": 6.5
                },
                {
                    "count": 6,
                    "mean_qscore": 8.0
                },
                {
                    "count": 2,
                    "mean_qscore": 8.5
                },
                {
                    "count": 2,
                    "mean_qscore": 9.0
                },
                {
                    "count": 4,
                    "mean_qscore": 10.0
                },
                {
                    "count": 2,
                    "mean_qscore": 10.5
                },
                {
                    "count": 2,
                    "mean_qscore": 11.0
                },
                {
                    "count": 3,
                    "mean_qscore": 11.5
                }
            ],
            "qscore_sum_temp": {
                "count": 22,
                "mean": 9.67939376831055,
                "sum": 212.946670532227
            },
            "read_len_events_sum_temp": 258278,
            "seq_len_bases_dist_temp": [
                {
                    "count": 22,
                    "length": 0.0
                }
            ],
            "seq_len_bases_sum_temp": 22,
            "seq_len_events_dist_temp": [
                {
                    "count": 1,
                    "length": 2000.0
                },
                {
                    "count": 1,
                    "length": 3000.0
                },
                {
                    "count": 1,
                    "length": 4000.0
                },
                {
                    "count": 3,
                    "length": 5000.0
                },
                {
                    "count": 1,
                    "length": 6000.0
                },
                {
                    "count": 2,
                    "length": 8000.0
                },
                {
                    "count": 1,
                    "length": 9000.0
                },
                {
                    "count": 3,
                    "length": 11000.0
                },
                {
                    "count": 1,
                    "length": 12000.0
                },
                {
                    "count": 1,
                    "length": 14000.0
                },
                {
                    "count": 3,
                    "length": 16000.0
                },
                {
                    "count": 1,
                    "length": 18000.0
                },
                {
                    "count": 1,
                    "length": 19000.0
                },
                {
                    "count": 1,
                    "length": 22000.0
                },
                {
                    "count": 1,
                    "length": 26000.0
                }
            ],
            "speed_bases_per_second_dist_temp": [
                {
                    "count": 22,
                    "speed": 1.0
                }
            ],
            "strand_median_pa": {
                "count": 22,
                "mean": 99.7638244628906,
                "sum": 2194.80419921875
            },
            "strand_sd_pa": {
                "count": 22,
                "mean": 9.5963773727417,
                "sum": 211.120300292969
            }
        },
        "channel_count": 22,
        "context_tags": {
            "experiment_kit": "genomic_dna",
            "filename": "odw_genlab4209_20161213_fn_mn16303_sequencing_run_sample_id_32395",
            "sample_frequency": "4000",
            "user_filename_input": "sample_id"
        },
        "latest_run_time": 21142.6875,
        "levels_sums": {
            "count": 22,
            "mean": 232.005477905273,
            "open_pore_level_sum": 5104.12060546875
        },
        "opts": {
            "adapter_pt_range_scale": "5.200000",
            "align_ref": "",
            "allow_inferior_barcodes": "0",
            "arrangements_files": "",
            "as_cpu_threads_per_scaler": "2",
            "as_gpu_runners_per_device": "2",
            "as_model_file": "adapter_scaling_dna_r9.4.1_min.jsn",
            "as_num_scalers": "1",
            "as_reads_per_runner": "32",
            "barcode_kits": "",
            "barcoding_config_file": "configuration.cfg",
            "bed_file": "",
            "builtin_scripts": "1",
            "calib_detect": "0",
            "calib_max_sequence_length": "3800",
            "calib_min_coverage": "0.600000",
            "calib_min_sequence_length": "3000",
            "calib_reference": "lambda_3.6kb.fasta",
            "chunk_size": "2000",
            "chunks_per_caller": "10000",
            "chunks_per_runner": "160",
            "client_id": "-1",
            "compress_fastq": "0",
            "cpu_threads_per_caller": "4",
            "detect_mid_strand_barcodes": "0",
            "device": "auto",
            "disable_events": "0",
            "disable_pings": "0",
            "dmean_threshold": "1.000000",
            "dmean_win_size": "2",
            "end_gap1": "40",
            "end_gap2": "40",
            "extend_gap1": "40",
            "extend_gap2": "160",
            "fast5_out": "0",
            "flowcell": "",
            "front_window_size": "150",
            "gpu_runners_per_device": "8",
            "high_priority_threshold": "10",
            "input_file_list": "",
            "jump_threshold": "1.000000",
            "kernel_path": "",
            "kit": "",
            "log_speed_frequency": "0",
            "max_block_size": "50000",
            "max_queued_reads": "2000",
            "max_search_len": "1000",
            "medium_priority_threshold": "4",
            "min_qscore": "7.000000",
            "min_score": "60.000000",
            "min_score_mid_barcodes": "60.000000",
            "min_score_rear_override": "60.000000",
            "model_file": "template_r9.4.1_450bps_fast.jsn",
            "nested_output_folder": "0",
            "num_alignment_threads": "4",
            "num_barcode_threads": "4",
            "num_barcoding_buffers": "96",
            "num_callers": "5",
            "num_extra_bases_trim": "0",
            "open_gap1": "40",
            "open_gap2": "160",
            "overlap": "50",
            "override_scaling": "0",
            "ping_segment_duration": "60",
            "ping_url": "https://ping.oxfordnanoportal.com/basecall",
            "port": "",
            "post_out": "0",
            "print_workflows": "0",
            "progress_stats_frequency": "-1.000000",
            "pt_median_offset": "2.500000",
            "pt_minimum_read_start_index": "30",
            "pt_required_adapter_drop": "30.000000",
            "pt_scaling": "0",
            "qscore_filtering": "0",
            "qscore_offset": "-0.130000",
            "qscore_scale": "0.905000",
            "quiet": "0",
            "read_batch_size": "4000",
            "read_id_list": "",
            "rear_window_size": "150",
            "records_per_fastq": "4000",
            "recursive": "0",
            "require_barcodes_both_ends": "0",
            "resume": "0",
            "reverse_sequence": "0",
            "scaling_mad": "1.000000",
            "scaling_med": "0.000000",
            "score_matrix_filename": "",
            "server_file_load_timeout": "30",
            "start_gap1": "40",
            "start_gap2": "40",
            "stay_penalty": "1.000000",
            "temp_bias": "1.000000",
            "temp_weight": "1.000000",
            "trace_categories_logs": "",
            "trace_domains_config": "",
            "trace_domains_log": "",
            "trim_barcodes": "0",
            "trim_min_events": "3",
            "trim_strategy": "dna",
            "trim_threshold": "2.500000",
            "u_substitution": "0",
            "verbose_logs": "0"
        },
        "read_count": 22,
        "reads_per_channel_dist": [
            {
                "channel": 43,
                "count": 1
            },
            {
                "channel": 44,
                "count": 1
            },
            {
                "channel": 54,
                "count": 1
            },
            {
                "channel": 57,
                "count": 1
            },
            {
                "channel": 64,
                "count": 1
            },
            {
                "channel": 66,
                "count": 1
            },
            {
                "channel": 107,
                "count": 1
            },
            {
                "channel": 111,
                "count": 1
            },
            {
                "channel": 139,
                "count": 1
            },
            {
                "channel": 158,
                "count": 1
            },
            {
                "channel": 170,
                "count": 1
            },
            {
                "channel": 200,
                "count": 1
            },
            {
                "channel": 281,
                "count": 1
            },
            {
                "channel": 302,
                "count": 1
            },
            {
                "channel": 309,
                "count": 1
            },
            {
                "channel": 326,
                "count": 1
            },
            {
                "channel": 378,
                "count": 1
            },
            {
                "channel": 381,
                "count": 1
            },
            {
                "channel": 383,
                "count": 1
            },
            {
                "channel": 403,
                "count": 1
            },
            {
                "channel": 442,
                "count": 1
            },
            {
                "channel": 493,
                "count": 1
            }
        ],
        "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
        "segment_duration": 60,
        "segment_number": 6,
        "segment_type": "guppy-acquisition",
        "software": {
            "analysis": "1d_basecalling",
            "name": "guppy-basecalling",
            "version": "4.0.15+5694074"
        },
        "tracking_id": {
            "asic_id": "420170566",
            "asic_id_eeprom": "2043896",
            "asic_temp": "30.1846237",
            "auto_update": "1",
            "auto_update_source": "https://mirror.oxfordnanoportal.com/software/MinKNOW/",
            "bream_core_version": "1.1.21.1",
            "bream_is_standard": "1",
            "bream_map_version": "1.1.21.1",
            "bream_ont_version": "1.1.21.1",
            "bream_prod_version": "1.1.21.1",
            "bream_rnd_version": "0.1.1",
            "device_id": "MN16303",
            "exp_script_name": "NC_48Hr_Sequencing_Run_FLO-MIN106_SQK-LSK108.py",
            "exp_script_purpose": "sequencing_run",
            "exp_start_time": "1481657610",
            "flow_cell_id": "",
            "heatsink_temp": "33.9765625",
            "hostname": "odw-genlab4209",
            "installation_type": "map",
            "local_firmware_file": "0",
            "msg_id": "319de42a-9f4a-4ff2-9218-4684ba084dd3",
            "operating_system": "Windows 6.1",
            "protocol_run_id": "3eecebf6-325f-4ac5-b896-a7588f2b2324",
            "protocols_version": "1.1.21",
            "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
            "time_stamp": "2020-09-30T16:38:16Z",
            "usb_config": "1.0.11_ONT#MinION_fpga_1.0.1#ctrl#Auto",
            "version": "1.1.21"
        }
    },
    {
        "aggregation": "cumulative",
        "analysis_id": "5f809176-8b0a-4419-959e-6638bfa895b6",
        "basecall_1d": {
            "exit_status_dist": {
                "fail:qscore_filter": 7,
                "pass": 105
            },
            "qscore_dist_temp": [
                {
                    "count": 1,
                    "mean_qscore": 5.5
                },
                {
                    "count": 3,
                    "mean_qscore": 6.0
                },
                {
                    "count": 3,
                    "mean_qscore": 6.5
                },
                {
                    "count": 2,
                    "mean_qscore": 7.0
                },
                {
                    "count": 6,
                    "mean_qscore": 7.5
                },
                {
                    "count": 8,
                    "mean_qscore": 8.0
                },
                {
                    "count": 8,
                    "mean_qscore": 8.5
                },
                {
                    "count": 8,
                    "mean_qscore": 9.0
                },
                {
                    "count": 13,
                    "mean_qscore": 9.5
                },
                {
                    "count": 19,
                    "mean_qscore": 10.0
                },
                {
                    "count": 18,
                    "mean_qscore": 10.5
                },
                {
                    "count": 14,
                    "mean_qscore": 11.0
                },
                {
                    "count": 9,
                    "mean_qscore": 11.5
                }
            ],
            "qscore_sum_temp": {
                "count": 112,
                "mean": 9.76147651672363,
                "sum": 1093.28540039062
            },
            "read_len_events_sum_temp": 1356361,
            "seq_len_bases_dist_temp": [
                {
                    "count": 112,
                    "length": 0.0
                }
            ],
            "seq_len_bases_sum_temp": 112,
            "seq_len_events_dist_temp": [
                {
                    "count": 1,
                    "length": 1000.0
                },
                {
                    "count": 2,
                    "length": 2000.0
                },
                {
                    "count": 5,
                    "length": 3000.0
                },
                {
                    "count": 8,
                    "length": 4000.0
                },
                {
                    "count": 6,
                    "length": 5000.0
                },
                {
                    "count": 6,
                    "length": 6000.0
                },
                {
                    "count": 3,
                    "length": 7000.0
                },
                {
                    "count": 6,
                    "length": 8000.0
                },
                {
                    "count": 8,
                    "length": 9000.0
                },
                {
                    "count": 5,
                    "length": 10000.0
                },
                {
                    "count": 10,
                    "length": 11000.0
                },
                {
                    "count": 6,
                    "length": 12000.0
                },
                {
                    "count": 7,
                    "length": 13000.0
                },
                {
                    "count": 5,
                    "length": 14000.0
                },
                {
                    "count": 7,
                    "length": 15000.0
                },
                {
                    "count": 5,
                    "length": 16000.0
                },
                {
                    "count": 4,
                    "length": 17000.0
                },
                {
                    "count": 6,
                    "length": 18000.0
                },
                {
                    "count": 1,
                    "length": 19000.0
                },
                {
                    "count": 1,
                    "length": 20000.0
                },
                {
                    "count": 2,
                    "length": 22000.0
                },
                {
                    "count": 2,
                    "length": 23000.0
                },
                {
                    "count": 1,
                    "length": 24000.0
                },
                {
                    "count": 3,
                    "length": 26000.0
                },
                {
                    "count": 2,
                    "length": 27000.0
                }
            ],
            "speed_bases_per_second_dist_temp": [
                {
                    "count": 112,
                    "speed": 1.0
                }
            ],
            "strand_median_pa": {
                "count": 112,
                "mean": 94.4532852172852,
                "sum": 10578.767578125
            },
            "strand_sd_pa": {
                "count": 112,
                "mean": 9.59036540985107,
                "sum": 1074.12097167969
            }
        },
        "channel_count": 79,
        "context_tags": {
            "experiment_kit": "genomic_dna",
            "filename": "odw_genlab4209_20161213_fn_mn16303_sequencing_run_sample_id_32395",
            "sample_frequency": "4000",
            "user_filename_input": "sample_id"
        },
        "latest_run_time": 21142.6875,
        "levels_sums": {
            "count": 112,
            "mean": 225.230667114258,
            "open_pore_level_sum": 25225.833984375
        },
        "opts": {
            "adapter_pt_range_scale": "5.200000",
            "align_ref": "",
            "allow_inferior_barcodes": "0",
            "arrangements_files": "",
            "as_cpu_threads_per_scaler": "2",
            "as_gpu_runners_per_device": "2",
            "as_model_file": "adapter_scaling_dna_r9.4.1_min.jsn",
            "as_num_scalers": "1",
            "as_reads_per_runner": "32",
            "barcode_kits": "",
            "barcoding_config_file": "configuration.cfg",
            "bed_file": "",
            "builtin_scripts": "1",
            "calib_detect": "0",
            "calib_max_sequence_length": "3800",
            "calib_min_coverage": "0.600000",
            "calib_min_sequence_length": "3000",
            "calib_reference": "lambda_3.6kb.fasta",
            "chunk_size": "2000",
            "chunks_per_caller": "10000",
            "chunks_per_runner": "160",
            "client_id": "-1",
            "compress_fastq": "0",
            "cpu_threads_per_caller": "4",
            "detect_mid_strand_barcodes": "0",
            "device": "auto",
            "disable_events": "0",
            "disable_pings": "0",
            "dmean_threshold": "1.000000",
            "dmean_win_size": "2",
            "end_gap1": "40",
            "end_gap2": "40",
            "extend_gap1": "40",
            "extend_gap2": "160",
            "fast5_out": "0",
            "flowcell": "",
            "front_window_size": "150",
            "gpu_runners_per_device": "8",
            "high_priority_threshold": "10",
            "input_file_list": "",
            "jump_threshold": "1.000000",
            "kernel_path": "",
            "kit": "",
            "log_speed_frequency": "0",
            "max_block_size": "50000",
            "max_queued_reads": "2000",
            "max_search_len": "1000",
            "medium_priority_threshold": "4",
            "min_qscore": "7.000000",
            "min_score": "60.000000",
            "min_score_mid_barcodes": "60.000000",
            "min_score_rear_override": "60.000000",
            "model_file": "template_r9.4.1_450bps_fast.jsn",
            "nested_output_folder": "0",
            "num_alignment_threads": "4",
            "num_barcode_threads": "4",
            "num_barcoding_buffers": "96",
            "num_callers": "5",
            "num_extra_bases_trim": "0",
            "open_gap1": "40",
            "open_gap2": "160",
            "overlap": "50",
            "override_scaling": "0",
            "ping_segment_duration": "60",
            "ping_url": "https://ping.oxfordnanoportal.com/basecall",
            "port": "",
            "post_out": "0",
            "print_workflows": "0",
            "progress_stats_frequency": "-1.000000",
            "pt_median_offset": "2.500000",
            "pt_minimum_read_start_index": "30",
            "pt_required_adapter_drop": "30.000000",
            "pt_scaling": "0",
            "qscore_filtering": "0",
            "qscore_offset": "-0.130000",
            "qscore_scale": "0.905000",
            "quiet": "0",
            "read_batch_size": "4000",
            "read_id_list": "",
            "rear_window_size": "150",
            "records_per_fastq": "4000",
            "recursive": "0",
            "require_barcodes_both_ends": "0",
            "resume": "0",
            "reverse_sequence": "0",
            "scaling_mad": "1.000000",
            "scaling_med": "0.000000",
            "score_matrix_filename": "",
            "server_file_load_timeout": "30",
            "start_gap1": "40",
            "start_gap2": "40",
            "stay_penalty": "1.000000",
            "temp_bias": "1.000000",
            "temp_weight": "1.000000",
            "trace_categories_logs": "",
            "trace_domains_config": "",
            "trace_domains_log": "",
            "trim_barcodes": "0",
            "trim_min_events": "3",
            "trim_strategy": "dna",
            "trim_threshold": "2.500000",
            "u_substitution": "0",
            "verbose_logs": "0"
        },
        "read_count": 112,
        "reads_per_channel_dist": [
            {
                "channel": 7,
                "count": 1
            },
            {
                "channel": 8,
                "count": 1
            },
            {
                "channel": 21,
                "count": 1
            },
            {
                "channel": 24,
                "count": 1
            },
            {
                "channel": 28,
                "count": 1
            },
            {
                "channel": 40,
                "count": 1
            },
            {
                "channel": 41,
                "count": 1
            },
            {
                "channel": 43,
                "count": 5
            },
            {
                "channel": 44,
                "count": 1
            },
            {
                "channel": 47,
                "count": 2
            },
            {
                "channel": 54,
                "count": 2
            },
            {
                "channel": 57,
                "count": 3
            },
            {
                "channel": 64,
                "count": 2
            },
            {
                "channel": 66,
                "count": 1
            },
            {
                "channel": 69,
                "count": 1
            },
            {
                "channel": 80,
                "count": 1
            },
            {
                "channel": 84,
                "count": 2
            },
            {
                "channel": 85,
                "count": 2
            },
            {
                "channel": 91,
                "count": 1
            },
            {
                "channel": 95,
                "count": 2
            },
            {
                "channel": 98,
                "count": 2
            },
            {
                "channel": 107,
                "count": 1
            },
            {
                "channel": 109,
                "count": 1
            },
            {
                "channel": 111,
                "count": 2
            },
            {
                "channel": 118,
                "count": 1
            },
            {
                "channel": 123,
                "count": 2
            },
            {
                "channel": 139,
                "count": 1
            },
            {
                "channel": 144,
                "count": 1
            },
            {
                "channel": 158,
                "count": 1
            },
            {
                "channel": 170,
                "count": 1
            },
            {
                "channel": 174,
                "count": 1
            },
            {
                "channel": 177,
                "count": 1
            },
            {
                "channel": 179,
                "count": 1
            },
            {
                "channel": 196,
                "count": 1
            },
            {
                "channel": 200,
                "count": 1
            },
            {
                "channel": 250,
                "count": 1
            },
            {
                "channel": 280,
                "count": 2
            },
            {
                "channel": 281,
                "count": 1
            },
            {
                "channel": 289,
                "count": 2
            },
            {
                "channel": 290,
                "count": 2
            },
            {
                "channel": 292,
                "count": 1
            },
            {
                "channel": 294,
                "count": 1
            },
            {
                "channel": 302,
                "count": 2
            },
            {
                "channel": 309,
                "count": 1
            },
            {
                "channel": 316,
                "count": 2
            },
            {
                "channel": 326,
                "count": 1
            },
            {
                "channel": 342,
                "count": 1
            },
            {
                "channel": 350,
                "count": 1
            },
            {
                "channel": 353,
                "count": 1
            },
            {
                "channel": 355,
                "count": 1
            },
            {
                "channel": 361,
                "count": 2
            },
            {
                "channel": 378,
                "count": 5
            },
            {
                "channel": 381,
                "count": 1
            },
            {
                "channel": 383,
                "count": 1
            },
            {
                "channel": 391,
                "count": 2
            },
            {
                "channel": 403,
                "count": 1
            },
            {
                "channel": 407,
                "count": 1
            },
            {
                "channel": 418,
                "count": 1
            },
            {
                "channel": 420,
                "count": 1
            },
            {
                "channel": 427,
                "count": 1
            },
            {
                "channel": 432,
                "count": 1
            },
            {
                "channel": 433,
                "count": 1
            },
            {
                "channel": 442,
                "count": 2
            },
            {
                "channel": 460,
                "count": 2
            },
            {
                "channel": 467,
                "count": 1
            },
            {
                "channel": 471,
                "count": 1
            },
            {
                "channel": 477,
                "count": 1
            },
            {
                "channel": 481,
                "count": 3
            },
            {
                "channel": 482,
                "count": 1
            },
            {
                "channel": 483,
                "count": 2
            },
            {
                "channel": 485,
                "count": 1
            },
            {
                "channel": 486,
                "count": 1
            },
            {
                "channel": 490,
                "count": 1
            },
            {
                "channel": 491,
                "count": 1
            },
            {
                "channel": 493,
                "count": 2
            },
            {
                "channel": 497,
                "count": 1
            },
            {
                "channel": 501,
                "count": 1
            },
            {
                "channel": 505,
                "count": 2
            },
            {
                "channel": 506,
                "count": 1
            }
        ],
        "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
        "segment_duration": 360,
        "segment_number": 1,
        "segment_type": "guppy-acquisition",
        "software": {
            "analysis": "1d_basecalling",
            "name": "guppy-basecalling",
            "version": "4.0.15+5694074"
        },
        "tracking_id": {
            "asic_id": "420170566",
            "asic_id_eeprom": "2043896",
            "asic_temp": "30.1846237",
            "auto_update": "1",
            "auto_update_source": "https://mirror.oxfordnanoportal.com/software/MinKNOW/",
            "bream_core_version": "1.1.21.1",
            "bream_is_standard": "1",
            "bream_map_version": "1.1.21.1",
            "bream_ont_version": "1.1.21.1",
            "bream_prod_version": "1.1.21.1",
            "bream_rnd_version": "0.1.1",
            "device_id": "MN16303",
            "exp_script_name": "NC_48Hr_Sequencing_Run_FLO-MIN106_SQK-LSK108.py",
            "exp_script_purpose": "sequencing_run",
            "exp_start_time": "1481657610",
            "flow_cell_id": "",
            "heatsink_temp": "33.9765625",
            "hostname": "odw-genlab4209",
            "installation_type": "map",
            "local_firmware_file": "0",
            "msg_id": "e3371a44-7a8b-44eb-a720-a3193a91c7ef",
            "operating_system": "Windows 6.1",
            "protocol_run_id": "3eecebf6-325f-4ac5-b896-a7588f2b2324",
            "protocols_version": "1.1.21",
            "run_id": "0cc960b63c07619b4bf2917507d447479a21da66",
            "time_stamp": "2020-09-30T16:38:16Z",
            "usb_config": "1.0.11_ONT#MinION_fpga_1.0.1#ctrl#Auto",
            "version": "1.1.21"
        }
    }
]