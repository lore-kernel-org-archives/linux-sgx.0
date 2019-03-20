Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070FEC43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 17:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C68F720850
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 17:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfCTRSZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 13:18:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:42637 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbfCTRSZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 13:18:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 10:14:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="135730316"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga003.jf.intel.com with ESMTP; 20 Mar 2019 10:14:22 -0700
Date:   Wed, 20 Mar 2019 10:14:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v19 25/27] x86/sgx: SGX documentation
Message-ID: <20190320171422.GD30469@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-26-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190317211456.13927-26-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Mar 17, 2019 at 11:14:54PM +0200, Jarkko Sakkinen wrote:
> Documentation of the features of the Software Guard eXtensions (SGX),
> the basic design choices for the core and driver functionality and
> the UAPI.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> +Intel(R) SGX is a set of CPU instructions that can be used by applications to
> +set aside private regions of code and data. The code outside the enclave is
> +disallowed to access the memory inside the enclave by the CPU access control.
> +In a way you can think that SGX provides an inverted sandbox. It protects the
> +application from a malicious host.
> +
> +You can tell if your CPU supports SGX by looking into ``/proc/cpuinfo``:
> +
> +	``cat /proc/cpuinfo  | grep sgx``
> +
> +Overview of SGX
> +===============
> +
> +SGX has a set of data structures to maintain information about the enclaves and
> +their security properties. BIOS reserves a fixed size region of physical memory
> +for these structures by setting Processor Reserved Memory Range Registers
> +(PRMRR).
> +
> +This memory range is protected from outside access by the CPU and all the data
> +coming in and out of the CPU package is encrypted by a key that is generated for
> +each boot cycle.

The overview should probably be limited to architectural features, e.g. the
ISA, *architectural* EPC and EPCM behavior, etc...  Then add a dedicated
section on EPC implementation(s), which are micro-architecture specific.

> +
> +Enclaves execute in ring 3 in a special enclave submode using pages from the
> +reserved memory range. A fixed logical address range for the enclave is reserved
                                  ^^^^^^^

I'm 99.99999% certain the above should be "linear address range".  The SDM
SDM first introduces ELRANGE as working with logical addresses:

    Address space allocation is the specification of the range of logical
    addresses that the enclave may use. This range is called the ELRANGE.

but I think that's a documentation bug.  Subsequent references in the SDM
all refer to linear addresses, and the ELRANGE checks definitely work with
linear addresses.

> +by ENCLS(ECREATE), a leaf instruction used to create enclaves. It is referred to
> +in the documentation commonly as the *ELRANGE*.
> +
> +Every memory access to the ELRANGE is asserted by the CPU. If the CPU is not
> +executing in the enclave mode inside the enclave, #GP is raised. On the other

This isn't correct.  ELRANGE protections are activated when only executing
inside an enclave.  An enclave's memory is protected by the EPC{M} when the
CPU is operating outside the enclave or in a different enclave.

> +hand, enclave code can make memory accesses both inside and outside of the
> +ELRANGE.
> +
> +An enclave can only execute code inside the ELRANGE. Instructions that may cause
> +VMEXIT, IO instructions and instructions that require a privilege change are

The VM-Exit blurb is technically no longer accurate, e.g. a VMM can choose
to intercept RDTSC, but RDTSC is also allowed in enclaves.

> +prohibited inside the enclave. Interrupts and exceptions always cause an enclave
> +to exit and jump to an address outside the enclave given when the enclave is
> +entered by using the leaf instruction ENCLS(EENTER).
> +
> +Protected memory
> +----------------
> +
> +Enclave Page Cache (EPC)
> +    Physical pages used with enclaves that are protected by the CPU from
> +    unauthorized access.
> +
> +Enclave Page Cache Map (EPCM)
> +    A database that describes the properties and state of the pages e.g. their
> +    permissions or which enclave they belong to.
> +
> +Memory Encryption Engine (MEE) integrity tree
> +    Autonomously updated integrity tree. The root of the tree located in on-die
> +    SRAM.
> +
> +EPC data types
> +--------------
> +
> +SGX Enclave Control Structure (SECS)
> +    Describes the global properties of an enclave. Will not be mapped to the
> +    ELRANGE.
> +
> +Regular (REG)
> +    These pages contain code and data.
> +
> +Thread Control Structure (TCS)
> +    The pages that define the entry points inside an enclave. An enclave can
> +    only be entered through these entry points and each can host a single
> +    hardware thread at a time.
> +
> +Version Array (VA)
> +   The pages contain 64-bit version numbers for pages that have been swapped
> +   outside the enclave. Each page has the capacity of 512 version numbers.

The page type descriptions could use a bit of improvement.  Tangentially
related, would it make sense to add a "Terminology" section given the
absurd number of acronyms used by SGX?

> +
> +Launch control
> +--------------
> +
> +To launch an enclave, two structures must be provided for ENCLS(EINIT):
> +
> +1. **SIGSTRUCT:** signed measurement of the enclave binary.
> +2. **EINITTOKEN:** a cryptographic token CMAC-signed with a AES256-key called
> +   *launch key*, which is regenerated for each boot cycle.
> +
> +The CPU holds a SHA256 hash of a 3072-bit RSA public key inside
> +IA32_SGXLEPUBKEYHASHn MSRs. Enclaves with a SIGSTRUCT that is signed with this
> +key do not require a valid EINITTOKEN and can be authorized with special
> +privileges. One of those privileges is ability to acquire the launch key with
> +ENCLS(EGETKEY).

This section should also call out that the IA32_SGXLEPUBKEYHASHn MSRs also
affect EINIT tokens.  And simply being signed with the key referenced by
IA32_SGXLEPUBKEYHASHn doesn't grant access to the EINITTOKEN_KEY, the
enclave still needs to explicit request access, e.g. the kernel could deny
access to the EINITTOKEN_KEY by refusing to create enclaves that request
said key.

> +**IA32_FEATURE_CONTROL[SGX_LE_WR]** is used by the BIOS configure whether
> +IA32_SGXLEPUBKEYHASH MSRs are read-only or read-write before locking the feature
> +control register and handing over control to the operating system.

...

> +The PF_SGX bit is set if and only if the #PF is detected by the SGX Enclave Page

The ordering here is a bit backwards, e.g. the EPCM and its protections
should come first, and then describe the faults that can be signaled by
the EPCM.

> +Cache Map (EPCM). The EPCM is a hardware-managed table that enforces accesses to
> +an enclave's EPC pages in addition to the software-managed kernel page tables,
> +i.e. the effective permissions for an EPC page are a logical AND of the kernel's
> +page tables and the corresponding EPCM entry.
> +
> +The EPCM is consulted only after an access walks the kernel's page tables, i.e.:
> +
> +1. the access was allowed by the kernel
> +2. the kernel's tables have become less restrictive than the EPCM
> +3. the kernel cannot fixup the cause of the fault
> +
> +Notably, (2) implies that either the kernel has botched the EPC mappings or the
> +EPCM has been invalidated (see below).  Regardless of why the fault occurred,
> +userspace needs to be alerted so that it can take appropriate action, e.g.
> +restart the enclave. This is reinforced by (3) as the kernel doesn't really
> +have any other reasonable option, i.e. signalling SIGSEGV is actually the least
> +severe action possible.
> +
> +Although the primary purpose of the EPCM is to prevent a malicious or
> +compromised kernel from attacking an enclave, e.g. by modifying the enclave's
> +page tables, do not WARN on a #PF with PF_SGX set. The SGX architecture
> +effectively allows the CPU to invalidate all EPCM entries at will and requires
> +that software be prepared to handle an EPCM fault at any time.  The architecture
> +defines this behavior because the EPCM is encrypted with an ephemeral key that
> +isn't exposed to software.  As such, the EPCM entries cannot be preserved across
> +transitions that result in a new key being used, e.g. CPU power down as part of
> +an S3 transition or when a VM is live migrated to a new physical system.
> +
> +SGX UAPI
> +========
> +
> +.. kernel-doc:: drivers/platform/x86/intel_sgx/sgx_ioctl.c

Stale file reference.

> +   :functions: sgx_ioc_enclave_create
> +               sgx_ioc_enclave_add_page
> +               sgx_ioc_enclave_init
> +
> +.. kernel-doc:: arch/x86/include/uapi/asm/sgx.h
> +
> +References
> +==========
> +
> +* A Memory Encryption Engine Suitable for General Purpose Processors
> +  <https://eprint.iacr.org/2016/204.pdf>
> +* System Programming Manual: 39.1.4 Intel® SGX Launch Control Configuration

Probably should leave off the exact section, e.g. "39.1.4" is already out
of date.

IMO this whole document could use an overhaul to uplevel the overview
and {micro-}architecture descriptions to make it a useful standalone doc
instead of a poor man's regurgitation of the SDM.  If there are no
objections, I'll start typing and reply with a fresh patch at some point.

Oh, and the vDSO interface needs to be added, I'll do that too.
