/* -*- P4_16 -*- */

#include <core.p4>
#include <tna.p4>

/*************************************************************************
 ************* C O N S T A N T S    A N D   T Y P E S  *******************
**************************************************************************/
//const bit<16> ETHERTYPE_TPID   = 0x8100;
//const bit<16> ETHERTYPE_IPV4   = 0x0800;
//const bit<16> ETHERTYPE_IPV6   = 0x86DD;
//const bit<16> ETHERTYPE_TO_CPU = 0xBF01;

//const int NEXTHOP_ID_WIDTH = 14;
//typedef bit<(NEXTHOP_ID_WIDTH)> nexthop_id_t;

/* Table Sizing */
//const int IPV4_HOST_TABLE_SIZE = 131072;
//const int IPV4_LPM_TABLE_SIZE  = 12288;

//const int IPV6_HOST_TABLE_SIZE = 65536;
//const int IPV6_LPM_TABLE_SIZE  = 4096;

//const int NEXTHOP_TABLE_SIZE   = 1 << NEXTHOP_ID_WIDTH;

/*
 * Portable Types for PortId and MirrorID that do not depend on the target
 */
typedef bit<16> P_PortId_t;
typedef bit<16> P_MirrorId_t;
typedef bit<8>  P_QueueId_t;

#if __TARGET_TOFINO__ == 1
typedef bit<7> PortId_Pad_t;
typedef bit<6> MirrorId_Pad_t;
typedef bit<3> QueueId_Pad_t;
#define MIRROR_DEST_TABLE_SIZE 256
#elif __TARGET_TOFINO__ == 2
typedef bit<7> PortId_Pad_t;
typedef bit<8> MirrorId_Pad_t;
typedef bit<1> QueueId_Pad_t;
#define MIRROR_DEST_TABLE_SIZE 256
#else
#error Unsupported Tofino target
#endif

/*************************************************************************
 ***********************  H E A D E R S  *********************************
 *************************************************************************/

/*  Define all the headers the program will recognize             */
/*  The actual sets of headers processed by each gress can differ */

/* Standard ethernet header */
//header ethernet_h {
//    bit<48>   dst_addr;
//    bit<48>   src_addr;
//    bit<16>   ether_type;
//}

//header vlan_tag_h {
//    bit<3>   pcp;
//    bit<1>   cfi;
//    bit<12>  vid;
//    bit<16>  ether_type;
//}

//header ipv4_h {
//    bit<4>   version;
//    bit<4>   ihl;
//    bit<8>   diffserv;
//    bit<16>  total_len;
//    bit<16>  identification;
//    bit<3>   flags;
//    bit<13>  frag_offset;
//    bit<8>   ttl;
//    bit<8>   protocol;
//    bit<16>  hdr_checksum;
//    bit<32>  src_addr;
//    bit<32>  dst_addr;
//}

//header ipv4_options_h {
//    varbit<320> data;
//}

/*header ipv6_h {
    bit<4>   version;
    bit<8>   traffic_class;
    bit<20>  flow_label;
    bit<16>  payload_len;
    bit<8>   next_hdr;
    bit<8>   hop_limit;
    bit<128> src_addr;
    bit<128> dst_addr;
}*/

/*** Internal Headers ***/

typedef bit<4> header_type_t;
typedef bit<4> header_info_t;

const header_type_t HEADER_TYPE_BRIDGE         = 0xB;
const header_type_t HEADER_TYPE_MIRROR_INGRESS = 0xC;
const header_type_t HEADER_TYPE_MIRROR_EGRESS  = 0xD;
const header_type_t HEADER_TYPE_RESUBMIT       = 0xA;

/*
 * This is a common "preamble" header that must be present in all internal
 * headers. The only time you do not need it is when you know that you are
 * not going to have more than one internal header type ever
 */

#define INTERNAL_HEADER         \
    header_type_t header_type;  \
    header_info_t header_info


header inthdr_h {
    INTERNAL_HEADER;
}

/* Bridged metadata */
header bridge_h {
    INTERNAL_HEADER;

#ifdef FLEXIBLE_HEADERS
    @flexible     PortId_t ingress_port;
    @flexible     bit<48>  ingress_mac_tstamp;
    @flexible     bit<48>  ingress_global_tstamp;
#else
    @padding PortId_Pad_t    pad0; PortId_t   ingress_port;
                                   bit<48>    ingress_mac_tstamp;
                                   bit<48>    ingress_global_tstamp;
#endif
}

/* Ingress mirroring information */
const MirrorType_t ING_PORT_MIRROR = 3;
const MirrorType_t EGR_PORT_MIRROR = 5;

header ing_port_mirror_h {
    INTERNAL_HEADER;

#ifdef FLEXIBLE_HEADERS
    @flexible     PortId_t    ingress_port;
    @flexible     MirrorId_t  mirror_session;
    @flexible     bit<48>     ingress_mac_tstamp;
    @flexible     bit<48>     ingress_global_tstamp;
#else
    @padding PortId_Pad_t    pad0; PortId_t    ingress_port;
    @padding MirrorId_Pad_t  pad1; MirrorId_t  mirror_session;
                                   bit<48>     ingress_mac_tstamp;
                                   bit<48>     ingress_global_tstamp;
#endif
}

header egr_port_mirror_h {
    INTERNAL_HEADER;                                                  /* 1 */

#ifdef FLEXIBLE_HEADERS
    @flexible  PortId_t    ingress_port;
    @flexible  PortId_t    egress_port;
    @flexible  MirrorId_t  mirror_session;
    @flexible  bit<16>     pkt_length;

#ifndef TOFINO_TELEMETRY
    @flexible  bit<48>     ingress_mac_tstamp;
    @flexible  bit<48>     ingress_global_tstamp;
    @flexible  bit<48>     egress_global_tstamp;
#else
    @flexible  bit<48>     ingress_mac_tstamp;
    @flexible  bit<48>     egress_global_tstamp;
    /* The fields below won't work on the model */
    @flexible  bit<19>     enq_qdepth;
    @flexible  bit<2>      enq_congest_stat;
    @flexible  bit<19>     deq_qdepth;
    @flexible  bit<2>      deq_congest_stat;
    @flexible  bit<8>      app_pool_congest_stat;
    @flexible  QueueId_t   egress_qid;
    @flexible  bit<3>      egress_cos;
#endif

#else /* Fixed Headers */                                            /* Bytes */
    @padding PortId_Pad_t    pad0; PortId_t    ingress_port;          /*  2 */
    @padding PortId_Pad_t    pad1; PortId_t    egress_port;           /*  2 */
    @padding MirrorId_Pad_t  pad2; MirrorId_t  mirror_session;        /*  2 */
                                   bit<16>     pkt_length;            /*  2 */
#ifndef TOFINO_TELEMETRY
                                   bit<48>     ingress_mac_tstamp;    /*  6 */
                                   bit<48>     ingress_global_tstamp; /*  6 */
                                   bit<48>     egress_global_tstamp;  /*  6 */
                                                         /* 1 + 8 + 18 = 27 */
#else
                                   bit<48>     ingress_mac_tstamp;    /*  6 */
                                   bit<48>     egress_global_tstamp;  /*  6 */
    /* The fields below won't work on the model */
    @padding bit<5>         pad3;  bit<19>     enq_qdepth;            /*  3 */
    @padding bit<6>         pad4;  bit<2>      enq_congest_stat;      /*  1 */
    @padding bit<5>         pad6;  bit<19>     deq_qdepth;            /*  3 */
    @padding bit<6>         pad7;  bit<2>      deq_congest_stat;      /*  1 */
                                   bit<8>      app_pool_congest_stat; /*  1 */
    @padding QueueId_Pad_t  pad9;  QueueId_t   egress_qid;            /*  1 */
    @padding bit<5>  pad10;        bit<3>      egress_cos;            /*  1 */
#endif                                                   /* 1 + 8 + 24 = 32 */
#endif /* FLEXIBLE_HEADERS */
}

/*
 * Custom to-cpu header. This is not an internal header, which is why
 * we cannot use @flexible annotation here, since these packets
 * do appear on the wire and thus must have deterministic header format.
 *
 * For that same reason, one should avoid using architecture-specific types
 * in these headers. If you haven't defined  type yourself, it is better not
 * to use it. See the types P_PortId_t, etc. as a possible solution
 */

/*
 * Since the packet goes out on the wire, it is better *not* to use @padding
 * annotation, but instead explictly set all the paddings to 0. However, we
 * decided to provide an option here
 */
/*
#ifndef DIRTY_CPU_PADDING
#define PADDING
#else
#define PADDING @padding
#endif

header to_cpu_h {
    INTERNAL_HEADER;
                            P_PortId_t   ingress_port;
                            P_PortId_t   egress_port;
                            P_MirrorId_t mirror_session;
                            bit<16>      pkt_length;
                            bit<48>      ingress_mac_tstamp;
                            bit<48>      ingress_global_tstamp;
                            bit<48>      egress_global_tstamp;
                            bit<48>      mirror_global_tstamp;*/
    /*
     * The fields below are great for telemetry, but won't work on the model.
     * However, we'll always keep them in the header to avoid changing the
     * header definition in PTF tests
     */
/*
    PADDING  bit<5>  pad3;  bit<19>      enq_qdepth;
    PADDING  bit<6>  pad4;  bit<2>       enq_congest_stat;
    PADDING  bit<5>  pad6;  bit<19>      deq_qdepth;
    PADDING  bit<6>  pad7;  bit<2>       deq_congest_stat;
                            bit<8>       app_pool_congest_stat;
    PADDING  bit<14> pad8;  bit<18>      deq_timedelta;
                            P_QueueId_t  egress_qid;
    PADDING  bit<5>  pad10; bit<3>       egress_cos;
    PADDING  bit<7>  pad11; bit<1>       deflection_flag;
}*/


/*************************************************************************
 **************  I N G R E S S   P R O C E S S I N G   *******************
 *************************************************************************/

    /***********************  H E A D E R S  ************************/

struct my_ingress_headers_t {
    bridge_h           bridge;
   // ethernet_h         ethernet;
   // vlan_tag_h         vlan_tag;
   // ipv4_h             ipv4;
   // ipv4_options_h     ipv4_options;
   // ipv6_h             ipv6;
}

    /******  G L O B A L   I N G R E S S   M E T A D A T A  *********/

struct my_ingress_metadata_t {
    header_type_t  mirror_header_type;
    header_info_t  mirror_header_info;
    PortId_t       ingress_port;
    MirrorId_t     mirror_session;
    bit<48>        ingress_mac_tstamp;
    bit<48>        ingress_global_tstamp;
    bit<1>         ipv4_csum_err;
}

    /***********************  P A R S E R  **************************/
parser IngressParser(packet_in        pkt,
    /* User */
    out my_ingress_headers_t          hdr,
    out my_ingress_metadata_t         meta,
    /* Intrinsic */
    out ingress_intrinsic_metadata_t  ig_intr_md)
{
    Checksum() ipv4_checksum;

    /* This is a mandatory state, required by Tofino Architecture */
     state start {
        pkt.extract(ig_intr_md);
        pkt.advance(PORT_METADATA_SIZE);
        transition init_bridge_and_meta;
    }

    state init_bridge_and_meta {
        meta = { 0, 0, 0, 0, 0, 0, 0 };

        hdr.bridge.setValid();
        hdr.bridge.header_type  = HEADER_TYPE_BRIDGE;
        hdr.bridge.header_info  = 0;

        hdr.bridge.ingress_port = ig_intr_md.ingress_port;
        hdr.bridge.ingress_mac_tstamp = ig_intr_md.ingress_mac_tstamp;

        //transition parse_ethernet;
	transition accept;
    }
/*
    state parse_ethernet {
        pkt.extract(hdr.ethernet);
        transition select(hdr.ethernet.ether_type) {
            ETHERTYPE_TPID:  parse_vlan_tag;
            ETHERTYPE_IPV4:  parse_ipv4;
            ETHERTYPE_IPV6:  parse_ipv6;
            default: accept;
        }
    }

    state parse_vlan_tag {
        pkt.extract(hdr.vlan_tag);
        transition select(hdr.vlan_tag.ether_type) {
            ETHERTYPE_IPV4:  parse_ipv4;
            ETHERTYPE_IPV6:  parse_ipv6;
            default: accept;
        }
    }

    state parse_ipv4 {
        pkt.extract(hdr.ipv4);
        ipv4_checksum.add(hdr.ipv4);

        transition select(hdr.ipv4.ihl) {
                  5 : parse_ipv4_no_options;
            6 .. 15 : parse_ipv4_options;
            //default : reject
        }
    }

    state parse_ipv4_options {
        pkt.extract(
            hdr.ipv4_options,
            (bit<32>)(hdr.ipv4.ihl - 5) * 32);

        ipv4_checksum.add(hdr.ipv4_options);
        transition parse_ipv4_no_options;
    }

    state parse_ipv4_no_options {
        meta.ipv4_csum_err = (bit<1>)ipv4_checksum.verify();
        transition accept;
    }

    state parse_ipv6 {
        pkt.extract(hdr.ipv6);

        transition accept;
    }*/
}

    /***************** M A T C H - A C T I O N  *********************/

control Ingress(
    /* User */
    inout my_ingress_headers_t                       hdr,
    inout my_ingress_metadata_t                      meta,
    /* Intrinsic */
    in    ingress_intrinsic_metadata_t               ig_intr_md,
    in    ingress_intrinsic_metadata_from_parser_t   ig_prsr_md,
    inout ingress_intrinsic_metadata_for_deparser_t  ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t        ig_tm_md)
{
    /*
    nexthop_id_t    nexthop_id = 0;
    bit<8>          ttl_dec = 0;

    action set_nexthop(nexthop_id_t nexthop) {
        nexthop_id = nexthop;
    }

    table ipv4_host {
        key = { hdr.ipv4.dst_addr : exact; }
        actions = {
            set_nexthop;
            @defaultonly NoAction;
        }
        const default_action = NoAction();
        size = IPV4_HOST_TABLE_SIZE;
    }

    table ipv4_lpm {
        key     = { hdr.ipv4.dst_addr : lpm; }
        actions = { set_nexthop; }

        default_action = set_nexthop(0);
        size           = IPV4_LPM_TABLE_SIZE;
    }

    table ipv6_host {
        key = { hdr.ipv6.dst_addr : exact; }
        actions = {
            set_nexthop;
            @defaultonly NoAction;
        }
        const default_action = NoAction();
        size = IPV6_HOST_TABLE_SIZE;
    }

    table ipv6_lpm {
        key     = { hdr.ipv6.dst_addr : lpm; }
        actions = { set_nexthop; }

        default_action = set_nexthop(0);
        size           = IPV6_LPM_TABLE_SIZE;
    }
    */

    /*********** NEXTHOP ************/
    action send(PortId_t port) {
        ig_tm_md.ucast_egress_port = port;
    }

    action drop() {
        ig_dprsr_md.drop_ctl = 1;
    }

    /*action l3_switch(PortId_t port, bit<48> new_mac_da, bit<48> new_mac_sa) {
        hdr.ethernet.dst_addr = new_mac_da;
        hdr.ethernet.src_addr = new_mac_sa;
        ttl_dec = 1;
        send(port);
    }*/

    /*table nexthop {
        key = { nexthop_id : exact; }
        actions = { send; drop; l3_switch; }
        size = NEXTHOP_TABLE_SIZE;
    }*/

    /********* MIRRORING ************/
    action acl_mirror(MirrorId_t mirror_session) {
        ig_dprsr_md.mirror_type = ING_PORT_MIRROR;

        meta.mirror_header_type = HEADER_TYPE_MIRROR_INGRESS;
        meta.mirror_header_info = (header_info_t)ING_PORT_MIRROR;

        meta.ingress_port   = ig_intr_md.ingress_port;
        meta.mirror_session = mirror_session;

        meta.ingress_mac_tstamp    = ig_intr_md.ingress_mac_tstamp;
        meta.ingress_global_tstamp = ig_prsr_md.global_tstamp;
    }

    action acl_drop_and_mirror(MirrorId_t mirror_session) {
        acl_mirror(mirror_session);
        drop();
    }

    table port_acl {
        key = {
            ig_intr_md.ingress_port : ternary;
        }
        actions = {
            acl_mirror; acl_drop_and_mirror; drop; NoAction;
        }
        size = 512;
        default_action = NoAction();
    }

    apply {
       /* if (ig_prsr_md.parser_err == 0) {
            if (hdr.ipv4.isValid()) {
                if (meta.ipv4_csum_err == 0 && hdr.ipv4.ttl > 1) {
                    if (!ipv4_host.apply().hit) {
                        ipv4_lpm.apply();
                    }
                    nexthop.apply();
                }
            } else if (hdr.ipv6.isValid()) {
                if (hdr.ipv6.hop_limit > 1) {
                    if (!ipv6_host.apply().hit) {
                        ipv6_lpm.apply();
                    }
                    nexthop.apply();
                }
            }

            if (hdr.ipv4.isValid()) {
                hdr.ipv4.ttl =  hdr.ipv4.ttl - ttl_dec;
            } else if (hdr.ipv6.isValid()) {
                hdr.ipv6.hop_limit = hdr.ipv6.hop_limit - ttl_dec;
            }
        }*/

	// eingefügt von MBeausencourt
	if (ig_intr_md.ingress_port == 134) {
            ig_tm_md.ucast_egress_port = 135;
        }
        else if (ig_intr_md.ingress_port == 135) {
            ig_tm_md.ucast_egress_port = 134;
        }

        /* Mirroring */
        port_acl.apply();

        /* Fill in any other fields you need to  bridge */
        hdr.bridge.ingress_global_tstamp = ig_prsr_md.global_tstamp;
    }

}

   /*********************  D E P A R S E R  ************************/

#ifdef FLEXIBLE_HEADERS
#define PAD(field)  field
#else
#define PAD(field)  0, field
#endif

control IngressDeparser(packet_out pkt,
    /* User */
    inout my_ingress_headers_t                       hdr,
    in    my_ingress_metadata_t                      meta,
    /* Intrinsic */
    in    ingress_intrinsic_metadata_for_deparser_t  ig_dprsr_md)
{
    //Checksum() ipv4_checksum;
    Mirror()   ing_port_mirror;

    apply {
        /*
         * If there is a mirror request, create a clone.
         * Note: Mirror() externs emits the provided header, but also
         * appends the ORIGINAL ingress packet after those
         */
        if (ig_dprsr_md.mirror_type == ING_PORT_MIRROR) {
            ing_port_mirror.emit<ing_port_mirror_h>(
                meta.mirror_session,
                {
                    meta.mirror_header_type, meta.mirror_header_info,
                    PAD(meta.ingress_port),
                    PAD(meta.mirror_session),
                    meta.ingress_mac_tstamp,
                    meta.ingress_global_tstamp
                });
        }

        /* Update the IPv4 checksum first. Why not in the egress deparser? */
        /*if (hdr.ipv4.isValid()) {
            hdr.ipv4.hdr_checksum = ipv4_checksum.update({
                    hdr.ipv4.version,
                    hdr.ipv4.ihl,
                    hdr.ipv4.diffserv,
                    hdr.ipv4.total_len,
                    hdr.ipv4.identification,
                    hdr.ipv4.flags,
                    hdr.ipv4.frag_offset,
                    hdr.ipv4.ttl,
                    hdr.ipv4.protocol,
                    hdr.ipv4.src_addr,
                    hdr.ipv4.dst_addr,
                    hdr.ipv4_options.data
                });
        }*/

        /* Deparse the regular packet with bridge metadata header prepended */
        pkt.emit(hdr);
    }
}


/*************************************************************************
 ****************  E G R E S S   P R O C E S S I N G   *******************
 *************************************************************************/

    /***********************  H E A D E R S  ************************/


struct my_egress_headers_t {
//    ethernet_h   cpu_ethernet;
//    to_cpu_h     to_cpu;
}

    /********  G L O B A L   E G R E S S   M E T A D A T A  *********/

struct my_egress_metadata_t {
    inthdr_h           inthdr;
    bridge_h           bridge;
    MirrorId_t         mirror_session;
    bool               ing_mirrored;
    bool               egr_mirrored;
    ing_port_mirror_h  ing_port_mirror;
    egr_port_mirror_h  egr_port_mirror;
    header_type_t      mirror_header_type;
    header_info_t      mirror_header_info;
    MirrorId_t         egr_mirror_session;
    bit<16>            egr_mirror_pkt_length;
}

    /***********************  P A R S E R  **************************/

parser EgressParser(packet_in        pkt,
    /* User */
    out my_egress_headers_t          hdr,
    out my_egress_metadata_t         meta,
    /* Intrinsic */
    out egress_intrinsic_metadata_t  eg_intr_md)
{
    /* This is a mandatory state, required by Tofino Architecture */
    state start {
        meta.mirror_session        = 0;
        meta.ing_mirrored          = false;
        meta.egr_mirrored          = false;
        meta.mirror_header_type    = 0;
        meta.mirror_header_info    = 0;
        meta.egr_mirror_session    = 0;
        meta.egr_mirror_pkt_length = 0;

        pkt.extract(eg_intr_md);
        meta.inthdr = pkt.lookahead<inthdr_h>();

        transition select(meta.inthdr.header_type, meta.inthdr.header_info) {
            ( HEADER_TYPE_BRIDGE,         _ ) :
                           parse_bridge;
            ( HEADER_TYPE_MIRROR_INGRESS, (header_info_t)ING_PORT_MIRROR ):
                           parse_ing_port_mirror;
            ( HEADER_TYPE_MIRROR_EGRESS,  (header_info_t)EGR_PORT_MIRROR ):
                           parse_egr_port_mirror;
            default : reject;
        }
    }

    state parse_bridge {
        pkt.extract(meta.bridge);
        transition accept;
    }

    state parse_ing_port_mirror {
        pkt.extract(meta.ing_port_mirror);
        meta.ing_mirrored   = true;
        meta.mirror_session = meta.ing_port_mirror.mirror_session;
        transition accept;
    }

    state parse_egr_port_mirror {
        pkt.extract(meta.egr_port_mirror);
        meta.egr_mirrored   = true;
        meta.mirror_session = meta.egr_port_mirror.mirror_session;
        transition accept;
    }
}

    /***************** M A T C H - A C T I O N  *********************/
control Egress(
    /* User */
    inout my_egress_headers_t                          hdr,
    inout my_egress_metadata_t                         meta,
    /* Intrinsic */
    in    egress_intrinsic_metadata_t                  eg_intr_md,
    in    egress_intrinsic_metadata_from_parser_t      eg_prsr_md,
    inout egress_intrinsic_metadata_for_deparser_t     eg_dprsr_md,
    inout egress_intrinsic_metadata_for_output_port_t  eg_oport_md)
{
    action just_send() {}

#ifndef DIRTY_CPU_PADDING
#define CPU_PAD(N, field) hdr.to_cpu.pad##N = 0; field
#else
#define CPU_PAD(N, field) field
#endif

    /*action send_to_cpu(bit<48> dst_mac, bit<48>src_mac) {
        hdr.cpu_ethernet.setValid();
        hdr.cpu_ethernet.dst_addr   = dst_mac;
        hdr.cpu_ethernet.src_addr   = src_mac;
        hdr.cpu_ethernet.ether_type = ETHERTYPE_TO_CPU;

        hdr.to_cpu.setValid();
        hdr.to_cpu.header_type = meta.inthdr.header_type;
        hdr.to_cpu.header_info = meta.inthdr.header_info;
    }*/

    /*action send_to_cpu_ing_mirror(bit<48> dst_mac, bit<48>src_mac) {
        send_to_cpu(dst_mac, src_mac);

                    hdr.to_cpu.ingress_port          = (P_PortId_t)
                                   meta.ing_port_mirror.ingress_port;
                    hdr.to_cpu.egress_port           = 0;
                    hdr.to_cpu.mirror_session        = (P_MirrorId_t)
                                    meta.ing_port_mirror.mirror_session;
                    hdr.to_cpu.pkt_length             = 0;
                    hdr.to_cpu.ingress_mac_tstamp     =
                                    meta.ing_port_mirror.ingress_mac_tstamp;
                    hdr.to_cpu.ingress_global_tstamp  =
                                    meta.ing_port_mirror.ingress_global_tstamp;
                    hdr.to_cpu.egress_global_tstamp   = 0;
                    hdr.to_cpu.mirror_global_tstamp   =
                                    eg_prsr_md.global_tstamp;

        CPU_PAD( 3, hdr.to_cpu.enq_qdepth)            = 0;
        CPU_PAD( 4, hdr.to_cpu.enq_congest_stat)      = 0;
        CPU_PAD( 6, hdr.to_cpu.deq_qdepth)            = 0;
        CPU_PAD( 7, hdr.to_cpu.deq_congest_stat)      = 0;
                    hdr.to_cpu.app_pool_congest_stat  = 0;
                    hdr.to_cpu.egress_qid             = 0;
        CPU_PAD(10, hdr.to_cpu.egress_cos)            = 0;
        CPU_PAD(11, hdr.to_cpu.deflection_flag)       = 0;
    }*/

    /*action send_to_cpu_egr_mirror(bit<48> dst_mac, bit<48>src_mac) {
        send_to_cpu(dst_mac, src_mac);

                    hdr.to_cpu.ingress_port           = (P_PortId_t)
                                    meta.egr_port_mirror.ingress_port;
                    hdr.to_cpu.egress_port            = (P_PortId_t)
                                    meta.egr_port_mirror.egress_port;
                    hdr.to_cpu.mirror_session         = (P_MirrorId_t)
                                    meta.egr_port_mirror.mirror_session;
                    hdr.to_cpu.pkt_length             =
                                    meta.egr_port_mirror.pkt_length;

#ifndef TOFINO_TELEMETRY
                    hdr.to_cpu.ingress_mac_tstamp     =
                                    meta.egr_port_mirror.ingress_mac_tstamp;
                    hdr.to_cpu.ingress_global_tstamp  =
                                    meta.egr_port_mirror.ingress_global_tstamp;
                    hdr.to_cpu.egress_global_tstamp   =
                                    meta.egr_port_mirror.egress_global_tstamp;
                    hdr.to_cpu.mirror_global_tstamp   =
                                    eg_prsr_md.global_tstamp;
        CPU_PAD( 3, hdr.to_cpu.enq_qdepth)            = 0;
        CPU_PAD( 4, hdr.to_cpu.enq_congest_stat)      = 0;
        CPU_PAD( 6, hdr.to_cpu.deq_qdepth)            = 0;
        CPU_PAD( 7, hdr.to_cpu.deq_congest_stat)      = 0;
                    hdr.to_cpu.app_pool_congest_stat  = 0;
                    hdr.to_cpu.egress_qid             = 0;
        CPU_PAD(10, hdr.to_cpu.egress_cos)            = 0;
        CPU_PAD(11, hdr.to_cpu.deflection_flag)       = 0;
#else
                    hdr.to_cpu.ingress_mac_tstamp     =
                                    meta.egr_port_mirror.ingress_mac_tstamp;
                    hdr.to_cpu.ingress_global_tstamp  = 0;
                    hdr.to_cpu.egress_global_tstamp   =
                                    meta.egr_port_mirror.egress_global_tstamp;
                    hdr.to_cpu.mirror_global_tstamp   =
                                    eg_prsr_md.global_tstamp;
        CPU_PAD( 3, hdr.to_cpu.enq_qdepth)            =
                                    meta.egr_port_mirror.enq_qdepth;
        CPU_PAD( 4, hdr.to_cpu.enq_congest_stat)      =
                                    meta.egr_port_mirror.enq_congest_stat;
        CPU_PAD( 6, hdr.to_cpu.deq_qdepth)            =
                                    meta.egr_port_mirror.deq_qdepth;
        CPU_PAD( 7, hdr.to_cpu.deq_congest_stat)      =
                                    meta.egr_port_mirror.deq_congest_stat;
                    hdr.to_cpu.app_pool_congest_stat  =
                                    meta.egr_port_mirror.app_pool_congest_stat;
                    hdr.to_cpu.egress_qid             = (P_QueueId_t)
                                    meta.egr_port_mirror.egress_qid;
        CPU_PAD(10, hdr.to_cpu.egress_cos)            =
                                    meta.egr_port_mirror.egress_cos;
        CPU_PAD(11, hdr.to_cpu.deflection_flag)       = 0;
#endif
    }*/

    table mirror_dest {
        key = {
            meta.ing_mirrored       : ternary;
            meta.egr_mirrored       : ternary;
            meta.mirror_session     : exact;
        }

        actions = {
            just_send;
            //send_to_cpu_ing_mirror;
            //send_to_cpu_egr_mirror;
        }
        default_action = just_send();
        size = MIRROR_DEST_TABLE_SIZE;
    }

    /********* EGRESS MIRRORING ************/
    action drop() {
        eg_dprsr_md.drop_ctl = 1;
    }

    action acl_mirror(MirrorId_t mirror_session) {
        eg_dprsr_md.mirror_type = EGR_PORT_MIRROR;

        /*
         * Older versions of the compiler require the programmer to
         * initialize eg_dprsr_md.mirror_io_select manually. Newer versions
         * automatically initialize that field for Tofino-compatible behavior
         */
#if COMPILER_VERSION <= PACK_VERSION(9,7,0)
        #if __TARGET_TOFINO__ > 1
        eg_dprsr_md.mirror_io_select = 1;
        #endif
#endif
        meta.mirror_header_type     = HEADER_TYPE_MIRROR_EGRESS;
        meta.mirror_header_info     = (header_info_t)EGR_PORT_MIRROR;
        meta.egr_mirror_session     = mirror_session;

        /*
         * An interesting (and a little counter-intuitive) property of
         * eg_intr_md.pkt_length is that it reflects the length of the
         * "normal" (i.e. not mirrored) packet as it was at ingress, i.e.,
         * even if any modifications have been done to the packet (such
         * as prepending the bridge header), they will not be reflected
         * in eg_intr_md.pkt_length.
         *
         * Fortunately, this is precisely what we want in this case!
         */
        meta.egr_mirror_pkt_length  = eg_intr_md.pkt_length;

        /*
         * There is no need to copy the following data, since the deparser
         * has access to both meta, eg_intr_md and eg_prsr_md.
         * We will however, list these for the reference
         *
         * egr_port_mirror.ingress_port          = meta.bridge.ingress_port;
         * egr_port_mirror.egress_port           = eg_intr_md.egress_port;
         * egr_port_mirror.ingress_mac_tstamp    =
         *                                   meta.bridge.ingress_mac_tstamp;
         * egr_port_mirror.ingress_global_tstamp =
         *                                meta.bridge.ingress_global_tstamp;
         * egr_port_mirror.egress_global_tstamp  = eg_prsr_md.global_tstamp;
         *
         * OPTIONAL TELEMETRY (Watch for the mirror header size)
         * egr_port_mirror.enq_qdepth            = eg_intr_md.enq_qdepth;
         * egr_port_mirror.enq_congest_stat      =
         *                                    eg_intr_md.enq_congest_stat;
         * egr_port_mirror.deq_qdepth            = eg_intr_md.deq_qdepth;
         * egr_port_mirror.deq_congest_stat      =
         *                                    eg_intr_md.deq_congest_stat;
         * egr_port_mirror.app_pool_congest_stat =
         *                                    eg_intr_md.app_pool_congest_stat;
         * egr_port_mirror.egress_qid            = eg_intr_md.egress_qid;
         * egr_port_mirror.egress_cos            = eg_intr_md.egress_cos;
         * egr_port_mirror.deflection_flag       = eg_intr_md.deflection_flag;
         */
    }

    action acl_drop_and_mirror(MirrorId_t mirror_session) {
        acl_mirror(mirror_session);
        drop();
    }

    table port_acl {
        key = {
            meta.bridge.ingress_port : ternary;
            eg_intr_md.egress_port   : ternary;
        }
        actions = {
            acl_mirror; acl_drop_and_mirror; drop; NoAction;
        }
        size = 512;
        default_action = NoAction();
    }

    apply {
        if (meta.bridge.isValid()) {
            port_acl.apply();
        } else if (meta.ing_port_mirror.isValid() ||
                   meta.egr_port_mirror.isValid()) {
           mirror_dest.apply();
        }
    }
}

    /*********************  D E P A R S E R  ************************/

control EgressDeparser(packet_out pkt,
    /* User */
    inout my_egress_headers_t                       hdr,
    in    my_egress_metadata_t                      meta,
    /* Intrinsic */
    in    egress_intrinsic_metadata_for_deparser_t  eg_dprsr_md,
    in    egress_intrinsic_metadata_t               eg_intr_md,
    in    egress_intrinsic_metadata_from_parser_t   eg_prsr_md)
{
    Mirror() egr_port_mirror;
    apply {
        /*
         * If there is a mirror request, create a clone.
         * Note: Mirror() externs emits the provided header, but also
         * appends the ORIGINAL ingress packet after those
         */
        if (eg_dprsr_md.mirror_type == EGR_PORT_MIRROR) {
            egr_port_mirror.emit<egr_port_mirror_h>(
                meta.egr_mirror_session,
                {
                    meta.mirror_header_type,
                    meta.mirror_header_info,
                    PAD(meta.bridge.ingress_port),
                    PAD(eg_intr_md.egress_port),
                    PAD(meta.egr_mirror_session),
                    meta.egr_mirror_pkt_length,
#ifndef TOFINO_TELEMETRY
                    meta.bridge.ingress_mac_tstamp,
                    meta.bridge.ingress_global_tstamp,
                    eg_prsr_md.global_tstamp
#else
                    meta.bridge.ingress_mac_tstamp,
                    eg_prsr_md.global_tstamp,
                    PAD(eg_intr_md.enq_qdepth),
                    PAD(eg_intr_md.enq_congest_stat),
                    PAD(eg_intr_md.deq_qdepth),
                    PAD(eg_intr_md.deq_congest_stat),
                    eg_intr_md.app_pool_congest_stat,
                    PAD(eg_intr_md.egress_qid),
                    PAD(eg_intr_md.egress_cos)
#endif
                });
        }

        pkt.emit(hdr);
    }
}


/************ F I N A L   P A C K A G E ******************************/
Pipeline(
    IngressParser(),
    Ingress(),
    IngressDeparser(),
    EgressParser(),
    Egress(),
    EgressDeparser()
) pipe;

Switch(pipe) main;
