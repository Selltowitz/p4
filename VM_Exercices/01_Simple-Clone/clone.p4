/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>


const bit<32> I2E_CLONE_SESSION_ID = 100;
const bit<32> E2E_CLONE_SESSION_ID = 101;

struct metadata {
    /* empty */
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


    apply {
        if (standard_metadata.ingress_port == 1) {
            standard_metadata.egress_spec = 2;
            do_clone_i2e();
        }
        else if (standard_metadata.ingress_port == 2) {
            standard_metadata.egress_spec = 1;
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
