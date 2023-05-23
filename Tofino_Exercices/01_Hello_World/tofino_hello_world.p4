/* -*- P4_16 -*- */
#include <core.p4>
#include <tna.p4>


struct metadata {
    /* empty */
}

struct headers {
    /* empty */
}

/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/

parser MyIngressParser(packet_in pkt,
                out headers hdr,
                out metadata meta,
                out ingress_intrinsic_metadata_t ig_intr_md) {


    state start {
	pkt.extract(ig_intr_md);
        transition accept;
    }
}

/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  in ingress_intrinsic_metadata_t ig_intr_md,
 		  in ingress_intrinsic_metadata_from_parser_t ig_prsr_md,
    		  inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
    		  inout ingress_intrinsic_metadata_for_tm_t ig_tm_md)
{
// 134 = QSFP1-3; 135 = QSFP1-4    
    apply {
        if (ig_intr_md.ingress_port == 134) {
            ig_tm_md.ucast_egress_port = 135;
        }
        else if (ig_intr_md.ingress_port == 135) {
            ig_tm_md.ucast_egress_port = 134;
        }
    }
}

/*************************************************************************
************   I N G R E S S   D E P A R S E R   *************
*************************************************************************/

control MyIngressDeparser(packet_out pkt,
			  inout headers hdr, 
			  in metadata meta, 
			  in ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md)
{
	apply {}
}



/*************************************************************************
************   E G R E S S   P A R S E R   *************
*************************************************************************/

parser MyEgressParser(packet_in pkt,
		      out headers hdr,
                      out metadata meta,
          	      out egress_intrinsic_metadata_t eg_intr_md)
{
		state start {
			pkt.extract(eg_intr_md);
			transition accept;
		}
}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/
control MyEgress(inout headers hdr,
                 inout metadata meta,
		 in egress_intrinsic_metadata_t eg_intr_md,
		 in egress_intrinsic_metadata_from_parser_t eg_prsr_md,
		 inout egress_intrinsic_metadata_for_deparser_t eg_dprsr_md,
		 inout egress_intrinsic_metadata_for_output_port_t eg_oport_md)
{
    apply {  }
}

/*************************************************************************
***********************  E G R E S S   D E P A R S E R  ******************
*************************************************************************/

control MyEgressDeparser(packet_out pkt, 
			 inout headers hdr, 
			 in metadata meta, 
			 in egress_intrinsic_metadata_for_deparser_t eg_dprsr_md) 
{
	apply
	{}
}
/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/
Pipeline(
MyIngressParser(),
MyIngress(),
MyIngressDeparser(),
MyEgressParser(),
MyEgress(),
MyEgressDeparser()
) pipe;
Switch(pipe) main;

