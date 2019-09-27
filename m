Return-Path: <SRS0=CuW6=XW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09ACCC4360C
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 17:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8F9820872
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 17:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pi1TqRZg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfI0RHZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Sep 2019 13:07:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43932 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfI0RHZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 27 Sep 2019 13:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xTQzDROB7e5nWLLWCEXdqxNLgL3OQIo5th8TD+vu3MY=; b=pi1TqRZgUI6qRdwcep8MPDrUL
        kyxNrxGrZPjdFHRGDprgUf6KB/GZkSh5Y2P/T4UDvK5JZojqrdhNf4ZUvt1hkW4h1HsZ6aTXSTBgr
        cU6zc/gLSlq8OylD4OB+sXGFZlzaaC7bdk1E3PS1lVdOEkIUXd1GhgzGZBHFSGxCFW06jypX37mTC
        cOU8KmHO8CiBw7EPROjFOfXE00CTrwqhu2cB/LPScMPOrwUhQsGunPTmhulCoEcdsEy3X0YF+C3sP
        MuqVAeBXVKDNH7kzzenVR5Q3WITyRsTWAT9hbb6WJVXbJ0GNnX1G9NNOd8iFIMvPCKvHSAIz3mIKY
        qzi+E0Wtg==;
Received: from [2601:1c0:6280:3f0::9a1f]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iDti3-00057T-Ob; Fri, 27 Sep 2019 17:07:11 +0000
Subject: Re: [PATCH v22 24/24] docs: x86/sgx: Document kernel internals
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-25-jarkko.sakkinen@linux.intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <97dbd2a8-f1e5-a3f9-dac7-f1f4d6b6cd4c@infradead.org>
Date:   Fri, 27 Sep 2019 10:07:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903142655.21943-25-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 9/3/19 7:26 AM, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Document some of the more tricky parts of the kernel implementation
> internals.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Hi,
Some edits for you to consider.

> ---
>  Documentation/x86/sgx/2.Kernel-internals.rst | 76 ++++++++++++++++++++
>  Documentation/x86/sgx/index.rst              |  1 +
>  2 files changed, 77 insertions(+)
>  create mode 100644 Documentation/x86/sgx/2.Kernel-internals.rst
> 
> diff --git a/Documentation/x86/sgx/2.Kernel-internals.rst b/Documentation/x86/sgx/2.Kernel-internals.rst
> new file mode 100644
> index 000000000000..5c90a65936f2
> --- /dev/null
> +++ b/Documentation/x86/sgx/2.Kernel-internals.rst
> @@ -0,0 +1,76 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +================
> +Kernel Internals
> +================
> +
> +CPU configuration
> +=================
> +
> +Because SGX has an ever evolving and expanding feature set, it's possible for
> +a BIOS or VMM to configure a system in such a way that not all CPUs are equal,
> +e.g. where Launch Control is only enabled on a subset of CPUs.  Linux does
> +*not* support such a heterogeneous system configuration, nor does it even
> +attempt to play nice in the face of a misconfigured system.  With the exception
> +of Launch Control's hash MSRs, which can vary per CPU, Linux assumes that all
> +CPUs have a configuration that is identical to the boot CPU.
> +
> +EPC management
> +==============
> +
> +Because the kernel can't arbitrarily read EPC memory or share RO backing pages
> +between enclaves, traditional memory models such as CoW and fork() do not work
> +with enclaves.  In other words, the architectural rules of EPC forces it to be

                                                                  force

> +treated as MAP_SHARED at all times.
> +
> +The inability to employ traditional memory models also means that EPC memory
> +must be isolated from normal memory pools, e.g. attempting to use EPC memory
> +for normal mappings would result in faults and/or perceived data corruption.
> +Furthermore, EPC is not enumerated by as normal memory, e.g. BIOS enumerates

                           enumerated as

> +EPC as reserved memory in the e820 tables, or not at all.  As a result, EPC
> +memory is directly managed by the SGX subsystem, e.g. SGX employs VM_PFNMAP to
> +manually insert/zap/swap page table entries, and exposes EPC to userspace via
> +a well known device, /dev/sgx/enclave.
> +
> +The net effect is that all enclave VMAs must be MAP_SHARED and are backed by
> +a single file, /dev/sgx/enclave.
> +
> +EPC oversubscription
> +====================
> +
> +SGX allows to have larger enclaves than amount of available EPC by providing a

                                      than the amount of

> +subset of leaf instruction for swapping EPC pages to the system memory.  The

                  instructions  {I think}

> +details of these instructions are discussed in the architecture document. Due
> +to the unique requirements for swapping EPC pages, and because EPC pages do not
> +have associated page structures, management of the EPC is not handled by the
> +standard memory subsystem.
> +
> +SGX directly handles swapping of EPC pages, including a thread to initiate the
> +reclaiming process and a rudimentary LRU mechanism. When the amount of free EPC
> +pages goes below a low watermark the swapping thread starts reclaiming pages.
> +The pages that have not been recently accessed (i.e. do not have the A bit set)
> +are selected as victim pages. Each enclave holds an shmem file as a backing
> +storage for reclaimed pages.
> +
> +Launch Control
> +==============
> +
> +The current kernel implementation supports only writable MSRs. The launch is
> +performed by setting the MSRs to the hash of the public key modulus of the
> +enclave signer and a token with the valid bit set to zero. Because kernel makes

                                                              Because the kernel

> +ultimately all the launch decisions token are not needed for anything.  We

   ultimately makes all the launch decisions, tokens are not


> +don't need or have a launch enclave for generating them as the MSRs must always
> +be writable.
> +
> +Provisioning
> +============
> +
> +The use of provisioning must be controlled because it allows to get access to
> +the provisioning keys to attest to a remote party that the software is running
> +inside a legit enclave. This could be used by a malware network to ensure that

            legitimate

> +its nodes are running inside legit enclaves.

                                legitimate

> +
> +The driver introduces a special device file /dev/sgx/provision and a special
> +ioctl SGX_IOC_ENCLAVE_SET_ATTRIBUTE to accomplish this. A file descriptor
> +pointing to /dev/sgx/provision is passed to ioctl from which kernel authorizes
> +the PROVISION_KEY attribute to the enclave.



-- 
~Randy
