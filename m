Return-Path: <SRS0=1HHV=63=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD1DC433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 13 May 2020 23:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FD5C2065C
	for <linux-sgx@archiver.kernel.org>; Wed, 13 May 2020 23:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732243AbgEMXJd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 May 2020 19:09:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:49358 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732151AbgEMXJd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 13 May 2020 19:09:33 -0400
IronPort-SDR: ChnACrQ/nlAlRRpEz6OigGc4nO25Ll1gBxiDxOwFPd5igRnaWW62co8hNJ7FMnhyUWgnV1SY8c
 bKxppW4l9Esw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 16:09:32 -0700
IronPort-SDR: FpN+OY1K71+x9lmhQ/R4t4qwERrf/qTusZ1FBnThNG4M39goM1tFnsuO/WDX+bOXeczqIJ0DEx
 wqKjm7T9eLzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,389,1583222400"; 
   d="scan'208";a="372053949"
Received: from rthurerx-mobl.ger.corp.intel.com ([10.249.36.107])
  by fmsmga001.fm.intel.com with ESMTP; 13 May 2020 16:09:25 -0700
Message-ID: <ba92f60e41cee1be11b30e8383268b1e1ce896b1.camel@linux.intel.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jordan Hand <jorhand@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Date:   Thu, 14 May 2020 02:09:19 +0300
In-Reply-To: <e50f4c00-12e6-19e6-ead3-f180074bceea@linux.microsoft.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
         <e50f4c00-12e6-19e6-ead3-f180074bceea@linux.microsoft.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2020-05-06 at 09:39 -0700, Jordan Hand wrote:
> On 4/21/20 2:52 PM, Jarkko Sakkinen wrote:
> > Intel(R) SGX is a set of CPU instructions that can be used by applications
> > to set aside private regions of code and data. The code outside the enclave
> > is disallowed to access the memory inside the enclave by the CPU access
> > control.
> > 
> > There is a new hardware unit in the processor called Memory Encryption
> > Engine (MEE) starting from the Skylake microacrhitecture. BIOS can define
> > one or many MEE regions that can hold enclave data by configuring them with
> > PRMRR registers.
> > 
> > The MEE automatically encrypts the data leaving the processor package to
> > the MEE regions. The data is encrypted using a random key whose life-time
> > is exactly one power cycle.
> > 
> > The current implementation requires that the firmware sets
> > IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
> > decide what enclaves it wants run. The implementation does not create
> > any bottlenecks to support read-only MSRs later on.
> > 
> > You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
> > 
> > 	cat /proc/cpuinfo  | grep sgx
> > 
> > v29:
> > * The selftest has been moved to selftests/sgx. Because SGX is an execution
> >    environment of its own, it really isn't a great fit with more "standard"
> >    x86 tests.
> > 
> >    The RSA key is now generated on fly and the whole signing process has
> >    been made as part of the enclave loader instead of signing the enclave
> >    during the compilation time.
> > 
> >    Finally, the enclave loader loads now the test enclave directly from its
> >    ELF file, which means that ELF file does not need to be coverted as raw
> >    binary during the build process.
> > * Version the mm_list instead of using on synchronize_mm() when adding new
> >    entries. We hold the write lock for the mm_struct, and dup_mm() can thus
> >    deadlock with the page reclaimer, which could hold the lock for the old
> >    mm_struct.
> > * Disallow mmap(PROT_NONE) from /dev/sgx. Any mapping (e.g. anonymous) can
> >    be used to reserve the address range. Now /dev/sgx supports only opaque
> >    mappings to the (initialized) enclave data.
> > * Make the vDSO callable directly from C by preserving RBX and taking leaf
> >    from RCX.
> > 
> 
> Tested with the Open Enclave SDK on top of Intel PSW. Specifically built 
> the Intel PSW with changes to support /dev/sgx mapping[1] new in v29.
> 
> Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
> 
> [1] https://github.com/intel/linux-sgx/pull/530

Thank you!

/Jarkko


