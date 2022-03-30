# AHB-LITE
AHB-Lite is a subset of the full AHB specification for use in designs where only a single bus master is used. This can either be a simple single-master system, or a multi-layer AHB-Lite system where there is only one AHB master per layer.

AHB-Lite addresses the requirements of high-performance synthesizable
designs. It is a bus interface that supports a single bus master and provides
high-bandwidth operation

Masters designed to the AHB-Lite interface specification are significantly simpler in terms of interface design, than a full AHB master. AHB-Lite enables faster design and verification of these masters, and you can add a standard off-the-shelf bus mastering wrapper to convert an AHB-Lite master for use in a full AHB system.
Any master that is already designed to the full AHB specification can be used in an AHB-Lite system with no modification. The majority of AHB slaves can be used interchangeably in either an AHB or AHB-Lite system. This is because AHB slaves that do not use either the Split or Retry response are automatically compatible with both the full AHB and the AHB-Lite specification. It is only existing AHB slaves that do use Split or Retry responses that require you to use an additional standard off-the-shelf wrapper in your AHB-Lite system.
Any slave designed for use in an AHB-Lite system works in both a full AHB and an AHB-Lite design.

# AHB-Lite Verification

