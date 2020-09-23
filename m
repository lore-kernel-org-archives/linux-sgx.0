Return-Path: <SRS0=YjYT=DA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 607F7C4727E
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 13:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB9AF21BE5
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 13:50:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="TEMPDJLk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIWNuS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Sep 2020 09:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgIWNuO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 23 Sep 2020 09:50:14 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC12CC0613CE;
        Wed, 23 Sep 2020 06:50:14 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0d13003cb05fb00c1da4a2.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1300:3cb0:5fb0:c1d:a4a2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 934761EC0409;
        Wed, 23 Sep 2020 15:50:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600869012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0fGvnIQVdKsMqeTksW4QaaQdYOv2dMjo3K5+QpVLLC8=;
        b=TEMPDJLks9CJno66rpFCZKPTRy9PbYXCVYKioWfHID1hEW9su1NnCiPiF7C9/aZ7WlciEb
        QybTPddDIiIPJ55Q21MtaXLgesdq2zN81lzt8IY+cw1TKVj91JUbo5IXEJ7G2en8LgcrK+
        l9AwkaJl9Dk6AIQLdy4WEK56UyZeFtA=
Date:   Wed, 23 Sep 2020 15:50:05 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 23/24] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
Message-ID: <20200923135005.GI28545@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-24-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200915112842.897265-24-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This patch must come first in the set so that other reviewers can read
what all this jazz is about first, before exposing them to the gory
details later.

On Tue, Sep 15, 2020 at 02:28:41PM +0300, Jarkko Sakkinen wrote:
> diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> new file mode 100644
> index 000000000000..706a846ae353
> --- /dev/null
> +++ b/Documentation/x86/sgx.rst
> @@ -0,0 +1,200 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +============
> +Architecture
> +============

Only the title of the document should be sandwiched between two lines of

============

as that is what appears in the documentation TOC. As it is right now,it says
"Architecture" but it should say "Software Guard eXtensions (SGX)"

Architecture should follow only with a bottom line as a section name:

Architecture
============

> +
> +*Software Guard eXtensions (SGX)* is a set of instructions that enable ring-3
> +applications to set aside private regions of code and data. These regions are
> +called enclaves. An enclave can be entered to a fixed set of entry points. Only

s / to / at /

> +a CPU running inside the enclave can access its code and data.
> +
> +The support can be determined by
> +
> +	``grep sgx /proc/cpuinfo``
> +
> +Enclave Page Cache
> +==================
> +
> +SGX utilizes an *Enclave Page Cache (EPC)* to store pages that are associated
> +with an enclave. It is contained in a BIOS reserved region of physical memory.

BIOS-reserved

> +Unlike pages used for regular memory, pages can only be accessed outside the
> +enclave for different purposes with the instructions **ENCLS**, **ENCLV** and
> +**ENCLU**.
> +
> +Direct memory accesses to an enclave can be only done by a CPU executing inside
> +the enclave. An enclave can be entered with **ENCLU[EENTER]** to a fixed set of

s / to / at /

> +entry points. However, a CPU executing inside the enclave can do outside memory
> +accesses.
> +
> +Page Types
> +----------
> +
> +**SGX Enclave Control Structure (SECS)**
> +   Enclave's address range, attributes and other global data are defined
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
> +contains an entry for each EPC page, which describes the owning enclave, access
> +rights and page type among the other things.
> +
> +The permissions from EPCM is consulted if and only if walking the kernel page

s/ is / are /

> +tables succeeds. The total permissions are thus a conjunction between page table
> +and EPCM permissions.
> +
> +For all intents and purposes the SGX architecture allows the processor to
			       ^
			       ,

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
> +starts reclaiming pages. The pages that do not have the **A** bit set are
> +selected as victim pages.
> +
> +Launch Control
> +==============
> +
> +SGX provides a launch control mechanism. After all enclave pages have been
> +copied, kernel executes **ENCLS[EINIT]**, which initializes the enclave. Only
> +after this the CPU can execute inside the enclave.
> +
> +This leaf function takes an RSA-3072 signature of the enclave measurement and an
> +optional cryptographic token. Linux does not take advantage of launch tokens.
> +The instruction checks that the signature is signed with the key defined in
> +**IA32_SGXLEPUBKEYHASH?** MSRs and the measurement is correct. If so, the

That '?' wants to be '[0123]' perhaps?

> +enclave is allowed to be executed.
> +
> +MSRs can be configured by the BIOS to be either readable or writable. Linux

"Those MSRs..."

> +supports only writable configuration in order to give full control to the kernel
> +on launch control policy. Readable configuration requires the use of previously
> +mentioned launch tokens.
> +
> +The current kernel implementation supports only writable MSRs.

This sentence is repeated a couple of lines above.

> The launch is
> +performed by setting the MSRs to the hash of the enclave signer's public key.
> +The alternative would be to have *a launch enclave* that would be signed with
> +the key set into MSRs, which would then generate launch tokens for other
> +enclaves. This would only make sense with read-only MSRs, and thus the option
> +has been discarded.
> +
> +Attestation
> +===========
> +
> +Local Attestation
> +-----------------
> +
> +In local attestation an enclave creates a **REPORT** data structure with
		       ^
		       ,

> +**ENCLS[EREPORT]**, which describes the origin of an enclave. In particular, it
> +contains a AES-CMAC of the enclave contents signed with a report key unique to
> +each processor. All enclaves have access to this key.
> +
> +This mechanism can also be used in addition as a communication channel as the
> +**REPORT** data structure includes a 64-byte field for variable information.

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
