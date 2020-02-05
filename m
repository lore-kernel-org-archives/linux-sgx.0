Return-Path: <SRS0=YPok=3Z=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA6EC35247
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 17:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E03D217BA
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 17:54:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LjsPEiQ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgBERye (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Feb 2020 12:54:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37884 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbgBERye (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 5 Feb 2020 12:54:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=9JMobWgsvWorEne/Ocjw8LwZqNsKiEDmSrOUanLtD8g=; b=LjsPEiQ8/qKv0AYBhKWL+zmxMA
        RMBKO8WqYkgerVZs+trKI/HTATYK2ugTJ1+/70guiWPRDoh8MDz5/mOEye44murScGaQDQWiZSbOK
        /xdV/S5oThBP2y0SEDfRB2P+9K+I4TJP41aJE4OccmA3daeBFzFXZ/K6l0+coQXPDU2tpf4uW2LxW
        E1gMO3OmGZbI9XMtTTbUYMULnPOTo7bNzluXrw6JGkI6XwazosYtmdwIOUf8FsXAYlA2CKdzK5+Bq
        KdDZqJvTHXlLrtHjsxMA0J948Q/jkijlwZ5090GST9lMUs90buL3phiZPsE6Uwob6QT6uygo8UU78
        O2nATMbg==;
Received: from [2603:3004:32:9a00::c7a3]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izOsi-0005Kh-R5; Wed, 05 Feb 2020 17:54:32 +0000
Subject: Re: [PATCH v25 21/21] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-doc@vger.kernel.org
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
 <20200204060545.31729-22-jarkko.sakkinen@linux.intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5ea28632-cd64-bc26-fab6-2868142eb9e4@infradead.org>
Date:   Wed, 5 Feb 2020 09:54:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200204060545.31729-22-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi,
I have some Documentation edits. Please see inline below...


On 2/3/20 10:05 PM, Jarkko Sakkinen wrote:
> Document Intel SGX micro architecture and kernel internals. The motivation
> is to make the core ideas approachable by keeping a fairly high abstraction
> level. Fine-grained micro architecture details can be looked up from Intel
> SDM Volume 3D.
> 
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: linux-doc@vger.kernel.org
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  Documentation/x86/index.rst |   1 +
>  Documentation/x86/sgx.rst   | 177 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 178 insertions(+)
>  create mode 100644 Documentation/x86/sgx.rst

> diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> new file mode 100644
> index 000000000000..04deaba83981
> --- /dev/null
> +++ b/Documentation/x86/sgx.rst
> @@ -0,0 +1,177 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +============
> +Architecture
> +============
> +
> +Introduction
> +============
> +
> +*Software Guard eXtensions (SGX)* is a set of instructions and that enable

                                                   drop:      and

> +ring-3 applications to set aside private regions of code and data. These regions
> +are called enclaves. Enclave can be entered to a fixed set of entry points. Only

                        An enclave can be entered by a fixed set of entry points.

> +a CPU running inside the enclave can access its code and data.
> +
> +SGX support can be determined by
> +
> +	``cat /proc/cpuinfo | grep sgx``

or just: ``grep sgx /proc/cpuinfo

> +
> +Enclave Page Cache``

> +==================
> +
> +SGX utilizes an *Enclave Page Cache (EPC)* to store pages that are associated
> +with an enclave. It is contained in a BIOS reserved region of physical memory.
> +Unlike pages used for regular memory, pages can only be accessed outside the
> +enclave for different purposes with the instructions **ENCLS**, **ENCLV** and
> +**ENCLU**.
> +
> +Direct memory accesses to an enclave can be only done by a CPU executing inside
> +the enclave. Enclave can be entered with **ENCLU[EENTER]** leaf function to a

                An enclave can be entered with the

> +fixed set of entry points. However, a CPU executing inside the enclave can do
> +outside memory accesses.
> +
> +Page Types
> +----------
> +
> +**SGX Enclave Control Structure (SECS)**
> +   Enclave's address range, attributes and other global data is defined

                                                                are defined
 
> +   by this structure.
> +
> +**Regular (REG)**
> +   Regular EPC pages contain the code and data of an enclave.
> +
> +**Thread Control Structure (TCS)**
> +   Thread Control Structure pages define the entry points to an enclave and
> +   track the execution state of an enclave thread.
> +
> +**Version Array (VA)**
> +   Version Array pages contain 512 slots, each of which can contain a version
> +   number for a page evicted from the EPC.
> +
> +Enclave Page Cache Map
> +----------------------
> +
> +The processor tracks EPC pages via the *Enclave Page Cache Map (EPCM)*.  EPCM
> +contains entry for each EPC page, which describes the owning enclave, access

   contains an entry for each

> +rights and page type among the other things.
> +
> +The permissions from EPCM is consulted if and only if walking the kernel page
> +tables succeeds. The total permissions are thus a conjunction between page table
> +and EPCM permissions.
> +
> +For all intents and purposes the SGX architecture allows the processor to
> +invalidate all EPCM entries at will, i.e. requires that software be prepared to
> +handle an EPCM fault at any time. The contents of EPC are encrypted with an
> +ephemeral key, which is lost on power transitions.
> +
> +EPC management
> +==============
> +
> +EPC pages do not have ``struct page`` instances. They are IO memory from kernel
> +perspective. The consequence is that they are always mapped as shared memory.
> +Kernel defines ``/dev/sgx/enclave`` that can be mapped as ``MAP_SHARED`` to
> +define the address range for an enclave.
> +
> +EPC Over-subscription
> +=====================
> +
> +When the amount of free EPC pages goes below a low watermark the swapping thread
> +starts reclaiming pages. The pages that have no do not have the **A** bit set

                                     drop: have no

> +are selected as victim pages. Each enclave holds an shmem file as a backing
> +storage for reclaimed pages.
> +
> +Launch Control
> +==============
> +
> +SGX provides a launch control mechanism. After all enclave pages have been
> +copied, kernel executes **ENCLS[EINIT]**, which initializes the enclave. Only
> +after this the CPU can execute inside the enclave.
> +
> +This leaf function takes a RSA-3072 signature of the enclave measurement and an

                      takes an

> +optional cryptographic token. Linux does not take advantage of launch tokens.
> +The instruction checks that the signature is signed with the key defined in
> +**IA32_SGXLEPUBKEYHASH?** MSRs and the measurement is correct. If so, the
> +enclave is allowed to be executed.
> +
> +MSRs can be configured by the BIOS to be either readable or writable.  Linux
> +supports only writable configuration in order give full control to the kernel on

                                        in order to give

> +launch control policy. Readable configuration requires the use of previously
> +mentioned launch tokens.
> +
> +The current kernel implementation supports only writable MSRs. The launch is
> +performed by setting the MSRs to the hash of the enclave signer's public key.
> +Alternative would be to have *a launch enclave* that would be signed with the

   The alternative would be

> +key set into MSRs, which would then generate launch tokens for other enclaves.
> +This would only make sense with read-only MSRs, and thus the option has been
> +discluded.

I can't find "discluded" in a dictionary.

> +
> +Attestation
> +===========
> +
> +Local Attestation
> +-----------------
> +
> +In local attestation the source enclave calculates a MAC of itself with

"MAC" can mean a lots of different things.  Which one is this?

> +**ENCLS[EREPORT]**. Then the destination enclave verifies this with
> +**ENCLS[EGETKEY(REPORT)]** key. This mechanism can also be used in addition as a
> +communication channel as the **REPORT** data structure includes 64 byte field

                                                          includes a 64-byte field

> +for passing variable information.
> +
> +Remote Attestation
> +------------------
> +
> +For remote attestation (aka provisioning) there a multiple options available:

                                             there are

> +
> +* An EPID based scheme, which requires the use of Intel managed attestation

Drop: "An " to make it similar to next bullet point.

> +  service.
> +* ECDSA based scheme, which 3rd party to act as an attestation service.

                         which uses a 3rd party
or
                         using a 3rd party

> +
> +Intel provides an open source *quoting enclave (QE)* and *provisioning
> +certification enclave (PCE)* for the ECDSA based scheme. The latter acts as
> +the CA for the local QE's. Intel also a precompiled binary version of the PCE

                                    also provides [??]

> +so that, if required, quotation can be linked to the hardware.
> +
> +The use of remote attestation must be strictly controlled because it allows to
> +get access to the provisioning keys to attest to a remote party that the
> +software is running inside a legitimate enclave on real hardware. This could be
> +potentially used by malware, and thus must be protected.
> +
> +Enclaves can attest their identity when **ATTRIBUTES.PROVISIONKEY** set in SECS.

                                                                       is set in SECS.

> +This attribute authorizes **ENCLS[EGETKEY]** to access provisioning keys.
> +
> +Kernel defines ``/dev/sgx/provision`` and a special ioctl
> +``SGX_IOC_ENCLAVE_SET_ATTRIBUTE`` to accomplish this. A file descriptor pointing
> +to ``/dev/sgx/provision`` is passed to ioctl from which kernel authorizes the
> +use of remote attestation keys. This must be called before
> +``SGX_IOC_ENCL_CREATE`` if remote attestation is required.
> +
> +References
> +----------
> +
> +"Intel® Software Guard Extensions: EPID Provisioning and Attestation Services"
> +   https://software.intel.com/sites/default/files/managed/57/0e/ww10-2016-sgx-provisioning-and-attestation-final.pdf
> +
> +"Supporting Third Party Attestation for Intel® SGX with Intel® Data Center
> +Attestation Primitives"
> +   https://software.intel.com/sites/default/files/managed/f1/b8/intel-sgx-support-for-third-party-attestation.pdf
> +
> +Usage Models
> +============
> +
> +Shared Library
> +--------------
> +
> +Sensitive data and the code that acts on it is partitioned from the application
> +into a separate library. The library is then linked as a DSO which can be loaded
> +into an enclave. The application can then make individual function calls into
> +the enclave through special SGX instructions. A run-time within the enclave is
> +configured to marshall function parameters into and out of the enclave and to

                 marshal

> +call the correct library function.
> +
> +Application Container
> +---------------------
> +
> +An application may be loaded into a container enclave which is specially
> +configured with a library OS and run-time which permits the application to run.
> +The enclave run-time and library OS work together to execute the application
> +when a thread enters the enclave.
> 

cheers.
-- 
~Randy
