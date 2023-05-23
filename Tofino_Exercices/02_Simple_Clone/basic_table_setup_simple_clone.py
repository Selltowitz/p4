from ipaddress import ip_address
#from ipaddress import ip_network # seems not to work, maybe because this creates another type of object (address vs network)
p4 = bfrt.tofino_simple_clone.pipe

#
# Program the default topology
# sometimes: put ".push()" after command

# Set Mirror Session to 1 for Ingress Ports 134-135 (QSFP1-3 und 1-4)
p4.Ingress.port_acl.add_with_acl_mirror(ingress_port=134, ingress_port_mask=510, mirror_session=1)


# Kommentar vervollständigen
bfrt.mirror.cfg.add_with_normal(sid=1, session_enable=True, direction='BOTH', ucast_egress_port=40, ucast_egress_port_valid=True)

p4.Egress.mirror_dest.add_with_just_send(ing_mirrored_mask=0, egr_mirrored_mask=0, mirror_session=1)

bfrt.complete_operations()

# Final programming
print("""
******************* PROGRAMMING RESULTS *****************
""")
print ("\nTable Ingress Port ACL:")
p4.Ingress.port_acl.dump(table=True)
print ("\nTable Egress Mirror Destination:")
p4.Egress.mirror_dest.dump(table=True)
print ("\nTable mirror.cfg:")
bfrt.mirror.cfg.dump(table=True)
