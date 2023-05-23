/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_NORMAL        = 0;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_INGRESS_CLONE = 1;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_EGRESS_CLONE  = 2;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_COALESCED     = 3;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_RECIRC        = 4;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_REPLICATION   = 5;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_RESUBMIT      = 6;


const bit<32> I2E_CLONE_SESSION_ID = 100;
const bit<32> E2E_CLONE_SESSION_ID = 101;

struct mymeta_t {
	@field_list(1) // this number must be called in resubmit_preserving_field_list()
	bit<9> port;
}

struct metadata {
    mymeta_t mymeta;
}

struct headers {
    /* empty */
}

/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {
        transition accept;
    }
}

/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {  }
}


/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {

    action do_clone_i2e() {
        // hdr.ethernet.dstAddr = 0x080000000333;
        // See the resubmit_preserving_field_list() call for notes on
        // the 3rd argument, which is similar to the only argument to
        // resubmit_preserving_field_list().
        clone_preserving_field_list(CloneType.I2E, I2E_CLONE_SESSION_ID, 0);
    }

    // action to resubmit incoming packets
//    action do_resubmit (/*PortID_t port*/) {
//   resubmit_preserving_field_list();
//    }
	

    apply {
	// Check whether packet was resubmitted
	if (standard_metadata.instance_type == BMV2_V1MODEL_INSTANCE_TYPE_RESUBMIT){
	// packet is already resubmitted --> change outgoing port :)


		if (meta.mymeta.port == 1) {
        	    	standard_metadata.egress_spec = 2;
        	}
       		else if (meta.mymeta.port == 2) {
         		standard_metadata.egress_spec = 1;
   		}
		//all Resubmitted Packets: ingress_port = 0
		else if (standard_metadata.ingress_port == 0) {
              		standard_metadata.egress_spec = 2;
    		} 

	}
	else if (standard_metadata.instance_type == BMV2_V1MODEL_INSTANCE_TYPE_NORMAL){
		// standard, incoming packet --> resubmit
		//-> speichert den Ingress Port in "MYMETA.PORT" -> später wichtig :)
		meta.mymeta.port = standard_metadata.ingress_port; 
		resubmit_preserving_field_list(1);
		// set outgoing port -> does nothing because "original" packet isnt transmitted, only resubmitted packet
		if (standard_metadata.ingress_port == 1) {
                        standard_metadata.egress_spec = 2;
                }
                else if (standard_metadata.ingress_port == 2) {
                        standard_metadata.egress_spec = 1;
                }

	}
    }
}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {

    action do_clone_e2e() {
        // hdr.ethernet.dstAddr = 0x080000000333;
        // See the resubmit_preserving_field_list() call for notes on
        // the 3rd argument, which is similar to the only argument to
        // resubmit_preserving_field_list().
        clone_preserving_field_list(CloneType.E2E, E2E_CLONE_SESSION_ID, 0);
    }

    apply { 
	//do_clone_e2e(); //this does not work, packets loop around and flood the network and logs!!! 
	}
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
     apply { }
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
    apply {
    }
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
